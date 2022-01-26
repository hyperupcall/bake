#!/usr/bin/env bash

task.test() {
	bats tests
}

task.docs() {
	shdoc < './pkg/src/bakeScript.sh' > './docs/api.md'
}
