#!/usr/bin/env bats

load './util/init.sh'

@test "Ensure local 'bake' is copied" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() { :; }
EOF

	run bake foo
	assert_success
	assert [ -f './bake' ]
}


@test "Works as intended" {
cat > './Bakefile.sh' <<"EOF"
task.print() {
	printf '%s\n' 'rainbows'
}
EOF
	cp "$BATS_TEST_DIRNAME/../bin/bake" ./bake

	run --separate-stderr ./bake print
	assert_success
	assert_output 'rainbows'
}

@test "Works as intended 2" {
cat > './Bakefile.sh' <<"EOF"
task.print() {
	printf '%s\n' 'rainbows'
}
EOF

	run --separate-stderr "$BATS_TEST_DIRNAME/../bin/bake" print
	assert_success
	assert_output 'rainbows'
}

@test "Sets correct shell options" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	p() { printf '%s\n' "$1"; }

	shopt -q -o errtrace || p 'errtrace-no'
	shopt -q -o errexit || p 'errexit-no'
	shopt -q -o pipefail || p 'pipefail-no'
	shopt -q dotglob || p 'dotglob-no'
	shopt -q extglob || p 'extglob-no'
	shopt -q globasciiranges || p 'globasciiranges-no'
	shopt -q globstar || p 'globstar-no'
	shopt -q lastpipe || p 'lastpipe-no'
	shopt -q shift_verbose || p 'shift_verbose-no'
	[ "$LANG" = 'C' ] || p 'LANG-no'
	[ "$LC_CTYPE" = 'C' ] || p 'LC_CTYPE-no'
	[ "$LC_NUMERIC" = 'C' ] || p 'LC_NUMERIC-no'
	[ "$LC_ALL" = 'C' ] || p 'LC_ALL-no'
}
EOF

	run --separate-stderr bake foo

	assert_success

	local line=
	while read -r line; do
		if [[ "$line" == *-no ]]; then
			refute [ "$line" ]
		fi
	done <<< "$output"; unset -v line
}

@test "Runs init first" {
	cat > './Bakefile.sh' <<"EOF"
init() {
	printf '%s\n' 'flava'
}

task.foo() {
	printf '%s\n' "blua"
}
EOF

	run --separate-stderr bake foo

	assert_success
	assert_line -n 0 'flava'
	assert_line -n 1 'blua'
}

@test "Runs correct task" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	printf '%s\n' 'WOOF'
}
EOF

	run --separate-stderr bake foo

	assert_success
	assert [ "$output" = 'WOOF' ]
}

@test "Correct error code on return" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	return 99
}
EOF

	run bake foo

	assert_failure
	[ "$status" -eq 99 ]
}

@test "Correct error code on exit" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	exit 99
}
EOF

	run bake foo

	[ "$status" -eq 99 ]
}
