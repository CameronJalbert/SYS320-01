. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Exit`n"
$Prompt += "10 - List At-Risk Users`n"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 9){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    
    }

    # Create a user
    elseif($choice -eq 3){ 

        $name = Read-Host -Prompt "Please enter the username for the new user"
        
    

        # Create a function called checkUser in Users that: 
        # - Checks if user a exists. 
        # - If user exists, returns true, else returns false

        # Check the given username with your new function.
        # - If false is returned, continue with the rest of the function
        # - If true is returned, do not continue and inform the user
        #vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

        # ---- Username existence guard ----
        if (checkUser $name) {
            Write-Host "User '$name' already exists. Choose a different username."
        }

        else {
        # Only ask for password when username is available
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"
                # Password validation
        if (-not (checkPassword $password)) {
            Write-Host "Password must be 6+ chars and include a letter, a number, and a special character."
        }
        else {
       
              createAUser $name $password

              Write-Host "User: $name is created." | Out-String
       
          }
        }  
        #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        # TODO: Create a function called checkPassword in String-Helper that:
        #              - Checks if the given string is at least 6 characters
        #              - Checks if the given string contains at least 1 special character, 1 number, and 1 letter
        #              - If the given string does not satisfy conditions, returns false
        #              - If the given string satisfy the conditions, returns true
        # TODO: Check the given password with your new function. 
        #              - If false is returned, do not continue and inform the user
        #              - If true is returned, continue with the rest of the function

       
        
    

}


    # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"

        # TODO: Check the given username with the checkUser function.
        #vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    if (-not (checkUser $name)) {
        Write-Host "User '$name' does not exist."
    }
    else {

        removeAUser $name

        Write-Host "User: $name Removed." | Out-String
    }

}
    # Enable a user
    elseif($choice -eq 5){


        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        # TODO: Check the given username with the checkUser function.
        #vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

    if (-not (checkUser $name)) {
        Write-Host "User '$name' does not exist."
    }
    else {
        $u = Get-LocalUser -Name $name
        if ($u.Enabled) { Write-Host "User '$name' is already enabled." }
        else { enableAUser $name; Write-Host "User '$name' enabled." }
    }
}


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        # TODO: Check the given username with the checkUser function.
        #vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

    if (-not (checkUser $name)) {
        Write-Host "User '$name' does not exist."
    }
    else {
        $u = Get-LocalUser -Name $name
        if (-not $u.Enabled) { Write-Host "User '$name' is already disabled." }
        else { disableAUser $name; Write-Host "User '$name' disabled." }
    }
}


elseif ($choice -eq 7) {

    $name = Read-Host -Prompt "Please enter the username for the user logs"

    # Check the given username with the checkUser function.
    if (-not (checkUser $name)) {
        Write-Host "User '$name' does not exist."
    }
    else {
        # Ask days from the user (replace the hard-coded 90)
        $daysText = Read-Host -Prompt "How many days back? (e.g., 30)"
        [int]$days = 0
        if (-not [int]::TryParse($daysText, [ref]$days) -or $days -lt 0) {
            Write-Host "Please enter a non-negative whole number of days."
        }
        else {
            $userLogins = getLogInAndOffs $days

            # Filter to the username and print as a table 
            Write-Host (
                $userLogins |
                    Where-Object { $_.User -ilike "*$name" } |
                    Format-Table Time, Id, Event, User -AutoSize |
                    Out-String
            )
        }
    }
}



elseif ($choice -eq 8) {

    $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"

    # Check the given username with the checkUser function.
    if (-not (checkUser $name)) {
        Write-Host "User '$name' does not exist."
    }
    else {
        # Ask days from the user (replace the hard-coded 90)
        $daysText = Read-Host -Prompt "How many days back? (e.g., 30)"
        [int]$days = 0
        if (-not [int]::TryParse($daysText, [ref]$days) -or $days -lt 0) {
            Write-Host "Please enter a non-negative whole number of days."
        }
        else {
            $userLogins = getFailedLogins $days

            # Filter by full DOMAIN\user or just the tail 'user'
            Write-Host (
                $userLogins |
                    Where-Object { $_.User -ieq $name -or $_.User -ilike "*\$name" } |
                    Format-Table Time, Id, Event, User -AutoSize |
                    Out-String
            )
        }
    }
}


    # TODO: Create another choice "List at Risk Users" that
    #              - Lists all the users with more than 10 failed logins in the last <User Given> days.  
    #                (You might need to create some failed logins to test)
    #              - Do not forget to update prompt and option numbers

elseif ($choice -eq 10) {

    # Ask lookback window
    $daysText = Read-Host -Prompt "Count failed logins in how many days? (e.g., 30)"
    [int]$days = 0
    if (-not [int]::TryParse($daysText, [ref]$days) -or $days -lt 0) {
        Write-Host "Please enter a non-negative whole number of days."
    }
    else {
        # Ask threshold (default 10 if blank)
        $threshText = Read-Host -Prompt "Minimum failures to flag as at-risk? (default: 10)"
        if ([string]::IsNullOrWhiteSpace($threshText)) { $thresh = 10 }
        elseif (-not [int]::TryParse($threshText, [ref]([ref]$th = 0).Value)) {
            # TryParse trick above is ugly; simpler:
            [int]$thresh = 0
            if (-not [int]::TryParse($threshText, [ref]$thresh) -or $thresh -lt 1) {
                Write-Host "Please enter a whole number ≥ 1."
                return
            }
        } else { [int]$thresh = [int]$threshText }

        # Pull 4625s, group by user, filter by threshold
        $fails = getFailedLogins $days

        $atRisk =
            $fails |
            Group-Object -Property User |
            Where-Object { $_.Count -gt $thresh } |
            Sort-Object Count -Descending |
            ForEach-Object {
                [pscustomobject]@{
                    User  = $_.Name
                    Count = $_.Count
                }
            }

        if (-not $atRisk -or $atRisk.Count -eq 0) {
            Write-Host "No users exceeded $thresh failed logins in the last $days day(s)."
        }
        else {
            Write-Host (
                $atRisk |
                    Format-Table User, Count -AutoSize |
                    Out-String
            )
        }
    }
}
    
    # TODO: If user enters anything other than listed choices, e.g. a number that is not in the menu   
    #       or a character that should not be accepted. Give a proper message to the user and prompt again.
    else {
    Write-Host "Invalid choice. Please enter a number from the menu."
}

}




