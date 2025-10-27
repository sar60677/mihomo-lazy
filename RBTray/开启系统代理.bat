@echo off
chcp 65001 >nul
echo 正在设置系统代理...

:: 读取配置文件中的端口
for /f "tokens=2" %%i in ('findstr /r "^mixed-port:" "C:\Clash\config.yaml"') do set PORT=%%i

:: 设置系统代理
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "127.0.0.1:%PORT%" /f >nul

echo 系统代理已设置为: 127.0.0.1:%PORT%
echo 完成！
timeout /t 2 /nobreak >nul