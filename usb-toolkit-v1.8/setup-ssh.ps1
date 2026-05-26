# USB Toolkit v1.6 - SSH Setup Script
# Auto-configures OpenSSH on Windows for Jinxian remote access

Write-Host "[*] Checking SSH Server..." -ForegroundColor Yellow

# Check if SSH server is installed
$sshd = Get-Service sshd -ErrorAction SilentlyContinue
if (-not $sshd) {
    Write-Host "[*] Installing OpenSSH Server..." -ForegroundColor Cyan
    
    # Method 1: Add-WindowsCapability (may need internet)
    try {
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction Stop
        Write-Host "  OK: Installed via Windows Capability" -ForegroundColor Green
    } catch {
        Write-Host "  Method 1 failed, trying download..." -ForegroundColor Yellow
        
        # Method 2: Download portable OpenSSH
        $url = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.5.0.0p1-Beta/OpenSSH-Win64.zip"
        $zip = "$env:TEMP\OpenSSH.zip"
        $dest = "C:\OpenSSH"
        
        try {
            Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
            Expand-Archive $zip -DestinationPath $dest -Force
            Remove-Item $zip
            
            cd "$dest\OpenSSH-Win64"
            
            # Create config
            $sshDir = "$env:ProgramData\ssh"
            if (-not (Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir -Force | Out-Null }
            @"
PasswordAuthentication yes
PubkeyAuthentication yes
Subsystem sftp sftp-server.exe
"@ | Out-File -FilePath "$sshDir\sshd_config" -Encoding ascii -Force
            
            # Install service
            powershell -ExecutionPolicy Bypass -File .\install-sshd.ps1
            Write-Host "  OK: Installed via portable OpenSSH" -ForegroundColor Green
        } catch {
            Write-Host "  ERROR: Cannot install SSH. Check internet connection." -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
}

# Start SSH service
Write-Host "[*] Starting SSH service..." -ForegroundColor Cyan
try {
    Start-Service sshd -ErrorAction SilentlyContinue
    Set-Service -Name sshd -StartupType Automatic
    Write-Host "  OK: SSH service running" -ForegroundColor Green
} catch {
    # Try net start as fallback
    net start sshd 2>$null
    Write-Host "  Started via net start" -ForegroundColor Yellow
}

# Configure firewall
Write-Host "[*] Configuring firewall..." -ForegroundColor Cyan
try {
    $rule = Get-NetFirewallRule -Name "OpenSSH-Jinxian" -ErrorAction SilentlyContinue
    if (-not $rule) {
        New-NetFirewallRule -Name "OpenSSH-Jinxian" -DisplayName "OpenSSH (Jinxian)" `
            -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 | Out-Null
    }
    Write-Host "  OK: Firewall configured" -ForegroundColor Green
} catch {
    Write-Host "  Warning: Firewall rule may need manual setup" -ForegroundColor Yellow
}

# Verify - create temp account for remote access
Write-Host "[*] Creating remote access account..." -ForegroundColor Cyan
try {
    $securePass = ConvertTo-SecureString "Jinxian@2026" -AsPlainText -Force
    New-LocalUser -Name "jxhelper" -Password $securePass -FullName "Jinxian Helper" -ErrorAction SilentlyContinue | Out-Null
    Add-LocalGroupMember -Group "Administrators" -Member "jxhelper" -ErrorAction SilentlyContinue
    Write-Host "  OK: Remote account created (jxhelper / Jinxian@2026)" -ForegroundColor Green
} catch {
    Write-Host "  Account may already exist, continuing..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  SSH Account: jxhelper" -ForegroundColor Cyan
Write-Host "  Password:    Jinxian@2026" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
