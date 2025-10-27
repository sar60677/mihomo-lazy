@echo off
chcp 65001 >nul
echo 正在关闭 Clash 开机自启动...

:: 删除开机启动快捷方式
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "shortcut=%startup%\Clash.lnk"

if exist "%shortcut%" (
    del "%shortcut%"
    echo Clash 开机自启动已关闭！
) else (
    echo Clash 未设置开机自启动！
)

timeout /t 3 /nobreak >nul
