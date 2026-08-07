// Load the freshly built module the way the page does and exercise the entry
// points the page calls. This exists because a missing entry in the makefile's
// EXPORTED_FUNCTIONS or EXPORTED_RUNTIME_METHODS lists produces a clips.js and
// clips.wasm that build cleanly, look the right size, and only fail when
// someone clicks a button - which no file-level check would catch.
//
// Usage: node ci/smoke-test.js   (run from anywhere; paths resolve to the repo)
'use strict';

const assert = require('node:assert');
const path = require('node:path');

// Every name in the makefile's EXPORTED_FUNCTIONS, kept as a literal list so
// that dropping one from the build fails here rather than in a browser.
const REQUIRED_EXPORTS = [
	'_BatchStar',
	'_CreateEnvironment',
	'_DestroyEnvironment',
	'_Eval',
	'_Clear',
	'_Reset',
	'_malloc',
	'_free',
];

// Likewise for EXPORTED_RUNTIME_METHODS. The page calls all four through
// Module rather than as bare globals, so dropping one from the build breaks
// the page for real - stringToUTF8Array is the one behind (read), which feeds
// Module.stdin and has no other coverage here.
const REQUIRED_RUNTIME_METHODS = [
	'FS',
	'stringToUTF8',
	'stringToUTF8Array',
	'lengthBytesUTF8',
];

// Eval returns an EvalError (vendor/clips/strngfun.h): 0 is EE_NO_ERROR, and
// the nonzero values are parsing and processing errors.
const EE_NO_ERROR = 0;

// A whole program rather than one expression: defining a rule, resetting so
// that (initial-fact) activates it, and running the engine covers the parse,
// match and fire path in one go.
const BATCH_PROGRAM = [
	'(defrule smoke-rule',
	'  =>',
	'  (printout t "BATCH-OK" crlf))',
	'(reset)',
	'(run)',
	'',
].join('\n');

const BATCH_PATH = './smoke.bat';

const Module = require(path.join(__dirname, '..', 'clips.js'));

// whenReady(): resolve once the wasm has instantiated. Under node emscripten
// instantiates asynchronously, so onRuntimeInitialized is still settable here;
// the typeof check covers the case where it has already finished.
function whenReady(mod, timeoutMs) {
	if (typeof mod._CreateEnvironment === 'function') return Promise.resolve();
	return new Promise((resolve, reject) => {
		const timer = setTimeout(() => {
			reject(new Error(`wasm runtime did not initialize within ${timeoutMs}ms`));
		}, timeoutMs);
		mod.onRuntimeInitialized = () => {
			clearTimeout(timer);
			resolve();
		};
	});
}

// cstring(): copy a JS string into the heap as a NUL-terminated C string and
// return its address, the same way the page's (batch*) button does.
function cstring(str) {
	const size = Module.lengthBytesUTF8(str) + 1;
	const ptr = Module._malloc(size);
	assert.notStrictEqual(ptr, 0, 'malloc returned a null pointer');
	Module.stringToUTF8(str, ptr, size);
	return ptr;
}

// capture(): run fn with stdout and stderr collected rather than printed, and
// return [result, text]. CLIPS writes through the runtime's default printer,
// which is bound at require time and so cannot be redirected via Module.print.
function capture(fn) {
	const chunks = [];
	const stdout = process.stdout.write.bind(process.stdout);
	const stderr = process.stderr.write.bind(process.stderr);
	const collect = (chunk) => {
		chunks.push(chunk.toString());
		return true;
	};
	process.stdout.write = collect;
	process.stderr.write = collect;
	try {
		return [fn(), chunks.join('')];
	} finally {
		process.stdout.write = stdout;
		process.stderr.write = stderr;
	}
}

