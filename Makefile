include .bingo/Variables.mk

WEBSITE_DIR ?= web
WEBSITE_BASE_URL ?= https://rhobs-handbook.netlify.app/
MD_FILES_TO_FORMAT=$(shell find content -name "*.md") README.md

help: ## Displays help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

all: docs web

.PHONY: docs
docs: ## Format docs, localise links, ensure GitHub format.
docs: $(MDOX)
	$(MDOX) fmt --links.localize.address-regex="https://rhobs-handbook.netlify.app/.*" *.md $(MD_FILES_TO_FORMAT)

.PHONY: docs-check
docs-check: ## Checks if docs are localised and links are correct.
docs-check: $(MDOX)
	$(MDOX) fmt --check \
-l --links.validate.without-address-regex="https://.*" \
--links.localize.address-regex="https://rhobs-handbook.netlify.app/.*" *.md $(MD_FILES_TO_FORMAT)

.PHONY: web-pre
web-pre: ## Pre process docs using mdox transform which converts it from GitHub structure to Hugo one.
web-pre: $(MDOX)
	$(MDOX) transform --log.level=debug -c .mdox.yaml

$(WEBSITE_DIR)/node_modules:
	@git submodule update --init --recursive
	cd $(WEBSITE_DIR)/themes/docsy/ && npm install && rm -rf content

.PHONY: web
web: ## Build website in publish directory.
web: $(WEBSITE_DIR)/node_modules $(HUGO) web-pre
	cd $(WEBSITE_DIR) && $(HUGO) -b $(WEBSITE_BASE_URL)

.PHONY: web-serve
web-serve: ## Build website and run in foreground process in localhost:1313
web-serve: $(WEBSITE_DIR)/node_modules $(HUGO) web-pre
	cd $(WEBSITE_DIR) && $(HUGO) serve
