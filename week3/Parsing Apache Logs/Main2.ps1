# Import Apache-Logs2.ps1
. "$PSScriptRoot\Apache-Logs2.ps1"

# Call the function
$stableRecords = Parse-ApacheLogs

# Display results in table format
$stableRecords | Format-Table -AutoSize -Wrap