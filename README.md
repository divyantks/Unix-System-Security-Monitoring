# Unix System Security & Log Monitoring System (USSLM)

## Project Overview

The Unix System Security & Log Monitoring System (USSLM) is a Bash-based security monitoring application designed for Linux/Unix environments.

It analyses authentication logs, monitors running processes, detects suspicious login activity, generates security alerts and creates security reports.

The system also supports automated monitoring through Cron jobs.

## Technologies Used

- Bash Shell Scripting
- Linux/Unix Commands
- AWK
- GREP
- PS
- TAIL
- CRON
- Ubuntu Linux / WSL

## Project Features

1. **Login Activity Monitor** – Displays successful and failed login attempts.
2. **Brute Force Detector** – Identifies IP addresses with repeated failed login attempts.
3. **IP Address Monitor** – Displays successful and failed login statistics for each IP.
4. **User Activity Monitor** – Tracks login activity for individual usernames.
5. **Process Monitor** – Displays running processes and CPU/memory usage.
6. **Real-time Log Monitor** – Continuously monitors new authentication log entries.
7. **Security Report Generator** – Generates reports containing login statistics, suspicious IPs, user activity and process information.
8. **Alert Management System** – Classifies suspicious IP activity and stores security alerts.
9. **Automated Monitoring** – Uses Cron to execute periodic security checks automatically.

## Project Structure

```text
USSLM/
├── README.md
├── main.sh
├── alerts/
│   └── security_alerts.log
├── config/
│   └── config.sh
├── logs/
│   ├── auth_sample.log
│   └── cron_monitor.log
├── modules/
│   ├── alert_manager.sh
│   ├── brute_force_detector.sh
│   ├── cron_monitor.sh
│   ├── ip_monitor.sh
│   ├── login_monitor.sh
│   ├── process_monitor.sh
│   ├── realtime_monitor.sh
│   ├── report_generator.sh
│   └── user_monitor.sh
└── reports/
```

## Configuration

The file `config/config.sh` contains the failed login attempt threshold.

Example:

```bash
FAILED_ATTEMPT_THRESHOLD=3
```

An IP address reaching this threshold is classified as suspicious.

## Requirements

- Linux/Unix environment or Ubuntu on WSL
- Bash shell
- Standard Linux utilities
- Cron service for automated monitoring

## Installation and Execution

1. Clone or download the project.
2. Navigate to the project directory.
3. Make the main script executable:

```bash
chmod +x main.sh
```

4. Run the application:

```bash
./main.sh
```

5. Select the desired monitoring feature from the main menu.

## Automated Monitoring Setup

The project supports scheduled security monitoring using Cron.

Example Cron entry:

```bash
*/5 * * * * /bin/bash /absolute/path/to/USSLM/modules/cron_monitor.sh
```

This executes the monitoring script every five minutes.

## Output Files

- `alerts/security_alerts.log` – Stores generated security alerts.
- `logs/cron_monitor.log` – Stores automated monitoring execution details.
- `reports/` – Stores generated security reports.

## Testing

The project uses a sample authentication log file (`logs/auth_sample.log`) containing simulated SSH login events.

These events are used to test successful login detection, failed login detection, suspicious IP identification and real-time monitoring.

## Limitations

- The current implementation uses a sample authentication log for demonstration.
- Real system log monitoring requires access to the appropriate authentication log file.
- Brute-force detection currently uses the total failed attempts in the available log rather than a time-based detection window.
- Process monitoring identifies resource-intensive processes but does not independently establish whether a process is malicious.

## Team Information

**Team Name:** Kernel Panic  
**Group Number:** 6

**Team Members:**

- Naitik Laddha
- Kabir Gaur
- Pushkar Sharma
- Vinit Khatana
- Divyant Kumar Srivastava

## Conclusion

USSLM demonstrates how Bash scripting and standard Linux utilities can be combined to develop a modular security monitoring system. It provides authentication log analysis, suspicious activity detection, process monitoring, alert generation, report generation and automated security checks.