cd C:\Users\champuser\SYS320-01\week1
$files=Get-ChildItem

$folderPath = "C:/Users/champuser/Desktop/outfolder/"
$filePath = $folderPath + "out.csv"

$files | Where-Object {$_.Name -like "*.ps1"} | Export-Csv -Path $filePath