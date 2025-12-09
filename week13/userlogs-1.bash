#! /bin/bash

authfile="/var/log/auth.log"

function getLogins(){
 logline=$(cat "$authfile" | grep "systemd-logind" | grep "New session")
 dateAndUser=$(echo "$logline" | cut -d' ' -f1,2,11 | tr -d '\.')
 echo "$dateAndUser" 
}

function getFailedLogins(){
	logline=$(cat "$authfile" | grep "failure")
	dateAndUser=$(echo "$logline" | cut -d' ' -f1,2,3,17)
	echo "$dateAndUser"
# Todo - 1
# a) Make a little research and experimentation to complete the function
# b) Generate failed logins and test
}


# Sending logins as email - Do not forget to change email address
# to your own email address
echo "To: cameron.jalbert@mymail.champlain.edu" > emailform.txt
echo "Subject: Logins" >> emailform.txt
getLogins >> emailform.txt
cat emailform.txt | ssmtp cameron.jalbert@mymail.champlain.edu

# Todo - 2
# Send failed logins as email to yourself.
# Similar to sending logins as email
echo "To: cameron.jalbert@mymail.champlain.edu" > emailform02.txt
echo "Subject: Login Fails" >> emailform02.txt
getFailedLogins >> emailform02.txt
cat emailform02.txt | ssmtp cameron.jalbert@mymail.champlain.edu 
