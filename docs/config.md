# Config

Currently, there are three runtime configuration options with `bake.cfg`

## `stacktrace`

Prints a stacktrace when a task fails.

This isn't enabled by default since the failed task is rarely an issue with Bake, but the underlying command line tool it executes. Not disabling it will unecessarily clog the terminal with useless text

## `pedantic-task-cd`

Ensures that the `$PWD` will _always_ be correct when running a task. In nearly all cases it is, with the sole exception being changing a directory mid-task and running another task from there.

This isn't enabled by default since it traps `DEBUG` (and therefore feels messy)

## `big-print`

Sometimes, big decorative lines are printed, such as before and after executing a Task. This helps seeing which task is printed, but sometimes it can get in the way of things

This option is special because the actual function only checks at runtime if you've passed 'yes' or 'no'. To properly use this, make sure that this config option is the _first line_ after the function declaration like so

```sh
task.test() {
  bake.cfg 'decorative-print' 'off'
}
```

You can use single, double, or no quotes. If the line is anywhere else this will not work and silently fail. This behavior depends on the `-A` flag of grep, which is supported by GNU Grep, BSD Grep, BusyBox Grep (if built with it)

This is enabled by default.
