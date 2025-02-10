param (
    [string]$PathToTrayUnhiderScript,
    [string]$UserName
)

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
