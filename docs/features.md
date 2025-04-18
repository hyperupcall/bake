# Features

## Sensible Defaults

Say goodbye to shellscript boilerplate. The following options are set:

```sh
set -ETeo pipefail
shopt -s dotglob extglob globasciiranges globstar lastpipe shift_verbose noexpand_translation
export LANG='C' LC_CTYPE='C' ... LC_ALL='C'
```

## Make-esque variable-setting

Set variables as you would with make; there are additional constraints. Variables that are all caps such as `CC` can be directly accessed; otherwise, the name is prefixed with `var_`. Like so:

```sh
bake CC=gcc should_eat=yes run
```

```sh
task.run() {
	printf '%s\n' "$CC" "$var_should_eat"
}
```

## Automatic `cd`

Typically, shell sripts contain code for changing to the main project directory:

```bash
cd "$(dirname "$0")/.."
```

`bake` automatically handles this for you, changing the directory in tasks to the directory that contains `Bakefile.sh`.

## Environment Variables

Bash sets various environment variables

- `BAKE_FILE`: the absolute path of the `Bakefile.sh` being used for running tasks.
- `BAKE_ROOT`: the absolute path of the directory containing `BAKE_FILE`. This has the same value as `PWD` at the start of a task.
- `BAKE_OLDPWD`: the original directory where bake was invoked from.

## Config Comments

Set configuration values through comments like so:

```sh
#config: stacktrace big-print=off
task.docs() {
	:
}
```

If no value is given, it defaults to `on`. There are several keys:

## Big prints

`RUNNING TASK`

## `init` Function

We have `init()` function for repetitive things to do on each invocation (`set -e`, etc.)

## tracking time

We track time and when task ends, we print total time of execution

## Script things

### `init()`

## `watchexec` support

It's super easy to make a Bake task automatically reload on a file change. Simply use the `-w` flag:

```sh
#watch: --ignore main
task.buld() {
	"${CC:-gcc}" -o main "$@" main.cpp
}
```

```sh
bake -w build
```

## Version Consistency

If the version of `./bake` and, say, `~/bin/bake` are different, `bake` will always execute the local version for consistency. Pass `-u` to update `./bake` with the current version.
