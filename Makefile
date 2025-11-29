# Disable all of make's built-in rules (similar to Fortran's implicit none)
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

run: 
	@cd ./src/static/; \
		npm run build

	LIBRARY_PATH="${PWD}/libs:${LIBRARY_PATH}" fpm build
	fpm run

build: 
	@cd ./src/static/; \
		npm run build

	LIBRARY_PATH="${PWD}/libs:${LIBRARY_PATH}" fpm build

prepare:
	@echo "Warning: about to clean folders './libs' and './build'; continue? [Y/n]"
	@read line; if [ $$line = "n" ]; then echo "aborting"; exit 1 ; fi
	@echo "Cleaning './libs'"
	@if [ -d "./libs" ]; then \
		rm -rf "./libs"; \
	fi

	@echo "Cleaning './build'"
	@if [ -d "./build" ]; then \
		rm -rf "./build"; \
	fi

	cd ./include/webview/ && \
		cmake -B build -S . -DCMAKE_BUILD_TYPE=Release && \
		cmake --build build --parallel

	mkdir ./libs
	cp ./include/webview/build/core/libwebview.so.0.12 ./
	cp ./include/webview/build/core/libwebview.so ./libs/
	cp ./include/webview/build/core/libwebview.so ./
	cp ./include/webview/build/core/libwebview.a ./libs/

	@echo "Run 'make build' to regenerate './build'"

