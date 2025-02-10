#define MyAppVersion "1.0.0";

[Setup]
AppName=TrayUnhider
AppVersion={#MyAppVersion}
AppVerName=TrayUnhider
DefaultDirName={commonpf32}\TrayUnhider
DefaultGroupName=TrayUnhider
OutputBaseFilename="tray_unhider_v{#MyAppVersion}_installer"
ArchitecturesInstallIn64BitMode=x64compatible
Compression=lzma
SolidCompression=yes
MinVersion=10.0.22000
OutputDir=installer
PrivilegesRequired=admin 

[Files]
Source: "src\tray_unhider.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "src\create_task.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Run]
//Filename: "schtasks.exe"; Parameters: "/Create /tn ""TrayUnhider"" /tr ""cmd /C start /min \""\"" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File \""{app}\tray_unhider.ps1\"""" /sc onlogon /ec Application /mo *[System/EventID=11707] /rl highest /f"; Flags: runhidden
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\create_task.ps1"" -PathToTrayUnhiderScript ""{app}\tray_unhider.ps1"" -UserName ""{username}"""; WorkingDir: {win}; Flags: shellexec runhidden
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\tray_unhider.ps1"""; WorkingDir: {win}; Flags: shellexec runhidden runasoriginaluser

[UninstallRun]
Filename: "{cmd}"; Parameters: "/C schtasks /delete /tn ""TrayUnhider"" /f"; Flags: runhidden; RunOnceId: "DeleteTrayUnhiderTask"

[UninstallDelete]
Type: filesandordirs; Name: "{app}"