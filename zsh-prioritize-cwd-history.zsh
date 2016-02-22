# Scope history to the current working directory.
# Idea from https://github.com/jimhester/per-directory-history
# https://github.com/ericfreese/zsh-cwd-history
# v0.2.1
# Copyright (c) 2016 Eric Freese
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

#--------------------------------------------------------------------#
# Required History Options                                           #
#--------------------------------------------------------------------#

# We use timestamps as unique keys for commands in the history file
setopt EXTENDED_HISTORY

# We reload global history from $HISTFILE on directory change
# Have to write to the file incrementally to avoid losing history on
# directory change.
setopt INC_APPEND_HISTORY

#--------------------------------------------------------------------#
# Global Config Variables                                            #
#--------------------------------------------------------------------#

ZSH_PRIORITIZE_CWD_HISTORY_DIR="$HOME/.zsh_prioritize_cwd_history"

#--------------------------------------------------------------------#
# Histrefs files store timestamp references to entries in HISTFILE   #
#--------------------------------------------------------------------#

# Prints to STDOUT the name of the histrefs file to use for current
# working directory
_zsh_prioritize_cwd_history_histrefs_for_cwd() {
	local md5=$(echo "${PWD:A}" | md5 -q)

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
	local pattern=$(
		# Get last 1000 histrefs
		tail -1000 "$histrefs" |

		# Prepend ": " to timestamps
		sed -e 's/^/\^: /' |

		# Join lines with a pipe delimiter
		paste -s -d '\|' - |

		# Format into grep `OR` with backslash pipe
		sed -e 's/\|/\\\|/g'
	)

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
	local template="$ZSH_PRIORITIZE_CWD_HISTORY_DIR/.tmphistXX"
	local tmp_histfile=$(mktemp "$template")

	# Copy history entries executed in this directory to tmp file
	_zsh_prioritize_cwd_history_cwd_hist_entries > "$tmp_histfile"

	# Read the history entries from the tmp file
	fc -R "$tmp_histfile"

	# All done, remove the tmp file
	rm "$tmp_histfile"
}

#--------------------------------------------------------------------#
# Zsh Hooks                                                          #
#--------------------------------------------------------------------#

# Initialize on first prompt, then remove the precmd hook
_zsh_prioritize_cwd_history_initialize() {
	# Remove the precmd hook so this is only called once
	add-zsh-hook -d precmd _zsh_prioritize_cwd_history_initialize

	# Simulate initial chpwd
	_zsh_prioritize_cwd_history_cwd_changed

	# Add a hook to save histrefs
	add-zsh-hook zshaddhistory _zsh_prioritize_cwd_history_addhistory

	# Add a hook to reload history on chpwd
	add-zsh-hook chpwd _zsh_prioritize_cwd_history_cwd_changed
}

# Read current working directory history when changing dirs
_zsh_prioritize_cwd_history_cwd_changed() {
	# Reset history list from $HISTFILE
	fc -P; fc -p "$HISTFILE"

	# Read in history for this dir after global history
	_zsh_prioritize_cwd_history_load_cwd_history
}

# Save a histref every time we save something to history
_zsh_prioritize_cwd_history_addhistory() {
	local histrefs=$(_zsh_prioritize_cwd_history_histrefs_for_cwd)

	[ -d "$ZSH_PRIORITIZE_CWD_HISTORY_DIR" ] || mkdir -p "$ZSH_PRIORITIZE_CWD_HISTORY_DIR"

	echo "$(date +%s)" >> "$histrefs"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zsh_prioritize_cwd_history_initialize
