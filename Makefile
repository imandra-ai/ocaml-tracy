
all:
	@dune build @install

clean:
	@dune clean

watch:
	@dune build @install -w

VERSION?=
dune-release-distrib:
	@[ -n "$(VERSION)" ] || (echo "make sure to pass VERSION " && exit 1)
	@echo "using version $(VERSION)"
	@git tag -d v$(VERSION) || true
	dune-release tag -f v$(VERSION)
	dune-release distrib -p tracy,tracy-client --include-submodules -t v$(VERSION) -V $(VERSION)
	echo "distrib done, publishing"
	dune-release publish -p tracy,tracy-client -t v$(VERSION) -V $(VERSION)
	echo "publishing done"

dune-release-publish:
	@echo "make sure you ran `make dune-release-distrib` first"
	dune-release opam pkg
	dune-release opam submit
	



.PHONY: clean watch dune-release-distrib dune-release-publish
