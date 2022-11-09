#!/usr/bin/env bats

load './util/init.sh'

@test "unprefixed variable (uppercase) works" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$GOO"; }
EOF

	run --separate-stderr bake GOO=value foo

	assert_success
	assert_line -n 0 'value'
}

@test "unprefixed variable (not uppercase) works 1" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$Goo"; }
EOF

	run --separate-stderr bake Goo=value foo

	assert_success
	assert_line -n 0 'value'
}

@test "unprefixed variable (not uppercase) works 2" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$goo"; }
EOF

	run --separate-stderr bake goo=value foo

	assert_success
	assert_line -n 0 'value'
}

@test "prefixed variable (uppercase) works" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$var_GOO"; }
EOF

	run --separate-stderr bake GOO=value foo

	assert_success
	assert_line -n 0 'value'
}

@test "prefixed variable (not uppercase) works 1" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$var_Goo"; }
EOF

	run --separate-stderr bake Goo=value foo

	assert_success
	assert_line -n 0 'value'
}

@test "prefixed variable (not uppercase) works 2" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$var_goo"; }
EOF

	run --separate-stderr bake goo=value foo

	assert_success
	assert_line -n 0 'value'
}

@test "works with spaces" {
	cat > './Bakefile.sh' <<"EOF"
	task.foo() { printf '%s\n' "$var_goo"; }
EOF

	run --separate-stderr bake goo='val ue' foo

	assert_success
	assert_line -n 0 'val ue'
}
