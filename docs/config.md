# Config

Currently, there are three runtime configuration options with `bake.cfg`

## Usage

There are two ways to set configuration values. Best is the use of comments like so:

```sh
# config: stacktrace big-print=off
task.docs() {
	:
}
```

If no value is given, it defaults to `true`

## Options

### `stacktrace`

Prints a stacktrace when a task fails.

This isn't enabled by default since the failed task is rarely an issue with Bake, but the underlying command line tool it executes. Disabling it by defualt prevents unecessary clogging of the terminal

### `big-print`

Big decorative lines are printed before and after execution of a task. This helps seeing which task is printed, but sometimes it can get in the way

This is enabled by default

### `pedantic-task-cd` (deprecated)

Ensures that the `$PWD` will _always_ be correct when running a task. Nearly always it is, with the only exception occuring for the case where a directory is changed within a task, and another task is manually ran

This isn't enabled by default since it traps `DEBUG` (and therefore feels messy)

## Environment

### `BAKE_FILE`

The absolute path of the `Bakefile.sh` being used for running tasks

### `BAKE_ROOT`

The absolute path of the directory containing the aforementioned `Bakefile.sh`. Essentially `${BAKE_FILE%/*}`

### `PWD`

Because Bake automatically switches to `BAKE_ROOT` before executing a task, this has the same value as `BAKE_ROOT`
