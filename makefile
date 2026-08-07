TARGET    = clips.js
CLIPS_DIR = vendor/clips

# The CLIPS source arrives over the network from a SourceForge mirror and is
# compiled straight into the wasm that gets deployed, so a substituted tarball
# would end up in the published artifact unnoticed. Checking it on every build
# also validates the copy CI restores from its cache.
CLIPS_TARBALL = clips_core_source_642.tar.gz
CLIPS_SHA256  = 608a1eb2fc6e9caff30d63d684095f0bca7108f2294d21ee6f5617427c10455a

CC     = emcc
CFLAGS = -O3

EMSDK_VERSION = $(shell cat .emscripten-version)
EMCC_VERSION  = $(shell $(CC) --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)

# Build a valid JSON array for EXPORTED_FUNCTIONS, with commas (no leading/trailing)
empty :=
space := $(empty) $(empty)

comma := ,

.PHONY: all clean html fmt check-emcc emsdk

all: $(TARGET)

# Generate the tutorial page from chapters/ in the order set by chapters-index.
# Depends on the built engine and the stylesheet too: build.sh hashes their
# contents to name the assets/ copies that the page links to.
html: tour-of-clips.html

tour-of-clips.html: build.sh chapters-index template/head.html template/tail.html $(wildcard chapters/*.md) $(TARGET) tour-of-clips.css
	sh build.sh > $@

# Reflow chapter prose to ~80 columns in place (leaves code fences/links intact).
fmt:
	@for f in chapters/*.md; do \
		awk -f wrap-md.awk "$$f" > "$$f.tmp" && mv "$$f.tmp" "$$f"; \
	done

# Fail loudly on a toolchain mismatch
check-emcc:
	@[ -n "$(EMCC_VERSION)" ] || { echo "makefile: $(CC) not found on PATH (source \$$EMSDK/emsdk_env.sh)"; exit 1; }
	@[ "$(EMCC_VERSION)" = "$(EMSDK_VERSION)" ] || { \
		echo "makefile: emcc is $(EMCC_VERSION) but .emscripten-version pins $(EMSDK_VERSION)"; \
		echo "          run 'make emsdk' to switch, or edit .emscripten-version to move the pin"; \
		exit 1; }

emsdk:
	@[ -n "$$EMSDK" ] || { echo "makefile: set EMSDK to your emsdk checkout first"; exit 1; }
	$$EMSDK/emsdk install $(EMSDK_VERSION)
	$$EMSDK/emsdk activate $(EMSDK_VERSION)
	@echo "now run: source $$EMSDK/emsdk_env.sh"

# Depends on the makefile itself so that editing the link flags below actually
# relinks: without it a flag change is silently not applied until the next
# clean. (CI keys its cache on this file's hash for the same reason.)
$(TARGET): $(CLIPS_DIR)/libclips.a makefile | check-emcc
	$(CC) $(CFLAGS) -I$(CLIPS_DIR) -L$(CLIPS_DIR) -lclips -o $@ \
		--no-entry \
		-sEXPORTED_FUNCTIONS='["_BatchStar","_CreateEnvironment","_DestroyEnvironment","_Eval","_Clear","_Reset","_malloc","_free"]' \
		-sEXPORTED_RUNTIME_METHODS='["FS","stringToUTF8","stringToUTF8Array","lengthBytesUTF8"]' \
		-sALLOW_TABLE_GROWTH=1

$(CLIPS_DIR)/libclips.a:
	[ -e $(CLIPS_TARBALL) ] || wget https://sourceforge.net/projects/clipsrules/files/CLIPS/6.4.2/$(CLIPS_TARBALL)
	echo "$(CLIPS_SHA256)  $(CLIPS_TARBALL)" | sha256sum -c -
	[ -d "$(CLIPS_DIR)" ] || mkdir -p $(CLIPS_DIR) && tar --strip-components=2 -xvf $(CLIPS_TARBALL) -C $(CLIPS_DIR)
	$(MAKE) -C $(CLIPS_DIR) CC=$(CC) CFLAGS="$(CFLAGS)"

clean:
	$(MAKE) -C $(CLIPS_DIR) clean
	rm -f $(TARGET) $(TARGET:.js=.wasm) tour-of-clips.html
	rm -rf assets

