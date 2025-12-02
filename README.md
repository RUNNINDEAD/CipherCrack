# 🔐 CipherCrack v3.0.0

CipherCrack is a cross-platform cryptography and encoding toolkit written in **Python**, with optional **Bash** and **PowerShell (Linux pwsh)** companion scripts.

It supports fast encoding/decoding, classical cipher operations, SHA-256 hashing, and file hashing. Perfect for CTFs, cybersecurity students, threat analysis, or quick SOC triage.

---

## 🚀 Features

### Encoding / Decoding
- Base64  
- Base32  
- ASCII85 / Base85  
- Hex (encode/decode)  
- Binary (encode/decode)  
- URL encode/decode  
- Reverse text  

### Classical Ciphers
- ROT13  
- ROT47  
- Atbash  
- Caesar (shift 0–25)  
- Vigenère (alpha key)  
- XOR (encode → hex, decode from hex)

### Hashing (SHA-256)
- Hash strings  
- Hash files  
- Compare computed hash vs user input  

---

# 📦 Requirements

### Python  
- Python **3.10+** (for match/case)

### Bash Script  
- Works on any Linux/macOS with:
  - `bash`
  - `base64`, `base32`, `rev`, `xxd`
  - `python3` (for XOR, ASCII85 helpers)

### PowerShell (Linux Only)  
- Requires **PowerShell 7+**
- Installed as `pwsh` on Linux systems  

---

# 🐍 Python Usage

### Run interactive menu:
```bash
python3 ciphercrack.py
```

### Show help:
```bash
python3 ciphercrack.py --help
```

### Show version:
```bash
python3 ciphercrack.py --version
```

### Hash a file (SHA-256):
```bash
python3 ciphercrack.py --file secrets.txt --hash
```

### Example: Base64 encode
```bash
python3 ciphercrack.py base64 --encode "RUNNINDEAD"
```

---

# 🖥️ Bash Script Usage (`ciphercrack.sh`)

### Run interactive menu:
```bash
./ciphercrack.sh
```

### Show help:
```bash
./ciphercrack.sh --help
```

### Show version:
```bash
./ciphercrack.sh --version
```

### Hash a file:
```bash
./ciphercrack.sh --file payload.bin --hash
```

---

# 🧩 PowerShell Usage (Linux Only — `pwsh`)

### Interactive menu:
```bash
pwsh -File ciphercrack.ps1
```

### Show help:
```bash
pwsh -File ciphercrack.ps1 -Help
```

### Show version:
```bash
pwsh -File ciphercrack.ps1 -ShowVersion
```

### Hash a file:
```bash
pwsh -File ciphercrack.ps1 -File report.pdf -Hash
```

---

# 📁 Project Structure

```
CipherCrack/
├── ciphercrack.py
├── ciphercrack.sh
├── ciphercrack.ps1
└── README.md
```

---

# 📜 License  
MIT License
