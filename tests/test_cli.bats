#!/usr/bin/env bats

load './util/init.sh'

@test "Passing -f cd to correct directory" {
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

@test "Omitting -f cd to correct directory" {
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

@test "Argument GOO=value sets GOO variable" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	if [ "$GOO" = 'value' ]; then
		printf 'yes'
	else
		printf 'no'
	fi
}
EOF

	run --separate-stderr bake GOO=value foo

	assert_success
	assert_line -n 0 'yes'
}

@test "Argument GOO=value does not set var_GOO variable" {
cat > './Bakefile.sh' <<"EOF"
task.foo() {
	if [ "$var_GOO" = 'value' ]; then
		printf 'yes'
	else
		printf 'no'
	fi
}
EOF

	run --separate-stderr bake GOO=value foo

	assert_success
	assert_line -n 0 'no'
}

@test "Argument Goo=value does not create Goo variable" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	if [ "$Goo" = 'value' ]; then
		printf 'yes'
	else
		printf 'no'
	fi
}
EOF

	run --separate-stderr bake Goo=value foo

	assert_success
	assert_line -n 0 'no'
}

@test "Argument Goo=value creates var_Goo variable" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	if [ "$var_Goo" = 'value' ]; then
		printf 'yes'
	else
		printf 'no'
	fi
}
EOF

	run --separate-stderr bake Goo=value foo

	assert_success
	assert_line -n 0 'yes'
}

@test "Argument goo=value does not create goo variable" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	if [ "$goo" = 'value' ]; then
		printf 'yes'
	else
		printf 'no'
	fi
}
EOF

	run --separate-stderr bake goo=value foo

	assert_success
	assert_line -n 0 'no'
}

@test "Argument goo=value creates var_goo variable" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	if [ "$var_goo" = 'value' ]; then
		printf 'yes'
	else
		printf 'no'
	fi
}
EOF

	run --separate-stderr bake goo=value foo

	assert_success
	assert_line -n 0 'yes'
}

@test "Variable values with whitespace work variable" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$var_goo"; }
EOF

	run --separate-stderr bake goo='val ue' foo

	assert_success
	assert_line -n 0 'val ue'
}
