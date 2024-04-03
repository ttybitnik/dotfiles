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
