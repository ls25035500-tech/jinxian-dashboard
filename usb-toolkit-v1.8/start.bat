@echo off
chcp 65001 >nul
title USB Toolkit v1.8

echo ================================
echo   Jinxian USB Toolkit v1.8
echo   (SSH key auth - no password!)
echo ================================
echo.

REM ============================================
REM  Step 0: Basic checks before anything else
REM ============================================

REM Check if we can find ourselves
if not exist "%~f0" (
    echo [ERROR] Cannot find script file.
    echo This may happen when running from a network path.
    echo Please copy the toolkit to a local drive first.
    pause
    exit /b 1
)

REM Check if jx_key exists
if not exist "%~dp0jx_key" (
    echo [ERROR] SSH key file "jx_key" not found!
    echo.
    echo The key file must be in the same folder as start.bat.
    echo Current folder: %~dp0
    echo.
    echo Files in this folder:
    dir /b "%~dp0" 2>nul
    echo.
    echo Please make sure all toolkit files are copied together.
    pause
    exit /b 1
)

REM Check if setup-ssh.ps1 exists
if not exist "%~dp0setup-ssh.ps1" (
    echo [ERROR] setup-ssh.ps1 not found!
    echo Please extract all toolkit files to the same folder.
    pause
    exit /b 1
)

echo [OK] All toolkit files present
echo [*] Script path: %~dp0
echo.

REM ============================================
REM  Step 1: Check administrator privileges
REM ============================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Need administrator privileges. Restarting...
    echo     A UAC prompt will appear - please click "Yes".
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
echo [OK] Running as Administrator
echo.

REM ============================================
REM  Step 2: Setup SSH
REM ============================================
echo [*] Setting up SSH...
echo.
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0setup-ssh.ps1"
if %errorlevel% neq 0 (
    echo.
    echo [WARNING] SSH setup had errors, but continuing...
    echo.
)

REM ============================================
REM  Step 3: Check if SSH command is available
REM ============================================
ssh -V >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] SSH command not found!
    echo OpenSSH may not be installed correctly.
    echo Try running setup-ssh.ps1 manually as Administrator.
    pause
    exit /b 1
)
echo [OK] SSH client ready
echo.

REM ============================================
REM  Step 4: Start Pinggy tunnel
REM ============================================
echo [*] Starting Pinggy reverse tunnel (key auth)...
echo.
echo The tunnel address will appear below:
echo ================================
echo.

ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -i "%~dp0jx_key" -p 443 -R 0:localhost:22 tcp@a.pinggy.io

echo.
echo ================================
echo Tunnel closed.
pause
