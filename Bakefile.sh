#!/usr/bin/env bash

dobad() { echo 'doing bad'; return 2; }

task.seven() {
	if [ -e fakefile ]; then
		echo is handled
	fi
	false || echo not
	echo 'going to fail'
	dobad
	echo $?
	echo 'after failure'
}
