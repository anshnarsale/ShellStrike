#!/bin/bash
# messages.sh - Standard message functions for consistent output
# Requires colors.sh to be sourced first

msg_success() {
    echo -e "${GREEN}[+]${RESET} $1"
}

msg_error() {
    echo -e "${RED}[-]${RESET} $1"
}

msg_warning() {
    echo -e "${YELLOW}[!]${RESET} $1"
}

msg_info() {
    echo -e "${CYAN}[*]${RESET} $1"
}

msg_header() {
    echo -e "${BOLD}${BLUE}== $1 ==${RESET}"
}
