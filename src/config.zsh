
#--------------------------------------------------------------------#
# Global Config Variables                                            #
#--------------------------------------------------------------------#

if [ -z "$ZSH_PRIORITIZE_CWD_HISTORY_DIR" ];then
	# only override if there's no variable
	ZSH_PRIORITIZE_CWD_HISTORY_DIR="$HOME/.zsh_prioritize_cwd_history"
fi
