#!/bin/bash
# challenge2.bash
# This script checks Apache logs for any Indicators of Compromise (IOCs)
# Usage: bash finalC2.bash access.log IOC.txt

logfile=$1
iocfile=$2
output="report.txt"

# Clear any previous report
> "$output"

# Loop through each IOC pattern in the IOC file
while read -r ioc; do
    # Search the log file for lines containing the IOC
    grep "$ioc" "$logfile" | awk '{print $1, $4, $7}' | sed 's/\[//g' >> "$output"
done < "$iocfile"

echo "Report saved to $output"
