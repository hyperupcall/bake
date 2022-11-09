#!/usr/bin/env bats

load './util/init.sh'

@test "correct directory without applying -f" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	printf '%s\n' "$PWD"
}
EOF

	local pwd="$PWD"

	run --separate-stderr bake foo

	assert_success
	assert_line -n 0 "$pwd"
}

@test "correct directory with applying -f 1" {
	cat > './Bakefile.sh' <<"EOF"
task.run() {
	printf '%s\n' "$PWD"
}
EOF

	local old_pwd="$PWD"
	mkdir -p './subdir'
	cd './subdir'

	run --separate-stderr bake -f '../Bakefile.sh' run

	assert_success
	assert_line -n 0 "$old_pwd"
}
