# 📋 金仙資產清冊

> 所有已完成的設定、已申請的服務、已部署的專案
> **任何「這個辦了沒？」的問題，先讀這份檔案，不要靠記憶回答**

---

## 🤖 OpenClaw 環境

| 項目 | 狀態 | 備註 |
|:---|:---:|:---|
| OpenClaw 框架 | ✅ 運行中 | v2026.5.19 |
| 模型：DeepSeek V4 Flash | ✅ 可用 | 1000k context |
| 管理 IP | ✅ 可用 | 192.168.55.48:18789 |

---

## 📡 通道狀態

| 通道 | 身份名稱 | 狀態 | 備註 |
|:---|:---|:---:|:---|
| Telegram | 金仙 (@sgaopenclawbot) | ✅ 正常 | 主要通道 |
| LINE | 蝦捲（金仙蝦捲 @329ljuvt） | ✅ 正常 | 專用工作通道 |
| ClickClack | - | ✅ 啟用 | 未使用 |
| Canvas | - | ✅ 啟用 | http://127.0.0.1:18789/__openclaw__/canvas/ |

### Serveo Tunnel（LINE Webhook）
- 狀態：✅ 運行中
- systemd 服務：`serveo-tunnel.service`（自動重啟）
- 用於 LINE Webhook 接收

---

## 🔑 API / 憑證一覽

| 服務 | 狀態 | 憑證位置 |
|:---|:---:|:---|
| DeepSeek API | ✅ 已設定 | `openclaw.json models.providers.deepseek.apiKey` |
| LINE Channel | ✅ 已設定 | `openclaw.json channels.line` |
| Telegram Bot | ✅ 已設定 | `openclaw.json channels.telegram` |
| ElevenLabs TTS | ✅ 已設定 | `openclaw.json env.ELEVENLABS_API_KEY` |
| GitHub Token | ✅ 已設定 | `notes/github-config.env` |
| GitHub Pages | ✅ 已上線 | `ls25035500-tech/jinxian-dashboard` |

---

## 🌐 GitHub Pages 網站

| 項目 | 內容 |
|:---|:---|
| Repo | `ls25035500-tech/jinxian-dashboard` |
| Push Token | ✅ 已存於 `notes/github-config.env` |
| 儀表板首頁 | https://ls25035500-tech.github.io/jinxian-dashboard/ |
| 本機工作目錄 | `/tmp/gh-pages/` |
| 已上傳檔案 | index.html, report-55-ip.html, yt-report.html, excel-nas-troubleshoot.html |

---

## 📞 東訊 SDX500 自動化

| 項目 | 狀態 | 備註 |
|:---|:---:|:---|
| 自動化腳本 | ✅ 已完成 | `projects/SDX500自動化/` |
| 分機改號 1698↔1699 | ✅ 驗證通過 | Python requests 模擬 HTTP POST |
| 設定備份 + Email | ✅ 可行 | `email_sender.py` |
| 完整設定報告 | ✅ 已產出 | `SDX500_完整設定報告.md` |
| 設定比對報告 | ✅ 已產出 | `backups/config_compare/` |

---

## 🔒 網路設備

| 設備 | IP | 帳密 | 備註 |
|:---|:---:|:---|:---|
| 閘道器 | 192.168.55.1 | - | Linux 主機 |
| 交換器 PLANET GS4210-24P4C | 192.168.55.254 | admin/admin | 28埠 |
| 接取層控制器 | 192.168.55.28 | admin/1234 | 網管系統 |
| NAS Public | 192.168.55.26 | sga/*** | 檔案共用 |

### IP 封鎖 SOP
- 檔案：`docs/network-block-sop.md`
- 方法：telnet 192.168.55.254 → configure → interface giX → shutdown

---

## 🔄 NAS 即時同步

| 項目 | 狀態 |
|:---|:---:|
| NAS 掛載 | ✅ `/mnt/nas-public` |
| 即時同步腳本 | ✅ `tools/real-time-sync.sh` |
| systemd 服務 | ✅ `realtime-nas-sync.service` |
| 同步方向 | workspace → NAS |

---

## 🎤 語音功能（ElevenLabs TTS）

| 項目 | 狀態 |
|:---|:---:|
| API Key | ✅ 已設定 |
| 方案 | B：本機 TTS（免費，不常用） |
| 觸發方式 | 結尾加「用說的」 |

---

## 🗂️ 專案目錄

| 專案 | 狀態 | 位置 |
|:---|:---:|:---|
| 找MIS來一下 | 🔶 待討論 | `projects/找MIS來一下/` |
| 聯昇廣告 | ✅ 已完成 | `projects/lienshen-ad/` |
| SDX500 自動化 | ✅ 已完成 | `projects/SDX500自動化/` |
| LINE 串接 | ✅ 已完成 | `projects/Line串接/` |
| 報價單系統 | 🔶 進行中 | `projects/sales-quotations/` |

---

## ⚠️ 待辦事項

- [ ] 找MIS需求討論（全職/兼職/工作內容）
- [ ] 確認蝦捲（LINE agent）的 multi-agent 設定是否正常運作（2026-05-22 設定）
