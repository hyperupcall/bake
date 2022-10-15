# shellcheck shell=bash

# @description Copy 'bake' script to current context
# @internal
__bake_copy_bakescript() {
	# If there was an older version, and the versions are different, let the user know
	if [ -z ${__version_old+x} ]; then
		__bake_internal_warn "Updating from version <=1.10.0 to $__version_new"
	else
		if [ -n "$__version_old" ] && [ "$version_old" != "$__version_new" ]; then
			__bake_internal_warn "Updating from version $version_old to $__version_new"
		fi
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
}

__bake_just_in_case_trap_debug() {
	local current_function="${FUNCNAME[1]}"

	if [ "$current_function" = '__bake_main' ]; then
		local version_old="$__global_bake_version"

		trap - DEBUG
		unset -v BAKE_INTERNAL_ONLY_VERSION
		unset -v BAKE_INTERNAL_CAN_SOURCE

		__bake_copy_bakescript
		if [ "$BAKE_FLAG_UPDATE" = 'yes' ]; then
			exit 0
		else
			exec "$BAKE_ROOT/bake" "${__bake_backup_args[@]}"
		fi
	fi
}

main.bake() {
	local bake_script="$BASALT_PACKAGE_DIR/pkg/src/bakeScript.sh"

	# shellcheck disable=SC1090
	BAKE_INTERNAL_CAN_SOURCE='yes' source "$bake_script"
	local __version_new=$__global_bake_version

	# Set `BAKE_{ROOT,FILE}`
	BAKE_ROOT=; BAKE_FILE=
	__bake_parse_args "$@"

	# If we are allowed to replace the 'bake' script (when not in Git interactive rebase, etc.), then do so.
	if __bake_should_replace_bakescript; then
		local __version_old

		# We check if a 'bake' script already exists, so we can the "current" (pre-replacement) version, and tell
		# the user if the script is going to be updated. This requires some tricks, as mentioned below
		if [ -f "$BAKE_ROOT/bake" ]; then
			local -a __bake_backup_args=("$@")

			# These traps are required because 'BAKE_INTERNAL_ONLY_VERSION' is a recent addition. With older versions
			# that don't test for it, the source will run through the whole script, including the __bake_main
			# function (this is also why BAKE_INTERNAL_CAN_SOURCE=yes - so this feature doesn't cause older scripts
			# to just error and die). We use these traps to ensure the script does _not_ run __bake_main. Just "letting
			# it run" would make things more simple, but that would mean that we will have to run 'bake' twice to perform
			# the update, instead of just once (and it would not be guaranteed, since it updates at the end). Also, doing
			# this would mean values like "$0" are not what would be expected.
			trap '__bake_just_in_case_trap_debug' DEBUG
			# shellcheck disable=SC1091
			BAKE_INTERNAL_ONLY_VERSION='yes' BAKE_INTERNAL_CAN_SOURCE='yes' source "$BAKE_ROOT/bake"
			trap - DEBUG
			__version_old=$__global_bake_version
			unset -v __bake_backup_args
		fi

		__bake_copy_bakescript
		if [ "$BAKE_FLAG_UPDATE" != 'yes' ]; then
			exec "$BAKE_ROOT/bake" "$@"
		fi
	else
		if [ "$BAKE_FLAG_UPDATE" = 'yes' ]; then
			__bake_copy_bakescript
		else
			__bake_internal_warn "Skipping 'bake' script replacement"
			__bake_main "$@"
		fi
	fi
}
