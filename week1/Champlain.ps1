$par = Get-Process | Where-Object { $_.ProcessName -eq "chrome" }

if ($par) {
    Get-Process | Where-Object { $_.ProcessName -eq "chrome" } | Stop-Process -Force
    Write-Host "Chrome was running and has been stopped."
} else {
    Start-Process "chrome.exe" "https://www.champlain.edu"
    Write-Host "Chrome was not running. Started Chrome and navigated to Champlain.edu"
}