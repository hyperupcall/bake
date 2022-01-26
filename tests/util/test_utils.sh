# shellcheck shell=bash

dup() {
	local dir=$1

	cp -r -- "$BATS_TEST_DIRNAME/testdata/$dir" .
	cd -- "$dir"
}
