#!/bin/bash
# countingCurlAccess.bash
# Count all curl accesses and display one summary line

file="/var/log/apache2/access.log.1"

function countingCurlAccess(){
    # Filter curl lines and extract IP + user agent
    results=$(grep "curl" "$file" | awk '{print $1, $12}' | tr -d '"')

    # Count total curl lines
    count=$(echo "$results" | wc -l)

    # Extract the first IP and user agent
    ip=$(echo "$results" | head -n 1 | awk '{print $1}')
    curlver=$(echo "$results" | head -n 1 | awk '{print $2}')

    # Output
    echo "$count $ip \"$curlver\""
}

countingCurlAccess
