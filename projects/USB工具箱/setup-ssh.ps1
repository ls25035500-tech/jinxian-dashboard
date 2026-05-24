# 🦐 金仙 USB 工具箱 — SSH 自動設定
# 以系統管理員權限執行

Write-Host "🔧 檢查 Windows SSH Server..."

# 檢查 SSH 是否已安裝
$sshd = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
if ($sshd.State -ne "Installed") {
    Write-Host "📦 安裝 OpenSSH Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}

# 啟動 SSH 服務
$service = Get-Service sshd -ErrorAction SilentlyContinue
if (-not $service) {
    Write-Host "❌ SSH 服務不存在，請確認 Windows 版本 (需 Win10 1809+)"
    exit 1
}

if ($service.Status -ne "Running") {
    Write-Host "▶️ 啟動 SSH Server..."
    Start-Service sshd
}

Set-Service -Name sshd -StartupType Automatic

# 開防火牆
Write-Host "🔓 設定防火牆..."
$rule = Get-NetFirewallRule -Name "OpenSSH-金仙" -ErrorAction SilentlyContinue
if (-not $rule) {
    New-NetFirewallRule -Name "OpenSSH-金仙" -DisplayName "金仙 USB SSH" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}

Write-Host "✅ SSH Server 已就緒"
