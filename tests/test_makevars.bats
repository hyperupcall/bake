#!/usr/bin/env bats

load './util/init.sh'

@test "uppercase unprefix succeeds" {
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

@test "uppercase prefix fails" {
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

@test "lowercase unprefix fails" {
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

@test "lowercase unprefix fails 2" {
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

@test "lowercase prefix succeeds" {
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

@test "lowercase prefix succeeds 2" {
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

@test "works with spaces" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$var_goo"; }
EOF

	run --separate-stderr bake goo='val ue' foo

	assert_success
	assert_line -n 0 'val ue'
}
