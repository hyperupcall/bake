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
