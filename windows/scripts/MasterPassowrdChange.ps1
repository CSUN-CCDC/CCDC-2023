# Prompt the user to enter the OU distinguished name
$ouDN = Read-Host "Enter the distinguished name of the OU (e.g., 'OU=Users,DC=contoso,DC=com')"

# Prompt the user for the number of characters for the random password
$passwordLength = Read-Host "Enter the length of the random password"

# Get a list of user accounts in the specified OU
$users = Get-ADUser -Filter * -SearchBase $ouDN

# Initialize an array to store the results
$results = @()

# Loop through each user in the OU
foreach ($user in $users) {
    # Generate a random password
    $newPassword = -join ((33..126) | Get-Random -Count $passwordLength | ForEach-Object { [char]$_ })

    try {
        # Convert the password to a SecureString
        $secureNewPassword = ConvertTo-SecureString -String $newPassword -AsPlainText -Force

        # Set the user's password
        Set-ADAccountPassword -Identity $user -NewPassword $secureNewPassword -Reset
        $changePasswordStatus = "Success"
    } catch {
        $changePasswordStatus = "Failed: $($_.Exception.Message)"
    }

    # Create an object with user details and change password status
    $userObject = [PSCustomObject]@{
        'User' = $user.SamAccountName
        'OU' = $ouDN
        'NewPassword' = $newPassword
        'ChangePasswordStatus' = $changePasswordStatus
    }

    # Add the user object to the results array
    $results += $userObject
}

# Export the results to a CSV file in C:\
$results | Export-Csv -Path "C:\password_change_results.csv" -NoTypeInformation

Write-Host "Password change results exported to C:\password_change_results.csv"
