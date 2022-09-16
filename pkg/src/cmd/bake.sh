# shellcheck shell=bash

main.bake() {
	local bake_version='1.10.1'

	local bake_script="$BASALT_PACKAGE_DIR/pkg/src/bakeScript.sh"

	# shellcheck disable=SC1090
	BAKE_INTERNAL_CAN_SOURCE='yes' source "$bake_script"

	# Set `BAKE_{ROOT,FILE}`
	BAKE_ROOT=; BAKE_FILE=
	__bake_parse_args "$@"

	if ! cp -f "$bake_script" "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to copy 'bakeScript.sh'"
	fi
	if ! printf '\n%s\n' '__bake_main "$@"' >> "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to append to '$BAKE_ROOT/bake'"
	fi

	if ! chmod +x "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to 'chmod +x' bake script" >&2
	fi

	if [ "$__global_bake_version" != "$bake_version" ]; then
		__bake_internal_warn "Updating from version $__global_bake_version to $bake_version"
	fi

	exec "$BAKE_ROOT/bake" "$@"
}
