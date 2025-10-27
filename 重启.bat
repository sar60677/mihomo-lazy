@echo off
chcp 65001 >nul
echo 正在重启 Clash...

for /f "tokens=2" %%i in ('tasklist /FI "IMAGENAME eq mihomo.exe" ^| find "mihomo.exe"') do (
    echo 当前已运行的 mihomo.exe，其 PID 为 %%i。
)

taskkill /F /IM mihomo.exe >nul 2>nul
timeout /t 2 /nobreak >nul
start "" "C:\Clash\start-clash.vbs"
echo Clash 已重启！
timeout /t 2 /nobreak >nul