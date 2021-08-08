; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define AppName "Sonarr"
#define AppPublisher "Team Sonarr"
#define AppURL "https://sonarr.tv/"
#define ForumsURL "https://forums.sonarr.tv/"
#define AppExeName "Sonarr.exe"
#define BaseVersion GetEnv('MAJORVERSION')
#define BuildNumber GetEnv('MINORVERSION')
#define BuildVersion GetEnv('SONARRVERSION')
#define BranchName GetEnv('BUILD_SOURCEBRANCHNAME')

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{56C1065D-3523-4025-B76D-6F73F67F7F71}
AppName={#AppName}
AppVersion={#BaseVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#ForumsURL}
AppUpdatesURL={#AppURL}
UsePreviousAppDir=no
DefaultDirName={commonappdata}\Sonarr\bin
DisableDirPage=yes
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputBaseFilename=Sonarr.{#BranchName}.{#BuildVersion}.windows.{#Framework}
SolidCompression=yes
AppCopyright=Creative Commons 3.0 License
AllowUNCPath=False
UninstallDisplayIcon={app}\Sonarr.exe
DisableReadyPage=True
CompressionThreads=2
Compression=lzma2/normal
AppContact={#ForumsURL}
VersionInfoVersion={#BaseVersion}.{#BuildNumber}
SetupLogging=yes
OutputDir=output

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopIcon"; Description: "{cm:CreateDesktopIcon}"
Name: "windowsService"; Description: "Install Windows Service (Starts when the computer starts as the LocalService user, you will need to change the user to access network shares)"; GroupDescription: "Start automatically"; Flags: exclusive unchecked
Name: "startupShortcut"; Description: "Create shortcut in Startup folder (Starts when you log into Windows)"; GroupDescription: "Start automatically"; Flags: exclusive
Name: "none"; Description: "Do not start automatically"; GroupDescription: "Start automatically"; Flags: exclusive unchecked

[Files]
Source: "..\..\..\_artifacts\{#Runtime}\{#Framework}\Sonarr\Sonarr.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\..\_artifacts\{#Runtime}\{#Framework}\Sonarr\*"; Excludes: "Sonarr.Update"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Parameters: "/icon"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Parameters: "/icon"; Tasks: desktopIcon
Name: "{userstartup}\{#AppName}"; Filename: "{app}\Sonarr.exe"; WorkingDir: "{app}"; Tasks: startupShortcut

[InstallDelete]
Name: "{commonappdata}\NzbDrone\bin"; Type: filesandordirs
Name: "{app}"; Type: filesandordirs

[Run]
Filename: "{app}\Sonarr.Console.exe"; StatusMsg: "Removing previous Windows Service"; Parameters: "/u /exitimmediately"; Flags: runhidden waituntilterminated;
Filename: "{app}\Sonarr.Console.exe"; Description: "Enable Access from Other Devices"; StatusMsg: "Enabling Remote access"; Parameters: "/registerurl /exitimmediately"; Flags: postinstall runascurrentuser runhidden waituntilterminated; Tasks: startupShortcut none;
Filename: "{app}\Sonarr.Console.exe"; StatusMsg: "Installing Windows Service"; Parameters: "/i /exitimmediately"; Flags: runhidden waituntilterminated; Tasks: windowsService
Filename: "{app}\Sonarr.exe"; Description: "Open Sonarr Web UI"; Flags: postinstall skipifsilent nowait; Tasks: windowsService;
Filename: "{app}\Sonarr.exe"; Description: "Start Sonarr"; Flags: postinstall skipifsilent nowait; Tasks: startupShortcut none;

[UninstallRun]
Filename: "{app}\Sonarr.Console.exe"; Parameters: "/u"; Flags: runhidden waituntilterminated skipifdoesntexist

[Code]
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Exec('net', 'stop nzbdrone', '', 0, ewWaitUntilTerminated, ResultCode)
  Exec('sc', 'delete nzbdrone', '', 0, ewWaitUntilTerminated, ResultCode)
end;
