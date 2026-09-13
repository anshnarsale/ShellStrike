#!/bin/bash
# netscout.sh - Network discovery tool for local/authorized networks

# Load shared framework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/messages.sh"
source "$SCRIPT_DIR/../lib/validate.sh"
source "$SCRIPT_DIR/../lib/logging.sh"
source "$SCRIPT_DIR/../lib/traps.sh"

msg_header "NetScout - Network Discovery"

# Detect default network interface
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

if [[ -z "$INTERFACE" ]]; then
    msg_error "Could not detect network interface."
    exit 1
fi

msg_info "Detected interface: $INTERFACE"

# Get local IP on that interface
LOCAL_IP=$(ip -4 addr show "$INTERFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
msg_success "Local IP: $LOCAL_IP"

# Get default gateway
GATEWAY=$(ip route | grep default | awk '{print $3}' | head -n1)
msg_success "Gateway: $GATEWAY"

# Extract subnet from local IP (assumes /24)
SUBNET=$(echo "$LOCAL_IP" | cut -d. -f1-3).0/24

msg_info "Scanning subnet: $SUBNET (this may take a moment)"

check_command "nmap" || exit 1

# Ping scan to discover live hosts
SCAN_OUTPUT=$(nmap -sn "$SUBNET" 2>/dev/null)

echo "$SCAN_OUTPUT" | grep -E "Nmap scan report|MAC Address"

# Save results to reports/ with timestamp
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
REPORT_FILE="$SCRIPT_DIR/../reports/netscout_$TIMESTAMP.txt"

{
    echo "NetScout Report - $(date)"
    echo "Interface: $INTERFACE"
    echo "Local IP: $LOCAL_IP"
    echo "Gateway: $GATEWAY"
    echo "Subnet scanned: $SUBNET"
    echo ""
    echo "$SCAN_OUTPUT" | grep -E "Nmap scan report|MAC Address"
} > "$REPORT_FILE"

msg_success "Report saved to: $REPORT_FILE"
log_event "NetScout scan completed, report: $REPORT_FILE"
