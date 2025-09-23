$par = (Get-NetIpAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -ilike "Ethernet" }).IPAddress

Write-Host ($par | Format-Table | Out-String)