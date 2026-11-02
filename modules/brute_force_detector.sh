#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_DIR/config/config.sh"

LOG_FILE="$PROJECT_DIR/logs/auth_sample.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Authentication log file not found!"
    exit 1
fi

echo "======================================"
echo "       BRUTE FORCE DETECTOR"
echo "======================================"

echo
echo "Failed Login Attempts by IP:"
echo

FAILED_IP_COUNTS=$(awk '/sshd.*: Failed password for / {
    for(i=1;i<NF;i++) {
        if($i=="from") {
            print $(i+1)
            break
        }
    }
}' "$LOG_FILE" | sort | uniq -c | sort -nr)

if [ -z "$FAILED_IP_COUNTS" ]; then
    echo "No failed login attempts found."
    exit 0
fi

echo "$FAILED_IP_COUNTS"

echo
echo "Threshold: $FAILED_ATTEMPT_THRESHOLD attempts"
echo
echo "----------- SUSPICIOUS IPs -----------"

SUSPICIOUS_IPS=$(echo "$FAILED_IP_COUNTS" | awk -v threshold="$FAILED_ATTEMPT_THRESHOLD" '$1>=threshold')

if [ -z "$SUSPICIOUS_IPS" ]; then
    echo "No suspicious IP addresses detected."
else
    echo "$SUSPICIOUS_IPS" | while read -r count ip
    do
        echo "ALERT: $ip has $count failed login attempts!"
    done
fi

echo
echo "======================================"