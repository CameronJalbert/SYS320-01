#Finds specific logs accross multiple files
$A = Get-Content C:\xampp\apache\logs\*.log | Where-Object { $_ -match "error" }
$A | Select-Object -Last 5
