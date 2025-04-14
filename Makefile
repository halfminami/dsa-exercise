GO_DIRS = MaxFlow/go util/go
RACKET_DIRS = util/racket misc/SmallIso misc/Primality 
UIUA_FILES = misc/FFT/src/lib.ua

test-go : $(GO_DIRS)

$(GO_DIRS) :
	cd $@ && go test ./...


test-racket : $(RACKET_DIRS)
	raco test $^


test-uiua : $(UIUA_FILES)

$(UIUA_FILES) :
	uiua test $@


test : test-go test-racket test-uiua

.PHONY : test-go $(GO_DIRS) \
	 test-racket \
	 test-uiua $(UIUA_FILES) test
