# shellcheck shell=bash

main.bake() {
	local __bake_dynamic_script="$BASALT_PACKAGE_DIR/pkg/src/bakeScript.sh"

	# shellcheck disable=SC1090
	BAKE_INTERNAL_CAN_SOURCE='yes' source "$__bake_dynamic_script"
	local __version_new="$__global_bake_version"

	# Set `BAKE_{ROOT,FILE}`
	BAKE_ROOT=; BAKE_FILE=
	__bake_parse_args "$@"

	# If we are allowed to replace the 'bake' script (when not in Git interactive rebase, etc.), then do so.
	if __bake_should_replace_bakescript; then
		local __version_old

		# We check if a 'bake' script already exists, so we can the "current" (pre-replacement) version, and tell
		# the user if the script is going to be updated. This requires some tricks, as mentioned below
		if [ -f "$BAKE_ROOT/bake" ]; then
			declare -ag __bake_global_backup_args=("$@")

			# These traps are required because 'BAKE_INTERNAL_ONLY_VERSION' is a recent addition. With older versions
			# that don't test for it, the source will run through the whole script, including the __bake_main
			# function (this is also why BAKE_INTERNAL_CAN_SOURCE=yes - so this feature doesn't cause older scripts
			# to just error and die). We use these traps to ensure the script does _not_ run __bake_main. Just "letting
			# it run" would make things more simple, but that would mean that we will have to run 'bake' twice to perform
			# the update, instead of just once (and it would not be guaranteed, since it updates at the end). Also, doing
			# this would mean values like "$0" are not what would be expected.
			trap '__bake_trap_debug_barrier' DEBUG
			# shellcheck disable=SC1091
			BAKE_INTERNAL_ONLY_VERSION='yes' BAKE_INTERNAL_CAN_SOURCE='yes' source "$BAKE_ROOT/bake"
			trap - DEBUG
			__version_old=$__global_bake_version
			unset -v __bake_global_backup_args
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
