$htmlformat = "<style>BODY{background-color:LightBlue;}</style>"

# Get a list of all services
$Services = Get-Service

# Create an array to store service information
$ServiceInfo = @()

# Iterate through each service
foreach ($service in $Services) {
    $ServiceName = $service.Name
    $DisplayName = $service.DisplayName
    $Status = $service.Status

    $ServiceInfo += [PSCustomObject]@{
        Name = $ServiceName
        DisplayName = $DisplayName
        Status = $Status
    }
}

# Convert the service information to HTML
$ServicesHTML = $ServiceInfo | ConvertTo-HTML -Head $htmlformat -Body "<H2>Services</H2>"

# Save the HTML to a file
$HtmlFilePath = "C:\services.html"
$ServicesHTML | Out-File -FilePath $HtmlFilePath

# Open the HTML file in the default web browser
Invoke-Item -Path $HtmlFilePath