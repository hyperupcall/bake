# shellcheck shell=bash

eval "$(basalt-package-init)"
basalt.package-init
basalt.package-load
basalt.load 'github.com/hyperupcall/bats-all' 'load.bash'

load './util/test_utils.sh'

source "$BASALT_PACKAGE_DIR/pkg/src/cmd/bake.sh"
bake() { main.bake "$@"; }

setup() {
	cd "$BATS_TEST_TMPDIR"
}

teardown() {
	cd "$BATS_SUITE_TMPDIR"
}
