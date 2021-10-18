# Bake

A Bash-based Make alternative

## Why?

Notwithstanding the fact that Make was not built to be a task runner, Makefiles are commonly used for running tasks

Make is inflexible and not ergonomic. Let's use what makes the most sense: Bash

All you have to do is create a `Bakefile.sh`

```sh
#!/usr/bin/env bash

task.deploy() {
	yarn format && yarn lint
	yarn build
	git commit -m v0.8.0 ... && git tag v0.8.0 ...
	gh release ...
}
```

Then, just run

```sh
bake deploy
```

This will automatically create a `./bake`, that you can use to execute your tasks in CI, or for those that don't have `bake`. All you need is Bash

Bake solves this by providing a simple framework for executing tasks, which are sensibly defined by Bash functions. Furthermore, a few tiny boilerplate functions are provided to make task execution possible without the `bake` executable (with pure Bash)

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/bake
```

## Reference

#### `BAKE_ROOT`

Environment variable with the absolute path to the directory that contains the `Bakefile.sh`
