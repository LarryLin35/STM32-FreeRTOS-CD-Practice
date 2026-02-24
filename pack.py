import hashlib
import struct
import os

# 定義你的「通關密語」 (4 Bytes)
MAGIC_NUMBER = 0xABCD1234  

def pack():
    input_file = "firmware.bin"
    output_file = "production_package.bin"

    if not os.path.exists(input_file):
        print(f"找不到 {input_file}")
        return

    with open(input_file, "rb") as f:
        payload = f.read()

    # 1. 計算 SHA-256
    sha256_hash = hashlib.sha256(payload).digest()
    
    # 2. 獲取檔案長度
    payload_len = len(payload)

    # 3. 建立 Header (小端序)
    # I = 4 bytes unsigned int, 32s = 32 bytes string (SHA-256)
    # 格式：Magic(4B) + Length(4B) + SHA256(32B)
    header = struct.pack('<II32s', MAGIC_NUMBER, payload_len, sha256_hash)

    # 4. 寫入新檔案
    with open(output_file, "wb") as f:
        f.write(header)
        f.write(payload)
    
    print(f"打包成功！已產生 {output_file}")
    print(f"SHA-256: {sha256_hash.hex()}")

if __name__ == "__main__":
    pack()
