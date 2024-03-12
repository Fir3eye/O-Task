#!/bin/bash

# Configuration
OUTPUT_DIR="/tmp/mariadb_logs"
SLOW_LOG_FILE="/var/log/mysql/mariadb-slow.log"
OUTPUT_FILE="${OUTPUT_DIR}/latest_qualifying_log_entry.txt"
BYTES_SENT_FILE="${OUTPUT_DIR}/latest_bytes_sent_value.txt"
EMAIL_RECIPIENT="your@email.com" # Change this to your actual email address

# Ensure the output directory exists
mkdir -p "${OUTPUT_DIR}"

# Initialize control variables
capture=false
latest_bytes_sent=0
entry=()
entry_started=false

# Process the slow log file in reverse to find the most recent entry that meets the condition
tac "${SLOW_LOG_FILE}" | while IFS= read -r line; do
    if [[ "$line" =~ ^"# Time:" ]]; then
        if [[ "$capture" = true ]]; then
            # If an entry to be captured has been found, reverse the array to maintain original order and write to the file
            printf "%s\n" "${entry[@]}" | tac > "${OUTPUT_FILE}"
            echo "${latest_bytes_sent}" > "${BYTES_SENT_FILE}"
            break # Exit the loop after saving the qualifying log entry
        fi
        entry=("$line") # Start capturing a new entry
        entry_started=true
    else
        if [[ "$entry_started" = true ]]; then
            entry+=("$line") # Continue capturing the entry
        fi
    fi

    if [[ "$line" =~ Bytes_sent:\ ([0-9]+) && "${BASH_REMATCH[1]}" -gt 28718 ]]; then
        capture=true # Flag to start capturing the entry
        latest_bytes_sent="${BASH_REMATCH[1]}" # Capture the latest "Bytes_sent" value
    fi
done

# Send notification if a new log entry was captured
if [ -s "${OUTPUT_FILE}" ]; then
    # Prepare the message
    MESSAGE="A new MariaDB slow log entry with 'Bytes_sent' greater than 28718 has been captured and stored in ${OUTPUT_FILE}. Check ${BYTES_SENT_FILE} for the 'Bytes_sent' value."
    # Send email notification
    echo "${MESSAGE}" | mail -s "MariaDB Log Entry Update" "${EMAIL_RECIPIENT}"
fi

echo "Script execution completed. Check ${OUTPUT_DIR} for the results."
