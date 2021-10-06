# shellcheck shell=bash

bmake.main() {
	__internal_subcommand=
	for arg; do case "$arg" in
		-*)
			printf '%s\n' "Error: Flag '$arg' not valid"
			exit 1
			;;
		*)
			__internal_subcommand="$arg"
			shift
			;;
	esac done; unset arg

	if [ -z "$__internal_subcommand" ]; then
		printf '%s\n' "Error: No subcommand was specified"
		exit 1
	fi

	while [ ! -f 'bmake.sh' ] && [ "$PWD" != / ]; do
		if ! cd ..; then
			printf '%s\n' "Error: Could not cd .."
			exit 1
		fi
	done

	if [ "$PWD" = / ]; then
		printf '%s\n' "Error: Could not find 'bmake.sh'"
		exit 1
	fi

	source "$PWD/bmake.sh"
	if declare -F task."$__internal_subcommand" &>/dev/null; then
		task."$__internal_subcommand" "$@"
	else
		printf '%s\n' "Error: Task '$__internal_subcommand' not found"
		exit 1
	fi
}
