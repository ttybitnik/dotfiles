#!/usr/bin/env bash

# Personal library with sugar functions.
#   Prefix:
#     tty

#===============================================================================
# Display message and exit properly for errors.
#-------------------------------------------------------------------------------
# Arguments:
#   Error message to display
# Outputs:
#   Error message to stderr
# Returns:
#   Non-zero due erratic behaviour
#===============================================================================
tty::fatal() {
    printf "%s\n" "$@" >&2
    exit 1
}

#===============================================================================
# Run command explicitly, for debugging or displaying the command.
#-------------------------------------------------------------------------------
# Arguments:
#   Command to run
# Outputs:
#   Command run, with a prefix highlighter, to stdout
# Returns:
#   Zero if command was run, non-zero on error
#===============================================================================
tty::run_print() {
    printf "\n>> %s \n\n" "$*"
    "$@"
}

#===============================================================================
# Check command exit code and send a desktop notification in case of errors.
# To grab the exit code, use "err=$?" after the command to be checked.
# -------------------------------------------------------------------------------
# Arguments:
#   Command executed
#   Exit code variable to check (integer)
#   Context error message
# Outputs:
#   None, only sends a desktop notification
# Returns:
#   Zero even if command panic
# ===============================================================================
tty::notify_urgent() {
    if [ "$2" -ne 0 ]; then
    notify-send --urgency=critical "$(basename "$1")" \
		"Error. Execution failed: $3"
    fi
}

#===============================================================================
# Check command exit code, and send a desktop notification and exit in case of
# errors. To grab the exit code, use "err=$?" after the command to be checked.
#-------------------------------------------------------------------------------
# Arguments:
#   Command executed
#   Exit code variable to check (integer)
#   Context error message
# Outputs:
#   None, only sends a desktop notification
# Returns:
#   Non-zero due erratic behaviour
#===============================================================================
tty::notify_fatal() {
    if [ "$2" -ne 0 ]; then
    notify-send --urgency=critical "$(basename "$1")" \
		"Error. Execution failed: $3"
    exit 1
    fi
}
