#!/usr/bin/env bats

load './util/init.sh'

@test "Config parsing works if option has no value" {
	cat > './Bakefile.sh' <<"EOF"
#config: big-print stacktrace
task.foo() {
	printf '%s\n' "1: ${__bake_config_map[big-print]}"
	printf '%s\n' "2: ${__bake_config_map[stacktrace]}"
}
EOF

	run --separate-stderr bake foo

	assert_success
	assert_line -n 0 -p '1: on'
	assert_line -n 1 -p '2: on'
}

@test "Config parsing works if option set to 'on'" {
	cat > './Bakefile.sh' <<"EOF"
#config: big-print=on stacktrace=on
task.foo() {
	printf '%s\n' "1: ${__bake_config_map[big-print]}"
	printf '%s\n' "2: ${__bake_config_map[stacktrace]}"
}
EOF

	run --separate-stderr bake foo

	assert_success
	assert_line -n 0 -p '1: on'
	assert_line -n 1 -p '2: on'
}

@test "Config parsing works if option set to 'off'" {
	cat > './Bakefile.sh' <<"EOF"
#config: big-print=off stacktrace=off
task.foo() {
	printf '%s\n' "1: ${__bake_config_map[big-print]}"
	printf '%s\n' "2: ${__bake_config_map[stacktrace]}"
}
EOF

	run --separate-stderr bake foo

	assert_success
	assert_line -n 0 -p '1: off'
	assert_line -n 1 -p '2: off'
}

@test "Config parsing works with assorted values" {
	cat > './Bakefile.sh' <<"EOF"
#config: big-print=on
init() {
	:
}

#config: stacktrace=off
task.foo() {
	util.print
}

#config: big-print=off stacktrace=off
task.bar() {
	util.print
}

util.print() {
	printf '%s\n' "1: ${__bake_config_map[big-print]}"
	printf '%s\n' "2: ${__bake_config_map[stacktrace]}"
}
EOF

	run --separate-stderr bake foo

	assert_success
	assert_line -n 0 -p '1: on'
	assert_line -n 1 -p '2: off'

	run --separate-stderr bake bar

	assert_success
	assert_line -n 0 -p '1: off'
	assert_line -n 1 -p '2: off'
}

@test "Config parsing warns if using comma as delimiter" {
	cat > './Bakefile.sh' <<"EOF"
#config: big-print=off,stacktrace=off
task.foo() {
	:
}
EOF

	run bake foo

	assert_success
	assert_line -n 0 -p 'Use spaces as delimiters rather than commas'
}

@test "Option doc works with space" {
	cat > './Bakefile.sh' <<"EOF"
# doc: foo comment
task.foo() {
	:
}

# doc: bar comment
task.bar() {
	:
}
EOF

	run bake -h

	assert_success
	assert_line -n 2 -p 'foo (foo comment)'
	assert_line -n 3 -p 'bar (bar comment)'
}

@test "Option doc works without space" {
	cat > './Bakefile.sh' <<"EOF"
#doc: foo comment
task.foo() {
	:
}

#doc: bar comment
task.bar() {
	:
}
EOF

	run bake -h

	assert_success
	assert_line -n 2 -p 'foo (foo comment)'
	assert_line -n 3 -p 'bar (bar comment)'
}

@test "Option stacktrace not printed by default" {
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

@test "Option stacktrace printed if set" {
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

@test "Option watch works in task" {
	cat > './Bakefile.sh' <<"EOF"
#watch: --clear
task.foo() {
	:
}
EOF
	mkdir -p './bin'
	cat > './bin/watchexec' <<"EOF"
#!/usr/bin/env bash
printf '%s\n' "stub-${0##*/}: $*"
EOF
	chmod +x './bin/watchexec'
	PATH="$PWD/bin:$PATH"

	run bake -w foo

	assert_success
	assert_line -n 0 -e 'stub-watchexec: --clear /.*? -- foo'
}

@test "Option watch works in task and init" {
	cat > './Bakefile.sh' <<"EOF"
# watch: --clear
init() {

}

#watch: -r
task.foo() {
	:
}
EOF
	mkdir -p './bin'
	cat > './bin/watchexec' <<"EOF"
#!/usr/bin/env bash
printf '%s\n' "stub-${0##*/}: $*"
EOF
	chmod +x './bin/watchexec'
	PATH="$PWD/bin:$PATH"

	run bake -w foo

	assert_success
	assert_line -n 0 -e 'stub-watchexec: --clear -r /.*? -- foo'
}

@test "Option watch works with reload" {
	cat > './Bakefile.sh' <<"EOF"
# watch: --reload
init() {

}
EOF
	mkdir -p './bin'
	cat > './bin/watchexec' <<"EOF"
#!/usr/bin/env bash
printf '%s\n' "stub-${0##*/}: $*"
EOF
	chmod +x './bin/watchexec'
	PATH="$PWD/bin:$PATH"

	run bake -w foo

	assert_success
	assert_line -n 0 -e 'stub-watchexec: --reload /.*? -- foo'
}
