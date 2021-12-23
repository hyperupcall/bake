#!/usr/bin/env bash

dobad() { echo 'doing bad'; return 2; }

task.seven() {
	echo aaa "$@"

	echo last
	false
	echo final
}
