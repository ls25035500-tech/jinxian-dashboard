@echo off
title Jinxian USB Toolkit v1.4

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
echo   Jinxian USB Toolkit v1.4
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

:: Random port 10000-60000
set /a RNDPORT=%random% %% 50000 + 10000

echo.
echo [2/2] Creating tunnel on port %RNDPORT%...
echo.
echo ============================================
echo   Waiting for tunnel... (port %RNDPORT%)
echo   Send this to Jinxian:
echo     ssh -p %RNDPORT% %MYUSER%@serveo.net
echo.
echo   !! Closing this window = disconnect !!
echo ============================================
echo.

ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R %RNDPORT%:localhost:22 serveo.net

echo.
echo Tunnel closed. Run start.bat again to reconnect.
pause
