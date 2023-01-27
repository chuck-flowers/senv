BIN_NAME=senv

# The location to which to install the application
PREFIX ?= /usr/local

BUILD_DIR=build

.PHONY: all
all: man-pages

.PHONY: clean
clean:
	-rm -r build/*

.PHONY: install
install: install-man-pages

.PHONY: uninstall
uninstall: uninstall-man-pages

# MANUAL PAGES
PANDOC=pandoc
PANDOC_FLAGS=--standalone
MAN_PAGES_SRC_DIR=src/man
MAN_PAGES_DST_DIR=build/share/man
MAN_PAGES_MD=$(shell find $(MAN_PAGES_SRC_DIR) -type f -name '*.md')
MAN_PAGES_FILES=$(patsubst $(MAN_PAGES_SRC_DIR)/%.md, $(MAN_PAGES_DST_DIR)/%, $(MAN_PAGES_MD))
.PHONY: man-pages
man-pages: $(MAN_PAGES_FILES)
$(MAN_PAGES_DST_DIR)/%: $(MAN_PAGES_SRC_DIR)/%.md
	mkdir -p $(dir $@)
	$(PANDOC) $(PANDOC_FLAGS) --to man -o $@ $<
.PHONY: install-man-pages
install-man-pages:
	install -D $(wildcard $(MAN_PAGES_DST_DIR)/man1/*) $(PREFIX)/share/man/man1
.PHONY: uninstall-man-pages
uninstall-man-pages:
	rm $(patsubst $(BUILD_DIR)/%, $(PREFIX)/%, $(MAN_PAGES_FILES))

