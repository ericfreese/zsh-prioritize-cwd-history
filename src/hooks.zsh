
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
