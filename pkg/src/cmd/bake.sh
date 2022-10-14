# shellcheck shell=bash

# @description Copy 'bake' script to current context
#  @internal
__bake_copy_bakescript() {
	if ! cp -f "$bake_script" "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to copy 'bakeScript.sh'"
	fi
	if ! printf '\n%s\n' '__bake_main "$@"' >> "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to append to '$BAKE_ROOT/bake'"
	fi

	if ! chmod +x "$BAKE_ROOT/bake"; then
		__bake_internal_die "Failed to 'chmod +x' bake script" >&2
	fi
}

main.bake() {
	local bake_script="$BASALT_PACKAGE_DIR/pkg/src/bakeScript.sh"

	# shellcheck disable=SC1090
	BAKE_INTERNAL_CAN_SOURCE='yes' source "$bake_script"
	local version_new=$__global_bake_version

	# Set `BAKE_{ROOT,FILE}`
	BAKE_ROOT=; BAKE_FILE=
	__bake_parse_args "$@"

	if __bake_should_replace_bakescript; then
		if [ -f "$BAKE_ROOT/bake" ]; then
			# shellcheck disable=SC1091
			BAKE_INTERNAL_ONLY_VERSION='yes' BAKE_INTERNAL_CAN_SOURCE='yes' source "$BAKE_ROOT/bake"
			local version_old=$__global_bake_version
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

			if [ "$version_old" != "$version_new" ]; then
				__bake_internal_warn "Updating from version $version_old to $version_new"
			fi
		fi

		__bake_copy_bakescript
		exec "$BAKE_ROOT/bake" "$@"
	else
		__bake_internal_warn "Skipping 'bake' script replacement"
		__bake_main "$@"
	fi
}
