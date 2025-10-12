TARGET    = clips.js
CLIPS_DIR = vendor/clips

CC     = emcc
CFLAGS = -O3

# Build a valid JSON array for EXPORTED_FUNCTIONS, with commas (no leading/trailing)
empty :=
space := $(empty) $(empty)

comma := ,

all: $(TARGET)

$(TARGET): $(CLIPS_DIR)/libclips.a
	$(CC) $(CFLAGS) -I$(CLIPS_DIR) -L$(CLIPS_DIR) -lclips -o $@ \
		--no-entry \
		-sEXPORTED_FUNCTIONS='["_BatchStar","_CreateEnvironment","_DestroyEnvironment","_Eval","_malloc","_free"]' \
		-sALLOW_TABLE_GROWTH=1

$(CLIPS_DIR)/libclips.a:
	[ -e clips_core_source_642.tar.gz ] || wget https://sourceforge.net/projects/clipsrules/files/CLIPS/6.4.2/clips_core_source_642.tar.gz
	[ -d "$(CLIPS_DIR)" ] || mkdir -p $(CLIPS_DIR) && tar --strip-components=2 -xvf clips_core_source_642.tar.gz -C $(CLIPS_DIR)
	$(MAKE) -C $(CLIPS_DIR) CC=$(CC) CFLAGS="$(CFLAGS)"

clean:
	$(MAKE) -C $(CLIPS_DIR) clean
	rm -f $(TARGET) $(TARGET:.js=.wasm)

