# shellcheck shell=bash

main.bake() {
	if ! BAKE_ROOT="$(
		while [ ! -f 'Bakefile.sh' ] && [ "$PWD" != / ]; do
			if ! cd ..; then
				printf '%s\n' "Error: Could not cd .." >&2
				exit 1
			fi
		done

		if [ "$PWD" = / ]; then
			printf '%s\n' "Error: Could not find 'Bakefile.sh'" >&2
			exit 1
		fi

		printf '%s' "$PWD"
	)"; then
		exit 1
	fi

	if ! cp -f "$BASALT_PACKAGE_DIR/pkg/src/bakeScript.sh" "$BAKE_ROOT/bake"; then
		printf '%s\n' "Error: Could not copy 'bakeScript.sh'" >&2
		exit 1
	fi
	if ! chmod +x "$BAKE_ROOT/bake"; then
		printf '%s\n' "Error: could not 'chmod +x' bake script" >&2
		exit 1
	fi

	unset -v BASALT_PACKAGE_DIR
	# shellcheck disable=SC2097,SC2098
	BAKE_ROOT="$BAKE_ROOT" "$BAKE_ROOT/bake" "$@"
}
