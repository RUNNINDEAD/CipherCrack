# 🔐 CipherCrack v3.0.0
A modern multi-tool cryptographic decoder for common ciphers, hashes, and encodings.  
Beginner-friendly, modular, and perfect for **CTFs**, **SOC work**, **DFIR**, or quick security triage.

---

## 🚀 What’s New in 3.0
- Global CLI flags: `--help`, `--version`, `--file <path> --hash`
- Unified SHA-256 hashing system
- Improved interactive menu
- New Tkinter GUI (`ciphercrack_gui.py`)
- Clean refactor of Python codebase
- Updated GitHub documentation

---

## 🧰 Features

### Encoding / Decoding
- Base64  
- Base32  
- ASCII85/Base85  
- Hex  
- URL encode/decode  
- Binary encode/decode  
- Reverse  

### Classical Ciphers
- ROT13  
- ROT47  
- Atbash  
- Caesar (0–25)  
- Vigenère  
- XOR (key-based)  

### Morse Code
- Encode  
- Decode (`/` = space between words)

### Rail Fence Cipher
- Encrypt  
- Decrypt  
- Custom rails + offset

### Hashing
- SHA-256 string hashing  
- SHA-256 file hashing (CLI + menu mode)  
- SHA-256 hash comparison

---

# 📦 Requirements

### Python version
- Python **3.10+** required

### Tkinter (GUI)
Linux:
```bash
sudo apt install python3-tk
```

Fedora:
```bash
sudo dnf install python3-tkinter
```

Windows/macOS: included by default.

---

# ⚙️ Installation

Clone the repository:

```bash
git clone https://github.com/runnindead/ciphercrack.git
cd ciphercrack
```

Run the Python CLI:

```bash
python3 ciphercrack.py
```

Launch GUI:

```bash
python3 ciphercrack_gui.py
```

---

# 🖥️ CLI Usage

### Help
```bash
python3 ciphercrack.py --help
```

### Version
```bash
python3 ciphercrack.py --version
```

### File Hashing (SHA-256)
```bash
python3 ciphercrack.py --file example.bin --hash
```

### Base64 Encoding
```bash
python3 ciphercrack.py base64 --encode "RUNNINDEAD"
```

### URL Decoding
```bash
python3 ciphercrack.py url --decode "hello%20world"
```

### Hash a String
```bash
python3 ciphercrack.py hash --string "Hello World"
```

---

# 🧩 Interactive Menu Mode

Launch interactive mode:

```bash
python3 ciphercrack.py
```

Includes:

- All encoding/decoding tools  
- Classical ciphers  
- Hash utilities  
- File SHA-256 hashing  
- Input validation and error handling  

---

# 🎨 GUI Mode (Tkinter)

Launch:

```bash
python3 ciphercrack_gui.py
```

GUI Features:

- Dropdown menu for algorithms  
- Encoding/decoding toggle  
- SHA-256 compare mode  
- Input/output panels  
- Clipboard buttons  

---

# 📁 Project Structure

```
ciphercrack/
├── ciphercrack.py        # Python CLI + menu tool
├── ciphercrack_gui.py    # GUI application (Tkinter)
└── README.md             # Documentation
```

---

# 🤝 Contributing
Pull requests are welcome.  
CipherCrack is extensible—add new ciphers, algorithms, or GUIs!

---

# 📜 License
Licensed under the **MIT License**.

---

# 💬 Maintainer
**Wil Dennison (RUNNINDEAD)**  
GitHub: https://github.com/runnindead 
LinkedIn: https://www.linkedin.com/in/wil-dennison-9a48a028a/
