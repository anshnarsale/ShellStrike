#!/bin/bash
# portpilot.sh - Nmap wrapper for authorized target scanning

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/messages.sh"
source "$SCRIPT_DIR/../lib/validate.sh"
source "$SCRIPT_DIR/../lib/logging.sh"
source "$SCRIPT_DIR/../lib/traps.sh"

msg_header "PortPilot - Port Scanner"

# Check target argument provided
if [[ -z "$1" ]]; then
    msg_error "Usage: $0 <authorized-target>"
    exit 1
fi

TARGET="$1"

# Validate target is an IP (basic check for now)
if ! is_valid_ip "$TARGET"; then
    msg_error "Invalid IP address: $TARGET"
    exit 1
fi

msg_info "Target: $TARGET"

check_command "nmap" || exit 1

msg_info "Running scan (this may take a moment)..."

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
REPORT_FILE="$SCRIPT_DIR/../reports/portpilot_${TARGET}_${TIMESTAMP}.txt"

# Basic scan: top common ports, service/version detection
SCAN_OUTPUT=$(nmap -sV --top-ports 100 "$TARGET" 2>/dev/null)

echo "$SCAN_OUTPUT"

{
    echo "PortPilot Report - $(date)"
    echo "Target: $TARGET"
    echo ""
    echo "$SCAN_OUTPUT"
} > "$REPORT_FILE"

msg_success "Report saved to: $REPORT_FILE"
log_event "PortPilot scan completed for $TARGET, report: $REPORT_FILE"
