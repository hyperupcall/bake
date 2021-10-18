# shellcheck shell=bash

main.bake() {
	if ! BAKE_ROOT="$(
		while [ ! -f 'Bakefile.sh' ] && [ "$PWD" != / ]; do
			if ! cd ..; then
				printf '%s\n' "Error: Could not cd .."
				exit 1
			fi
		done

		if [ "$PWD" = / ]; then
			printf '%s\n' "Error: Could not find 'bmake.sh'"
			exit 1
		fi

		printf '%s' "$PWD"
	)"; then
		exit 1
	fi

	cat >| "$BAKE_ROOT/bake" <<EOF
#!/usr/bin/env bash
set -eo pipefail
set -- "\${1:-}"

if [ "\$0" != "\${BASH_SOURCE[0]}" ]; then
	printf '%s\n' "Error: This file should not be sourced"
	return 1
fi

if ! BAKEFILE_ROOT="\$(
	while [ ! -f 'bake' ] && [ "\$PWD" != / ]; do
		if ! cd ..; then
			printf '%s\n' "Error: Could not cd .."
			exit 1
		fi
	done

	if [ "\$PWD" = / ]; then
		printf '%s\n' "Error: Could not find 'bmake.sh'"
		exit 1
	fi

	printf '%s' "\$PWD"
)"; then
	exit 1
fi
export BAKEFILE_ROOT

# shellcheck disable=SC2097,SC1007,SC2098
BAKEFILE_ROOT= source "\$BAKEFILE_ROOT/Bakefile.sh"

die() {
	if ((\$# == 1)); then
		set -- 1 "\${1:-}"
	fi

	if [ -n "\$2" ]; then
		error "\$2. Exiting"
	else
		error "Exiting"
	fi

	exit "\$1"
}


error() {
	if [[ -v NO_COLOR || \$TERM = dumb ]]; then
		printf "%s\n" "Error: \$1"
	else
		printf "\033[0;31m%s\033[0m\n" "Error: \$1" >&2
	fi
}

warn() {
	if [[ -v NO_COLOR || \$TERM = dumb ]]; then
		printf "%s\n" "Warn: \$1"
	else
		printf "\033[1;33m%s\033[0m\n" "Warn: \$1" >&2
	fi
}


info() {
	if [[ -v NO_COLOR || \$TERM = dumb ]]; then
		printf "%s\n" "Info: \$1"
	else
		printf "\033[0;34m%s\033[0m\n" "Info: \$1"
	fi
}


ensure() {
	if ! "\$@"; then
		printf '%s\n' "Error: Command '\$*'  failed to run successfully"
		exit 1
	fi
}

if [ -z "\$1" ]; then
	printf '%s\n' "Error: No task supplied"
	exit 1
fi

if declare -f task."\$1" >/dev/null 2>&1; then
	if ! task."\$1"; then
		printf '%s\n' "Error: Task '\$1' failed"
			echo \${FUNCNAME[*]}

		exit 1
	fi
else
	printf '%s\n' "Error: Task '\$1' not found"
	exit 1
fi

EOF

	chmod +x "$BAKE_ROOT/bake"
	"$BAKE_ROOT/bake" "$@"
}
