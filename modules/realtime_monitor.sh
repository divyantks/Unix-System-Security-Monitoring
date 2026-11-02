#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

LOG_FILE="$PROJECT_DIR/logs/auth_sample.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Authentication log file not found!"
    exit 1
fi

echo "======================================"
echo "       REAL-TIME LOG MONITOR"
echo "======================================"
echo
echo "Monitoring: $LOG_FILE"
echo "Press Ctrl+C to stop monitoring."
echo

tail -n 0 -f "$LOG_FILE" | while read -r line
do
    if [[ "$line" == *"Failed password"* ]]; then
        echo "[ALERT] Failed Login: $line"

    elif [[ "$line" == *"Accepted password"* || "$line" == *"Accepted publickey"* ]]; then
        echo "[SUCCESS] Successful Login: $line"

    else
        echo "[INFO] $line"
    fi
done