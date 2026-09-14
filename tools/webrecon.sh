#!/bin/bash
# webrecon.sh - Basic passive web reconnaissance for authorized targets

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/messages.sh"
source "$SCRIPT_DIR/../lib/validate.sh"
source "$SCRIPT_DIR/../lib/logging.sh"
source "$SCRIPT_DIR/../lib/traps.sh"

msg_header "WebRecon - Web Reconnaissance"

if [[ -z "$1" ]]; then
    msg_error "Usage: $0 <authorized-domain-or-url>"
    exit 1
fi

TARGET="$1"

# Strip protocol if user included it, keep clean domain for DNS lookups
DOMAIN=$(echo "$TARGET" | sed -E 's|^https?://||' | cut -d/ -f1)

msg_info "Target domain: $DOMAIN"

check_command "dig" || exit 1
check_command "curl" || exit 1

# DNS information
msg_info "DNS Information:"
DNS_A=$(dig +short A "$DOMAIN")
if [[ -n "$DNS_A" ]]; then
    echo "A record(s): $DNS_A"
else
    msg_warning "No A record found"
fi

DNS_NS=$(dig +short NS "$DOMAIN")
if [[ -n "$DNS_NS" ]]; then
    echo "Nameserver(s): $DNS_NS"
fi

# HTTP/HTTPS response check
msg_info "HTTP Response:"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "https://$DOMAIN")
echo "HTTPS status code: $HTTP_STATUS"

# HTTP headers
msg_info "HTTP Headers:"
curl -sI --max-time 10 "https://$DOMAIN" 2>/dev/null | head -n 15

# robots.txt check
msg_info "robots.txt:"
ROBOTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "https://$DOMAIN/robots.txt")
if [[ "$ROBOTS_STATUS" == "200" ]]; then
    curl -s --max-time 10 "https://$DOMAIN/robots.txt" | head -n 10
else
    msg_info "No robots.txt found (status: $ROBOTS_STATUS)"
fi

# TLS certificate information
msg_info "TLS Certificate:"
check_command "openssl" && {
    echo | openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" 2>/dev/null | openssl x509 -noout -subject -issuer -dates 2>/dev/null
}

# Save report
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
REPORT_FILE="$SCRIPT_DIR/../reports/webrecon_${DOMAIN}_${TIMESTAMP}.txt"

{
    echo "WebRecon Report - $(date)"
    echo "Target: $DOMAIN"
    echo ""
    echo "DNS A record(s): $DNS_A"
    echo "Nameserver(s): $DNS_NS"
    echo "HTTPS status: $HTTP_STATUS"
    echo "robots.txt status: $ROBOTS_STATUS"
} > "$REPORT_FILE"

msg_success "Report saved to: $REPORT_FILE"
log_event "WebRecon scan completed for $DOMAIN, report: $REPORT_FILE"
