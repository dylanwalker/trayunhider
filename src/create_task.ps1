param (
    [string]$PathToTrayUnhiderScript,
    [string]$UserName
)

# Define the log file path
$scriptFileName = [System.IO.Path]::GetFileName($PSCommandPath)
$logFile = "$ENV:APPDATA\TrayUnhider\$scriptFileName" -replace '\.ps1$', '.log'

$currentUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Log that the program was run
$currentDateTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
Add-Content -Path $logFile -Value "$currentDateTime`t$PSCommandPath run by $currentUsername"

$action = New-ScheduledTaskAction -Execute "cmd" -Argument "/C start /min """" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File ""$PathToTrayUnhiderScript"""
$trigger1 = New-ScheduledTaskTrigger -AtLogon
$CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger
$trigger2 = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
#$trigger2 = New-ScheduledTaskTrigger
$trigger2.Subscription = 
@"
<QueryList><Query Id="0" Path="Application"><Select Path="Application">*[System[EventID=11707]]</Select></Query></QueryList>
"@

$principal = New-ScheduledTaskPrincipal -UserId "$UserName" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName "TrayUnhider" -Action $action -Trigger $trigger1, $trigger2 -Principal $principal -Settings $settings
