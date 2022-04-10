# Bake

Bake: A Bash-based Make alternative

## Overview

Bake is a dead-simple task runner used to quickly cobble together shell scripts

In a few words, Bake lets you call the following 'print' task with './bake print'

```bash
#!/usr/bin/env bash
task.print() {
printf '%s\n' 'Contrived example'
}
```

Learn more about it [on GitHub](https://github.com/hyperupcall/bake)

## Index

* [bake.die()](#bakedie)
* [bake.warn()](#bakewarn)
* [bake.info()](#bakeinfo)
* [bake.assert_nonempty()](#bakeassert_nonempty)
* [bake.assert_not_empty()](#bakeassert_not_empty)
* [bake.assert_cmd()](#bakeassert_cmd)
* [bake.cfg()](#bakecfg)

### bake.die()

Prints `$1` formatted as an error and the stacktrace to standard error,
then exits with code 1

#### Arguments

* **$1** (string): Text to print

### bake.warn()

Prints `$1` formatted as a warning to standard error

#### Arguments

* **$1** (string): Text to print

### bake.info()

Prints `$1` formatted as information to standard output

#### Arguments

* **$1** (string): Text to print

### bake.assert_nonempty()

Dies if any of the supplied variables are empty. Deprecated in favor of 'bake.assert_not_empty'

#### Arguments

* **...** (string): Names of variables to check for emptiness

#### See also

* [bake.assert_not_empty](#bakeassert_not_empty)

### bake.assert_not_empty()

Dies if any of the supplied variables are empty

#### Arguments

* **...** (string): Names of variables to check for emptiness

### bake.assert_cmd()

Dies if a command cannot be found

#### Arguments

* **$1** (string): Command name to test for existence

### bake.cfg()

Change the behavior of Bake. See [guide.md](./docs/guide.md) for details

#### Arguments

* **$1** (string): Name of config property to change
* **$2** (string): New value of config property

