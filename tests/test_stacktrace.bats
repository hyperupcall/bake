#!/usr/bin/env bats

load './util/init.sh'

@test "Runs stacktrace on error" {
	cat > './Bakefile.sh' <<"EOF"
# config: stacktrace
task.foo() {
	false
}
EOF

	run bake foo

	assert_failure
	assert_line -p 'Stacktrace:'
	assert_line -p 'in task.foo (Bakefile.sh:3)'
}

@test "No stacktrace on error if option set" {
	cat > './Bakefile.sh' <<"EOF"
task.foo() {
	false
}
EOF

	run bake foo

	assert_failure
	refute_line -p 'Stacktrace:'
	refute_line -p 'in task.run (Bakefile.sh:2)'
}
