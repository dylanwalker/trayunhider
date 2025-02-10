# TrayUnhider


TrayUnhider is a utility to keep Windows 11 system tray icons *unhidden*, because I got sick of turning On new system trays in the Taskbar menu whenever an App updated or I installed something new. 

### How to Install

Just download the executable installer from the release page and run it.  


### Or if you'd rather install manually
The installation consists of ensuring you have the required prerequisites, copying some files and creating a scheduled task to run the unhide script on different trigger event (startup, new app installed with MSI installer).

0) Requirements:

 	a) Ensure that you can run powershell scripts


1) Copy all files from `.\src` into `%programfiles(x86)%\TrayUnhider`

2) Create a new task in Task Scheduler with the following:

- Trigger 1

	- At logon of any user

- Trigger 2

	- On Event Log:Application, Event ID: 11707

- Action

	- Program/Script:
		- `cmd`
	- Arguments:
		```
		/c start /min "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Program Files (x86)\TrayUnhider\tray_unhider.ps1"
		```
				
- For the task General->Security opions:

	- When running the task use the following user account:
		- `<your user account>`
	- Run with the highest priveleges
	
### How it works

I use a powershell script `tray_unhider.ps1` to read through the registry for apps with system tray (i.e., all subkeys of `HKCU:\Control Panel\NotifyIconSettings`). 
If an subkey doesn't have the value `IsPromoted=1` then I create that value and log it in `tray_unhider.log`. 
There are some solutions out there that are similar, but they are compiled (rather than a transparent powershell script) and do this on a loop with a time delay within the code. 
In contrast, my script runs through the subkeys of the registry once and I use windows task schedule to trigger it. 