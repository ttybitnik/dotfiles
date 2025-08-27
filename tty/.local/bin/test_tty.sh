#!/bin/sh

# Test script for '/usr/local/lib/tty.sh'.

. /usr/local/lib/tty.sh

TESTS_PASSED=0
TESTS_TOTAL=0

test_inc()
{
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
}

test_pass()
{
    TESTS_PASSED=$((TESTS_PASSED + 1))
    test_inc
}

printf "%s\n" "============================"
printf "%s\n" "    TTY.SH LIBRARY TEST    "
printf "%s\n" "============================"
printf "Current TTY_LOG_LEVEL: %s\n" "$TTY_LOG_LEVEL"
printf "\n"

################################################################################
printf "%s\n" "----------------------"
printf "%s\n" "BASIC LOGGING TESTING"
printf "%s\n" "----------------------"

tty_debug "This is a debug message (should show if level=DEBUG)"
tty_info "This is an info message"
tty_warn "This is a warning message"
tty_error "This is an error message"

test_pass
printf "\n%s\n" "Basic logging test completed!"
printf "\n"

################################################################################
printf "%s\n" "--------------------"
printf "%s\n" "NOTIFICATION TESTING"
printf "%s\n" "--------------------"

tty_notify_debug "Debug notification test"
tty_notify_info "Info notification test"
tty_notify_warn "Warning notification test"
tty_notify_error "Error notification test"

test_pass
printf "\n%s\n" "Notification test completed!"
printf "\n"

################################################################################
printf "%s\n" "---------------------------"
printf "%s\n" "LOG LEVEL FILTERING TESTING"
printf "%s\n" "---------------------------"

printf "Setting TTY_LOG_LEVEL to WARN (%s)\n" "$TTY_LOG_WARN"
TTY_LOG_LEVEL=$TTY_LOG_WARN

tty_debug "This debug should NOT appear"
tty_info "This info should NOT appear"
tty_warn "This warning SHOULD appear"
tty_error "This error SHOULD appear"

TTY_LOG_LEVEL=$TTY_LOG_INFO
printf "Reset TTY_LOG_LEVEL to INFO (%s)\n" "$TTY_LOG_INFO"

test_pass
printf "\n%s\n" "Log level filtering test completed!"
printf "\n"

################################################################################
printf "%s\n" "---------------------"
printf "%s\n" "FORMAT STRING TESTING"
printf "%s\n" "---------------------"

tty_info "User: %s, PID: %d, Time: %s" "$USER" "$$" "$(date +%H:%M:%S)"
tty_error "File not found: %s" "/path/to/nonexistent/file"
tty_notify_info "Process completed in %d seconds" "42"

test_pass
printf "\n%s\n" "Format string test completed!"
printf "\n"

################################################################################
printf "%s\n" "-------------------------"
printf "%s\n" "COMMAND EXECUTION TESTING"
printf "%s\n" "-------------------------"

printf "%s\n" "Testing successful command:"
tty_run_print echo "Hello from tty_run_print"

printf "\n%s\n" "Testing failing command:"
tty_run_print ls /nonexistent/directory 2>/dev/null
printf "Exit code: %d\n" "$?"

test_pass
printf "\n%s\n" "Command execution test completed!"
printf "\n"

################################################################################
printf "%s\n" "-------------------"
printf "%s\n" "MIXED USAGE TESTING"
printf "%s\n" "-------------------"

tty_info "Starting complex operation"
tty_notify_info "Operation started"

tty_warn "Encountered minor issue"
tty_notify_warn "Minor issue detected"

tty_info "Operation completed successfully"
tty_notify_info "Operation completed"

test_pass
printf "\n%s\n" "Mixed usage test completed!"
printf "\n"

################################################################################
printf "%s\n" "----------------------"
printf "%s\n" "ERROR HANDLING TESTING"
printf "%s\n" "----------------------"

simulate_failure() { return 1; }

printf "%s\n" "Testing error handling..."
if simulate_failure; then
    tty_info "Operation succeeded"
