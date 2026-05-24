# Jinxian USB Toolkit - SSH Setup v1.3
# Skip Windows Update check - just start the service

Write-Host "Checking SSH Server..."
$service = Get-Service sshd -ErrorAction SilentlyContinue

if ($service) {
    # Already installed
    if ($service.Status -ne "Running") {
        Write-Host "Starting SSH Server..."
        Start-Service sshd
    }
    Set-Service -Name sshd -StartupType Automatic
    Write-Host "[OK] SSH Server already installed and running"
} else {
    # Not installed - quick install
    Write-Host "SSH not found. Installing..."
    try {
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction Stop
        Start-Service sshd
        Set-Service -Name sshd -StartupType Automatic
        Write-Host "[OK] SSH Server installed"
    } catch {
        Write-Host "[FAIL] Cannot install SSH. Need Win10 1809+."
        Write-Host "Install manually: Settings -> Apps -> Optional Features -> OpenSSH Server"
        exit 1
    }
}

# Firewall rule
$rule = Get-NetFirewallRule -Name "OpenSSH-Jinxian" -ErrorAction SilentlyContinue
if (-not $rule) {
    Write-Host "Adding firewall rule..."
    New-NetFirewallRule -Name "OpenSSH-Jinxian" -DisplayName "Jinxian USB SSH" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 | Out-Null
}

Write-Host "[OK] SSH Server ready"
