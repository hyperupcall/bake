#!/usr/bin/env bats

load './util/init.sh'

@test "Sets correct options" {
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

@test "Runs init before all" {
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
