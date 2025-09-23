function Get-SystemStartStopEventsSimple {
    param([ValidateRange(1,365)][int]$Days = 30)

    Get-EventLog System -After (Get-Date).AddDays(-$Days) |
        Where-Object { $_.EventID -in 6005,6006 } |
        ForEach-Object {
            [pscustomobject]@{
                Time  = $_.TimeGenerated
                Id    = $_.EventID
                Event = if($_.EventID -eq 6005){"Startup"} else {"Shutdown"}
                User  = "System"
            }
        } | Sort-Object Time -Descending
}

# Interactive console prompt (optional)
$days = Read-Host "Enter number of days (1-365, default 30)"
if (-not $days) { $days = 30 }

Get-SystemStartStopEventsSimple -Days $days
