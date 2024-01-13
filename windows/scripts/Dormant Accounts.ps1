## Dormant Accounts ##
$InactiveDate = (Get-Date).Adddays(-30)
$HTML=@"
<title>Dormant Accounts Report</title>
<style>
BODY{background-color :LightBlue}
</style>
"@
$disabledaccounts = Get-ADUser -Filter {Enabled -eq $false} | select samAccountName,GivenName,Surname | ConvertTo-Html -Property "samAccountName","GivenName","Surname" -Fragment -PreContent "<h2>Disabled Account</h2>"
$inactiveaccounts = Get-ADUser -Filter {LastLogonDate -lt $InactiveDate -and Enabled -eq $true} -Properties LastLogonDate | select samAccountName,GivenName,Surname,LastLogonDate | ConvertTo-Html -Property "samAccountName","GivenName","Surname","LastLogonDate" -Fragment -PreContent "<h2>Inactive Accounts</h2>"
$Reportvalues = ConvertTo-HTML -Body "$disabledaccounts $inactiveaccounts" -Head $HTML
$Reportvalues | Out-File "C:\dormantusers.html"