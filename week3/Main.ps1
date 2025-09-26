# Import Apache-Logs.ps1 (dot notation) (PSScriptRoot works when both files are in the same directory) (Call full path otherwise)
. "$PSScriptRoot\Apache-Logs.ps1"

# Call the function with values
Get-ApacheLogIPs -Page "index.html" -HttpCode "200"