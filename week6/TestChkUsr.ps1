
. (Join-Path $PSScriptRoot Users.ps1)   # dot-source to load functions

checkUser "NoSuchUser123"     # should return False
checkUser $env:USERNAME       # should return True (local user)
