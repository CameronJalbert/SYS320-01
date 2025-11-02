# Get only logs that contain 404 (Not Found)
$notfounds = Get-Content C:\xampp\apache\logs\access.log | findstr "404"

# Define a regex for IP addresses
$regex = [regex] "\b\d{1,3}(\.\d{1,3}){3}\b"

# Get only the IP matches from the 404 logs
$ipsUnorganized = $regex.Matches($notfounds)

# Put IPs into a PowerShell object
$ips = @()
for ($i = 0; $i -lt $ipsUnorganized.Count; $i++) {
    $ips += [PSCustomObject]@{ IP = $ipsUnorganized[$i].Value }
}

# Filter IPs to show only local 10.x.x.x
$ipsoftens = $ips | Where-Object { $_.IP -ilike "10.*" }

# Count occurrences of each IP
$counts = $ipsoftens | Group-Object -Property IP

# Display final counts (IP + how many times it appeared)
$counts | Select-Object Count, Name