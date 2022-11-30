# Config

### `doc`

Documentation for `-h`

### `watch`

Flags for `-w`

### `config`

General options:

#### `stacktrace`

Prints a stacktrace when a task fails.

This isn't enabled by default since the failed task is rarely an issue with Bake, but the underlying command line tool it executes.

This is disabled by default.

#### `big-print`

Big decorative lines are printed before and after execution of a task. This helps seeing which task is printed, but sometimes it can get in the way.

This is enabled by default.

## `watchexec` integration

When the `-w` flag is passed, we wrap `bake` in watchexec
