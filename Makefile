# Disable all of make's built-in rules (similar to Fortran's implicit none)
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

run: 
	@cd ./src/static/; \
		npm run build

	LIBRARY_PATH="${PWD}/libs:${LIBRARY_PATH}" fpm build
	LD_LIBRARY_PATH="${PWD}/libs:${LD_LIBRARY_PATH}" fpm run
build: 
	@cd ./src/static/; \
		npm run build

	LIBRARY_PATH="${PWD}/libs:${LIBRARY_PATH}" fpm build

