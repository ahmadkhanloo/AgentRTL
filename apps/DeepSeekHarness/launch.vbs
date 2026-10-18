' DeepSeek Harness RTL launcher. wscript.exe keeps PowerShell hidden and prevents console flash.
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
here = fso.GetParentFolderName(WScript.ScriptFullName)
ps = shell.ExpandEnvironmentStrings("%SystemRoot%") & "\System32\WindowsPowerShell\v1.0\powershell.exe"
If Not fso.FileExists(ps) Then ps = "powershell.exe"
shell.Run """" & ps & """ -NoProfile -ExecutionPolicy Bypass -File """ & here & "\start.ps1"" -Gui", 0, False
