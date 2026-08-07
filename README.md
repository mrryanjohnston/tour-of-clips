# Tour of CLIPS

This repo provides convenience methods for building new versions of
[Tour of CLIPS](https://ryjo.codes/tour-of-clips.html).

## Toolchain

The emscripten version is pinned in `.emscripten-version`, and that one file is
the source of truth for both local builds and CI.
`make` refuses to build if the `emcc` on
your `PATH` disagrees with it, because the emcc version determines the generated
glue and therefore the content hash in the published asset urls.

To switch to the pinned version:

```
make emsdk                    # needs $EMSDK set to your emsdk checkout
source $EMSDK/emsdk_env.sh
```

To move the pin, edit `.emscripten-version` and commit it; CI follows on the
next push.

## Building

```
make clean
make
make html
```

`make` compiles CLIPS to `clips.js` + `clips.wasm`. `make html` generates
`tour-of-clips.html` and stages `assets/`, which holds content-addressed copies
of the engine and stylesheet:

```
assets/clips-<engine-id>/clips.js
assets/clips-<engine-id>/clips.wasm
assets/tour-of-clips.<css-id>.css
```

The ids are truncated sha256 of the file contents, so editing a chapter leaves
them untouched.

You can preview this locally by running this in the current directory:

```
python -m http.server
```

None of the build output is tracked in git; `make clean` removes all of it.

## Deploying

`.github/workflows/deploy.yml` builds on every push and pull request, and
deploys to S3 + CloudFront on pushes to `main`.

Because the assets are addressed by content, they are uploaded once and served
`immutable` for a year, and only `tour-of-clips.html` is ever invalidated. That
also means a stale cached page still references the exact engine it was built
against, so a visitor can never get a new page against an old wasm.
