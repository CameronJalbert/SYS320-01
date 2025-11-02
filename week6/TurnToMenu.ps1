# ==============================================
# TurnToMenu.ps1
# ==============================================
# Author: Cameron Jalbert
# Description: Unified operations menu that reuses
# previous lab functions via dot-notation.
# ==============================================

# --- Import required modules via dot notation ---
# Week 1 - Chrome process management
. "C:\Users\champuser\SYS320-01\week1\Champlain.ps1"

# Week 3 - Apache log parsing
. "C:\Users\champuser\SYS320-01\week3\Parsing Apache Logs\Apache-Logs2.ps1"

# Week 6 - Local user management and event handling

. "C:\Users\champuser\SYS320-01\week6\Event-Logs.ps1"
. "C:\Users\champuser\SYS320-01\week6\Users.ps1"
. "C:\Users\champuser\SYS320-01\week6\String-Helper.ps1"


# --- Menu prompt text ---
$menu = @"
=======================================
   SYSTEM ADMINISTRATOR TOOLKIT MENU
=======================================
1. Display last 10 Apache logs
2. Display last 10 failed logins for all users
3. Display at-risk users
4. Start Chrome and navigate to champlain.edu
5. Exit
=======================================
"@


# --- Loop until user exits ---
while ($true) {
    Clear-Host
    Write-Host $menu
    $choice = Read-Host "Enter your choice (1-5)"

    switch ($choice) {
        1 {
            Write-Host "`n[+] Displaying last 10 Apache log entries for 10.* IPs...`n"
            try {
                $logs = Parse-ApacheLogs
                if ($logs) {
                    $logs | Select-Object -First 10 | Format-Table -AutoSize
                } else {
                    Write-Host "No Apache logs found or failed to parse."
                }
            } catch {
                Write-Host "Error running Parse-ApacheLogs: $($_.Exception.Message)"
            }
            Pause
        }

        2 {
            Write-Host "`n[+] Displaying last 10 failed logins for all users...`n"
            try {
                $failed = getFailedLogins 30  # default: last 30 days
                if ($failed) {
                    $failed | Select-Object -First 10 | Format-Table Time, User, Event, Id -AutoSize
                } else {
                    Write-Host "No failed logins found."
                }
            } catch {
                Write-Host "Error running getFailedLogins: $($_.Exception.Message)"
            }
            Pause
        }

        3 {
            Write-Host "`n[+] Displaying at-risk users (more than 10 failed logins)...`n"
            try {
                # Pull recent failed logins
                $failed = getFailedLogins 30
                $atRisk = $failed |
                    Group-Object -Property User |
                    Where-Object { $_.Count -gt 10 } |
                    Sort-Object Count -Descending |
                    ForEach-Object {
                        [PSCustomObject]@{
                            User  = $_.Name
                            Count = $_.Count
                        }
                    }

                if ($atRisk) {
                    $atRisk | Format-Table User, Count -AutoSize
                } else {
                    Write-Host "No users exceeded 10 failed logins in the last 30 days."
                }
            } catch {
                Write-Host "Error while listing at-risk users: $($_.Exception.Message)"
            }
            Pause
        }

        4 {
            Write-Host "`n[+] Checking Chrome process...`n"
            try {
                # Directly reuse Champlain.ps1 functionality
                Start-Champlain
            } catch {
                Write-Host "Error running Chrome process script: $($_.Exception.Message)"
            }
            Pause
        }

        5 {
            Write-Host "`nExiting program. Goodbye!"
            return
        }

        default {
            Write-Host "`n[!] Invalid input. Please enter a number between 1 and 5."
            Pause
        }
    }
}
