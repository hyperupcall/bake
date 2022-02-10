# shellcheck shell=bash

fn3() {
	false
}

fn2() {
	fn3
}

fn1() {
	fn2
}

task.primary() {
	fn1
}
