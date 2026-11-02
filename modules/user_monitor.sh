#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

LOG_FILE="$PROJECT_DIR/logs/auth_sample.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Authentication log file not found!"
    exit 1
fi

echo "======================================"
echo "         USER ACTIVITY MONITOR"
echo "======================================"

echo
printf "%-15s %-12s %-12s %-12s\n" "USERNAME" "SUCCESSFUL" "FAILED" "TOTAL"
echo "--------------------------------------------------------"

awk '
/sshd.*: Accepted (password|publickey) for / ||
/sshd.*: Failed password for / {

    for(i=1;i<NF;i++) {
        if($i=="for") {

            user=$(i+1)

            if(user=="invalid" && $(i+2)=="user")
                user=$(i+3)

            if($0 ~ /: Accepted (password|publickey) for /)
                success[user]++
            else
                failed[user]++

            total[user]++
            break
        }
    }
}

END {
    for(user in total) {
        printf "%-15s %-12d %-12d %-12d\n",
        user,success[user],failed[user],total[user]
    }
}
' "$LOG_FILE" | sort -k1,1

echo
echo "======================================"
echo "Note: Invalid usernames in failed login"
echo "attempts are reported as targeted names."
echo "======================================"