# Disable all of make's built-in rules (similar to Fortran's implicit none)
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

run: 
	@cd ./src/static/ && \
		npm run build

	fpm build --link-flag "-L./libs -lstdc++ -lgcc -lgcc_s $$(pkg-config --libs gtk+-3.0 webkit2gtk-4.0) -static-libgfortran"
	export WEBKIT_DISABLE_DMABUF_RENDERER=1; fpm run

build: 
	@cd ./src/static/ && \
		npm run build

	fpm build --link-flag "-L./libs -lstdc++ -lgcc -lgcc_s $$(pkg-config --libs gtk+-3.0 webkit2gtk-4.0) -static-libgfortran"

prepare:
	@echo "Warning: about to clean folders './libs' and './build'; continue? [Y/n]"
	@read line; if [ $$line = "n" ]; then echo "aborting"; exit 1 ; fi
	@echo "Cleaning './libs'"
	@if [ -d "./libs" ]; then \
		echo "Folder './libs' not found -- skipping"; \
		rm -rf "./libs"; \
	fi

	@echo "Cleaning './build'"
	@if [ -d "./build" ]; then \
		echo "Folder './build' not found -- skipping"; \
		rm -rf "./build"; \
	fi

	cd ./include/webview/ && \
		cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF && \
		cmake --build build --parallel

	mkdir ./libs
	cp ./include/webview/build/core/libwebview.a ./libs/

	@echo "Run 'make build' to regenerate './build'"
