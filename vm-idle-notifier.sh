#!/bin/bash

TOPIC="sameer-vm-idle"
IDLE_THRESHOLD_MINUTES=30
CPU_IDLE_LIMIT=5
STATE_FILE="/tmp/xrdp_vm_idle_state"
NOW=$(date +%s)

# Get CPU usage
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)

# Count XRDP users
ACTIVE_XRDP_USERS=$(who | grep xrdp | wc -l)

if (( $(echo "$CPU_USAGE < $CPU_IDLE_LIMIT" | bc -l) )) && [ "$ACTIVE_XRDP_USERS" -eq 0 ]; then
    # VM is idle
    if [ -f "$STATE_FILE" ]; then
        LAST_IDLE=$(cat "$STATE_FILE")
        DIFF_MIN=$(( (NOW - LAST_IDLE) / 60 ))

        if [ "$DIFF_MIN" -ge "$IDLE_THRESHOLD_MINUTES" ]; then
            curl -d "🛑 XRDP VM idle for $DIFF_MIN minutes." ntfy.sh/$TOPIC
            echo "$NOW" > "$STATE_FILE"
        fi
    else
        echo "$NOW" > "$STATE_FILE"
    fi
else
    rm -f "$STATE_FILE"
fi
