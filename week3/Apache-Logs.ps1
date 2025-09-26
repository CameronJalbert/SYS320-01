function Get-ApacheLogIPs {
    param (
        [string]$Page,
        [string]$HttpCode
    )

    # Path to Apache access log
    $logPath = "C:\xampp\apache\logs\access.log"

    # Filter logs by page and HTTP code
    $filteredLogs = Get-Content $logPath | Where-Object {
        ($_ -match $Page) -and ($_ -match $HttpCode)
    }


    # Regex for IP extraction
    $regex = [regex] "\b\d{1,3}(\.\d{1,3}){3}\b"

    # Extract IPs from filtered logs
    $ipsUnorganized = $regex.Matches($filteredLogs)

    # Store as objects with both IP and HTTP Code
    $ips = @()
    for ($i = 0; $i -lt $ipsUnorganized.Count; $i++) {
        $ips += [PSCustomObject]@{
            IP       = $ipsUnorganized[$i].Value
            HttpCode = $HttpCode
        }
    }

    # Count occurrences of each IP
    $counts = $ips | Group-Object -Property IP

    # Output: Count, IP, and HttpCode
    return $counts | ForEach-Object {
        [PSCustomObject]@{
            Count    = $_.Count
            IP       = $_.Name
            HttpCode = $HttpCode
        }
    }
}
