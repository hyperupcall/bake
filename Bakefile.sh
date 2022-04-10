# shellcheck shell=bash

task.test() {
	bats tests
}

task.docs() {
	shdoc < './pkg/src/bakeScript.sh' > './docs/api.md'
}

task.release() {
	local version="$1"
	bake.assert_not_empty 'version'

	sed -ie "s|\(\t\tlocal bake_version='\)\(.*\)\('.*\)|\1$version\3|" './pkg/src/bakeScript.sh'
	basalt releases "$version"
}