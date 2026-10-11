; ZCode RTL — Inno Setup script.
; Build:   ISCC.exe /DMyAppVersion=1.2.3 installer.iss   (version optional)
; Output:  dist/ZCodeRTL-Setup-<version>.exe  (per-user install, no admin needed)

#define MyAppName "ZCode RTL"
#define MyAppPublisher "ahmadkhanloo"
#define MyAppURL "https://github.com/ahmadkhanloo/ZCodeRTL"

#ifndef MyAppVersion
#define MyAppVersion "1.1.0"
#endif

[Setup]
AppId={{A7E3F1B2-5C4D-4E8F-9A0B-1C2D3E4F5A6B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
LicenseFile=LICENSE
; per-user install, mirrors install.ps1 ({localappdata} requires no admin)
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
DefaultDirName={localappdata}\ZCodeRTL
DisableProgramGroupPage=yes
UninstallDisplayName={#MyAppName}
WizardStyle=modern
Compression=lzma2
SolidCompression=yes
; makes {pf} resolve to "C:\Program Files" on 64-bit Windows
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=dist
OutputBaseFilename=ZCodeRTL-Setup-{#MyAppVersion}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce

[Files]
Source: "launch.vbs"; DestDir: "{app}"
Source: "injector.mjs"; DestDir: "{app}"
Source: "install.ps1"; DestDir: "{app}"
Source: "LICENSE"; DestDir: "{app}"
Source: "README.md"; DestDir: "{app}"
Source: "README.fa.md"; DestDir: "{app}"

[Icons]
; start menu entry
Name: "{autoprograms}\{#MyAppName}"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\launch.vbs"""; WorkingDir: "{app}"; Comment: "Run ZCode with right-to-left support"
; desktop shortcut — three entries, one per possible ZCode.exe location, so the
; shortcut gets ZCode's real icon. Check() skips the ones that don't apply.
Name: "{userdesktop}\{#MyAppName}"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\launch.vbs"""; WorkingDir: "{app}"; IconFilename: "{pf}\ZCode\ZCode.exe"; IconIndex: 0; Tasks: desktopicon; Check: HasZCodeInProgramFiles
Name: "{userdesktop}\{#MyAppName}"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\launch.vbs"""; WorkingDir: "{app}"; IconFilename: "{pf32}\ZCode\ZCode.exe"; IconIndex: 0; Tasks: desktopicon; Check: HasZCodeInProgramFiles32
Name: "{userdesktop}\{#MyAppName}"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\launch.vbs"""; WorkingDir: "{app}"; IconFilename: "{localappdata}\Programs\ZCode\ZCode.exe"; IconIndex: 0; Tasks: desktopicon; Check: HasZCodeInLocalAppData

[Run]
Filename: "{sys}\wscript.exe"; Parameters: """{app}\launch.vbs"""; WorkingDir: "{app}"; Description: "{cm:LaunchZCodeRtl}"; Flags: nowait postinstall skipifsilent unchecked

[CustomMessages]
LaunchZCodeRtl=Launch ZCode RTL now (ZCode must be fully closed first)

[Code]
function HasZCodeInProgramFiles(): Boolean;
begin
  Result := FileExists(ExpandConstant('{pf}\ZCode\ZCode.exe'));
end;

function HasZCodeInProgramFiles32(): Boolean;
begin
  Result := FileExists(ExpandConstant('{pf32}\ZCode\ZCode.exe'));
end;

function HasZCodeInLocalAppData(): Boolean;
begin
  Result := FileExists(ExpandConstant('{localappdata}\Programs\ZCode\ZCode.exe'));
end;

function ZCodeFound(): Boolean;
begin
  Result := HasZCodeInProgramFiles() or HasZCodeInProgramFiles32() or HasZCodeInLocalAppData();
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssInstall) and (not ZCodeFound()) then
    MsgBox('ZCode.exe was not found in the standard install locations.' #13#10 #13#10 'You can still install ZCode RTL, but the shortcut will not do anything until ZCode itself is installed.', mbInformation, MB_OK);
end;
