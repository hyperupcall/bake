#!/usr/bin/env bats

load './util/init.sh'

@test "Variable BAKE_FILE is set" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	printf '%s\n' "$BAKE_FILE"
}
EOF

	local bake_file="$PWD/Bakefile.sh"
	mkdir './subdir'
	cd './subdir'

	run --separate-stderr bake -f '../Bakefile.sh' foo

	assert_success
	assert_line -n 0 "$bake_file"
}

@test "Variable BAKE_ROOT is set" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	printf '%s\n' "$BAKE_ROOT"
}
EOF

	local bake_root="$PWD"
	mkdir './subdir'
	cd './subdir'

	run --separate-stderr bake -f '../Bakefile.sh' foo

	assert_success
	assert_line -n 0 "$bake_root"
}

@test "Variable BAKE_OLDPWD is set" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	printf '%s\n' "$BAKE_OLDPWD"
}
EOF

	mkdir './subdir'
	cd './subdir'
	local oldpwd="$PWD"

	run --separate-stderr bake -f '../Bakefile.sh' foo

	assert_success
	assert_line -n 0 "$oldpwd"
}
