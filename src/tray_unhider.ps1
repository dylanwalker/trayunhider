# Useful Event IDs to trigger this script:  11707 (MSI Installer - successful installation) ; 8216 (System Restore Point created)


# Define the registry path
$registryPath = "HKCU:\Control Panel\NotifyIconSettings"

# Define the log file path
$logFilePath = "$PSScriptRoot\tray_unhider.log"

# Get all subkeys of the specified registry path
$subKeys = Get-ChildItem -Path $registryPath

# Iterate through each subkey and set the value for IsPromoted to 1
foreach ($subKey in $subKeys) {
    # Define the full path of the subkey
    $subKeyPath = $subKey.PSPath

    # Set the value for IsPromoted to 1
    #Set-ItemProperty -Path $subKeyPath -Name "IsPromoted" -Value 1
	
	# Check if the IsPromoted property exists
    $propertyValue = (Get-ItemProperty -Path $subKeyPath -Name "IsPromoted" -ErrorAction SilentlyContinue).IsPromoted
	
	# Extract the name of the executable
	$executablePath = (Get-ItemProperty -Path $subKeyPath -Name "ExecutablePath" -ErrorAction SilentlyContinue).ExecutablePath
	$exeName = Split-Path -Path $executablePath -Leaf 
	
	#Write-Host "$subKeyPath ($exeName) IsPromoted = $propertyValue" 
	
	# If the value IsPromoted does not exist or if it is not set to 1
    if ($null -eq $propertyValue -or $propertyValue -ne 1) {
        # Create or set the value for IsPromoted to 1
        New-ItemProperty -Path $subKeyPath -Name "IsPromoted" -Value 1 -PropertyType DWord -Force

        # Log the altered key path to the logfile with a newline
        Add-Content -Path $logFilePath -Value "$subKeyPath`n"
        
        # Log the altered key path to the logfile
		Add-Content -Path $logFilePath -Value "$subKeyPath ($exeName) setting IsPromoted to 1`n"
    }
}

