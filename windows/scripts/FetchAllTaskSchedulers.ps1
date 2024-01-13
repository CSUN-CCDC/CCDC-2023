$htmlformat = "<style>BODY{background-color:LightBlue;}</style>"

# Get a list of all Task Scheduler tasks
$ScheduledTasks = Get-ScheduledTask

# Create an array to store task information
$TaskInfo = @()

# Iterate through each scheduled task
foreach ($task in $ScheduledTasks) {
    $TaskName = $task.TaskName

    $TaskInfo += [PSCustomObject]@{
        Name = $TaskName
    }
}

# Convert the task information to HTML
$TasksHTML = $TaskInfo | ConvertTo-HTML -Head $htmlformat -Body "<H2>Scheduled Tasks</H2>"

# Save the HTML to a file
$HtmlFilePath = "C:\scheduled_tasks.html"
$TasksHTML | Out-File -FilePath $HtmlFilePath

# Open the HTML file in the default web browser
Invoke-Item -Path $HtmlFilePath
