<# String-Helper
*************************************************************
   This script contains functions that help with String/Match/Search
   operations. 
************************************************************* 
#>


<# ******************************************************
   Functions: Get Matching Lines
   Input:   1) Text with multiple lines  
            2) Keyword
   Output:  1) Array of lines that contain the keyword
********************************************************* #>
function getMatchingLines($contents, $lookline){

$allines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
 
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }

}

return $allines
}


<# ******************************************************
   Function: checkPassword
   Input :  $pw (SecureString or String)
   Output:  [bool] — true if:
            - length >= 6
            - contains >=1 letter, >=1 number, >=1 special char
********************************************************* #>
function checkPassword($pw) {
    # Normalize to plain string (only for validation)
    $s = $null
    if ($pw -is [System.Security.SecureString]) {
        $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)
        try { $s = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
        finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
    } else {
        $s = [string]$pw
    }

    if ([string]::IsNullOrWhiteSpace($s)) { return $false }

    # at least 6, at least one letter, one digit, one non-alnum
    $ok = $s -match '^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{6,}$'
    return [bool]$ok
}
