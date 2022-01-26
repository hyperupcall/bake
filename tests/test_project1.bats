#!/usr/bin/env bats

load './util/init.sh'

@test "source works" {
	dup 'project-1'

	run --separate-stderr bake print_fox

	[ "$status" -eq 0 ]
	[ "$lines" = 'fox' ]
}
