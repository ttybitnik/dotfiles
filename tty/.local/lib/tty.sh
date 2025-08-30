#!/bin/sh

# TTY.SH - Personal library with sugar functions for shell scripting
# Copyright (C) 2025 Vinícius Moraes <vinicius.moraes@eternodevir.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# All symbols are namespaced with the 'tty_' prefix. See the overview below.
#
#   00. CONSTANTS AND CONFIGURATION
#   01. INTERNAL FUNCTIONS
#   02. EXTERNAL FUNCTIONS
#
#   Logging:
#     tty_debug
#     tty_info
#     tty_warn
#     tty_error
#     tty_fatal
#   Notifications:
#     tty_notify_debug
#     tty_notify_info
#     tty_notify_warn
#     tty_notify_error
#     tty_notify_fatal
#   Utilities:
#     tty_usage
#     tty_run_print

#===============================================================================
# 00. CONSTANTS AND CONFIGURATION
#===============================================================================

readonly TTY_LOG_FATAL=4
readonly TTY_LOG_ERROR=3
readonly TTY_LOG_WARN=2
readonly TTY_LOG_INFO=1
readonly TTY_LOG_DEBUG=0

: "${TTY_LOG_LEVEL:=$TTY_LOG_INFO}"

#===============================================================================
# 01. INTERNAL FUNCTIONS
#===============================================================================

#-------------------------------------------------------------------------------
# Internal function to display messages and handle LOG levels.
# Globals:
#   TTY_LOG_LEVEL
# Arguments:
#   $1 - Log level (integer, see constants)
#   $2 - Format string (passed to printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Writes formatted message to stdout or stderr based on log level
# Returns:
#   Exits with status 1 if log level is FATAL, otherwise 0
#-------------------------------------------------------------------------------
_tty_log()
{
    _tty_log_level="$1"
    shift
    _tty_log_format="$1"
    shift

    [ "${_tty_log_level}" -lt "${TTY_LOG_LEVEL}" ] && return 0

    case "${_tty_log_level}" in
	"${TTY_LOG_DEBUG}") _tty_log_prefix="[DEBUG]" ;;
	"${TTY_LOG_INFO}")  _tty_log_prefix="[INFO]"  ;;
	"${TTY_LOG_WARN}")  _tty_log_prefix="[WARN]"  ;;
	"${TTY_LOG_ERROR}") _tty_log_prefix="[ERROR]" ;;
	"${TTY_LOG_FATAL}") _tty_log_prefix="[FATAL]" ;;
	*)                  _tty_log_prefix="[?????]" ;;
    esac

    # shellcheck disable=SC2059
    _tty_log_message=$(printf "${_tty_log_format}" "$@")

    if [ "${_tty_log_level}" -ge "${TTY_LOG_WARN}" ]; then
	printf "%s %s\n" "${_tty_log_prefix}" "${_tty_log_message}" >&2
    else
	printf "%s %s\n" "${_tty_log_prefix}" "${_tty_log_message}"
    fi

    [ "${_tty_log_level}" -eq "${TTY_LOG_FATAL}" ] && exit 1
    return 0
}

