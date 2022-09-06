# shellcheck shell=bash

# doc: build docs
# watch: -c
init() {
	:
}

# watch: --ignore **/docs/*
# config: stacktrace=on pedantic-cd bigprint=off
task.docs() {
	shdoc < './pkg/src/bakeScript.sh' > './docs/api.md'
}

# doc: release information
task.release() {
	local version="$1"
	bake.assert_not_empty 'version'

	if basalt release "$version"; then
		sed -i "s|\(\t\tlocal bake_version='\)\(.*\)\('.*\)|\1$version\3|" './pkg/src/bakeScript.sh'
		git add './pkg/src/bakeScript.sh'
		git commit --amend --no-edit
	fi
}

task.release-post() {
	local version{1,2}=

	version1=$(sed -n "s|\t\tlocal bake_version='\(.*\)'.*|\1|p" './pkg/src/bakeScript.sh')
	version2=$(sed -n "s|version = '\(.*\)'|\1|p" './basalt.toml')

	if [ "$version1" != "$version2" ]; then
		bake.die "Version '$version1' and version '$version2' do not match"
	fi
}
