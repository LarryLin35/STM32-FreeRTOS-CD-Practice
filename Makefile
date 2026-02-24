# 設定編譯器
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

# 設定 FreeRTOS 原始碼下載位置 (練習用，我們直接從 GitHub 抓)
FREERTOS_URL = https://github.com/FreeRTOS/FreeRTOS-Kernel/archive/refs/tags/V10.5.1.tar.gz

all:
	@echo "開始下載 FreeRTOS 核心..."
	curl -L $(FREERTOS_URL) | tar xz
	@echo "模擬編譯 STM32 + FreeRTOS..."
	# 這裡模擬編譯動作，產生一個假的 bin 檔
	echo "This is a fake STM32+FreeRTOS Binary" > firmware.bin
	@echo "編譯成功！"

clean:
	rm -rf FreeRTOS-Kernel-10.5.1 firmware.bin
