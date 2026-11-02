#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

LOG_FILE="$PROJECT_DIR/logs/auth_sample.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Authentication log file not found!"
    exit 1
fi

echo "======================================"
echo "          IP ADDRESS MONITOR"
echo "======================================"

echo
printf "%-20s %-12s %-12s %-12s\n" "IP ADDRESS" "SUCCESSFUL" "FAILED" "TOTAL"
echo "------------------------------------------------------------"

awk '
/sshd.*: Accepted (password|publickey) for / ||
/sshd.*: Failed password for / {

    for(i=1;i<NF;i++) {
        if($i=="from") {
            ip=$(i+1)

            if($0 ~ /: Accepted (password|publickey) for /)
                success[ip]++

            else if($0 ~ /: Failed password for /)
                failed[ip]++

            total[ip]++
            break
        }
    }
}

END {
    for(ip in total) {
        printf "%-20s %-12d %-12d %-12d\n",
        ip,success[ip],failed[ip],total[ip]
    }
}
' "$LOG_FILE" | sort -k1,1

echo
echo "======================================"