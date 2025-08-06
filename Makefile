GO_DIRS = MaxFlow/go util/go
RACKET_DIRS = util/racket misc/SmallIso misc/Primality 
UIUA_FILES = misc/FFT/src/lib.ua
ELIXIR_DIRS = Treap/elixir

test-go : $(GO_DIRS)

$(GO_DIRS) :
	cd $@ && go test ./...


test-racket : $(RACKET_DIRS)
	raco test $^

test-elixir : $(ELIXIR_DIRS)

$(ELIXIR_DIRS) :
	cd $@ && mix test

test-uiua : $(UIUA_FILES)

$(UIUA_FILES) :
	uiua test $@


test : test-go test-racket test-uiua

.PHONY : test-go $(GO_DIRS) \
	 test-racket \
	 test-elixir $(ELIXIR_DIRS) \
	 test-uiua $(UIUA_FILES) test