async function main() {
	await whenReady(Module, 60000);

	for (const name of REQUIRED_EXPORTS) {
		assert.strictEqual(typeof Module[name], 'function', `missing export: ${name}`);
	}
	for (const name of REQUIRED_RUNTIME_METHODS) {
		assert.ok(Module[name], `missing runtime method: ${name}`);
	}
	assert.strictEqual(typeof Module.FS.writeFile, 'function', 'FS.writeFile is missing');
	assert.strictEqual(typeof Module.FS.unlink, 'function', 'FS.unlink is missing');

	// CreateEnvironment returns an Environment* - a nonzero address in the wasm
	// heap. Getting one means the module instantiated and CLIPS initialized.
	const env = Module._CreateEnvironment();
	assert.notStrictEqual(env, 0, 'CreateEnvironment returned a null pointer');

	// Eval takes a CLIPSValue* for the result. Its layout is a union of pointers
	// (vendor/clips/entities.h) and is not read here, so anything comfortably
	// oversized will do.
	const returnValue = Module._malloc(64);

	// Eval, happy path. Asserting on the printed text rather than only on the
	// return code is what makes this an end-to-end check: the string was
	// marshalled in, parsed, and actually executed.
	const printExpr = cstring('(printout t "EVAL-OK" crlf)');
	const [printRc, printed] = capture(() => Module._Eval(env, printExpr, returnValue));
	Module._free(printExpr);
	assert.strictEqual(printRc, EE_NO_ERROR, `Eval of a printout returned ${printRc}`);
	assert.match(printed, /EVAL-OK/, `printout produced ${JSON.stringify(printed)}`);

	// Eval, error path. Without this a stubbed Eval that always returned 0 would
	// sail through the check above.
	const badExpr = cstring('(+ 1');
	const [badRc] = capture(() => Module._Eval(env, badExpr, returnValue));
	Module._free(badExpr);
	assert.notStrictEqual(badRc, EE_NO_ERROR, 'Eval accepted a malformed expression');

	// BatchStar, happy path - the exact sequence behind the page's (batch*)
	// button: write the sample into the emscripten filesystem, batch the file,
	// then remove it. Seeing BATCH-OK means the rule was defined, activated by
	// the reset, and fired by the run.
	Module.FS.writeFile(BATCH_PATH, BATCH_PROGRAM);
	const batchFile = cstring(BATCH_PATH);
	const [batchRc, batchOut] = capture(() => Module._BatchStar(env, batchFile));
	Module._free(batchFile);
	Module.FS.unlink(BATCH_PATH);
	assert.ok(batchRc, 'BatchStar reported failure on a valid batch file');
	assert.match(batchOut, /BATCH-OK/, `batch run produced ${JSON.stringify(batchOut)}`);

	// BatchStar, error path: a file that was never written must be reported as
	// a failure rather than trapping.
	const missingFile = cstring('/definitely-not-here.bat');
	const [missingRc, missingOut] = capture(() => Module._BatchStar(env, missingFile));
	Module._free(missingFile);
	assert.ok(!missingRc, 'BatchStar claimed success on a nonexistent file');
	assert.match(missingOut, /unable to open file/i, `BatchStar said ${JSON.stringify(missingOut)}`);

	const afterBatch = cstring('(+ 2 2)');
	const [afterRc] = capture(() => Module._Eval(env, afterBatch, returnValue));
	Module._free(afterBatch);
	assert.strictEqual(afterRc, EE_NO_ERROR, 'environment was left unusable by a failed BatchStar');

	// The two buttons that regressed once before. Both take only the
	// environment pointer.
	Module._Reset(env);
	Module._Clear(env);

	Module._free(returnValue);
	Module._DestroyEnvironment(env);

	console.log(
		`ok - ${REQUIRED_EXPORTS.length} exports and ${REQUIRED_RUNTIME_METHODS.length} runtime ` +
		'methods present, eval ran and rejected bad input, batch fired a rule and reported a ' +
		'missing file, reset and cleared'
	);
}

main().catch((err) => {
	console.error(`smoke test failed: ${err.message}`);
	process.exit(1);
});
