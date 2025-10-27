@echo off
chcp 65001 >nul
echo 正在设置 Clash 开机自启动...

:: 创建开机启动快捷方式
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "target=C:\Clash\start-clash.vbs"

:: 使用 PowerShell 创建快捷方式
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%startup%\Clash.lnk'); $s.TargetPath = '%target%'; $s.Save()"

echo Clash 开机自启动已设置！
echo 快捷方式位置: %startup%\Clash.lnk
timeout /t 3 /nobreak >nul