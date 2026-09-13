#!/bin/bash
# logging.sh - Simple logging function

LOG_FILE="${LOG_FILE:-$HOME/KaliKit/reports/kalikit.log}"

log_event() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}
