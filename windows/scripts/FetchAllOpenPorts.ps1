$htmlformat = "<style>BODY{background-color:LightBlue;}</style>"

# Ask the user for the target IP or hostname
$Target = Read-Host "Enter the target IP address or hostname"

# Run Nmap to scan open ports
$NmapOutput = nmap $Target

# Convert Nmap output to HTML
$NmapHTML = $NmapOutput | ConvertTo-HTML -Head $htmlformat -Body "<H2>Open Ports</H2>"

# Save the Nmap results to an HTML file
$NmapHtmlFilePath = "C:\open_ports.html"
$NmapHTML | Out-File -FilePath $NmapHtmlFilePath

# Open the HTML file in the default web browser
Invoke-Item -Path $NmapHtmlFilePath
