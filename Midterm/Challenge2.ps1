# ===================================================================
# Script Name: Challenge2.ps1
# Author: Cameron Jalbert
# Course: SYS320-01 | Midterm Challenge 2
# Description: 
#   Parses Apache access logs from the local Midterm directory and
#   displays IP, Time, Method, Page, Protocol, Response, and Referrer.
# ===================================================================

function Get-ApacheLogs {

    # Define path to Apache log file
    $logPath = "C:\Users\champuser\SYS320-01\Midterm\access.log"

    # Ensure the log file exists
    if (-not (Test-Path $logPath)) {
        Write-Host "Error: Log file not found at $logPath" -ForegroundColor Red
        return
    }

    # Read each line of the log
    $logLines = Get-Content $logPath

    # Array for parsed log entries
    $parsedLogs = @()

    # Regex for Apache log structure
    $regex = '^(?<IP>\S+) \S+ \S+ \[(?<Time>[^\]]+)\] "(?<Method>\S+)\s(?<Page>\S+)\s(?<Protocol>[^"]+)" (?<Response>\d{3}) \S+ "(?<Referrer>[^"]*)"'

    foreach ($line in $logLines) {
        if ($line -match $regex) {
            $parsedLogs += [PSCustomObject]@{
                IP        = $matches['IP']
                Time      = $matches['Time']
                Method    = $matches['Method']
                Page      = $matches['Page']
                Protocol  = $matches['Protocol']
                Response  = $matches['Response']
                Referrer  = if ($matches['Referrer']) { $matches['Referrer'] } else { "-" }
            }
        }
    }

    # Display formatted table
    $parsedLogs | Format-Table -AutoSize
}

# Execute the function
Get-ApacheLogs
