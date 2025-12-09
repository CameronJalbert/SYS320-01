#!/bin/bash

log="/home/champuser/SYS320-01/week13/fileaccesslog.txt"
time=$(date "+%Y-%m-%d %I:%M:%S %p")
echo "File was accessed at $time" >> "$log"

function logFile(){
 cat $log
}

echo "To: cameron.jalbert@mymail.champlain.edu" > email.txt
echo "Subject: File Access" >> email.txt

logFile >> email.txt

cat email.txt | ssmtp cameron.jalbert@mymail.champlain.edu
