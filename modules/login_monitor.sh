#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_DIR/logs/auth_sample.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Authentication log file not found!"
    exit 1
fi

echo "======================================"
echo "       LOGIN ACTIVITY MONITOR"
echo "======================================"

SUCCESS=$(grep -Ec 'sshd.*: Accepted (password|publickey) for ' "$LOG_FILE")
FAILED=$(grep -Ec 'sshd.*: Failed password for ' "$LOG_FILE")

echo
echo "Total Successful Logins: $SUCCESS"
echo "Total Failed Logins: $FAILED"

echo
echo "----------- SUCCESSFUL LOGINS -----------"
grep -E 'sshd.*: Accepted (password|publickey) for ' "$LOG_FILE" || true

echo
echo "------------- FAILED LOGINS -------------"
grep -E 'sshd.*: Failed password for ' "$LOG_FILE" || true

echo
echo "======================================"