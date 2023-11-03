# Enter a path to your import CSV file
$ADUsers = Import-csv users.csv

foreach ($User in $ADUsers) {
    $Username = $User.username
    $Password = $User.password

    # Check if the user account already exists in AD
    if (Get-ADUser -F {SamAccountName -eq $Username}) {
        # If user does exist change password
        Set-ADAccountPassword -Identity $Username -Reset `
        -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
        Write-Output "$Username password was reset"
    } else {
        # If a user does not exist then create a new user
        New-ADUser -Name $Username -Enabled $True `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force)
        Write-Output "$Username account was created"
    }
}