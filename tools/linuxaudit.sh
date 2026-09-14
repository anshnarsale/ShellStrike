#!/bin/bash
# linuxaudit.sh - Linux security audit tool (heuristic, not professional-grade)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"
source "$SCRIPT_DIR/../lib/messages.sh"
source "$SCRIPT_DIR/../lib/validate.sh"
source "$SCRIPT_DIR/../lib/logging.sh"
source "$SCRIPT_DIR/../lib/traps.sh"

msg_header "LinuxAudit - Security Audit"

PASS_COUNT=0
WARN_COUNT=0
CRIT_COUNT=0

# OS information
msg_info "OS Information:"
if [[ -f /etc/os-release ]]; then
    grep "PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"'
    ((PASS_COUNT++))
else
    msg_warning "Could not read /etc/os-release"
    ((WARN_COUNT++))
fi

# Kernel version
msg_info "Kernel Version:"
uname -r
((PASS_COUNT++))

# Current user
msg_info "Current User:"
whoami
((PASS_COUNT++))

# Users with login shells (potential login accounts)
msg_info "Users with login shells:"
grep -E "/bin/bash$|/bin/sh$|/bin/zsh$" /etc/passwd | cut -d: -f1
((PASS_COUNT++))

# SSH configuration checks
msg_info "SSH Configuration:"
SSHD_CONFIG="/etc/ssh/sshd_config"
if [[ -f "$SSHD_CONFIG" ]]; then
    ROOT_LOGIN=$(grep -i "^PermitRootLogin" "$SSHD_CONFIG" | awk '{print $2}')
    if [[ "$ROOT_LOGIN" == "yes" ]]; then
        msg_warning "SSH PermitRootLogin is set to yes (root login allowed)"
        ((WARN_COUNT++))
    else
        msg_success "SSH root login not explicitly permitted"
        ((PASS_COUNT++))
    fi

    PASS_AUTH=$(grep -i "^PasswordAuthentication" "$SSHD_CONFIG" | awk '{print $2}')
    if [[ "$PASS_AUTH" == "yes" ]]; then
        msg_warning "SSH password authentication enabled (key-based auth is safer)"
        ((WARN_COUNT++))
    else
        msg_success "SSH password authentication not explicitly enabled"
        ((PASS_COUNT++))
    fi
else
    msg_warning "sshd_config not found (SSH may not be installed)"
    ((WARN_COUNT++))
fi

# Firewall status (ufw if available)
msg_info "Firewall Status:"
if command -v ufw &> /dev/null; then
    UFW_STATUS=$(ufw status 2>/dev/null | head -n1)
    echo "$UFW_STATUS"
    if echo "$UFW_STATUS" | grep -qi "inactive"; then
        msg_warning "Firewall (ufw) is inactive"
        ((WARN_COUNT++))
    else
        msg_success "Firewall (ufw) is active"
        ((PASS_COUNT++))
    fi
else
    msg_warning "ufw not installed - cannot check firewall status"
    ((WARN_COUNT++))
fi

# Listening ports
msg_info "Listening Ports:"
if command -v ss &> /dev/null; then
    LISTENING=$(ss -tuln | grep LISTEN)
    if [[ -z "$LISTENING" ]]; then
        msg_info "No listening ports found"
    else
        echo "$LISTENING"
    fi
    ((PASS_COUNT++))
else
    msg_warning "ss command not found"
    ((WARN_COUNT++))
fi

# Sensitive file permissions
msg_info "Sensitive File Permissions:"
for f in /etc/passwd /etc/shadow /etc/sudoers; do
    if [[ -e "$f" ]]; then
        PERMS=$(stat -c "%a" "$f" 2>/dev/null)
        echo "$f -> $PERMS"
        ((PASS_COUNT++))
    fi
done

# World-writable files in common safe locations
msg_info "World-Writable Files (common locations):"
WW_FILES=$(find /etc /usr/bin /usr/local/bin -maxdepth 2 -perm -0002 -type f 2>/dev/null)
if [[ -z "$WW_FILES" ]]; then
    msg_success "No world-writable files found in checked locations"
    ((PASS_COUNT++))
else
    echo "$WW_FILES"
    msg_warning "World-writable files found (see above)"
    ((WARN_COUNT++))
fi

# Running services (systemd)
msg_info "Running Services (sample):"
if command -v systemctl &> /dev/null; then
    systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}' | head -n 10
    ((PASS_COUNT++))
else
    msg_warning "systemctl not found - cannot list services"
    ((WARN_COUNT++))
fi

# Failed login attempts (if log accessible)
msg_info "Failed Login Attempts:"
if [[ -r /var/log/auth.log ]]; then
    FAILED_COUNT=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null)
    echo "Failed password attempts logged: $FAILED_COUNT"
    ((PASS_COUNT++))
else
    msg_warning "Cannot read /var/log/auth.log (may not exist or need root)"
    ((WARN_COUNT++))
fi

# Final summary
echo ""
msg_header "Security Audit Summary (Project Heuristic - Not a Professional Rating)"
echo "Checks passed:     $PASS_COUNT"
echo "Warnings:          $WARN_COUNT"
echo "Critical findings: $CRIT_COUNT"

log_event "LinuxAudit completed. Passed: $PASS_COUNT, Warnings: $WARN_COUNT, Critical: $CRIT_COUNT"
