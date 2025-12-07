#!/bin/bash
# htmlReport.bash
# Converts report.txt into report.html and moves it to /var/www/html

report_txt="/home/champuser/SYS320-01/final/report.txt"
report_html="/home/champuser/SYS320-01/final/report.html"
web_dir="/var/www/html"

# Create the HTML file with header and table setup
{
echo "<html>"
echo "<body>"
echo "<h3>Access logs with IOC indicators:</h3>"
echo "<table border='1'>"

# Loop through each line of report.txt and format it into table rows
while read -r line; do
    echo "<tr><td>${line// /</td><td>}</td></tr>"
done < "$report_txt"

# Close HTML tags
echo "</table>"
echo "</body>"
echo "</html>"
} > "$report_html"

# Move report to Apache directory
sudo mv "$report_html" "$web_dir/"

echo "HTML report created and moved to $web_dir/report.html"
