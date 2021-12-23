#!/usr/bin/env bash

if [ "$0" != "${BASH_SOURCE[0]}" ]; then
	printf '%s\n' "Error: This file should not be sourced" >&2
	return 1
fi

# Private API (unstable)
__bake_trap_err() {
	local err_code=$?

	if __bake_is_tty; then
		printf "\033[0;31m%s\033[0m %s\n" "Error (bake)" "Your 'Bakefile.sh' did not exit successfully"
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

__bake_is_tty() {
	! [[ -v NO_COLOR || $TERM == dumb ]]
}

__bake_die() {
	if __bake_is_tty; then
		printf "\033[0;31m%s\033[0m %s\n" "Error (bake)" "$1" >&2
	else
		printf '%s: %s\n' 'Error (bake)' "$1" >&2
	fi

	exit 1
}

# Public API
die() {
	if [ -n "$1" ]; then
		error "$1. Exiting"
	else
		error 'Exiting'
	fi

	exit 1
}

error() {
	if __bake_is_tty; then
		printf "\033[0;31m%s\033[0m: %s\n" 'Error' "$1" >&2
	else
		printf '%s: %s\n' 'Error' "$1" >&2
	fi
}

warn() {
	if __bake_is_tty; then
		printf "\033[1;33m%s\033[0m: %s\n" 'Warn' "$1" >&2
	else
		printf '%s: %s\n' 'Warn' "$1" >&2
	fi
}

info() {
	if __bake_is_tty; then
		printf "\033[0;34m%s\033[0m: %s\n" 'Info' "$1"
	else
		printf '%s: %s\n' 'Info' "$1"
	fi
}

run() {
	if ! "$@"; then
		die "Command '$*' failed to run successfully"
	fi
}

# Note: Don't do `command -v` with anything related to `Bakefile.sh`, since `errexit` won't work
main() {
	set -Eeo pipefail
	shopt -s dotglob extglob globasciiranges globstar lastpipe nullglob shift_verbose
	export LANG='C' LC_CTYPE='C' LC_NUMERIC='C' LC_TIME='C' LC_COLLATE='C' LC_MONETARY='C' LC_MESSAGES='C' \
		LC_PAPER='C' LC_NAME='C' LC_ADDRESS='C' LC_TELEPHONE='C' LC_MEASUREMENT='C' LC_IDENTIFICATION='C' LC_ALL='C'
	trap '__bake_trap_err' 'ERR'

	task=$1
	set -- "${@:2}"

	if [ -z "$task" ]; then
		__bake_die "No task supplied"
	fi

	# shellcheck disable=SC2097,SC1007,SC2098,SC1091
	task= source "$BAKE_ROOT/Bakefile.sh"

	if declare -f task."$task" >/dev/null 2>&1; then
		read -r _stty_height _stty_width < <(stty size)

		local print_text="-> RUNNING TASK '$task'"
		# shellcheck disable=SC2183
		printf -v separator_text '%*s' $((_stty_width - ${#print_text} - 1))
		printf -v separator_text '%s' "${separator_text// /=}"
		if __bake_is_tty; then
			printf '\033[1m%s %s\033[0m\n' "$print_text" "$separator_text"
		else
			printf '%s %s\n' "$print_text" "$separator_text"
		fi
		unset -v _stty_height _stty_width print_text separator_text

		task."$task" "$@"
	else
		__bake_die "Task '$task' not found"
	fi
}

main "$@"
