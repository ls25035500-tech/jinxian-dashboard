@echo off
chcp 65001 >nul
title Install Jinxian Resident Tunnel

echo ================================
echo   Install Resident Tunnel
echo   (Auto-start at login, hidden)
echo ================================
echo.

REM Check admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Need Administrator privileges. Restarting...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo [*] Creating scheduled task...
schtasks /create /tn "JinxianTunnel" /tr "\"%~dp0start_silent.vbs\"" /sc onlogon /rl highest /f
if %errorlevel% equ 0 (
    echo [OK] Task created successfully
    echo.
    echo Tunnel will auto-start at next login.
    echo.
    echo To start now:
    schtasks /run /tn "JinxianTunnel"
) else (
    echo [ERROR] Failed to create task
)
echo.
echo To uninstall, run: uninstall_resident.bat
pause
