#!/bin/bash
# 小雞大逃亡備份腳本 (每日 04:00 自動執行)
BACKUP_DIR="/home/sga/.openclaw/workspace/bots/機器人大逃亡隨身碟"
NAS_RECOVERY_DIR="/home/sga/.openclaw/workspace/NAS_26_回收站"
mkdir -p "$BACKUP_DIR"
mkdir -p "$NAS_RECOVERY_DIR"

DATE=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="xiaoji_brain_${DATE}.tar.gz"

echo "1/2 正在從 NAS 26 拉回所有殘留與關聯檔案..."
# 嘗試使用 smbclient 將 NAS 上的相關檔案收回到本機
# 若老闆後續有設定密碼，可將 guest% 替換
smbclient //192.168.55.26/Public -U guest% -c "prompt OFF; recurse ON; cd 小CALL; mget *" >/dev/null 2>&1 || true
# 收回的檔案都會統一把放在 $NAS_RECOVERY_DIR 一起打包

echo "2/2 正在打包小雞大腦 (設定檔、記憶、腳本、對話歷史)..."
# 注意：已移除對 node_modules 的排除，確保所有相依套件全部離線打包，不需要網路！
cd /home/sga
tar --exclude='.openclaw/agents/main/sessions/sessions.json.bak' \
    --exclude='.openclaw/workspace/bots/機器人大逃亡隨身碟/*.tar.gz' \
    -czf "/tmp/$ARCHIVE_NAME" \
    .openclaw/openclaw.json \
    .openclaw/workspace \
    .openclaw/agents

mv "/tmp/$ARCHIVE_NAME" "$BACKUP_DIR/$ARCHIVE_NAME"

# ================= 產生 100% 完全斷網還原腳本 =================
cat << 'EOF' > "$BACKUP_DIR/一鍵復活_restore.sh"
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
EOF

chmod +x "$BACKUP_DIR/一鍵復活_restore.sh"

cd "$BACKUP_DIR"
ls -t xiaoji_brain_*.tar.gz | tail -n +6 | xargs -r rm --

echo "✅ 備份完成！"