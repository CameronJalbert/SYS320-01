$files=Get-ChildItem -Recurse -File
$files | Where-Object { $_.Extension -eq '.csv' } | Rename-Item -NewName { $_.Name -replace '.csv', '.log' }
Get-ChildItem -Recurse -File