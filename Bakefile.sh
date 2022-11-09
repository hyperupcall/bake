# shellcheck shell=bash

# doc: build docs
# watch: -c
init() {
	:
}

# watch: --ignore **/docs/*
# config: big-print=off
task.docs() {
	shdoc < './pkg/bin/bake' > './docs/api.md'
}
