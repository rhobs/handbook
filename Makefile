include .bingo/Variables.mk

WEBSITE_DIR ?= web
WEBSITE_BASE_URL ?= https://rhobs-handbook.netlify.app/

all: web-serve

.PHONY: web-pre
web-pre: $(MDOX)
	@$(MDOX) transform -c .mdox.yaml

$(WEBSITE_DIR)/node_modules:
	@git submodule update --init --recursive
	cd $(WEBSITE_DIR)/themes/docsy/ && npm install && rm -rf content

.PHONY: web
web: $(WEBSITE_DIR)/node_modules $(HUGO) web-pre
	cd $(WEBSITE_DIR) && $(HUGO) -b $(WEBSITE_BASE_URL)

.PHONY: web-serve
web-serve: $(WEBSITE_DIR)/node_modules $(HUGO) web-pre
	@cd $(WEBSITE_DIR) && $(HUGO) serve
