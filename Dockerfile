# 使用最輕量的底層
FROM alpine:latest

# 設定工作目錄
WORKDIR /firmware

# 將剛剛在 GitHub Action 編譯好的 firmware.bin 複製進 Image
COPY firmware.bin .

# 當別人執行這個 Image 時，顯示檔案資訊
CMD ["ls", "-l", "/firmware/firmware.bin"]
