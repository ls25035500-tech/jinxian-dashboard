# Jinxian USB Toolkit - SSH Setup
# Run as Administrator

Write-Host "Checking Windows SSH Server..."

$sshd = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
if ($sshd.State -ne "Installed") {
    Write-Host "Installing OpenSSH Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}

$service = Get-Service sshd -ErrorAction SilentlyContinue
if (-not $service) {
    Write-Host "[FAIL] SSH service not found. Need Win10 1809+."
    exit 1
}
if ($service.Status -ne "Running") {
    Start-Service sshd
}
Set-Service -Name sshd -StartupType Automatic

$rule = Get-NetFirewallRule -Name "OpenSSH-Jinxian" -ErrorAction SilentlyContinue
if (-not $rule) {
    New-NetFirewallRule -Name "OpenSSH-Jinxian" -DisplayName "Jinxian USB SSH" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}

Write-Host "[OK] SSH Server ready"
