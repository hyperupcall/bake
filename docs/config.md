# Config

Currently, there are three runtime configuration options

## Usage

Set configuration values through comments like so:

```sh
# config: stacktrace big-print=off
task.docs() {
	:
}
```

If no value is given, it defaults to `on`

## Options

### `stacktrace`

Prints a stacktrace when a task fails.

This isn't enabled by default since the failed task is rarely an issue with Bake, but the underlying command line tool it executes.

This is disabled by default.

### `big-print`

Big decorative lines are printed before and after execution of a task. This helps seeing which task is printed, but sometimes it can get in the way.

This is enabled by default.

## Environment

### `BAKE_FILE`

The absolute path of the `Bakefile.sh` being used for running tasks.

### `BAKE_ROOT`

The absolute path of the directory containing the aforementioned `Bakefile.sh`. Essentially `${BAKE_FILE%/*}`.

### `BAKE_OLDPWD`

The original directory (before `cd`ing to `BAKE_ROOT`).

### `PWD`

Because Bake automatically switches to `BAKE_ROOT` before executing a task, this has the same value as `BAKE_ROOT`.
