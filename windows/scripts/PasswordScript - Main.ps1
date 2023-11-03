Start-Process Powershell.exe -verb runas

Import-Module ActiveDirectory

Get-ADUser -Filter * -Properties * | Select-Object SamAccountName | Out-File -FilePath "C:\scripts\users.txt"

$users = Get-Content C:\scripts\users.txt

$outputPath = "C:\passwords.csv"

$results = foreach ($user in $users) {

    $Password = -join ((33..126) | Get-Random -Count 8 | ForEach-Object { [char]$_ })

    $NewPwd = ConvertTo-SecureString $Password -AsPlainText -Force

    Set-ADAccountPassword $user -NewPassword $NewPwd -Reset

    Set-ADUser -Identity $user -ChangePasswordAtLogon $true

    $passphrase = $Password -join "-"
    Write-Host "$user": "$passphrase"

    [PSCustomObject]@{
        User = $user
        Password = $passphrase
    }
}

if (Test-Path $outputPath) {
    $results | Export-Csv -Path $outputPath -NoTypeInformation -Append
} else {
    $results | Export-Csv -Path $outputPath -NoTypeInformation
}
