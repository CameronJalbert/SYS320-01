# ===================================================================
# Script Name: Challenge3.ps1
# Author: Cameron Jalbert
# Course: SYS320-01 | Midterm Challenge 3
# Description:
#   Takes parsed Apache logs and IOC patterns as input, and returns
#   only those logs where the Page property matches any IOC indicator.
# ===================================================================

function Get-ApacheLogs {
    param(
        [string]$logPath = "C:\Users\champuser\SYS320-01\Midterm\access.log"
    )

    if (-not (Test-Path $logPath)) {
        Write-Host "Error: Log file not found at $logPath" -ForegroundColor Red
        return
    }

    $regex = '^(?<IP>\S+) \S+ \S+ \[(?<Time>[^\]]+)\] "(?<Method>\S+) (?<Page>\S+) (?<Protocol>[^"]+)" (?<Response>\d{3}) \S+ "(?<Referrer>[^"]*)"'

    $logs = @()

    foreach ($line in (Get-Content $logPath)) {
        if ($line -match $regex) {
            $logs += [PSCustomObject]@{
                IP        = $matches['IP']
                Time      = $matches['Time']
                Method    = $matches['Method']
                Page      = $matches['Page']
                Protocol  = $matches['Protocol']
                Response  = $matches['Response']
                Referrer  = $matches['Referrer']
            }
        }
    }

    return $logs
}

function Get-IOCLogs {
    param(
        [Parameter(Mandatory)]
        [array]$Logs,

        [Parameter(Mandatory)]
        [array]$Indicators
    )

    $Filtered = @()

    foreach ($log in $Logs) {
        foreach ($indicator in $Indicators) {
            if ($log.Page -match [regex]::Escape($indicator)) {
                $Filtered += $log
                break
            }
        }
    }

    return $Filtered
}

# Step 1: Get all parsed logs
$Logs = Get-ApacheLogs

# Step 2: Define IOC patterns (from IOC table)
$Indicators = @(
    "etc/passwd",
    "cmd=",
    "/bin/bash",
    "/bin/sh",
    "1=1#",
    "1=1--"
)

# Step 3: Filter and display only matching IOC logs
$IOCLogs = Get-IOCLogs -Logs $Logs -Indicators $Indicators
$IOCLogs | Format-Table -AutoSize
