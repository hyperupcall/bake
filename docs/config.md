# Config

Currently, there are three runtime configuration options with `bake.cfg`

## `stacktrace`

Prints a stacktrace when a task fails.

This isn't enabled by default since the failed task is rarely an issue with Bake, but the underlying command line tool it executes. Disabling it by defualt prevents unecessary clogging of the terminal

## `pedantic-task-cd`

Ensures that the `$PWD` will _always_ be correct when running a task. Nearly always it is, with the only exception occuring for the case where a directory is changed within a task, and another task is manually ran

This isn't enabled by default since it traps `DEBUG` (and therefore feels messy)

## `big-print`

Big decorative lines are printed before and after execution of a task. This helps seeing which task is printed, but sometimes it can get in the way

This config switch _*only*_ works if `bake.cfg ...` is called either:

- On the first line of a `task.<TASK>()` function
- On the first line of the `init()` function

Like so:

```sh
task.test() {
  bake.cfg 'decorative-print' 'off'
}
```

This is enabled by default
