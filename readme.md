# TrayUnhider


TrayUnhider is a utility to keep Windows 11 system tray icons *unhidden*, because I got sick of turning On new system trays in the Taskbar menu whenever an App updated or I installed something new. 

### How to Install

Just download the executable installer from the release page and run it.  


### Or if you'd rather install manually
The installation consists of ensuring you have the required prerequisites, copying some files and creating a scheduled task to run the unhide script on different trigger event (startup, new app installed with MSI installer).

0) Ensure that you can run powershell scripts

1) Copy all files from `.\src` into  `<install location>` (e.g., `%programfiles(x86)%\TrayUnhider`)

2) Create the folder `%APPDATA%\TrayUnhider` (this is used to store log files).

3) From the install location, run:  `powershell.exe  -ExecutionPolicy Bypass -File .\create_task.ps1 -PathToTrayUnhiderScript <install location> -UserName <windows username>`. Note: `<windows username>` should include your PC Name, e.g., `COMPUTERNAME\username`
	
### How it works

I use a powershell script `tray_unhider.ps1` to read through the registry for apps with system tray (i.e., all subkeys of `HKCU:\Control Panel\NotifyIconSettings`). 
If an subkey doesn't have the value `IsPromoted=1` then I create that value and log it in `%APPDATA%\TrayUnhider\tray_unhider.log`. 
There are some solutions out there that are similar, but they are compiled (rather than a transparent powershell script) and do this on a loop with a time delay within the code. 
In contrast, my script runs through the subkeys of the registry once and I use windows task schedule to trigger it. 