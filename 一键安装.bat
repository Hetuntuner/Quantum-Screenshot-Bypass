@echo off
setlocal
chcp 65001 >nul
title 量子密信解除工具 - 自动配置脚本

echo ==========================================
echo      正在配置开机自启动任务...
echo ==========================================

:: 1. 检查管理员权限
fltmc >nul 2>&1 || (
    echo.
    echo [X] 请右键点击本文件，选择【以管理员身份运行】！
    echo.
    pause
    exit /b
)

:: 2. 获取当前路径和程序路径
set "WorkDir=%~dp0"
:: 去掉路径末尾可能存在的反斜杠
if "%WorkDir:~-1%"=="\" set "WorkDir=%WorkDir:~0,-1%"
set "ExePath=%WorkDir%\Injector.exe"

:: 3. 检查文件是否存在
if not exist "%ExePath%" (
    echo.
    echo [X] 错误：找不到 Injector.exe！
    echo 请确保本脚本和 Injector.exe 在同一个文件夹里。
    echo.
    pause
    exit /b
)

:: 4. 创建系统任务计划
:: /tn 任务名称
:: /tr 运行路径
:: /sc onlogon (登录时触发)
:: /rl highest (最高权限/绕过UAC弹窗)
:: /f (强制覆盖旧任务)
schtasks /create /tn "QuantumUnlocker" /tr "'%ExePath%'" /sc onlogon /rl highest /f

if %errorlevel%==0 (
    echo.
    echo [√] 配置成功！
    echo [√] 工具已设置为开机自启（后台静默运行）。
    echo.
    echo 正在尝试立即启动一次...
    start "" "%ExePath%"
) else (
    echo.
    echo [X] 配置失败，请检查是否被杀毒软件拦截。
)

echo.
echo 按任意键退出...
pause >nul