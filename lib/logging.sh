#!/bin/bash
# logging.sh - Simple logging function

# Use SCRIPT_DIR from the calling script (set before sourcing this file)
LOG_FILE="${LOG_FILE:-$SCRIPT_DIR/../reports/shellstrike.log}"

log_event() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}
