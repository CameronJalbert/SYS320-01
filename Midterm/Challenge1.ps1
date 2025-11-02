# ===================================================================
# Script Name: Challenge1.ps1
# Author: Cameron Jalbert
# Course: SYS320-01 | Midterm Challenge 1
# Description: 
#   Retrieves Indicators of Compromise (IOCs) from a specified webpage
#   and displays the results in a formatted PowerShell table.
# ===================================================================

function Get-IOC {

    # Define URL of IOC page
    $url = "http://10.0.17.47/IOC.html"

    # Retrieve HTML content
    $response = Invoke-WebRequest -Uri $url

    # Parse table rows using PowerShell's automatic .Links and .ParsedHtml fallback
    $html = $response.Content

    # Use regex to extract table rows manually
    $pattern = '<tr>\s*<td>(.*?)<\/td>\s*<td>(.*?)<\/td>\s*<\/tr>'
    $matches = [regex]::Matches($html, $pattern)

    $IOCList = @()

    foreach ($match in $matches) {
        $IOCList += [PSCustomObject]@{
            Pattern     = $match.Groups[1].Value.Trim()
            Explanation = $match.Groups[2].Value.Trim()
        }
    }

    # Output formatted table
    $IOCList | Format-Table -AutoSize
}

# Execute the function
Get-IOC
