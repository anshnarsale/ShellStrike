#!/bin/bash
# traps.sh - Clean exit handling for Ctrl+C and script exit

cleanup() {
    echo ""
    msg_warning "Interrupted. Cleaning up..."
    exit 130
}

trap cleanup SIGINT SIGTERM