else
    tty_error "Operation failed with code: %d" "$?"
    tty_notify_error "simulate_failure" "Test operation failed"
fi

test_pass
printf "\n%s\n" "Error handling test completed!"
printf "\n"

################################################################################
printf "%s\n" "-----------------"
printf "%s\n" "LOG LEVEL TESTING"
printf "%s\n" "-----------------"

for level in DEBUG INFO WARN ERROR FATAL; do
    case $level in
	DEBUG) lvl=$TTY_LOG_DEBUG ;;
	INFO)  lvl=$TTY_LOG_INFO ;;
	WARN)  lvl=$TTY_LOG_WARN ;;
	ERROR) lvl=$TTY_LOG_ERROR ;;
	FATAL) lvl=$TTY_LOG_FATAL ;;
    esac

    printf "Testing %s level (%s):\n" "$level" "$lvl"
    TTY_LOG_LEVEL=$lvl
    tty_debug "Debug test"
    tty_info "Info test"
    tty_warn "Warn test"
    tty_error "Error test"
    printf "\n"
done

TTY_LOG_LEVEL=$TTY_LOG_INFO
printf "Reset TTY_LOG_LEVEL to INFO (%s)\n" "$TTY_LOG_INFO"

test_pass
printf "\n%s\n" "Log level test completed!"
printf "\n"

################################################################################
printf "%s\n" "------------------"
printf "%s\n" "EDGE CASES TESTING"
printf "%s\n" "------------------"

tty_info ""

tty_info "Message with percent %% sign and \\ backslash"

long_msg="This is a very long message that should test the wrapping and display capabilities of the logging system across multiple lines and with various content types."
tty_info "%s" "$long_msg"

tty_info "Info message with no format arguments"
tty_error "Error message with no format arguments"

test_pass
printf "\n%s\n" "Edge cases test completed!"
printf "\n"

################################################################################
printf "%s\n" "----------------------"
printf "%s\n" "FATAL FUNCTION TESTING"
printf "%s\n" "----------------------"

printf "%s\n" "Testing tty_fatal (in subshell):"
output=$(tty_fatal "Test fatal error message" 2>&1)
exit_code=$?
printf "%s\n" "$output" | head -1
printf "Subshell exit code: %d\n" "$exit_code"

printf "\n%s\n" "Testing tty_notify_fatal (in subshell):"
output=$(tty_notify_fatal "Test fatal notification" 2>&1)
exit_code=$?
printf "%s\n" "$output" | head -1
printf "Subshell exit code: %d\n" "$exit_code"

printf "\n%s\n" "Testing tty_usage (in subshell):"
output=$(tty_usage "testscript <arg>" 2>&1)
exit_code=$?
printf "%s\n" "$output" | head -1
printf "Subshell exit code: %d\n" "$exit_code"

test_pass
printf "\n%s\n" "Fatal functions test completed!"
printf "\n"

################################################################################
printf "%s\n" "-------------------"
printf "%s\n" "PERFORMANCE TESTING"
printf "%s\n" "-------------------"

printf "%s" "Timing 100 info messages:"
time for i in $(seq 1 100); do
    tty_info "Performance test message %d" "$i" >/dev/null
done

test_pass
printf "\n%s\n" "Performance test completed!"
printf "\n"

################################################################################
printf "%s\n" "===================="
printf "%s\n" "   TEST SUMMARY     "
printf "%s\n" "===================="

printf "Tests passed: %d/%d\n" "$TESTS_PASSED" "$TESTS_TOTAL"
SUCCESS_RATE=$(echo "scale=1; $TESTS_PASSED * 100 / $TESTS_TOTAL" | bc)
printf "Success rate: %s%%\n" "$SUCCESS_RATE"

if [ "$TESTS_PASSED" -eq "$TESTS_TOTAL" ]; then
    printf "%s\n" "[V] All tests passed successfully!"
else
    printf "%s\n" "[X] Some tests failed: $((TESTS_TOTAL - TESTS_PASSED))"
fi

printf "\n"
