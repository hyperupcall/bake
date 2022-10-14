# shellcheck shell=bash

main.bake() {
	local bake_script="$BASALT_PACKAGE_DIR/pkg/src/bakeScript.sh"

	# shellcheck disable=SC1090
	BAKE_INTERNAL_CAN_SOURCE='yes' source "$bake_script"
	local new_global_bake_version=$__global_bake_version

	# Set `BAKE_{ROOT,FILE}`
	BAKE_ROOT=; BAKE_FILE=
	__bake_parse_args "$@"

	# shellcheck disable=SC1091
	BAKE_INTERNAL_ONLY_VERSION='yes' BAKE_INTERNAL_CAN_SOURCE='yes' source "$BAKE_ROOT/bake"
	local old_global_bake_version=$__global_bake_version
	if [ "$BAKE_INTERNAL_ONLY_VERSION_SUCCESS" != 'yes' ]; then
		# If we are here, it means the 'bake' file sourced is at an old version, and setting
		# 'BAKE_INTERNAL_ONLY_VERSION' didn't actually do anything. This is why we set
		# set 'BAKE_INTERNAL_CAN_SOURCE' - so no errors are printed. But now, the whole file
		# was sourced and all function definitions are out of date. So, we have to re-source
		# the newer version again

		# shellcheck disable=SC1090
		BAKE_INTERNAL_CAN_SOURCE='yes' source "$bake_script"

		# Instead of this rigmarole, we can just copy the '__bake_parse_args' function
		# to this file, but I'd rather not have that code duplication.
	fi

	if [ "$old_global_bake_version" != "$new_global_bake_version" ]; then
		__bake_internal_warn "Updating from version $old_global_bake_version to $new_global_bake_version"
	fi

	if ! cp -f "$bake_script" "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to copy 'bakeScript.sh'"
	fi
	if ! printf '\n%s\n' '__bake_main "$@"' >> "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to append to '$BAKE_ROOT/bake'"
	fi

	if ! chmod +x "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to 'chmod +x' bake script" >&2
	fi

	exec "$BAKE_ROOT/bake" "$@"
}
