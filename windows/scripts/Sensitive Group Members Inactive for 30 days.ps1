## Sensitive Group Members Inactive for 30 days ##
$30Days = (get-date).adddays(-30)
$HTML=@"
<title>Sensitive Groups Memebrship Report : USers Inactive for 30 days</title>
<style>
BODY{background-color :LightBlue}
</style>
"@
$enterpiseadmins = Get-ADGroupMember -Identity "Enterprise Admins" | where {$_.objectclass -eq 'user'} | Get-ADUser -Properties LastLogonDate |Where {$_.LastLogonDate -le $30Days}| select Name,LastLogonDate | ConvertTo-Html -Property "Name","LastLogonDate" -Fragment -PreContent "<h2>Enterprise Admins</h2>"
$schemaadmins = Get-ADGroupMember -Identity "Schema Admins" | where {$_.objectclass -eq 'user'} | Get-ADUser -Properties LastLogonDate | Where {$_.LastLogonDate -le $30Days}| select Name,LastLogonDate | ConvertTo-Html -Property "Name","LastLogonDate" -Fragment -PreContent "<h2>Schema Admins</h2>"
$domainadmins = Get-ADGroupMember -Identity "Domain Admins" | where {$_.objectclass -eq 'user'} | Get-ADUser -Properties LastLogonDate | Where {$_.LastLogonDate -le $30Days}| select Name,LastLogonDate | ConvertTo-Html -Property "Name","LastLogonDate" -Fragment -PreContent "<h2>Domain Admins</h2>" 
$accountoperators = Get-ADGroupMember -Identity "Account Operators" | where {$_.objectclass -eq 'user'} | Get-ADUser -Properties LastLogonDate | Where {$_.LastLogonDate -le $30Days}| select Name,LastLogonDate | ConvertTo-Html -Property "Name","LastLogonDate" -Fragment -PreContent "<h2>Account Operators</h2>" 
$serveroperators = Get-ADGroupMember -Identity "Server Operators" | where {$_.objectclass -eq 'user'} | Get-ADUser -Properties LastLogonDate | Where {$_.LastLogonDate -le $30Days}| select Name,LastLogonDate | ConvertTo-Html -Property "Name","LastLogonDate" -Fragment -PreContent "<h2>Server Operators</h2>"
$printoperators = Get-ADGroupMember -Identity "Print Operators" | where {$_.objectclass -eq 'user'} | Get-ADUser -Properties LastLogonDate | Where {$_.LastLogonDate -le $30Days}| select Name,LastLogonDate | ConvertTo-Html -Property "Name","LastLogonDate" -Fragment -PreContent "<h2>Print Operators</h2>"
$dnsadmins = Get-ADGroupMember -Identity "DnsAdmins" | where {$_.objectclass -eq 'user'} | Get-ADUser -Properties LastLogonDate | Where {$_.LastLogonDate -le $30Days}| select Name,LastLogonDate | ConvertTo-Html -Property "Name","LastLogonDate" -Fragment -PreContent "<h2>DNS Admins</h2>"
$Reportvalues = ConvertTo-HTML -Body "$enterpiseadmins $schemaadmins $domainadmins $accountoperators $serveroperators $printoperators $dnsadmins" -Head $HTML
$Reportvalues | Out-File "C:\inactiveusers.html"