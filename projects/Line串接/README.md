# Line 串接專案

> 開始時間：2026-05-21
> 目標：讓金仙可以透過 Line 與老闆對話

---

## ✅ 最終狀態（2026-05-21 完成）

| 項目 | 狀態 | 說明 |
|:---|:---|:---|
| LINE Official Account | ✅ 完成 | 名稱：金仙蝦捲（@329ljuvt） |
| Channel Secret | ✅ 已設定 | 儲存在 openclaw.json |
| Channel Access Token | ✅ 已設定 | 長效 Token，儲存在 openclaw.json |
| 公開隧道 | ✅ 已完成 | **jinxian.serveousercontent.com**（固定網址） |
| Webhook URL | ✅ 已設定 | `https://jinxian.serveousercontent.com/line/webhook` |
| Gateway 服務化 | ✅ 已設定 | systemd 自動重啟 |
| LINE 外掛 | ✅ 已啟用 | @openclaw/line |

---

## 隧道設定歷程

### 第一版：臨時 serveo（不穩定）
- 使用隨機網址，每次重啟 tunnel 網址就變
- 每次變動都要去 LINE Developers 改 Webhook URL
- **問題**：多次斷線，使用者體驗差

### 最終版：固定 serveo（已解決 ✅）
- 註冊 serveo.net 帳號（用 Google/GitHub 登入）
- 綁定 SSH 公鑰，取得固定子域名
- 固定隧道網址：**`https://jinxian.serveousercontent.com`**
- systemd 服務：`serveo-tunnel.service`（`Restart=always`）
- 以後重啟 VM 或服務，網址不會變，LINE 不會斷

---

## 跨通道規則

### Telegram ↔ LINE 溝通方式
- 兩個通道是不同的 session，無法自動互通對話內容
- 需要時老闆說「去看 LINE 對話」，金仙就去翻 session 檔
- 兩邊都讀同一個 workspace 的檔案（memory/、notes/、金仙守則.md）
- 共享筆記本：`notes/金仙蝦捲筆記本.md`
- 金仙守則：`notes/金仙守則.md`（規則 0 + 規則 0.5）

### 記錄 SOP
- 說「記錄一下」→ 寫進 `memory/`
- 說「寫進筆記本」→ 寫進共享筆記本

---

## 規則 0.5 — 重啟前必先告知
2026-05-21 新增至金仙守則。任何會導致服務中斷的操作（重啟 Gateway、更新套件、改設定），必須提前向老闆說明，並告知「待會如果沒回應，麻煩老闆幫忙重啟」。

---

## 待解決

- [x] ~~**LINE 上傳圖片功能**~~ ✅
- [x] ~~**隧道穩定性**~~ ✅（jinxian.serveousercontent.com）
- [x] ~~**跨通道經驗同步**~~ ✅
  - 共享經驗檔：`notes/修復經驗.md`
  - 金仙守則已加入查詢提示
  - 兩邊遇到問題先去查，解了寫回去

## 跨通道經驗同步

### 問題
Telegram 學到的修復經驗（字型、上傳流程），LINE 的金仙蝦捲不會自動知道，因為兩個是不同的 session。

### 解法
建立共享檔案 `notes/修復經驗.md`，兩邊的金仙遇到問題都先去查這個檔案。學會新的解法也寫進去，對方就能讀到。

同時在金仙守則最下方加了提示：「遇到問題先查修復經驗.md，解決了也寫回去。」

### 目前收錄的經驗
1. 中文圖片亂碼 → 用標楷體字型
2. LINE 上傳圖片流程 → upload-public.sh
3. 重啟前告知（規則 0.5）
4. 隧道網址固定方法

### 監控與健康檢查
- 定期檢查 LINE bot 狀態
