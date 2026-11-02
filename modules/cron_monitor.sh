
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

LOG_DIR="$PROJECT_DIR/logs"
ALERT_FILE="$PROJECT_DIR/alerts/security_alerts.log"
CRON_LOG="$LOG_DIR/cron_monitor.log"

mkdir -p "$LOG_DIR"

echo "======================================" >> "$CRON_LOG"
echo "Monitoring Run: $(date)" >> "$CRON_LOG"

bash "$SCRIPT_DIR/alert_manager.sh" >> "$CRON_LOG" 2>&1

if [ -f "$ALERT_FILE" ]; then
    echo "Alert check completed successfully." >> "$CRON_LOG"
else
    echo "Error: Alert file was not generated." >> "$CRON_LOG"
fi

echo "======================================" >> "$CRON_LOG"
