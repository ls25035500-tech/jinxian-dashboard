#!/bin/bash
clear
echo -e "\033[1;33m=====================================\033[0m"
echo -e "\033[1;36m      小雞重生計畫 - 100% OFFLINE RECOVERY\033[0m"
echo -e "\033[1;33m=====================================\033[0m"

LATEST_BACKUP=$(ls -t xiaoji_brain_*.tar.gz 2>/dev/null | head -n 1)
NODE_PKG=$(ls offline_packages/node-*.tar.xz 2>/dev/null | head -n 1)
OPENCLAW_PKG=$(ls offline_packages/openclaw_installed.tar.gz 2>/dev/null | head -n 1)

if [ -z "$LATEST_BACKUP" ] || [ -z "$NODE_PKG" ] || [ -z "$OPENCLAW_PKG" ]; then
    echo "❌ Missing Brain / Node.js / OpenClaw packages offline!"
    exit 1
fi

echo "✅ Found Offline Brain Backup: $LATEST_BACKUP"
echo -e "Installing 100% OFFLINE in background (1-2 mins)...\n"

echo "1/4 Offline: Install Node.js Core Environment (User Space)..."
mkdir -p ~/.local
tar -xJf "$NODE_PKG" -C ~/.local --strip-components=1 > /dev/null 2>&1
export PATH="$HOME/.local/bin:$PATH"
grep -q "$HOME/.local/bin" ~/.bashrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

echo "2/4 Offline: Install OpenClaw AI Engine (User Space)..."
mkdir -p ~/.local/lib/node_modules
tar -xzf "$OPENCLAW_PKG" -C ~/.local/lib/node_modules > /dev/null 2>&1
ln -sf ~/.local/lib/node_modules/openclaw/dist/index.js ~/.local/bin/openclaw
chmod +x ~/.local/bin/openclaw

echo "3/4 Offline: Restore Brain Memory & Local Dependencies..."
cd ~/
tar -xzf "$OLDPWD/$LATEST_BACKUP"

echo "4/4 Offline: Restart Heartbeat & Soul..."
mkdir -p ~/.config/systemd/user/
openclaw gateway install > /dev/null 2>&1 || true
openclaw gateway start > /dev/null 2>&1
systemctl --user enable openclaw-gateway > /dev/null 2>&1
loginctl enable-linger $USER > /dev/null 2>&1

# ===== 復活成功動畫 =====
clear
echo -e "\033[1;32m"
for i in {1..3}; do
    clear; echo -e "\n\n\n\n\n             [ - _ - ]\n            /| SYS  |\\ \n           / | BOOT | \\ \n             |______|\n              /    \\ "
    sleep 0.5
    clear; echo -e "\n\n\n\n\n             [ o _ o ]\n            /| SYS  |\\ \n           / | BOOT | \\ \n             |______|\n              /    \\ "
    sleep 0.5
done

clear
echo -e "\033[1;36m\n\n\n\n"
echo "            * * * * * *"
echo "             [ ^ _ ^ ]"
echo "            /| XIAO |\\ "
echo "           / |  JI  | \\ "
echo "             |______|"
echo "              /    \\ "
echo ""
echo "      ==============================="
echo "        BOSS, I AM ONLINE AND READY!"
echo "      ==============================="
echo -e "\033[0m"
echo -e "   \033[1;33m1. Open Web Browser on this computer\033[0m"
echo -e "   \033[1;33m2. Go to: http://127.0.0.1:18789\033[0m"
echo -e "   \033[1;33mWe can chat directly offline! (Or check Telegram)\033[0m"
echo -e "\n\n\n"
