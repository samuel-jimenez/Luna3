
BUILD_DIR     = build

default_target: all
.PHONY : default_target all cache clean config install plasmoid

config: $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake .. -DCMAKE_INSTALL_PREFIX=/usr


all: | $(BUILD_DIR)
	cd $(BUILD_DIR) && make

cache: | $(BUILD_DIR)
	cd $(BUILD_DIR) && make rebuild_cache

clean: | $(BUILD_DIR)
	cd $(BUILD_DIR) && make clean

install: | $(BUILD_DIR)
	cd $(BUILD_DIR) && make install

plasmoid: | $(BUILD_DIR)
	cd $(BUILD_DIR) && make plasmoid
