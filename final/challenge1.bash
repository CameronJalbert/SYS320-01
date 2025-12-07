#!/bin/bash
# challenge1.bash
# Scrape IOC indicators from the IOC web page and save to IOC.txt

# URL of the IOC page
url="http://10.0.17.47/IOC.html"

# File to save IOCs
output="IOC.txt"

# Fetch the page and extract only the pattern column (first column inside the table)
curl -s "$url" | grep -oP '(?<=<td>)[^<]+' | sed -n '1~2p' > "$output"

# Display confirmation
echo "IOCs saved to $output"
