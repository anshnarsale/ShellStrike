#!/bin/bash
# logsentinel.sh - Log analysis tool for Linux authentication logs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/messages.sh"
source "$SCRIPT_DIR/../lib/validate.sh"
source "$SCRIPT_DIR/../lib/logging.sh"
source "$SCRIPT_DIR/../lib/traps.sh"

if [[ "$1" == "--help" ]]; then
    echo "LogSentinel - Auth Log Analyzer"
    echo "Usage: ./tools/logsentinel.sh"
    echo "Analyzes authentication logs for failed login attempts and suspicious patterns."
    exit 0
fi

msg_header "LogSentinel - Log Analyzer"

# Try common Linux auth log locations
AUTH_LOG=""
for candidate in /var/log/auth.log /var/log/secure; do
    if [[ -r "$candidate" ]]; then
        AUTH_LOG="$candidate"
        break
    fi
done

if [[ -z "$AUTH_LOG" ]]; then
    msg_error "No readable auth log found (checked /var/log/auth.log, /var/log/secure)"
    msg_info "Try running with sudo, or this log may not exist on your system"
    exit 1
fi

msg_success "Using log file: $AUTH_LOG"

# Count total failed login attempts
TOTAL_FAILED=$(grep -a "sshd.*Failed password" "$AUTH_LOG" 2>/dev/null | wc -l)
msg_info "Total failed login attempts: $TOTAL_FAILED"

if [[ "$TOTAL_FAILED" -eq 0 ]]; then
    msg_success "No failed login attempts found in this log"
else
    msg_info "Failed attempts by IP address:"
    grep -a "sshd.*Failed password" "$AUTH_LOG" | grep -oP '(?<=from\s)\S+' | sort | uniq -c | sort -rn
fi

# Flag IPs with repeated failures (suspicious pattern threshold)
THRESHOLD=3
if [[ "$TOTAL_FAILED" -gt 0 ]]; then
    IP_COUNTS=$(grep -a "sshd.*Failed password" "$AUTH_LOG" | grep -oP '(?<=from\s)\S+' | sort | uniq -c | sort -rn)
    SUSPICIOUS=$(echo "$IP_COUNTS" | awk -v t="$THRESHOLD" '$1 >= t {print}')
    if [[ -n "$SUSPICIOUS" ]]; then
        echo ""
        msg_warning "Suspicious pattern detected (>= $THRESHOLD failures from same source):"
        echo "$SUSPICIOUS"
    fi
fi

# Save report
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
REPORT_FILE="$SCRIPT_DIR/../reports/logsentinel_$TIMESTAMP.txt"

{
    echo "LogSentinel Report - $(date)"
    echo "Log file analyzed: $AUTH_LOG"
    echo "Total failed attempts: $TOTAL_FAILED"
    echo ""
    if [[ "$TOTAL_FAILED" -gt 0 ]]; then
        echo "Failed attempts by source:"
        echo "$IP_COUNTS"
    fi
} > "$REPORT_FILE"

msg_success "Report saved to: $REPORT_FILE"
log_event "LogSentinel scan completed, report: $REPORT_FILE"
