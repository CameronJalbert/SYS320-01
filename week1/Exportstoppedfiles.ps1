$par = Get-Service | Where-Object { $_.Status -ilike "Stopped" } | Sort-Object Name | Export-Csv -Path "C:\Users\champuser\SYS320-01\week1\StoppedServices.csv" | Format-Table

Write-Host ( $par )