# shellcheck shell=bash

main.bake() {
	if ! bake_root="$(
		while [ ! -f 'Bakefile.sh' ] && [ "$PWD" != / ]; do
			if ! cd ..; then
				printf '%s\n' "Error (bake): Could not cd .." >&2
				exit 1
			fi
		done

		if [ "$PWD" = / ]; then
			printf '%s\n' "Error (bake): Could not find 'Bakefile.sh'" >&2
			exit 1
		fi

		printf '%s' "$PWD"
	)"; then
		exit 1
	fi

	if ! cp -f "$BASALT_PACKAGE_DIR/pkg/src/bakeScript.sh" "$bake_root/bake"; then
		printf '%s\n' "Error (bake): Could not copy 'bakeScript.sh'" >&2
		exit 1
	fi
	if ! chmod +x "$bake_root/bake"; then
		printf '%s\n' "Error (bake): could not 'chmod +x' bake script" >&2
		exit 1
	fi

	unset -v BASALT_PACKAGE_DIR # Unset so hidden for `Bakefile.sh` scripts

	# shellcheck disable=SC2097,SC2098
	exec "$bake_root/bake" "$@"
}
