# shellcheck shell=bash
eval "$(basalt-package-init)"
basalt.package-init || exit
basalt.package-load
basalt.load 'github.com/hyperupcall/bats-all' 'load.bash'

bats_require_minimum_version 1.7.0

bake() { "$BASALT_PACKAGE_DIR/pkg/bin/bake" "$@"; }

setup_file() {
	PATH="$BATS_TEST_DIRNAME/bin:$PATH"
}

setup() {
	cd "$BATS_TEST_TMPDIR"
}

teardown() {
	cd "$BATS_SUITE_TMPDIR"
}