#-------------------------------------------------------------------------------
# Internal function to send notifications and handle LOG levels.
# Arguments:
#   $1 - Log level (integer, see constants)
#   $2 - Format string (passed to notify-send or printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Sends desktop notification via notify-send, or
#   falls back to _tty_log if notify-send is unavailable
# Returns:
#   Exits with status 1 if log level is FATAL, otherwise 0
#-------------------------------------------------------------------------------
_tty_notify()
{
    _tty_notify_level="$1"
    shift
    _tty_notify_format="$1"
    shift

    [ "${_tty_notify_level}" -lt "${TTY_LOG_LEVEL}" ] && return 0

    case "${_tty_notify_level}" in
	"${TTY_LOG_DEBUG}") _tty_notify_prefix="[DEBUG]" ;;
	"${TTY_LOG_INFO}")  _tty_notify_prefix="[INFO]"  ;;
	"${TTY_LOG_WARN}")  _tty_notify_prefix="[WARN]"  ;;
	"${TTY_LOG_ERROR}") _tty_notify_prefix="[ERROR]" ;;
	"${TTY_LOG_FATAL}") _tty_notify_prefix="[FATAL]" ;;
	*)                  _tty_notify_prefix="[?????]" ;;
    esac

    # shellcheck disable=SC2059
    _tty_notify_message=$(printf "${_tty_notify_format}" "$@")

    _tty_notify_urgency="normal"
    if [ "${_tty_notify_level}" -ge "${TTY_LOG_WARN}" ]; then
	_tty_notify_urgency="critical"
    fi

    if command -v notify-send >/dev/null 2>&1; then
	notify-send --urgency "$_tty_notify_urgency" \
		    "${_tty_notify_prefix} $(basename "$0")" \
		    "$_tty_notify_message"
	_tty_log "${_tty_notify_level}" "%s" "${_tty_notify_message}"
    else
	_tty_log "${_tty_notify_level}" "%s" "${_tty_notify_message}"
    fi

    [ "${_tty_notify_level}" -eq "${TTY_LOG_FATAL}" ] && exit 1
    return 0
}

#===============================================================================
# 02. EXTERNAL FUNCTIONS
#===============================================================================

#-------------------------------------------------------------------------------
# Logs a message at DEBUG level.
# Arguments:
#   $1 - Format string (passed to printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Writes formatted message to stdout
#
# Examples:
#   tty_debug "%s: variables values: x=%d, y=%s" "$(basename "$0")" "$x" "$y"
#   tty_debug "%s: %s called with %d arguments" "$(basename "$0")" "$func" "$#"
#-------------------------------------------------------------------------------
tty_debug() { _tty_log "${TTY_LOG_DEBUG}" "$@"; }

#-------------------------------------------------------------------------------
# Logs a message at INFO level.
# Arguments:
#   $1 - Format string (passed to printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Writes formatted message to stdout
#
# Examples:
#   tty_info "%s: processing file: '%s'" "$(basename "$0")" "$filename"
#   tty_info "%s: operation completed successfully" "$(basename "$0")"
#-------------------------------------------------------------------------------
tty_info() { _tty_log "${TTY_LOG_INFO}" "$@"; }

#-------------------------------------------------------------------------------
# Logs a message at WARN level.
# Arguments:
#   $1 - Format string (passed to printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Writes formatted message to stderr
#
# Examples:
#   tty_warn "%s: disk space low: %dMB remaining" "$(basename "$0")" "$fspace"
#   tty_warn "%s: deprecated API endpoint: '%s'" "$(basename "$0")" "$endpoint"
#-------------------------------------------------------------------------------
tty_warn() { _tty_log "${TTY_LOG_WARN}" "$@"; }

#-------------------------------------------------------------------------------
# Logs a message at ERROR level.
# Arguments:
#   $1 - Format string (passed to printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Writes formatted message to stderr
#
# Examples:
#   tty_error "%s: failed to connect to database: '%s'" "$(basename "$0")" "$?"
#   tty_error "%s: invalid action: '%s'" "$(basename "$0")" "$action"
#-------------------------------------------------------------------------------
tty_error() { _tty_log "${TTY_LOG_ERROR}" "$@"; }

#-------------------------------------------------------------------------------
# Logs a message at FATAL level and exits the script.
# Arguments:
#   $1 - Format string (passed to printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Writes formatted message to stderr
# Returns:
#   Exits script with status 1
#
# Examples:
#   tty_fatal "%s: sed failed with exited code %d" "$(basename "$0")" "$?"
#   tty_fatal "%s: file not found: '%s'" "$(basename "$0")" "$filename"
#-------------------------------------------------------------------------------
tty_fatal() { _tty_log "${TTY_LOG_FATAL}" "$@"; }

