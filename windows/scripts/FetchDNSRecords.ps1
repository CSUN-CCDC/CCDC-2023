$htmlformat = "<style>BODY{background-color:LightBlue;}</style>"

# Prompt the user for the DNS zone
$DnsZone = Read-Host "Enter the DNS Zone (e.g., AnimeVerse.life)"

# Prompt the user for the DNS server
$DnsServer = Read-Host "Enter the DNS Server Name or IP Address"

# Get all DNS records in the specified DNS zone on the specified DNS server
$DnsRecords = Get-DnsServerResourceRecord -ZoneName $DnsZone -ComputerName $DnsServer

# Filter and sort DNS records alphabetically by RecordType
$FilteredDnsRecords = $DnsRecords | Sort-Object RecordType

# Convert the filtered and sorted DNS records to an HTML table
$DnsRecordsTable = $FilteredDnsRecords | Select-Object ZoneName, HostName, RecordType, RecordData, TimeStamp | ConvertTo-HTML -Head $htmlformat -Body "<H2>DNS Records</H2>"

# Save the HTML table to a file
$HtmlFilePath = "C:\dnsrecords.html"
$DnsRecordsTable | Out-File -FilePath $HtmlFilePath

# Open the HTML file in the default web browser
Invoke-Item -Path $HtmlFilePath
