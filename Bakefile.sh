#!/usr/bin/env bash

task.lint() {
	prettier "**/*.{js,css}"
	eslint '.'
	stylelint "**/*.css"
}

task.deploy() {
	yarn build
	git commit -m v0.1.0 ... && git tag v0.1.0 ...
	gh release ...
}

task.fail() {
	printf '%s\n' "$1"
	false
}
