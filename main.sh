#!/bin/bash
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true
do
    
    echo "======================================"
    echo "   UNIX SYSTEM SECURITY MONITOR"
    echo "======================================"
    echo "1. Login Activity Monitor"
    echo "2. Brute Force Detection"
    echo "3. IP Address Monitor"
    echo "4. User Activity Monitor"
    echo "5. Process Monitor"
    echo "6. Real-time Log Monitoring"
    echo "7. Generate Security Report"
    echo "8. Alert Management System"
    echo "9. Exit"
    echo "======================================"

    read -p "Enter your choice: " choice

    case $choice in
        1) bash "$PROJECT_DIR/modules/login_monitor.sh" ;;
        2) bash "$PROJECT_DIR/modules/brute_force_detector.sh" ;;
        3) bash "$PROJECT_DIR/modules/ip_monitor.sh" ;;
        4) bash "$PROJECT_DIR/modules/user_monitor.sh" ;;
        5) bash "$PROJECT_DIR/modules/process_monitor.sh" ;;
        6) bash "$PROJECT_DIR/modules/realtime_monitor.sh" ;;
        7) bash "$PROJECT_DIR/modules/report_generator.sh" ;;
        8) bash "$PROJECT_DIR/modules/alert_manager.sh" ;;
        9) exit 0 ;;
    esac

    read -p "Press Enter to continue..."
done