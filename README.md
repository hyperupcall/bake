# Bake

A Bash-based Make alternative

## Why?

Make is not meant to be used as a task runner. [Just](https://github.com/casey/just) and [scripts-to-rule-them-all](https://github.com/github/scripts-to-rule-them-all) help, but I wanted a simpler, more portable, and streamlined solution

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

task.succeed() {
	printf '%s\n' 'Success!'
}
```

In the same (or any child) directory:

```txt
$ bake deploy
-> RUNNING TASK 'deploy' =================================
yarn run v1.22.17
...
<- DONE ==================================================
```

When there is a failure...

```txt
$ bake fail 'WOOF'
-> RUNNING TASK 'docs' ===================================
WOOF
<- ERROR =================================================
Error (bake): Your 'Bakefile.sh' did not exit successfully
Stacktrace:
  -> Bakefile.sh:235 task.fail()
  -> bake:244 __bake_main()
$ echo $?
1
```

Prettified output is sent to standard error, so pipines works

```txt
$ bake succeed 2>/dev/null | cat
Success!
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

To sum it up, _it just works_

## Features

- Generates a `./bake` file, for use in CI, etc.
- `set`, `shopt`, `LANG`, (optionally _stacktrace_) boilerplate all set up
- Set variables à la Make: `bake key1=value1 key2=value2 docs`
- POSIX compliant
- Automatically `cd`'s to directory contaning Bakefile
- Pass `-f` to manually specify Bakefile
- Dead-simple, miniscule function API (see [api.md](./docs/api.md) for details)
- Use `init()` function to run code before any task execution
- Built-in support for [watchexec](https://github.com/watchexec/watchexec)
- Annotate task with description (or custom watch flags) using comments

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/bake
```
