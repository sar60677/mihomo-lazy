@echo off
chcp 65001 > nul
title 安装 mihomo 服务并启用系统代理

:: --- 脚本主体 ---

:: 1. 自动请求管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在请求管理员权限...
    echo.
    powershell -command "Start-Process '%0' -Verb RunAs"
    exit /b
)

:: 确保脚本在文件所在的目录中运行
cd /d "%~dp0"

cls
echo =======================================================
echo     正在安装 mihomo 服务并启用系统代理
echo =======================================================
echo.

:: 定义服务名称、可执行文件和代理设置
set "SERVICE_NAME=mihomo"
set "MIHOMO_EXECUTABLE=mihomo-service.exe"
set "PROXY_ADDRESS=127.0.0.1:7890"  :: Mihomo/Clash 常见的默认 HTTP/SOCKS 代理地址
set "PROXY_BYPASS=localhost;127.*;192.168.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*" :: 代理绕过地址 (例如局域网等)

:: --- 步骤 1: 安装 '%SERVICE_NAME%' 服务 ---
echo --- 步骤 1/3: 安装 '%SERVICE_NAME%' 服务 ---
echo.
sc query "%SERVICE_NAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [信息] 服务 '%SERVICE_NAME%' 已检测到已安装。跳过安装。
    echo        如果需要重新安装，请先运行卸载脚本或手动卸载。
) else (
    echo 尝试安装服务 '%SERVICE_NAME%'...
    if exist "%MIHOMO_EXECUTABLE%" (
        echo =================== 安装程序输出开始 ===================
        "%MIHOMO_EXECUTABLE%" install
        set "INSTALL_ERRORLEVEL=%errorlevel%"
        echo ==================== 安装程序输出结束 ====================
    ) else (
        echo [错误] '%MIHOMO_EXECUTABLE%' 未找到。无法安装服务。
        echo        请确保 '%MIHOMO_EXECUTABLE%' 在当前目录下。
        goto :end
    )
)
echo.

:: --- 步骤 2: 启动 '%SERVICE_NAME%' 服务 ---
echo --- 步骤 2/3: 启动 '%SERVICE_NAME%' 服务 ---
echo.
sc query "%SERVICE_NAME%" | find "RUNNING" >nul 2>&1
if %errorlevel% equ 0 (
    echo [信息] 服务 '%SERVICE_NAME%' 正在运行。
) else (
    echo 尝试启动服务 '%SERVICE_NAME%'...
    net start "%SERVICE_NAME%" >nul 2>&1
    
    :: 等待服务启动
    echo 等待服务启动中...
    timeout /t 5 /nobreak > nul
    
    REM 再次检查服务是否真正启动（匹配状态码 4=RUNNING）
    sc query "%SERVICE_NAME%" | findstr /R /C:"STATE *: *4" >nul
    if errorlevel 1 (
        echo [警告] 服务 '%SERVICE_NAME%' 启动失败或未处于运行状态。请手动检查服务，或查看日志。
    ) else (
        echo [成功] 服务 '%SERVICE_NAME%' 已启动。
    )
)
echo.

:: --- 步骤 3: 启用系统代理设置 ---
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
echo [信息] 基于注册表的代理设置已应用。可能需要重启应用程序或浏览器才能生效
echo.
echo =======================================================
echo          mihomo 服务已安装并成功启动。
echo.
echo          系统代理已设置。
echo =======================================================
:end
echo.
pause
exit
