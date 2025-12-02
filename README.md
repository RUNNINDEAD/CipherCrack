# 🔐 CipherCrack v3.0.0
A modern multi-tool cryptographic decoder for common ciphers, hashes, and encodings.  
Beginner-friendly, modular, and perfect for **CTFs**, **SOC work**, **DFIR**, or quick security triage.

---

## 🚀 What’s New in 3.0
- Global CLI flags: `--help`, `--version`, `--file <path> --hash`
- Refactored and cleaned Python core
- Interactive menu improvements
- Unified hash system using **SHA-256**
- New Tkinter GUI application (`ciphercrack_gui.py`)
- Better documentation and project structure

---

## 🧰 Features

### Encoding / Decoding
- Base64 encode/decode  
- Base32 encode/decode  
- ASCII85/Base85 encode/decode  
- Hex encode/decode  
- URL encode/decode  
- Binary encode/decode  
- Reverse text  

### Classical Ciphers
- ROT13  
- ROT47  
- Atbash  
- Caesar (shift 0–25)  
- Vigenère  
- XOR (key-based)  

### Morse Code
- Encode  
- Decode (`/` = space between words)  

### Rail Fence Cipher
- Encrypt  
- Decrypt  
- Supports custom rails + offset  

### Hashing
- SHA-256 string hashing  
- SHA-256 file hashing  
- SHA-256 compare mode  

---
