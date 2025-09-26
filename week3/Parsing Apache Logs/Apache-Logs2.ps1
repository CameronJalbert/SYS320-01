function Parse-ApacheLogs {
    # Path to Apache access log
    $logPath = "C:\xampp\apache\logs\access.log"

    # Read all log lines
    $logsNotFormatted = Get-Content $logPath
    $tableRecords = @()

    # Loop through each line
    for ($i = 0; $i -lt $logsNotFormatted.Count; $i++) {
        $words = $logsNotFormatted[$i] -split " "

        # Build PSCustomObject for each line
        $tableRecords += [PSCustomObject]@{
            IP       = $words[0]
            Time     = $words[3].Trim("[") + " " + $words[4].Trim("]")
            Method   = $words[5].Trim('"')
            Page     = $words[6]
            Protocol = $words[7].Trim('"')
            Response = $words[8]
            Referrer = if ($words.Count -ge 11) { $words[10].Trim('"') } else { "-" }
        }
    }

    # Filter for 10.* IPs
    return $tableRecords | Where-Object { $_.IP -like "10.*" }
}