@echo off
chcp 65001 >nul
title Uninstall Jinxian Resident Tunnel

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo [*] Removing scheduled task...
schtasks /delete /tn "JinxianTunnel" /f
if %errorlevel% equ 0 (
    echo [OK] Resident tunnel uninstalled
) else (
    echo Task not found or already removed
)
echo.
echo The manual start.bat still works anytime.
pause
