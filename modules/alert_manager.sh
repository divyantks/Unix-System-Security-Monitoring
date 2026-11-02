
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

LOG_FILE="$PROJECT_DIR/logs/auth_sample.log"
ALERT_DIR="$PROJECT_DIR/alerts"
ALERT_FILE="$ALERT_DIR/security_alerts.log"

source "$PROJECT_DIR/config/config.sh"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Authentication log file not found!"
    exit 1
fi

mkdir -p "$ALERT_DIR"

{
    echo "=========================================="
    echo "          SECURITY ALERT MANAGER"
    echo "=========================================="

    echo "Generated On: $(date)"
    echo "Failed Attempt Threshold: $FAILED_ATTEMPT_THRESHOLD"

    echo
    echo "----------- DETECTED SECURITY ALERTS -----------"

    awk -v threshold="$FAILED_ATTEMPT_THRESHOLD" '
    /sshd.*: Failed password for / {
        for(i=1;i<NF;i++) {
            if($i=="from") {
                count[$(i+1)]++
                break
            }
        }
    }

    END {
        found=0

        for(ip in count) {
            if(count[ip]>=threshold) {
                severity="MEDIUM"

                if(count[ip]>=threshold*2)
                    severity="HIGH"

                printf "[%s] ALERT: IP %s has %d failed login attempts.\n",
                severity,ip,count[ip]

                found=1
            }
        }

        if(found==0)
            print "No suspicious IP addresses detected."
    }'

    echo
    echo "=========================================="
    echo "             END OF ALERTS"
    echo "=========================================="

} < "$LOG_FILE" > "$ALERT_FILE"

echo "Security alerts generated successfully!"
echo
echo "Alert file saved at:"
echo "$ALERT_FILE"

echo
cat "$ALERT_FILE"
