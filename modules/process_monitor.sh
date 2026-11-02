#!/bin/bash

echo "======================================"
echo "           PROCESS MONITOR"
echo "======================================"

echo
echo "Top 5 CPU Consuming Processes:"
echo

ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6

echo
echo "======================================"
echo "Total Running Processes:"
ps -e --no-headers | wc -l

echo
echo "======================================"
echo "Processes Using More Than 50% CPU:"
echo

ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | awk 'NR>1 && $3>50'

echo
echo "======================================"