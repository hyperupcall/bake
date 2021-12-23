# Bake

A Bash-based Make alternative

## Why?

Make is not meant to be used as a task runner. [Just](https://github.com/casey/just) and [scripts-to-rule-them-all](https://github.com/github/scripts-to-rule-them-all) help, but I wanted both a simpler and more portable solution

It's simple: write a `Bakefile.sh` script:

```sh
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
```

You get the idea...

In the same directory:

```txt
$ bake deploy
-> RUNNING TASK 'deploy' ==============================
yarn run v1.22.17
...
```

When there is a failure...

```txt
$ bake fail 'WOOF'
WOOF
Error (bake): Your 'Bakefile.sh' did not exit successfully
  -> Bakefile.sh:17 __bake_trap_err()
  -> bake:117 task.fail()
  -> bake:123 main()
$ echo $?
1
```

If you don't remember the tasks...

```txt
$ bake
Error (bake) No task supplied
Tasks:
  -> lint
  -> deploy
  -> fail
```

_It just works_

## Features

- Generates a `./bake` file, for use in CI, etc.
- _Stacktrace_, `set`, `shopt`, `LANG` boilerplate all set up
- Dead-simple, miniscule function API (`die()`, `info()`, etc.)

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/bake
```
