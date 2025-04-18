#!/usr/bin/env bats

load './util/init.sh'

declare -g output_v1_11_2="-> RUNNING TASK 'apple' ================
pie
<- DONE ================================"

@test "v1.11.2 direct run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.11.2.sh" ./bake
	run ./bake apple
	assert_success
	assert_output "$output_v1_11_2"
}

@test "v1.11.2 indirect run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.11.2.sh" ./bake
	run bake apple
	assert_success
	assert_output "$output_v1_11_2"
}

declare -g output_v1_11_1="-> RUNNING TASK 'apple' ================
pie
<- DONE ===== (time: ) ================="

@test "v1.11.1 direct run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.11.1.sh" ./bake
	run ./bake apple
	assert_success
	assert_output "$output_v1_11_1"
}

@test "v1.11.1 indirect run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.11.1.sh" ./bake
	run bake apple
	assert_success
	assert_output "$output_v1_11_1"
}

declare -g output_v1_11_0="-> RUNNING TASK 'apple' ================
pie
<- DONE ===== (time: ) ================="

@test "v1.11.0 direct run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.11.0.sh" ./bake
	run ./bake apple
	assert_success
	assert_output "$output_v1_11_0"
}

@test "v1.11.0 indirect run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.11.0.sh" ./bake
	run bake apple
	assert_success
	assert_output "$output_v1_11_0"
}

declare -g output_v1_10_1="-> RUNNING TASK 'apple' ================
pie
<- DONE ================================"

@test "v1.10.1 direct run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.10.1.sh" ./bake
	run ./bake apple
	assert_success
	assert_output "$output_v1_10_1"
}

@test "v1.10.1 indirect run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.10.1.sh" ./bake
	run bake apple
	assert_success
	assert_output "$output_v1_10_1"
}

declare -g output_v1_9_0="-> RUNNING TASK 'apple' ================
pie
<- DONE ================================"

@test "v1.9.0 direct run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.9.0.sh" ./bake
	NO_COLOR= run ./bake apple
	assert_success
	assert_output "$output_v1_9_0"
}

@test "v1.9.0 indirect run works" {
cat > './Bakefile.sh' <<"EOF"
task.apple() {
	printf '%s\n' 'pie'
}
EOF
	cp "$BATS_TEST_DIRNAME/bakescripts/bake-v1.9.0.sh" ./bake
	NO_COLOR= run bake apple
	assert_success
	assert_output "$output_v1_9_0"
}

declare -g output_v0_1_0="pie"
