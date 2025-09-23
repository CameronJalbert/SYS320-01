# Dot-source function file
. "C:\Users\champuser\SYS320-01\week2\CallthisFile.ps1"

Clear-Host

# Get Login and Logoffs from the last 30 days
$loginoutsTable = Get-WinLogonEventsSimple -Days 30
$loginoutsTable

# Get Shut Downs from the last 25 days
$shutdownsTable = Get-SystemStartStopEventsSimple -Days 25 | Where-Object { $_.Event -eq "Shutdown" }
$shutdownsTable

# Get Start Ups from the last 25 days
$startupsTable = Get-SystemStartStopEventsSimple -Days 25 | Where-Object { $_.Event -eq "Startup" }
$startupsTable
