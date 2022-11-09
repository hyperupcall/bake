#!/usr/bin/env bats

load './util/init.sh'

@test "fails 1" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	return 99
}
EOF

	run bake foo

	assert_failure
	[ "$status" -eq 99 ]
}

@test "fails 2" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	exit 99
}
EOF

	run bake foo

	[ "$status" -eq 99 ]
}

@test "fails 3" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	false
}
EOF

	run bake foo

	[ "$status" -eq 1 ]
}

@test "succeeds 1" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	return 0
}
EOF

	run bake foo

	[ "$status" -eq 0 ]
}

@test "succeeds 2" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	exit 0
}
EOF

	run bake foo

	[ "$status" -eq 0 ]
}

@test "succeeds 3" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	:
}
EOF

	run bake foo

	[ "$status" -eq 0 ]
}
