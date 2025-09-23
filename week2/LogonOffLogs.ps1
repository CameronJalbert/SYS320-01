$logonouts = Get-EventLog System -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-30) # This value can be changed

$logonoutsTable = @()  
for($i = 0; $i -lt $logonouts.Count; $i++){
    $event = ""
    if($logonouts[$i].InstanceId -eq 7001){ $event = "Logon" }
   
    if($logonouts[$i].InstanceId -eq 7002){ $event = "Logoff" }

    $sid = $logonouts[$i].ReplacementStrings[1]
    $user = $sid
    try {
        $sidObj = New-Object System.Security.Principal.SecurityIdentifier($sid)
        $user = $sidObj.Translate([System.Security.Principal.NTAccount]).Value
    } catch { }
    $logonoutsTable += [pscustomobject]@{
        "Time"  = $logonouts[$i].TimeGenerated
        "Id"    = $logonouts[$i].InstanceId
        "Event" = $event
        "User"  = $user
    }
}

$logonoutsTable