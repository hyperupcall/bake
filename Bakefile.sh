# shellcheck shell=bash

# doc: This is a stub for a function that, in general, performs
# doc: the task of initialization. Initialization is important.
# doc: build docs
# watch: -c
init() {
	:
}

#doc: This builds documentation and writes it do a particular
#doc: file. It also performs other functions.
#watch: --ignore **/docs/*
#config: big-print=off
task.docs() {
	shdoc < './bin/bake' > './docs/api.md'
}

task.test() {
	bats './tests'
}
