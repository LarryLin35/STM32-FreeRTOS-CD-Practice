# STM32 FreeRTOS CI/CD 專案實踐 🚀

本專案展示了如何利用現代化 DevOps 工具，為嵌入式系統（STM32）建立一套自動化編譯、打包與發佈的完整流水線。

---

## 🏗 核心自動化流程 (CI/CD Workflow)

當代碼推送到 `main` 或 `dev` 分支時，GitHub Actions 會啟動一個虛擬化環境，執行以下步驟：

1. **Docker 環境隔離**：啟動一個預裝 `gcc-arm-none-eabi` 的 Docker 容器，確保開發環境在任何電腦、任何時間下都是「完全一致」的。
2. **自動交叉編譯**：透過 `make` 指令將 C 原始碼轉化為 STM32 硬體運行的原始韌體 `firmware.bin`。
3. **韌體封裝 (Packaging)**：運行 `pack.py` 腳本，為原始韌體戴上「身分證」。
   - 計算 **SHA-256** 數位指紋。
   - 加上 **Magic Number** (0xABCD1234) 作為識別。
   - 封裝成 OTA 專用的 `production_package.bin`。
4. **環境備份 (Packages)**：將編譯器、代碼、成品全部「快照」存檔為 Docker Image。
5. **正式發佈 (Release)**：自動在 GitHub 產生版本號，掛載韌體檔案並顯示校驗報告。

---

## 📦 Packages vs. Releases：這兩者有什麼差別？

在嵌入式產品開發中，這兩者有著完全不同的戰略意義：

| 特性 | **Packages (GitHub Packages)** | **Releases (GitHub Release)** |
| :--- | :--- | :--- |
| **本質** | Docker Image (時光機/工具箱) | Firmware Assets (成品交付) |
| **內容物** | OS + 編譯器版本 + 當下的 bin | 原始 bin + 打包後的 bin + 校驗文字檔 |
| **對象** | **開發工程師** | **手機 App、測試、最終用戶** |
| **意義** | 確保五年後還能編譯出一模一樣的結果。 | 提供手機 App 透過藍牙傳送給 STM32 更新。 |

---

## 🛡 安全校驗機制 (SHA-256 & Magic Number)

為了應對 **「手機 App -> BGM220 -> STM32」** 複雜的傳輸鏈，我們在韌體開頭加入了 40 Bytes 的 Header：

1. **Magic Number (4B)**: `0xABCD1234`。STM32 開機時會檢查，不對就不跑，防止誤燒或垃圾資料。
2. **Length (4B)**: 告知 STM32 後面有多少資料，避免藍牙斷線造成的數據殘缺。
3. **SHA-256 (32B)**: 數位指紋。STM32 收完後會自行運算並對比，只要傳輸過程錯 1 個 bit，校驗就會失敗，保障系統安全。



---

## 🛠 如何在本地端重現環境？

如果你需要修改代碼並在本地重現與 GitHub 一模一樣的編譯結果，只需執行：

```bash
# 下載此版本對應的開發環境映像檔
docker pull ghcr.io/${{ github.repository_owner }}/stm32-freertos-cd-practice:latest

# 直接從 Package 中提取當時編譯好的成品
docker run --rm ghcr.io/${{ github.repository_owner }}/stm32-freertos-cd-practice:latest ls -l /app
