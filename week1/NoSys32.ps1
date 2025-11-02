$par = Get-Process | Where-Object { $_.Path -cnotlike "system32" }

Write-Host ($par | Format-Table | Out-String )