cd C:\Users\champuser\SYS320-01\week1

$files=Get-ChildItem
for ($j=0; $j -le $files.Count; $j++){
    if ($files[$j].Name -ilike "*.ps1"){
        Write-Host $files[$j].Name
    }
}