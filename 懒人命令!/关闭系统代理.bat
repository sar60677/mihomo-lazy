@echo off
chcp 65001 >nul
echo 正在关闭系统代理...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul

echo 系统代理已关闭！
timeout /t 2 /nobreak >nul