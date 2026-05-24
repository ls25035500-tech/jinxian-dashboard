@echo off
chcp 65001 >nul
title 🦐 金仙 USB 工具箱 - 連線中...

echo.
echo ╔══════════════════════════════════════╗
echo ║   🦐 金仙 USB 工具箱 v1.0             ║
echo ║   插上去 → 點兩下 → 金仙連進來        ║
echo ╚══════════════════════════════════════╝
echo.

:: Step 1: 開 SSH Server
echo [1/2] 開啟 SSH Server...
powershell -ExecutionPolicy Bypass -File "%~dp0setup-ssh.ps1"

:: 抓本機帳號
for /f "tokens=*" %%i in ('whoami') do set MYUSER=%%i
echo       本機帳號: %MYUSER%

:: Step 2: 建立反向隧道
echo [2/2] 建立加密隧道...
echo.
echo ╔══════════════════════════════════════╗
echo ║  ⏳ 正在建立連線...                   ║
echo ║  連上後會顯示 IP 跟 Port              ║
echo ║  把下面資訊傳給金仙即可               ║
echo ╚══════════════════════════════════════╝
echo.
echo ⚠ 關掉這個視窗 = 斷線
echo ═══════════════════════════════════════
echo.

ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 0:localhost:22 serveo.net

echo.
echo ═══════════════════════════════════════
echo 隧道已關閉。需要重新連線請再執行 start.bat
pause
