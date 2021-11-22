URL = https://saidgarcia.com
MARKDOWN = $(patsubst ./%.md,build/%.html,$(wildcard ./*.md))
# ESH = $(patsubst ./%.esh,build/%.html,$(wildcard ./*.esh))
OTHER = $(filter-out build/_footer.html build/_header.html build/build build/makefile build/%.md build/%.esh, $(patsubst %,build/%,$(wildcard *)))

all: setlocal build $(MARKDOWN) build/index.html $(OTHER)

publish: build $(MARKDOWN) build/index.html $(OTHER)

build/%.html: %.md _header.esh
	TMP=$$(mktemp /tmp/wip.XXX); \
	TMP2=$$(mktemp /tmp/wip.XXX); \
	lowdown --html-no-skiphtml --html-no-escapehtml $< > $$TMP; \
	esh _header.esh TITLE="$$(pup -f $$TMP "h1 text{}")" > $$TMP2; \
	cat $$TMP2 $$TMP _footer.html > $@; \
	rm $$TMP $$TMP2

build/index.html: index.esh _header.esh
	TMP=$$(mktemp /tmp/wip.XXX); \
	TMP2=$$(mktemp /tmp/wip.XXX); \
	esh $< URL=$(URL) FILES='$(patsubst ./%.md,%,$(wildcard ./*.md))' LOCATIONS='$(MARKDOWN)' > $$TMP; \
	esh _header.esh TITLE="Said Garcia's Blog" > $$TMP2; \
	cat $$TMP2 $$TMP _footer.html > $@; \
	rm $$TMP

build/%: %
	cp $< build/

build:
	mkdir build

setlocal:
	$(eval URL=http://phoenix:3100)

.PHONY: clean

clean:
	rm build/*
