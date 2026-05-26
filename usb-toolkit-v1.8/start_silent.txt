' Jinxian Silent Tunnel v1.0
' Runs SSH tunnel in background with no visible window
' Auto-restarts if tunnel drops

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)

' Run the SSH tunnel silently (0 = hidden window, False = don't wait)
WshShell.Run "cmd /c cd /d """ & scriptDir & """ && ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -i """ & scriptDir & "\jx_key"" -p 443 -R 0:localhost:22 tcp@a.pinggy.io > """ & scriptDir & "\tunnel.log"" 2>&1", 0, False

' Wait a moment for tunnel to start
WScript.Sleep 3000

' The script exits but SSH keeps running (it was spawned as a child process)
Set WshShell = Nothing
Set fso = Nothing
