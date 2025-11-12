#!/bin/bash

file="/var/log/apache2/access.log.1"
pages=""

# Function: extract only accessed pages
function getAllLogs(){
    pages=$(cat "$file" | cut -d' ' -f7)
}

# Function: count how many times each page was accessed
function pageCount(){
    echo "$pages" | sort | uniq -c
}

# Run functions
getAllLogs
pageCount
