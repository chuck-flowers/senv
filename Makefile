BIN_NAME=senv

# The location to which to install the application
PREFIX ?= /usr/local

# Project directories
SRC_DIR=src
BUILD_DIR=build

.PHONY: all
all: bins man-pages

.PHONY: clean
clean:
	-rm -r build/*

.PHONY: install
install: install-bins install-man-pages

.PHONY: uninstall
uninstall: uninstall-man-pages

# EXECUTABLES
SHELLCHECK=shellcheck
SHELLCHECK_FLAGS=
BIN_NAME=senv
BIN_FILE_SRC=$(SRC_DIR)/bin/$(BIN_NAME)
BIN_FILE_DST=$(BUILD_DIR)/bin/$(BIN_NAME)
.PHONY: bins
bins: $(BIN_FILE_DST)
$(BIN_FILE_DST): $(BIN_FILE_SRC)
	$(SHELLCHECK) $(SHELLCHECK_FLAGS) $<
	install -DT $< $@
.PHONY: install-bins
install-bins:
	install -Dm555 $(BIN_FILE_DST) $(PREFIX)/bin/$(BIN_NAME)

# MANUAL PAGES
PANDOC=pandoc
PANDOC_FLAGS=--standalone
MAN_PAGES_SRC_DIR=$(SRC_DIR)/man
MAN_PAGES_DST_DIR=$(BUILD_DIR)/share/man
MAN_PAGES_MD=$(shell find $(MAN_PAGES_SRC_DIR) -type f -name '*.md')
MAN_PAGES_FILES=$(patsubst $(MAN_PAGES_SRC_DIR)/%.md, $(MAN_PAGES_DST_DIR)/%, $(MAN_PAGES_MD))
.PHONY: man-pages
man-pages: $(MAN_PAGES_FILES)
$(MAN_PAGES_DST_DIR)/%: $(MAN_PAGES_SRC_DIR)/%.md
	mkdir -p $(dir $@)
	$(PANDOC) $(PANDOC_FLAGS) --to man -o $@ $<
.PHONY: install-man-pages
install-man-pages:
	install -D $(wildcard $(MAN_PAGES_DST_DIR)/man1/*) -t $(PREFIX)/share/man/man1
.PHONY: uninstall-man-pages
uninstall-man-pages:
	rm $(patsubst $(BUILD_DIR)/%, $(PREFIX)/%, $(MAN_PAGES_FILES))

