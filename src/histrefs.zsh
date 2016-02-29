
#--------------------------------------------------------------------#
# Histrefs files store timestamp references to entries in HISTFILE   #
#--------------------------------------------------------------------#

# Use an appropriate md5 command (md5 is BSD, md5sum is GNU),
# whichever is actually available
zmodload zsh/parameter
_zsh_prioritize_cwd_history_md5() {
	if (( $+commands[md5] )); then
		md5 -q
	elif (( $+commands[md5sum] )); then
		md5sum | cut -d ' ' -f 1
	else
		# TODO: Fall back on something or error
	fi
}

# Prints to STDOUT the name of the histrefs file to use for current
# working directory
_zsh_prioritize_cwd_history_histrefs_for_cwd() {
	local md5=$(echo "${PWD:A}" | _zsh_prioritize_cwd_history_md5)

	echo "$ZSH_PRIORITIZE_CWD_HISTORY_DIR/.histrefs-$md5"
}

# Prints to STDOUT up to 1000 of the last history entries that were
# executed in the current working directory
_zsh_prioritize_cwd_history_cwd_hist_entries() {
	local histrefs=$(_zsh_prioritize_cwd_history_histrefs_for_cwd)

	[ -s "$histrefs" ] || return

	# Build a grep pattern that will pick out from HISTFILE all
	# history entries (that were saved with EXTENDED_HISTORY)
	# referenced by the histrefs file
	local pattern="$(
		# Get last 1000 histrefs
		tail -1000 "$histrefs" |

		# Prepend "^: " to timestamps
		sed -e 's/^/^: /' |

		# Join lines with a pipe delimiter
		paste -s -d '|' - |

		# Format into grep `OR` with backslash pipe
		sed -e 's/[|]/\\|/g'
	)"

	grep "$pattern" "$HISTFILE"
}

# Reads history entries executed in the current working directory into
# the history list
_zsh_prioritize_cwd_history_load_cwd_history() {
	local histrefs=$(_zsh_prioritize_cwd_history_histrefs_for_cwd)

	[ -s "$histrefs" ] || return

	# TODO: Validate format of histrefs file
	# [ (valid_histrefs) ] || return

	# Create a tmp file for use with `fc -R`
	local template="$ZSH_PRIORITIZE_CWD_HISTORY_DIR/.tmphistXXX"
	local tmp_histfile=$(mktemp "$template")

	# Copy history entries executed in this directory to tmp file
	_zsh_prioritize_cwd_history_cwd_hist_entries > "$tmp_histfile"

	# Read the history entries from the tmp file
	fc -R "$tmp_histfile"

	# All done, remove the tmp file
	rm "$tmp_histfile"
}
