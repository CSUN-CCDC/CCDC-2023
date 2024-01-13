$htmlformat = "<style>BODY{background-color: LightBlue;}</style>"

# Retrieve all Group Policies and their configurations
$GPOs = Get-GPO -All

# Create an HTML table to display the GPO information
$htmlTable = $GPOs | Select-Object DisplayName, Id, Description, CreationTime, ModificationTime | ConvertTo-Html -Head $htmlformat -Body "<H2>Group Policies and Configurations</H2>"

# Save the HTML table to a file
$htmlTable | Out-File C:\GroupPolicies.html

# Open the HTML file in the default web browser
Invoke-Expression C:\GroupPolicies.html
