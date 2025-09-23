function Get-WinLogonEventsSimple {
    param([ValidateRange(1,365)][int]$Days = 30)

    Get-EventLog System -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$Days) |
        Where-Object { $_.InstanceId -in 7001,7002 } |
        ForEach-Object {
            [pscustomobject]@{
                Time  = $_.TimeGenerated
                Id    = $_.InstanceId
                Event = if($_.InstanceId -eq 7001){"Logon"} else {"Logoff"}
                User  = try {
                            (New-Object System.Security.Principal.SecurityIdentifier($_.ReplacementStrings[1])).
                            Translate([System.Security.Principal.NTAccount]).Value
                        } catch { $_.ReplacementStrings[1] }
            }
        } | Sort-Object Time -Descending
}

# Interactive console prompt (optional)
$days = Read-Host "Enter number of days (1-365, default 30)"
if (-not $days) { $days = 30 }

Get-WinLogonEventsSimple -Days $days
