# CipherCrack v2.0.0

> A multi-tool cryptographic decoder for common ciphers, hashes, and encodings. Beginner-friendly, modular, and great for CTFs, education, or quick security triage.  

---

## ✨ What’s New in 2.0

- **Switch-style routing** via Python 3.10+ `match/case` for cleaner, faster menus and ops.
- **New ciphers/utilities**:
  - Caesar, Vigenère, XOR (with key), ROT47
  - Morse **encode** (you already had decode)
  - Rail Fence **encrypt** (you already had decrypt)
  - Base32, ASCII85 (A85), URL encode/decode, Reverse
- **Improved hashing:** single `hash_compare` supporting `sha256` and `md5`.
- **New helper script:** `scripts/detect_encoding.sh` to probe unknown strings against Base64/32/85, URL, ROT13, Hex, etc.

> v2.0.0 — September 8, 2025 (America/Chicago)

---

## 🧰 Features

**Core (expanded in 2.0):**
- Base64 **encode/decode**
- **SHA-256 / MD5** hash compare
- Binary **encode/decode**
- **ROT13** encode/decode
- **Morse** encode/decode (`/` between words)
- **Rail Fence** encrypt/decrypt (key ≥ 2; optional offset)
- **Hex** encode/decode
- **Atbash** (symmetric)
- **Caesar** encode/decode (shift 0–25)
- **Vigenère** encode/decode (alpha key recommended)
- **XOR** (encode/decode → hex; and `decode-hex`)
- **ROT47** encode/decode
- **Base32** encode/decode
- **ASCII85 (Base85/A85)** encode/Decode
- **URL** encode/decode
- **Reverse** encode/decode

> These extend your v1.x set (Base64, SHA-256/MD5, Binary↔Text, ROT13, Morse, Rail Fence **decode**, Hex, Atbash). :contentReference[oaicite:2]{index=2}

---

## 🖥️ Requirements

- **Python 3.10+** (for `match/case`)
- (Optional) For the Bash detector script: GNU `base64`, `base32`, `xxd`, and Python (for Base85 helpers)
- **Note for Binary math on older Bash tooling:** you previously recommended installing `bc`; keep if you rely on shell-side binary math in other scripts:  
  - Ubuntu/Debian: `sudo apt update && sudo apt install bc`  
  - Fedora: `sudo dnf install bc` :contentReference[oaicite:3]{index=3}

---

## 🚀 Quick Start

### Run the interactive tool
```bash
python ciphercrack.py
