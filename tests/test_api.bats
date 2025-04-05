#!/usr/bin/env bats

load './util/init.sh'

@test "bake.assert_nonempty works" {
	local a='value'
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	local a='value'
	bake.assert_nonempty a
}
EOF
	run bake foo

	assert_success
	assert_output -p 'is deprecated'
}