#-------------------------------------------------------------------------------
# Sends a notification at DEBUG level.
# Arguments:
#   $1 - Format string (passed to notify-send or printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Sends desktop notification via notify-send, or
#   writes formatted message to stdout if notify-send is unavailable
#
# Examples:
#   tty_notify_debug "%s: debug information: '%s'" "$(basename "$0")" "$data"
#   tty_notify_debug "%s: process ID: '%d'" "$(basename "$0")" "$$"
#-------------------------------------------------------------------------------
tty_notify_debug() { _tty_notify "${TTY_LOG_DEBUG}" "$@"; }

#-------------------------------------------------------------------------------
# Sends a notification at INFO level.
# Arguments:
#   $1 - Format string (passed to notify-send or printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Sends desktop notification via notify-send, or
#   writes formatted message to stdout if notify-send is unavailable
#
# Examples:
#   tty_notify_info "%s: download completed: '%s'" "$(basename "$0")" "$tar"
#   tty_notify_info "%s: system backup started" "$(basename "$0")"
#-------------------------------------------------------------------------------
tty_notify_info() { _tty_notify "${TTY_LOG_INFO}" "$@"; }

#-------------------------------------------------------------------------------
# Sends a notification at WARN level.
# Arguments:
#   $1 - Format string (passed to notify-send or printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Sends desktop notification via notify-send, or
#   writes formatted message to stderr if notify-send is unavailable
#
# Examples:
#   tty_notify_warn "%s: high memory usage: %dMB" "$(basename "$0")" "$mem"
#   tty_notify_warn "%s: network connection unstable" "$(basename "$0")"
#-------------------------------------------------------------------------------
tty_notify_warn() { _tty_notify "${TTY_LOG_WARN}" "$@"; }

#-------------------------------------------------------------------------------
# Sends a notification at ERROR level.
# Arguments:
#   $1 - Format string (passed to notify-send or printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Sends desktop notification via notify-send, or
#   writes formatted message to stderr if notify-send is unavailable
#
# Examples:
#   tty_notify_error "%s: sync failed: '%s'" "$(basename "$0")" "$location"
#   tty_notify_error "%s: disconnected after %ds" "$(basename "$0")" "$seconds"
#-------------------------------------------------------------------------------
tty_notify_error() { _tty_notify "${TTY_LOG_ERROR}" "$@"; }

#-------------------------------------------------------------------------------
# Sends a notification at FATAL level and exits the script.
# Arguments:
#   $1 - Format string (passed to notify-send or printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Sends desktop notification via notify-send, or
#   writes formatted message to stderr if notify-send is unavailable
# Returns:
#   Exits script with status 1
#
# Examples:
#   tty_notify_fatal "%s: ls failed with exited code %d" "$(basename "$0")" "$?"
#   tty_notify_fatal "%s: connection lost: cannot continue" "$(basename "$0")"
#-------------------------------------------------------------------------------
tty_notify_fatal() { _tty_notify "${TTY_LOG_FATAL}" "$@"; }


#-------------------------------------------------------------------------------
# Prints an usage message and exits with status 1.
# Arguments:
#   $1 - Format string (passed to printf)
#   $@ - Remaining arguments for the format string
# Outputs:
#   Writes formatted message to stderr
# Returns:
#   Exits script with status 1
#
# Examples:
#   tty_usage "scriptname <required> [optional]"
#   tty_usage "%s <required> [optional]" "$(basename "$0")"
#-------------------------------------------------------------------------------
tty_usage()
{
    _tty_usage_format="$1"
    shift

    printf "Usage: " >&2
    # shellcheck disable=SC2059
    printf "${_tty_usage_format}" "$@" >&2
    printf "\n" >&2
    exit 2
}

#-------------------------------------------------------------------------------
# Runs a command and prints it explicitly for debugging.
# Arguments:
#   $@ - Command and its arguments to run
# Outputs:
#   Writes the command to be executed to stdout
#   Writes the command's output to stdout
# Returns:
#   Exit code of the executed command
#
# Examples:
#   tty_run_print ls -la directory/dir
#   tty_run_print grep -r "pattern" file.txt
#-------------------------------------------------------------------------------
tty_run_print()
{
    printf "\n+ %s \n\n" "$*"
    "$@"
}
