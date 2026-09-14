#!/bin/bash
# shellstrike.sh - Main menu for ShellStrike toolkit

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/messages.sh"
source "$SCRIPT_DIR/lib/validate.sh"
source "$SCRIPT_DIR/lib/logging.sh"
source "$SCRIPT_DIR/lib/traps.sh"

VERSION="1.0.0"

if [[ "$1" == "--version" ]]; then
    echo "ShellStrike v$VERSION"
    exit 0
fi

if [[ "$1" == "--help" ]]; then
    echo "ShellStrike - Kali Linux Security Toolkit"
    echo ""
    echo "Usage: ./shellstrike.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  --help       Show this help message"
    echo "  --version    Show version information"
    echo ""
    echo "Run without options to launch the interactive menu."
    exit 0
fi


show_banner() {
    clear
    echo -e "${GREEN}${BOLD}"
    if command -v figlet &> /dev/null; then
        figlet -f slant "ShellStrike"
    else
        echo "SHELLSTRIKE"
    fi
    echo -e "${RESET}"
    echo -e "${GREEN}    [ Kali Linux Security Toolkit v1.0.0 ]${RESET}"
    echo -e "${CYAN}    ---------------------------------------${RESET}"
}
show_banner

show_menu() {
    echo -e "${GREEN}[1]${RESET} NetScout       - Network Discovery"
    echo -e "${GREEN}[2]${RESET} PortPilot      - Port Scanner"
    echo -e "${GREEN}[3]${RESET} LinuxAudit     - Linux Security Audit"
    echo -e "${GREEN}[4]${RESET} LogSentinel    - Log Analyzer"
    echo -e "${GREEN}[5]${RESET} WebRecon       - Web Reconnaissance"
    echo -e "${GREEN}[6]${RESET} System Info"
    echo -e "${GREEN}[7]${RESET} Generate Report"
    echo -e "${RED}[0]${RESET} Exit"
    echo ""
}

show_menu

while true; do
    read -rp "ShellStrike> Select an option: " CHOICE

    case "$CHOICE" in
        1)
            "$SCRIPT_DIR/tools/netscout.sh"
            ;;
        2)
            read -rp "Enter authorized target IP: " TARGET
            "$SCRIPT_DIR/tools/portpilot.sh" "$TARGET"
            ;;
        3)
            "$SCRIPT_DIR/tools/linuxaudit.sh"
            ;;
        4)
            "$SCRIPT_DIR/tools/logsentinel.sh"
            ;;
        5)
            read -rp "Enter authorized domain/URL: " WEBTARGET
            "$SCRIPT_DIR/tools/webrecon.sh" "$WEBTARGET"
            ;;
        6)
            msg_header "System Info"
            uname -a
            ;;
        7)
            msg_info "Reports are saved automatically in the reports/ folder by each tool."
            ls "$SCRIPT_DIR/reports/"
            ;;
        0)
            msg_success "Exiting ShellStrike. Stay safe."
            exit 0
            ;;
        *)
            msg_error "Invalid option: $CHOICE"
            ;;
    esac

    echo ""
    read -rp "Press Enter to return to menu..." _
    show_banner
    show_menu
done
