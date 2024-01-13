$htmlformat = "<style>BODY{background-color:LightBlue;}</style>"

# Get a list of all running .exe processes
$RunningProcesses = Get-Process | Where-Object { $_.Path -match '\.exe$' }

# Create an array to store process information
$ProcessInfo = @()

# Iterate through each running .exe process
foreach ($process in $RunningProcesses) {
    $ProcessName = $process.ProcessName
    $ExecutablePath = $process.Path

    $ProcessInfo += [PSCustomObject]@{
        Name = $ProcessName
        Path = $ExecutablePath
    }
}

# Convert the process information to HTML
$ProcessesHTML = $ProcessInfo | ConvertTo-HTML -Head $htmlformat -Body "<H2>Running .exe Processes</H2>"

# Save the HTML to a file
$HtmlFilePath = "C:\running_processes.html"
$ProcessesHTML | Out-File -FilePath $HtmlFilePath

# Open the HTML file in the default web browser
Invoke-Item -Path $HtmlFilePath
