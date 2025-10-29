@echo off
chcp 65001 > nul
title 启动 mihomo 代理服务并启用系统代理

:: --- Script Body ---

:: Auto-request for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 请求管理员权限...
    echo.
    powershell -command "Start-Process '%0' -Verb RunAs"
    exit /b
)

:: Ensure the script runs in the directory where the file is located
cd /d "%~dp0"

cls
echo =======================================================
echo     正在启动 mihomo 服务并启用系统代理
echo =======================================================
echo.

set "SERVICE_NAME=mihomo"
set "MIHOMO_EXECUTABLE=mihomo-service.exe"
set "PROXY_ADDRESS=127.0.0.1:7890"  :: Mihomo/Clash 默认 HTTP/SOCKS 代理地址
set "PROXY_BYPASS=localhost;127.*;192.168.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*" :: 代理绕过地址

:: --- Step 1: Install or ensure 'mihomo' service is installed ---
echo --- 步骤 1/3: 检查并安装 'mihomo' 服务 ---
sc query "%SERVICE_NAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo 服务 '%SERVICE_NAME%' 已安装。跳过安装。
) else (
    echo 尝试安装服务 '%SERVICE_NAME%'...
    if exist "%MIHOMO_EXECUTABLE%" (
        "%MIHOMO_EXECUTABLE%" install
        if %errorlevel% equ 0 (
            echo [成功] 服务 '%SERVICE_NAME%' 安装成功。
        ) else (
            echo [错误] 服务 '%SERVICE_NAME%' 安装失败。请检查 '%MIHOMO_EXECUTABLE%'。
            goto :end
        )
    ) else (
        echo [错误] '%MIHOMO_EXECUTABLE%' 未找到。无法安装服务。
        echo 请确保 '%MIHOMO_EXECUTABLE%' 在当前目录下。
        goto :end
    )
)
echo.

:: --- Step 2: Start the 'mihomo' service ---
echo --- 步骤 2/3: 启动 'mihomo' 服务 ---
sc query "%SERVICE_NAME%" | find "RUNNING" >nul 2>&1
if %errorlevel% equ 0 (
    echo 服务 '%SERVICE_NAME%' 正在运行。
) else (
    echo 尝试启动服务 '%SERVICE_NAME%'...
    net start "%SERVICE_NAME%" >nul 2>&1
    :: check service state
    sc query "%SERVICE_NAME%" | find "RUNNING" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [成功] 服务 '%SERVICE_NAME%' 已启动。
    ) else (
        echo [警告] 服务 '%SERVICE_NAME%' 启动失败或未处于运行状态。请手动检查。
    )
)
echo.


:: --- Step 3: Enable system proxy settings ---
echo --- 步骤 3/3: 启用系统代理设置 ---
echo.
echo [操作] 正在启用系统代理并设置代理服务器为: %PROXY_ADDRESS%

:: 启用代理 (将 ProxyEnable 设置为 1)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
if %errorlevel% equ 0 (
    echo [成功] 系统代理已启用。
) else (
    echo [错误] 启用系统代理失败。
)

:: 设置 ProxyServer 地址
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "%PROXY_ADDRESS%" /f >nul
if %errorlevel% equ 0 (
    echo [成功] 代理服务器地址设置成功。
) else (
    echo [错误] 设置代理服务器地址失败。
)

:: 设置 ProxyOverride (绕过本地地址等)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "%PROXY_BYPASS%" /f >nul
if %errorlevel% equ 0 (
    echo [成功] 代理绕过地址成功。
) else (
    echo [错误] 设置代理绕过地址失败。
)

echo [信息] 基于注册表的代理设置已应用。
echo.

echo =======================================================
echo          mihomo 代理服务和系统代理已启动。
echo =======================================================

:end
echo.
pause
exit
