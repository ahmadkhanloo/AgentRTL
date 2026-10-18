' Qoder RTL launcher - double-click this (it opens with wscript.exe, a GUI
' process, so no console window ever flashes). It only hands over to start.ps1
' hidden; env vars (QODER_RTL_PORT / QODER_RTL_EXE) set in
' the environment are inherited by the child process.
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
here = fso.GetParentFolderName(WScript.ScriptFullName)

ps = shell.ExpandEnvironmentStrings("%SystemRoot%") & "\System32\WindowsPowerShell\v1.0\powershell.exe"
If Not fso.FileExists(ps) Then ps = "powershell.exe"

shell.Run """" & ps & """ -NoProfile -ExecutionPolicy Bypass -File """ & here & "\start.ps1"" -Gui", 0, False
