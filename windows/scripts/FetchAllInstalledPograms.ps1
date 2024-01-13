$htmlformat = "<style>BODY{background-color:LightBlue;}</style>"

# Get a list of all installed programs
$InstalledPrograms = Get-WmiObject -Class Win32_Product

# Create an array to store program information
$ProgramInfo = @()

# Iterate through each installed program
foreach ($program in $InstalledPrograms) {
    $ProgramName = $program.Name
    $ProgramVersion = $program.Version
    $ProgramPublisher = $program.Vendor

    # Determine if the program is digitally signed
    $SignedStatus = "Not Signed"
    $signature = Get-AuthenticodeSignature $program.LocalPackage
    if ($signature.Status -eq 'Valid') {
        $SignedStatus = "Signed"
    }

    $ProgramInfo += [PSCustomObject]@{
        Name = $ProgramName
        Version = $ProgramVersion
        Publisher = $ProgramPublisher
        Signed = $SignedStatus
    }
}

# Convert the program information to HTML
$ProgramsHTML = $ProgramInfo | ConvertTo-HTML -Head $htmlformat -Body "<H2>Installed Programs and Signature Status</H2>"

# Save the HTML to a file
$HtmlFilePath = "C:\installed_programs.html"
$ProgramsHTML | Out-File -FilePath $HtmlFilePath

# Open the HTML file in the default web browser
Invoke-Item -Path $HtmlFilePath
