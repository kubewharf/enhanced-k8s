.PHONY: build
build: source
	@echo build binaries
	./build/build_binaries.sh

.PHONY: source
source:
	@echo prepare source
	./build/prepare_source.sh

.PHONY: kind
kind: source
	@echo build kind
	./build/build_kind.sh

.PHONY: clean
clean:
	rm -rf _output _source
