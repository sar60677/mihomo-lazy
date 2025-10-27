' 以管理员权限运行
If Not WScript.Arguments.Named.Exists("elevated") Then
    Set objShell = CreateObject("Shell.Application")
    objShell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevated", "", "runas", 0
    WScript.Quit
End If

Set ws = CreateObject("Wscript.Shell")
Set objWMI = GetObject("winmgmts:\\.\root\cimv2")

' 检测并杀死已存在的 mihomo.exe 进程
Set colProcesses = objWMI.ExecQuery("Select * from Win32_Process Where Name = 'mihomo.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next
WScript.Sleep 500

' 检测并杀死已存在的 RBTray.exe 进程
Set colProcesses = objWMI.ExecQuery("Select * from Win32_Process Where Name = 'RBTray.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next
WScript.Sleep 500

' 先启动 RBTray
ws.run "C:\Clash\RBTray\RBTray.exe", 0
WScript.Sleep 1000

' 然后启动 Clash
ws.run "cmd /c cd /d C:\Clash && mihomo.exe -f config.yaml", 0