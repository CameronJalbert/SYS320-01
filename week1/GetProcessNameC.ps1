$par = Get-Process | Where-Object { $_.Name -ilike "C*" }


Write-Host ($par | Format-Table | Out-String )




 