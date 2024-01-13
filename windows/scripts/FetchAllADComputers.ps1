$htmlformat = "<style>BODY{background-color:LightBlue;}</style>"

# Get all AD users
$users = Get-ADUser -Filter * -Properties "LastLogonDate"

# Create an array to store user information
$userInfo = @()

# Iterate through each user to retrieve group memberships
foreach ($user in $users) {
    $groups = Get-ADPrincipalGroupMembership $user | Select-Object -ExpandProperty Name
    $userInfo += [PSCustomObject]@{
        Name = $user.Name
        LastLogonDate = $user.LastLogonDate
        GroupMemberships = $groups -join ", "
    }
}

# Sort the user information by LastLogonDate
$userInfo = $userInfo | Sort-Object -Property LastLogonDate -Descending

# Convert the user information to HTML
$html = $userInfo | ConvertTo-HTML -Head $htmlformat -Body "<H2>AD Accounts and Their Group Memberships</H2>"

# Save the HTML to a file
$html | Out-File C:\ad_accounts.html

# Open the HTML file in the default web browser
Invoke-Expression C:\ad_accounts.html
