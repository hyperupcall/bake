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
* [bake.assert_cmd()](#bakeassert_cmd)

### bake.die()

Prints `$1` formatted as an error to standard error, then exits with code 1

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

Dies if any of the supplied variables are empty

#### Arguments

* **...** (string): Variable names to print

### bake.assert_cmd()

Dies if a command cannot be found

#### Arguments

* **$1** (string): Command to test for existence

