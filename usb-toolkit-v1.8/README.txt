Jinxian USB Toolkit v1.8
=========================

Files:
  start.bat        - Main entry point (double-click to run)
  setup-ssh.ps1    - SSH installation & configuration script
  jx_key           - SSH private key for tunnel authentication
  jx_key.pub       - SSH public key

Requirements:
  - Windows 10/11 (64-bit)
  - Administrator privileges
  - Internet connection (for Pinggy tunnel)

What it does:
  1. Checks all toolkit files are present (no more silent crashes!)
  2. Installs/configures OpenSSH Server
  3. Creates remote access account (jxhelper / Jinxian@2026)
  4. Opens firewall for SSH (port 22)
  5. Starts Pinggy reverse tunnel

v1.8 Changes:
  - Added error handling: missing files now show clear messages
  - Added SSH client check before attempting tunnel
  - Better path/directory detection
  - No more silent exit on missing jx_key
