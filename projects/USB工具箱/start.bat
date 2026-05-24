@echo off
title 🦐 金仙 USB 工具箱

:: ════════════════════════════════════
:: 自動要求管理員權限
:: ════════════════════════════════════
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 需要管理員權限，正在重新啟動...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ════════════════════════════════════
:: 主程式
:: ════════════════════════════════════
cd /d %~dp0

echo.
echo ╔══════════════════════════════════════╗
echo ║   🦐 金仙 USB 工具箱 v1.1             ║
echo ║   插上去 → 點兩下 → 金仙連進來        ║
echo ╚══════════════════════════════════════╝
echo.

echo [1/2] 開啟 SSH Server...
powershell -ExecutionPolicy Bypass -File "%~dp0setup-ssh.ps1"
if %errorlevel% neq 0 (
    echo.
    echo ❌ SSH 設定失敗！請檢查：
    echo    1. 是否為 Windows 10 1809 以上版本
    echo    2. 是否已連上網路
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('whoami') do set MYUSER=%%i
echo       本機帳號: %MYUSER%

echo.
echo [2/2] 建立加密隧道...
echo.
echo ╔══════════════════════════════════════╗
echo ║  ⏳ 正在連線到金仙...                 ║
echo ║  連上後會顯示 Port 號碼               ║
echo ║  把 Port + 本機帳密 傳給金仙          ║
echo ║                                    ║
echo ║  ⚠ 關掉這個視窗 = 斷線！            ║
echo ╚══════════════════════════════════════╝
echo.

ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 0:localhost:22 serveo.net

echo.
echo ═══════════════════════════════════════
echo 隧道已關閉，金仙已斷線。
echo 需要重新連線請再執行 start.bat
echo.
pause
