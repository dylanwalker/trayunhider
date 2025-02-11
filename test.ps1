# Define the path to your log file
$logFilePath = $logFilePath = $PSCommandPath -replace '\.ps1$', '.log'

# Get the current date and time
$currentDateTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

# Format the date and time if needed (optional)
#$formattedDateTime = $currentDateTime.ToString("yyyy-MM-dd HH:mm:ss")

# Append the date and time to the log file
$currentUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$scriptFileName = [System.IO.Path]::GetFileName($PSCommandPath)
$logFile = "$ENV:APPDATA\TrayUnhider\$scriptFileName" -replace '\.ps1$', '.log'
#Add-Content -Path $logFilePath -Value "$currentDateTime`tProgram Run by $currentUsername"
#Add-Content -Path $logFilePath -Value "$currentDateTime`tProgram Finished"
Add-Content -Path $logFilePath -Value "$logFile"

