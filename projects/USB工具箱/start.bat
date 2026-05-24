@echo off
title Jinxian USB Toolkit v1.2

:: Request admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d %~dp0

echo.
echo ============================================
echo   Jinxian USB Toolkit v1.2
echo   Plug in -^> Double-click -^> Jinxian connects
echo ============================================
echo.

echo [1/2] Enabling SSH Server...
powershell -ExecutionPolicy Bypass -File "%~dp0setup-ssh.ps1"
if %errorlevel% neq 0 (
    echo.
    echo [FAIL] SSH setup failed!
    echo Check: Win10 1809+, connected to internet?
    echo.
    pause
    exit /b 1
)

:: Show current username
for /f "tokens=*" %%i in ('whoami') do set MYUSER=%%i
echo       User: %MYUSER%

echo.
echo [2/2] Creating secure tunnel...
echo.
echo ============================================
echo   WAITING for tunnel...
echo   Once connected, send Port + User + Password
echo   to Jinxian via LINE or Telegram
echo.
echo   !! Closing this window = disconnect !!
echo ============================================
echo.

ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 0:localhost:22 serveo.net

echo.
echo ============================================
echo Tunnel closed. Jinxian disconnected.
echo Run start.bat again to reconnect.
echo.
pause
