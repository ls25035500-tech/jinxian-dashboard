@echo off
title Jinxian USB Toolkit v1.5

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
echo   Jinxian USB Toolkit v1.5
echo ============================================
echo.

echo [1/2] Enabling SSH Server...
powershell -ExecutionPolicy Bypass -File "%~dp0setup-ssh.ps1"
if %errorlevel% neq 0 (
    echo [FAIL] SSH setup failed!
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('whoami') do set MYUSER=%%i
echo       User: %MYUSER%

echo.
echo [2/2] Creating tunnel via Pinggy...
echo.
echo ============================================
echo   Keep this window open!
echo   Look for: tcp://...pinggy-free.link:PORT
echo   Send the tcp:// line to Jinxian
echo.
echo   !! Closing window = disconnect !!
echo ============================================
echo.

ssh -p 443 -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 0:localhost:22 tcp@a.pinggy.io

echo.
echo Tunnel closed. Run again to reconnect.
pause
