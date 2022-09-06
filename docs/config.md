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

The deprecated method is with `bake.cfg`. Do not use this method as it will be removed in a future release. Example:

```sh
bake.cfg 'big-print' 'off'
```

## Options

### `stacktrace`

Prints a stacktrace when a task fails.

This isn't enabled by default since the failed task is rarely an issue with Bake, but the underlying command line tool it executes. Disabling it by defualt prevents unecessary clogging of the terminal

### `big-print` (REMOVED)

This is only configurable in the comments.

Big decorative lines are printed before and after execution of a task. This helps seeing which task is printed, but sometimes it can get in the way

This config switch __only__ works if `bake.cfg ...` is called either:

- On the first line of a `task.<TASK>()` function
- On the first line of the `init()` function

Like so:

```sh
task.test() {
  bake.cfg 'big-print' 'off'
}
```

This is enabled by default

### `pedantic-task-cd`

Ensures that the `$PWD` will _always_ be correct when running a task. Nearly always it is, with the only exception occuring for the case where a directory is changed within a task, and another task is manually ran

This isn't enabled by default since it traps `DEBUG` (and therefore feels messy)
