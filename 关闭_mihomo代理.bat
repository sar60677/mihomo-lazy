@echo off
chcp 65001 > nul
title 关闭 mihomo 代理服务并清除系统代理设置

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
echo     正在停止 mihomo 服务并清除系统代理设置
echo =======================================================
echo.

set "SERVICE_NAME=mihomo"

:: --- Step 1: Stop the 'mihomo' service if it's running ---
echo --- 步骤 1/2: 停止 'mihomo' 服务 ---
sc query "%SERVICE_NAME%" | find "RUNNING" >nul 2>&1
if %errorlevel% equ 0 (
    echo 服务 '%SERVICE_NAME%' 正在运行。尝试停止...
    net stop "%SERVICE_NAME%" >nul 2>&1
    :: Check if the service is actually stopped after the command
    sc query "%SERVICE_NAME%" | find "STOPPED" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [成功] 服务 '%SERVICE_NAME%' 已成功停止。
    ) else (
        echo [警告] 停止服务 '%SERVICE_NAME%' 失败或服务仍在停止中。
    )
) else (
    echo 服务 '%SERVICE_NAME%' 未运行。无需停止。
)
echo.

:: --- Step 2: Clear system proxy settings directly ---
echo --- 步骤 2/2: 清除系统代理设置 ---
echo.
echo [操作] 正在禁用系统代理并清除代理服务器设置...

:: 禁用代理 (将 ProxyEnable 设置为 0)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
if %errorlevel% equ 0 (
    echo [成功] 系统代理已禁用
) else (
    echo [错误] 禁用系统代理失败
)

:: 清除 ProxyServer 设置
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>&1
if %errorlevel% equ 0 (
    echo [成功] 代理服务器地址已清除。
) else (
    rem 如果注册表项不存在，删除会失败，但这不是错误
    echo [信息] ProxyServer 注册表项未找到或已清除
)

:: 清除 ProxyOverride 设置 (例如，用于本地地址)
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /f >nul 2>&1
if %errorlevel% equ 0 (
    echo [成功] 代理绕过地址已清除
) else (
    rem 如果注册表项不存在，删除会失败，但这不是错误
    echo [信息] ProxyOverride 注册表项未找到或已清除
)

echo [信息] 基于注册表的代理设置已清除。
echo.

echo =======================================================
echo     mihomo 代理服务已停止，系统代理已清除。
echo =======================================================

:end
echo.
pause
exit
