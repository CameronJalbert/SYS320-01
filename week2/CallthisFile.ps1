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