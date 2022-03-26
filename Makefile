PWD=$(shell pwd)

src=build
from=master
target=gh-pages
message=Release: $(shell date)

GIT_REVISION=$(shell git rev-parse --short=7 HEAD)

ifneq ($(wildcard .env),)
	include .env
endif

export UA_CODE GIT_REVISION

.PHONY: build

dev: deps
	@npm run pages -- -w

dist: deps
	@NODE_ENV=production npm run pages -- -f
	@BASE_URL=https://docs.jamrock.dev npm run index

clean:
	@rm -rf build cache.json index.toml

index: deps
	@npm run index

pages:
	@(git fetch origin $(target) 2> /dev/null || (\
		git checkout --orphan $(target);\
		git rm -rf . > /dev/null;\
		git commit --allow-empty -m "initial commit";\
		git checkout $(from)))

deploy: pages
	@(mv $(src) .backup > /dev/null 2>&1) || true
	@(git worktree remove $(src) --force > /dev/null 2>&1) || true
	@(git worktree add $(src) $(target) && (cp -r .backup/* $(src) > /dev/null 2>&1)) || true
	@cd $(src) && git add . && git commit -m "$(message)" || true
	@(mv .backup $(src) > /dev/null 2>&1) || true
	@git push origin $(target) -f || true
	@rm -rf $(src)/.backup

deps:
	@(((ls node_modules | grep .) > /dev/null 2>&1) || npm i --silent) || true
