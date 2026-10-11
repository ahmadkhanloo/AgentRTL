' ZCode RTL launcher. Must be run via wscript.exe (a GUI process), so no console
' window ever appears — a .cmd here would flash a black window on every start.
' 1. Finds ZCode.exe in the standard install locations.
' 2. Starts it with the DevTools port the injector needs.
' 3. Starts the injector fully hidden (window style 0).
' The DevTools port can be overridden with the ZCODE_RTL_PORT environment
' variable (set it before launching, e.g. to run a second parallel setup).

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
here = fso.GetParentFolderName(WScript.ScriptFullName)

port = shell.ExpandEnvironmentStrings("%ZCODE_RTL_PORT%")
If port = "%ZCODE_RTL_PORT%" Or port = "" Then port = "9222"
' propagate to the injector child process
shell.Environment("Process")("ZCODE_RTL_PORT") = port

candidates = Array( _
  shell.ExpandEnvironmentStrings("%ProgramFiles%") & "\ZCode\ZCode.exe", _
  shell.ExpandEnvironmentStrings("%ProgramFiles(x86)%") & "\ZCode\ZCode.exe", _
  shell.ExpandEnvironmentStrings("%LocalAppData%") & "\Programs\ZCode\ZCode.exe")

exe = ""
For Each c In candidates
  If fso.FileExists(c) Then
    exe = c
    Exit For
  End If
Next

If exe = "" Then
  MsgBox "ZCode.exe was not found in the standard install locations." & vbCrLf & vbCrLf & _
         "Install ZCode first, or edit launch.vbs to hardcode its path.", _
         vbCritical, "ZCode RTL"
  WScript.Quit 1
End If

shell.Run """" & exe & """ --remote-debugging-port=" & port, 1, False

On Error Resume Next
shell.Run "node """ & here & "\injector.mjs""", 0, False
If Err.Number <> 0 Then
  Err.Clear
  MsgBox "Node.js was not found on PATH." & vbCrLf & _
         "Install Node.js 21 or newer from https://nodejs.org", _
         vbCritical, "ZCode RTL"
End If
On Error GoTo 0
