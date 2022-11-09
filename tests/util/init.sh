# shellcheck shell=bash
eval "$(basalt-package-init)"
basalt.package-init || exit
basalt.package-load
basalt.load 'github.com/hyperupcall/bats-all' 'load.bash'

bats_require_minimum_version 1.7.0

load './util/test_utils.sh'

BAKE_INTERNAL_CAN_SOURCE='yes' BAKE_INTERNAL_TEST='yes' source "$BASALT_PACKAGE_DIR/pkg/bin/bake"
bake() { "$BASALT_PACKAGE_DIR/pkg/bin/bake" "$@"; }

setup() {
	cd "$BATS_TEST_TMPDIR"
}

teardown() {
	cd "$BATS_SUITE_TMPDIR"
}
