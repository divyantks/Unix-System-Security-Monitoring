
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

LOG_FILE="$PROJECT_DIR/logs/auth_sample.log"
REPORT_DIR="$PROJECT_DIR/reports"

source "$PROJECT_DIR/config/config.sh"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Authentication log file not found!"
    exit 1
fi

mkdir -p "$REPORT_DIR"

REPORT_FILE="$REPORT_DIR/security_report_$(date +%Y%m%d_%H%M%S).txt"

SUCCESS=$(grep -Ec 'sshd.*: Accepted (password|publickey) for ' "$LOG_FILE")
FAILED=$(grep -Ec 'sshd.*: Failed password for ' "$LOG_FILE")

{
    echo "=========================================="
    echo "       UNIX SYSTEM SECURITY REPORT"
    echo "=========================================="

    echo
    echo "Generated On: $(date)"
    echo "Log Source: $LOG_FILE"

    echo
    echo "----------- LOGIN SUMMARY -----------"
    echo "Successful Logins: $SUCCESS"
    echo "Failed Logins: $FAILED"
    echo "Total Login Attempts: $((SUCCESS+FAILED))"

    echo
    echo "----------- FAILED LOGINS BY IP -----------"

    awk '/sshd.*: Failed password for / {
        for(i=1;i<NF;i++) {
            if($i=="from") {
                print $(i+1)
                break
            }
        }
    }' "$LOG_FILE" | sort | uniq -c | sort -nr

    echo
    echo "----------- SUSPICIOUS IP ADDRESSES -----------"

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
                printf "%s : %d failed attempts\n",ip,count[ip]
                found=1
            }
        }
        if(found==0)
            print "No suspicious IP addresses detected."
    }' "$LOG_FILE"

    echo
    echo "----------- USER LOGIN ACTIVITY -----------"

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
        printf "%-15s %-12s %-12s %-12s\n","USERNAME","SUCCESSFUL","FAILED","TOTAL"
        for(user in total)
            printf "%-15s %-12d %-12d %-12d\n",user,success[user],failed[user],total[user]
    }' "$LOG_FILE"

    echo
    echo "----------- TOP 5 CPU CONSUMING PROCESSES -----------"

    ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6

    echo
    echo "=========================================="
    echo "             END OF REPORT"
    echo "=========================================="

} > "$REPORT_FILE"

echo "Security report generated successfully!"
echo
echo "Report saved at:"
echo "$REPORT_FILE"
