#!/usr/bin/env bats

load './util/init.sh'

@test "Ensure local 'bake' is copied" {
	local f='./Bakefile.sh'

	cat > "$f" <<"EOF"
task.run() { :; }
EOF

	run bake -f "$f" run
	assert_success
	assert [ -f './bake' ]
}

@test "Sets correct options" {
	local f='./Bakefile.sh'

	cat > "$f" <<"EOF"
task.run() {
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

	run --separate-stderr bake -f "$f" run

	assert_success

	local line=
	while read -r line; do
		if [[ "$line" == *-no ]]; then
			refute [ "$line" ]
		fi
	done <<< "$output"; unset -v line
}

@test "Runs correct task" {
	local f='./Bakefile.sh'

	cat > "$f" <<"EOF"
task.run() {
	printf '%s\n' 'WOOF'
}
EOF

	run --separate-stderr bake -f "$f" run

	assert_success
	assert [ "$output" = 'WOOF' ]
}

@test "Runs stacktrace on error" {
	local f='./Bakefile.sh'

	cat > "$f" <<"EOF"
task.run() {
	bake.cfg stacktrace 'on'
	false
}
EOF

	run bake -f "$f" run

	assert_failure
	[[ "$output" == *'Stacktrace:'* ]]
	[[ "$output" == *'in task.run (Bakefile.sh:3)'* ]]
}

@test "No stacktrace on error if option set" {
	local f='./Bakefile.sh'

	cat > "$f" <<"EOF"
task.run() {
	false
}
EOF

	run bake -f "$f" run

	assert_failure
	[[ "$output" != *'Stacktrace:'* ]]
	[[ "$output" != *'in task.run (Bakefile.sh:2)'* ]]
}

@test "Sets key-value pairs like Make" {
	local f='./Bakefile.sh'

	cat > "$f" <<"EOF"
task.run() {
	printf '%s\n' "$key1"
	printf '%s\n' "$key2"
	printf '%s\n' "$key3"
}
EOF

	run --separate-stderr bake -f "$f" key1=value1 key2=value2 key3='mu nu' run

	assert_success
	assert [ "${lines[0]}" = 'value1' ]
	assert [ "${lines[1]}" = 'value2' ]
	assert [ "${lines[2]}" = 'mu nu' ]
}

@test "CDs to directory with Bakefile 1" {
	local f='./subdir/Bakefile.sh'

	mkdir -p "${f%/*}"
	cat > "$f" <<"EOF"
task.run() {
	printf '%s\n' "$PWD"
}
EOF

	run --separate-stderr bake -f "$f" run
	assert_success
	assert [ "${lines[0]}" = "$PWD/subdir" ]
}

@test "CDs to directory with Bakefile 2" {
	local f='./Bakefile.sh'

	cat > "$f" <<"EOF"
task.run() {
	printf '%s\n' "$PWD"
}
EOF

	local old_pwd="$PWD"
	mkdir -p 'subdir'
	cd 'subdir'
	run --separate-stderr bake run
	assert_success
	assert [ "${lines[0]}" = "$old_pwd" ]
}

@test "Runs init before all" {
	local f='./Bakefile.sh'

	cat > "$f" <<"EOF"
init() {
	printf '%s\n' 'flava'
}

task.run() {
	printf '%s\n' "blua"
}
EOF

	run --separate-stderr bake run
	assert_success
	assert [ "${lines[0]}" = 'flava' ]
	assert [ "${lines[1]}" = 'blua' ]
}
