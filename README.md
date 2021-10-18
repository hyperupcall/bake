# Bake

A Bash-based Make alternative

## Why?

Make is not meant to be used as a task runner. Why not use what already makes sense: Bash

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

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/bake
```

## Bugs

- `set -e` doesn't work properly


## Reference

Use these environment variables and functions _within tasks_ of your Bakefile

#### `BAKE_ROOT`

Environment variable with the absolute path to the directory that contains the `Bakefile.sh`

#### `run()`

Run a command and exit on failure

#### `die()`

#### `error`

#### `warn()`

### `info()`
