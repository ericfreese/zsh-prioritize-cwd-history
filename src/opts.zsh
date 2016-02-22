
#--------------------------------------------------------------------#
# Required History Options                                           #
#--------------------------------------------------------------------#

# We use timestamps as unique keys for commands in the history file
setopt EXTENDED_HISTORY

# We reload global history from $HISTFILE on directory change
# Have to write to the file incrementally to avoid losing history on
# directory change.
setopt INC_APPEND_HISTORY
