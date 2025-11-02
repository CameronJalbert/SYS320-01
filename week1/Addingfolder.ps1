$folderpath="C:\Users\champuser\Desktop\outfolder"
if (Test-Path $folderpath){
    Write-Host "Folder Already Exists"
}
else{
    New-Item -ItemType Directory -Path $folderpath
}