#!/usr/bin/env bash

# @name Bake
# @brief Bake: A Bash-based Make alternative
# @description Bake is a dead-simple task runner used to quickly cobble together shell scripts
#
# In a few words, Bake lets you call the following 'print' task with './bake print'
#
# ```bash
# #!/usr/bin/env bash
# task.print() {
# printf '%s\n' 'Contrived example'
# }
# ```
#
# Learn more about it [on GitHub](https://github.com/hyperupcall/bake)

if [ "$0" != "${BASH_SOURCE[0]}" ]; then
	printf '%s\n' "Error: This file should not be sourced" >&2
	return 1
fi

# @description Function 'trap' calls on 'ERR'
# @internal
__bake_trap_err() {
	local err_code=$?

	__bake_print_big "<- ERROR"

	if __bake_is_color; then
		printf "\033[0;31m%s\033[0m: %s\n" "Error (bake)" "Your 'Bakefile.sh' did not exit successfully"
	else
		printf '%s: %s\n' 'Error (bake)' "Your 'Bakefile.sh' did not exit successfully"
	fi

	if (( ${#FUNCNAME[@]} >> 2 )); then
		for ((i=0; i<${#FUNCNAME[@]}-1; i++)); do
			local bash_source=${BASH_SOURCE[$i+1]}; bash_source="${bash_source##*/}"
			printf '%s\n' "  -> $bash_source:${BASH_LINENO[$i]} ${FUNCNAME[$i]}()"
		done
	fi

	exit $err_code
} >&2

# @description Test whether color should be outputed
# @exitcode 0 if should print color
# @exitcode 1 if should not print color
# @internal
__bake_is_color() {
	! [[ -v NO_COLOR || $TERM == dumb ]]
}

# @description Prints `$1` formatted as a Bake error to standard error
# @arg $1 Text to print
# @internal
__bake_internal_error() {
	if __bake_is_color; then
		printf "\033[0;31m%s\033[0m: %s\n" "Error (bake)" "$1" >&2
	else
		printf '%s: %s\n' 'Error (bake)' "$1" >&2
	fi
}

# @description Prints `$1` formatted as an error to standard error
# @arg $1 string Text to print
# @internal
__bake_error() {
	if __bake_is_color; then
		printf "\033[0;31m%s\033[0m: %s\n" 'Error' "$1" >&2
	else
		printf '%s: %s\n' 'Error' "$1" >&2
	fi
}

# @description Nicely prints all 'Basalt.sh' tasks to standard output
# @internal
__bake_print_tasks() {
	# shellcheck disable=SC1007,SC2034
	local regex="^(([[:space:]]*function[[:space:]]*)?task\.(.*?)\(\)).*" line= fn_name=
	printf '%s\n' 'Tasks:'
	while IFS= read -r line; do
		if [[ "$line" =~ $regex ]]; then
			printf '%s\n' "  -> ${BASH_REMATCH[3]}"
		fi
	done < "$BAKE_ROOT/Bakefile.sh"; unset line
}

# @description Prints text that takes up the whole terminal width
# @arg $1 string Text to print
# @internal
__bake_print_big() {
	local print_text="$1"

	# shellcheck disable=SC1007
	local _stty_height= _stty_width=
	read -r _stty_height _stty_width < <(
		if command -v stty &>/dev/null; then
			stty size
		else
			printf '%s\n' '20 80'
		fi
	)

	local separator_text=
	# shellcheck disable=SC2183
	printf -v separator_text '%*s' $((_stty_width - ${#print_text} - 1))
	printf -v separator_text '%s' "${separator_text// /=}"
	if __bake_is_color; then
		printf '\033[1m%s %s\033[0m\n' "$print_text" "$separator_text"
	else
		printf '%s %s\n' "$print_text" "$separator_text"
	fi
}

# @description Prints `$1` formatted as an error to standard error, then exits with code 1
# @arg $1 string Text to print
die() {
	__bake_print_big "<- ERROR"

	if [ -n "$1" ]; then
		__bake_error "$1. Exiting"
	else
		__bake_error 'Exiting'
	fi
	exit 1
}

# @description Prints `$1` formatted as a warning to standard error
# @arg $1 string Text to print
warn() {
	if __bake_is_color; then
		printf "\033[1;33m%s\033[0m: %s\n" 'Warn' "$1" >&2
	else
		printf '%s: %s\n' 'Warn' "$1" >&2
	fi
}

# @description Prints `$1` formatted as information to standard output
# @arg $1 string Text to print
info() {
	if __bake_is_color; then
		printf "\033[0;34m%s\033[0m: %s\n" 'Info' "$1"
	else
		printf '%s: %s\n' 'Info' "$1"
	fi
}

# @description Dies if any of the supplied variables are empty
# @arg $@ string Variable names to print
assert.nonempty() {
	local variable_name=
	for variable_name; do
		local -n variable="$variable_name"

		if [ -z "$variable" ]; then
			die "Variable '$variable_name' is empty"
		fi
	done
}

# Note: Don't do `command -v` with anything related to `Bakefile.sh`, since `errexit` won't work
main() {
	set -Eeo pipefail
	shopt -s dotglob extglob globasciiranges globstar lastpipe nullglob shift_verbose
	export LANG='C' LC_CTYPE='C' LC_NUMERIC='C' LC_TIME='C' LC_COLLATE='C' LC_MONETARY='C' LC_MESSAGES='C' \
		LC_PAPER='C' LC_NAME='C' LC_ADDRESS='C' LC_TELEPHONE='C' LC_MEASUREMENT='C' LC_IDENTIFICATION='C' LC_ALL='C'
	trap '__bake_trap_err' 'ERR'

	local task=$1
	set -- "${@:2}"

	if [ -z "$task" ]; then
		__bake_internal_error "No valid task supplied"
		__bake_print_tasks >&2
		exit 1
	fi

	if ! cd "$BAKE_ROOT"; then
		__bake_internal_error "cd failed"
		exit 1
	fi

	# shellcheck disable=SC2097,SC1007,SC2098,SC1091
	task= source "$BAKE_ROOT/Bakefile.sh"

	if declare -f task."$task" >/dev/null 2>&1; then
		__bake_print_big "-> RUNNING TASK '$task'"
		task."$task" "$@"
		__bake_print_big "<- DONE"
	else
		__bake_internal_error "Task '$task' not found"
		__bake_print_tasks >&2
		exit 1
	fi
}

main "$@"
