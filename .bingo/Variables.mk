# Auto generated binary variables helper managed by https://github.com/bwplotka/bingo v0.4.2. DO NOT EDIT.
# All tools are designed to be build inside $GOBIN.
BINGO_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
GOPATH ?= $(shell go env GOPATH)
GOBIN  ?= $(firstword $(subst :, ,${GOPATH}))/bin
GO     ?= $(shell which go)

# Below generated variables ensure that every time a tool under each variable is invoked, the correct version
# will be used; reinstalling only if needed.
# For example for bingo variable:
#
# In your main Makefile (for non array binaries):
#
#include .bingo/Variables.mk # Assuming -dir was set to .bingo .
#
#command: $(BINGO)
#	@echo "Running bingo"
#	@$(BINGO) <flags/args..>
#
BINGO := $(GOBIN)/bingo-v0.4.2
$(BINGO): $(BINGO_DIR)/bingo.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/bingo-v0.4.2"
	@cd $(BINGO_DIR) && $(GO) build -mod=mod -modfile=bingo.mod -o=$(GOBIN)/bingo-v0.4.2 "github.com/bwplotka/bingo"

HUGO := $(GOBIN)/hugo-v0.80.0
$(HUGO): $(BINGO_DIR)/hugo.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/hugo-v0.80.0"
	@cd $(BINGO_DIR) && CGO_ENABLED=1 $(GO) build -tags=extended -mod=mod -modfile=hugo.mod -o=$(GOBIN)/hugo-v0.80.0 "github.com/gohugoio/hugo"

MDOX := $(GOBIN)/mdox-v0.2.2-0.20210518215136-625f80bfde7c
$(MDOX): $(BINGO_DIR)/mdox.mod
	@# Install binary/ries using Go 1.14+ build command. This is using bwplotka/bingo-controlled, separate go module with pinned dependencies.
	@echo "(re)installing $(GOBIN)/mdox-v0.2.2-0.20210518215136-625f80bfde7c"
	@cd $(BINGO_DIR) && $(GO) build -mod=mod -modfile=mdox.mod -o=$(GOBIN)/mdox-v0.2.2-0.20210518215136-625f80bfde7c "github.com/bwplotka/mdox"

