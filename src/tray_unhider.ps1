# Useful Event IDs to trigger this script:  11707 (MSI Installer - successful installation) ; 8216 (System Restore Point created)


# Define the registry path
$registryPath = "HKCU:\Control Panel\NotifyIconSettings"

# Define the log file path
$scriptFileName = [System.IO.Path]::GetFileName($PSCommandPath)
$logFile = "$ENV:APPDATA\TrayUnhider\$scriptFileName" -replace '\.ps1$', '.log'

$currentUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Get all subkeys of the specified registry path
$subKeys = Get-ChildItem -Path $registryPath

# Log that the program was called
$currentDateTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
Add-Content -Path $logFile -Value "$currentDateTime`t$PSCommandPath run by $currentUsername"

# Iterate through each subkey and set the value for IsPromoted to 1
foreach ($subKey in $subKeys) {
    # Define the full path of the subkey
    $subKeyPath = $subKey.PSPath
	
    # Check if the IsPromoted property exists
    $propertyValue = (Get-ItemProperty -Path $subKeyPath -Name "IsPromoted" -ErrorAction SilentlyContinue).IsPromoted
	
	# Extract the name of the executable
	$executablePath = (Get-ItemProperty -Path $subKeyPath -Name "ExecutablePath" -ErrorAction SilentlyContinue).ExecutablePath
	$exeName = Split-Path -Path $executablePath -Leaf 
	
	# If the value IsPromoted does not exist or if it is not set to 1
    if ($null -eq $propertyValue -or $propertyValue -ne 1) {
        # Create or set the value for IsPromoted to 1
        New-ItemProperty -Path $subKeyPath -Name "IsPromoted" -Value 1 -PropertyType DWord -Force
        
        # Log the altered key path to the logfile
		$currentDateTime = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Add-Content -Path $logFile -Value "$currentDateTime`tSetting IsPromoted=1 for ($exeName) $subKeyPath"
    }
}

