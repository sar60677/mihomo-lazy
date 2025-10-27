@echo off
chcp 65001 > nul
title 安装 mihomo 服务并关闭系统代理

:: --- 脚本主体 ---

:: 1. 自动请求管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [信息] 脚本未以管理员权限运行，将尝试自动提升权限...
    echo.
    powershell -command "Start-Process '%0' -Verb RunAs"
    exit /b
)

:: 确保脚本在文件所在的目录中运行
cd /d "%~dp0"

cls
echo =======================================================
echo     正在停止、卸载代理服务并清除代理设置
echo =======================================================
echo.

:: 定义服务名称和卸载程序可执行文件
set "SERVICE_NAME=mihomo"
set "UNINSTALLER_EXE=mihomo-service.exe"

:: --- 步骤 1/3: 停止 '%SERVICE_NAME%' 服务 ---
echo --- 步骤 1/3: 停止 '%SERVICE_NAME%' 服务 ---
echo.
rem 检查服务是否正在运行
sc query "%SERVICE_NAME%" | find "RUNNING" >nul 2>&1
if %errorlevel% equ 0 (
    echo [操作] 服务 '%SERVICE_NAME%' 正在运行。尝试停止它...
    net stop "%SERVICE_NAME%" >nul 2>&1
    
    rem 验证服务是否已停止
    sc query "%SERVICE_NAME%" | find "STOPPED" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [成功] 服务 '%SERVICE_NAME%' 已成功停止
    ) else (
        echo [警告] 停止服务 '%SERVICE_NAME%' 失败，或服务仍处于停止状态。继续卸载
    )
) else (
    echo [信息] 服务 '%SERVICE_NAME%' 未运行。无需停止。
)
echo.

:: --- 步骤 2/3: 卸载 '%SERVICE_NAME%' 服务 ---
echo --- 步骤 2/3: 卸载 '%SERVICE_NAME%' 服务 ---
echo.
echo [操作] 正在尝试使用 '%UNINSTALLER_EXE% uninstall' 卸载服务...
if exist "%UNINSTALLER_EXE%" (
    echo =================== 卸载程序输出开始 ===================
    "%UNINSTALLER_EXE%" uninstall
    echo ==================== 卸载程序输出结束 ====================
    echo.

    :: 修复后的 timeout 命令，移除 >nul 后的注释，并确保语法正确
    timeout /t 2 /nobreak >nul
    
) else (
    echo [错误] 卸载程序 '%UNINSTALLER_EXE%' 未找到。无法卸载服务
    echo        请确保 '%UNINSTALLER_EXE%' 在当前目录下
)
echo.

:: --- 步骤 3/3: 清除系统代理设置 ---
echo --- 步骤 3/3: 清除系统代理设置 ---
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

echo [信息] 基于注册表的代理设置已应用。可能需要重启应用程序或浏览器，或者刷新网络才能生效
echo.

echo =======================================================
echo      卸载和代理清除已完成
echo =======================================================

:end
echo.
pause
exit
