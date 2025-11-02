. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot String-Helper.ps1)

checkUser "NoSuchUser123"      # False
checkUser $env:USERNAME        # True
checkPassword "pass"           # False
checkPassword "Abc123!"        # True