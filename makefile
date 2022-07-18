URL = https://saidgarcia.com
MARKDOWN = $(filter-out build/README.html, $(patsubst ./%.md,build/%.html,$(wildcard ./*.md)))
# ESH = $(patsubst ./%.esh,build/%.html,$(wildcard ./*.esh))
OTHER = $(filter-out build/_footer.html build/_header.html build/build build/makefile build/%.md build/%.esh build/rss.xml build/README.md build/drafts, $(patsubst %,build/%,$(wildcard *)))

all: setlocal build $(MARKDOWN) build/index.html build/rss.xml $(OTHER)

publish: build $(MARKDOWN) build/index.html build/rss.xml $(OTHER)

build/%.html: %.md _header.esh
	TMP=$$(mktemp /tmp/wip.XXX); \
	TMP2=$$(mktemp /tmp/wip.XXX); \
	lowdown --html-no-skiphtml --html-no-escapehtml $< > $$TMP; \
	esh _header.esh TITLE="$$(pup -f $$TMP "h1 text{}")" URL=$(URL) > $$TMP2; \
	cat $$TMP2 $$TMP _footer.html > $@; \
	rm $$TMP $$TMP2

build/index.html: index.esh _header.esh
	TMP=$$(mktemp /tmp/wip.XXX); \
	TMP2=$$(mktemp /tmp/wip.XXX); \
	esh $< URL=$(URL) FILES='$(filter-out README, $(patsubst ./%.md,%,$(wildcard ./*.md)))' LOCATIONS='$(MARKDOWN)' > $$TMP; \
	esh _header.esh TITLE="Said Garcia's Blog" URL=$(URL) > $$TMP2; \
	cat $$TMP2 $$TMP _footer.html > $@; \
	rm $$TMP $$TMP2

build/rss.xml: rss.esh $(wildcard ./*.md)
	esh $< URL=$(URL) FILES='$(filter-out README.html, $(patsubst ./%.md,%.html,$(wildcard ./*.md)))' LOCATIONS='$(MARKDOWN)' > $@

build/%: %
	cp -r $< build/

build:
	mkdir build

setlocal:
	$(eval URL=http://phoenix:3100)

.PHONY: push

push:
	cp -r build/* /var/www/html/blog

.PHONY: clean

clean:
	rm build/*
