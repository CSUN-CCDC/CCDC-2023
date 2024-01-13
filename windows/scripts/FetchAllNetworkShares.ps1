$htmlformat = "<style>BODY{background-color:LightBlue;}</style>"

# Get a list of all network shares
$NetworkShares = Get-WmiObject -Query "SELECT * FROM Win32_Share"

# Create an array to store share information
$ShareInfo = @()

# Iterate through each network share
foreach ($share in $NetworkShares) {
    $ShareName = $share.Name
    $SharePath = $share.Path
    $ShareType = $share.Type

    $ShareInfo += [PSCustomObject]@{
        Name = $ShareName
        Path = $SharePath
        Type = $ShareType
    }
}

# Convert the share information to HTML
$SharesHTML = $ShareInfo | ConvertTo-HTML -Head $htmlformat -Body "<H2>Network Shares</H2>"

# Save the HTML to a file
$HtmlFilePath = "C:\network_shares.html"
$SharesHTML | Out-File -FilePath $HtmlFilePath

# Open the HTML file in the default web browser
Invoke-Item -Path $HtmlFilePath
