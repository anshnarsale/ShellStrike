#!/bin/bash
# validate.sh - Input validation and dependency check functions

# Check if a command/tool is installed
check_command() {
    if ! command -v "$1" &> /dev/null; then
        msg_error "Required tool not found: $1"
        return 1
    fi
    return 0
}

# Check if a string looks like a valid IPv4 address
is_valid_ip() {
    local ip="$1"
        if [[ "$ip" =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
        return 0
    else
        return 1
    fi
}

# Check if script is running as root
is_root() {
    [[ "$EUID" -eq 0 ]]
}
