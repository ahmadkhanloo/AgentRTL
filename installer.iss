; Keep the original AppId so existing ZCode RTL installs upgrade in place.
#define MyAppName "AgentRTL"
#define MyAppPublisher "ahmadkhanloo"
#define MyAppURL "https://github.com/ahmadkhanloo/AgentRTL"
#ifndef MyAppVersion
#define MyAppVersion "1.2.0"
#endif

[Setup]
AppId={{A7E3F1B2-5C4D-4E8F-9A0B-1C2D3E4F5A6B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
LicenseFile=LICENSE
PrivilegesRequired=lowest
DefaultDirName={localappdata}\AgentRTL
UsePreviousAppDir=yes
UsePreviousSetupType=yes
DisableProgramGroupPage=yes
DefaultGroupName=AgentRTL
UninstallDisplayName={#MyAppName}
WizardStyle=modern
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=dist
OutputBaseFilename=AgentRTL-Setup-{#MyAppVersion}

[Types]
Name: "full"; Description: "Install all RTL tools"
Name: "custom"; Description: "Choose which apps to install"; Flags: iscustom

[Components]
Name: "zcode"; Description: "ZCode RTL"; Types: full custom
Name: "qoder"; Description: "Qoder RTL"; Types: full custom
Name: "deepseek"; Description: "DeepSeek Harness RTL"; Types: full custom

[Tasks]
Name: "desktopicon_zcode"; Description: "Create a ZCode RTL desktop shortcut"; GroupDescription: "Desktop shortcuts:"; Components: zcode; Flags: checkedonce
Name: "desktopicon_qoder"; Description: "Create a Qoder RTL desktop shortcut"; GroupDescription: "Desktop shortcuts:"; Components: qoder; Flags: checkedonce
Name: "desktopicon_deepseek"; Description: "Create a DeepSeek Harness RTL desktop shortcut"; GroupDescription: "Desktop shortcuts:"; Components: deepseek; Flags: checkedonce

[Files]
Source: "install.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "cleanup.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "apps\ZCode\*"; DestDir: "{app}\apps\ZCode"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: zcode
Source: "apps\Qoder\*"; DestDir: "{app}\apps\Qoder"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: qoder
Source: "apps\DeepSeekHarness\*"; DestDir: "{app}\apps\DeepSeekHarness"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: deepseek

[Icons]
Name: "{group}\ZCode RTL"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\apps\ZCode\launch.vbs"""; WorkingDir: "{app}\apps\ZCode"; IconFilename: "{code:GetZCodeExe}"; Components: zcode
Name: "{userdesktop}\ZCode RTL"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\apps\ZCode\launch.vbs"""; WorkingDir: "{app}\apps\ZCode"; IconFilename: "{code:GetZCodeExe}"; Components: zcode; Tasks: desktopicon_zcode
Name: "{group}\Qoder RTL"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\apps\Qoder\launch.vbs"""; WorkingDir: "{app}\apps\Qoder"; IconFilename: "{code:GetQoderExe}"; Components: qoder
Name: "{userdesktop}\Qoder RTL"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\apps\Qoder\launch.vbs"""; WorkingDir: "{app}\apps\Qoder"; IconFilename: "{code:GetQoderExe}"; Components: qoder; Tasks: desktopicon_qoder
Name: "{group}\DeepSeek Harness RTL"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\apps\DeepSeekHarness\launch.vbs"""; WorkingDir: "{app}\apps\DeepSeekHarness"; IconFilename: "{code:GetDeepSeekExe}"; Components: deepseek
Name: "{userdesktop}\DeepSeek Harness RTL"; Filename: "{sys}\wscript.exe"; Parameters: """{app}\apps\DeepSeekHarness\launch.vbs"""; WorkingDir: "{app}\apps\DeepSeekHarness"; IconFilename: "{code:GetDeepSeekExe}"; Components: deepseek; Tasks: desktopicon_deepseek

[UninstallRun]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""{app}\cleanup.ps1"" -Root ""{app}"""; Flags: runhidden waituntilterminated; RunOnceId: "StopAgentRTLInjectors"

[UninstallDelete]
Type: files; Name: "{app}\launch.vbs"
Type: files; Name: "{app}\launch.sh"
Type: files; Name: "{app}\injector.mjs"

[Code]
const
  LegacyInstallKey = 'Software\Microsoft\Windows\CurrentVersion\Uninstall\{A7E3F1B2-5C4D-4E8F-9A0B-1C2D3E4F5A6B}_is1';
var
  LegacyZCodeUpgrade: Boolean;

function GetZCodeExe(Param: String): String;
begin
  Result := ExpandConstant('{pf}\ZCode\ZCode.exe');
  if FileExists(Result) then exit;
  Result := ExpandConstant('{pf32}\ZCode\ZCode.exe');
  if FileExists(Result) then exit;
  Result := ExpandConstant('{localappdata}\Programs\ZCode\ZCode.exe');
end;

function GetQoderExe(Param: String): String;
begin
  Result := ExpandConstant('{localappdata}\Programs\Qoder\Qoder.exe');
end;

function GetDeepSeekExe(Param: String): String;
begin
  Result := ExpandConstant('{localappdata}\Programs\DeepSeek Harness\DeepSeek Harness.exe');
end;

function HasQoder: Boolean;
begin
  Result := FileExists(GetQoderExe('')) and DirExists(ExpandConstant('{localappdata}\Programs\Qoder\.qoder-versions'));
end;

function HasDeepSeek: Boolean;
begin
  Result := FileExists(GetDeepSeekExe('')) and FileExists(ExpandConstant('{localappdata}\Programs\DeepSeek Harness\resources\app.asar'));
end;

function NodeIsSupported: Boolean;
var
  ResultCode, DotAt, Major: Integer;
  NodePath, VersionText: String;
  Output: TExecOutput;
begin
  Result := False;
  try
    if not ExecAndCaptureOutput(ExpandConstant('{sys}\where.exe'), 'node.exe', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode, Output) then exit;
    if (ResultCode <> 0) or (GetArrayLength(Output.StdOut) = 0) then exit;
    NodePath := Trim(Output.StdOut[0]);
    if not ExecAndCaptureOutput(NodePath, '--version', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode, Output) then exit;
    if (ResultCode <> 0) or (GetArrayLength(Output.StdOut) = 0) then exit;
    VersionText := Trim(Output.StdOut[0]);
    if Copy(VersionText, 1, 1) = 'v' then Delete(VersionText, 1, 1);
    DotAt := Pos('.', VersionText);
    if DotAt = 0 then exit;
    Major := StrToIntDef(Copy(VersionText, 1, DotAt - 1), 0);
    Result := Major >= 21;
  except
    Result := False;
  end;
end;

function InitializeSetup: Boolean;
var
  PreviousVersion, PreviousComponents: String;
begin
  LegacyZCodeUpgrade := RegQueryStringValue(HKEY_CURRENT_USER, LegacyInstallKey, 'DisplayVersion', PreviousVersion) and
    not RegQueryStringValue(HKEY_CURRENT_USER, LegacyInstallKey, 'Inno Setup: Selected Components', PreviousComponents);
  Result := True;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if (CurPageID = wpSelectComponents) and LegacyZCodeUpgrade then
    WizardSelectComponents('zcode,!qoder,!deepseek');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID <> wpSelectComponents then exit;
  if not (WizardIsComponentSelected('zcode') or WizardIsComponentSelected('qoder') or WizardIsComponentSelected('deepseek')) then begin
    MsgBox('Select at least one RTL tool to install.', mbError, MB_OK);
    Result := False;
    exit;
  end;
  if not NodeIsSupported then begin
    MsgBox('Node.js 21 or newer is required. Install it from https://nodejs.org, then run this installer again.', mbError, MB_OK);
    Result := False;
    exit;
  end;
  if WizardIsComponentSelected('zcode') and not FileExists(GetZCodeExe('')) then begin
    MsgBox('ZCode was selected but was not found in a standard install location. Install ZCode first.', mbError, MB_OK);
    Result := False;
    exit;
  end;
  if WizardIsComponentSelected('qoder') and not HasQoder then begin
    MsgBox('Qoder was selected but was not found in its standard install location. Install Qoder first.', mbError, MB_OK);
    Result := False;
    exit;
  end;
  if WizardIsComponentSelected('deepseek') and not HasDeepSeek then begin
    MsgBox('DeepSeek Harness was selected but was not found in its standard install location. Install DeepSeek Harness first.', mbError, MB_OK);
    Result := False;
  end;
end;
