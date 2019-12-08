#!/usr/bin/env bash

date_format="+%Y-%m-%d_%H-%M-%S%z"

# Measures and format elapsed time.
#
# If called with no arguments a new timer is returned.
# If called with arguments the first is used as a timer
# value and the elapsed time is returned in the form HH:MM:SS.
# source: https://www.linuxjournal.com/content/use-date-command-measure-elapsed-time
#
# Usage:
#
#   t=$(timer)
#   ... # do something
#   printf 'Elapsed time: %s\n' $(timer $t)
#      ===> Elapsed time: 0:01:12
timer() {
  if [[ $# -eq 0 ]]; then
      printf "$(date '+%s')\n"
  else
    local start_time=$1
    end_time=$(date '+%s')

    if [[ -z "$start_time" ]]; then
      start_time=${end_time}
    fi

    duration=$((end_time - start_time))
    duration_second=$((duration % 60))
    duration_minute=$(((duration / 60) % 60))
    duration_hour=$((duration / 3600))
    printf '%02d:%02d:%02d' ${duration_hour} ${duration_minute} ${duration_second}
  fi
}

# Print message with timestamp
# $1 - message to print
# $2 - boxed
#     true: print boxed message
#     false: print simple one line message
print_message() {
  if [[ "$2" == "true" ]]; then
    printf "\n                         #######################################################\n"
    printf "$(date ${date_format}) $1\n"
    printf "                         #######################################################\n"
  else
    printf "$(date ${date_format}) $1\n"
  fi
}

print_info() {
  print_message "### INFO - $1" "$2"
}

print_warn() {
  print_message "### WARN - $1" "$2"
}

print_error() {
  print_message "### ERROR - $1" "$2"
}

assert_error() {
  print_error "$1"
  exit 1
}

# Check if a string is empty. In such a case the error message is printed
# and the script exits with a non zero exit code.
#
# parameter:
# $1 - string to check
#       ATTENTION: this parameter must be quoted
# $2 - error message which is printed when string is empty
assert_not_empty_string() {
  if [[ -z "$1" ]]; then
    assert_error "$2"
  fi
}

assert_file_exists() {
  if [[ ! -e "$1" ]]; then
    assert_error "Could not find file: \"${1}\""
  fi
}

assert_exit_code() {
  local exit_code=$?
  if [[ "${exit_code}" -ne 0 ]]; then
    assert_error "$1 (exit code: ${exit_code})"
  fi
}
