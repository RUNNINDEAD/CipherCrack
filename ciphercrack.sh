#!/usr/bin/env bash

VERSION="3.0"

ascii_art='
 _____ _       _               _____                _    
/  __ (_)     | |             /  __ \              | |   
| /  \/_ _ __ | |__   ___ _ __| /  \/_ __ __ _  ___| | __
| |   | | '\''_ \| '\''_ \ / _ \ '\''__| |   | '\''__/ _` |/ __| |/ / 
| \__/\ | |_) | | | |  __/ |  | \__/\ | | (_| | (__|   <  
 \____/_| .__/|_| |_|\___|_|   \____/_|  \__,_|\___|_|\_\ 
        | |                                              
        |_|                                             
'

print_art() {
    printf "%s\n" "$ascii_art"
}

base64_op() {
    local mode="$1" text="$2"
    mode="${mode,,}"
    if [[ "$mode" == "encode" ]]; then
        printf "%s" "$text" | base64
    elif [[ "$mode" == "decode" ]]; then
        printf "%s" "$text" | base64 -d 2>/dev/null || echo "Base64 error"
    else
        echo "Invalid Base64 mode."
    fi
}

base32_op() {
    local mode="$1" text="$2"
    mode="${mode,,}"
    if [[ "$mode" == "encode" ]]; then
        printf "%s" "$text" | base32
    elif [[ "$mode" == "decode" ]]; then
        printf "%s" "$text" | base32 --decode 2>/dev/null || echo "Base32 error"
    else
        echo "Invalid Base32 mode."
    fi
}

ascii85_op() {
    local mode="$1" text="$2"
    python3 - "$mode" "$text" <<'PY'
import sys, base64
mode = sys.argv[1].lower()
text = sys.argv[2]
try:
    if mode == "encode":
        print(base64.a85encode(text.encode()).decode())
    elif mode == "decode":
        print(base64.a85decode(text).decode())
    else:
        print("Invalid ASCII85 mode.")
except Exception as e:
    print(f"ASCII85 error: {e}")
PY
}

url_op() {
    local mode="$1" text="$2"
    python3 - "$mode" "$text" <<'PY'
import sys, urllib.parse
mode = sys.argv[1].lower()
text = sys.argv[2]
if mode == "encode":
    print(urllib.parse.quote(text))
elif mode == "decode":
    print(urllib.parse.unquote(text))
else:
    print("Invalid URL mode.")
PY
}

string_hash_sha256() {
    local text="$1"
    printf "%s" "$text" | sha256sum 2>/dev/null | awk '{print $1}'
}

file_hash_sha256() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found."
        return
    fi
    sha256sum "$file" 2>/dev/null | awk '{print $1}' || echo "File hash error."
}

hash_compare_sha256() {
    local input_str="$1" hashed_str="$2"
    local computed
    computed="$(string_hash_sha256 "$input_str")"
    if [[ "$computed" == "$hashed_str" ]]; then
        echo "Match!"
    else
        echo "Does not match."
    fi
}

binary_op() {
    local mode="$1" text="$2"
    mode="${mode,,}"
    if [[ "$mode" == "encode" ]]; then
        local i char code bin
        for ((i=0; i<${#text}; i++)); do
            char="${text:i:1}"
            printf -v code '%d' "'$char"
            bin=$(echo "obase=2;$code" | bc 2>/dev/null)
            printf "%08s " "$bin"
        done
        echo
    elif [[ "$mode" == "decode" ]]; then
        local out="" bit
        for bit in $text; do
            local code=$((2#$bit))
            printf -v ch '\\%03o' "$code"
            printf "%b" "$ch"
        done
        echo
    else
        echo "Invalid binary mode."
    fi
}

rot13_op() {
    local text="$1"
    printf "%s" "$text" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
    echo
}

rot47_op() {
    local text="$1"
    python3 - "$text" <<'PY'
import sys
text = sys.argv[1]
out = []
for ch in text:
    o = ord(ch)
    if 33 <= o <= 126:
        out.append(chr(33 + ((o - 33 + 47) % 94)))
    else:
        out.append(ch)
print("".join(out))
PY
}

atbash_op() {
    local text="$1"
    python3 - "$text" <<'PY'
import sys
text = sys.argv[1]
out = []
for c in text:
    if 'A' <= c <= 'Z':
        out.append(chr(155 - ord(c)))
    elif 'a' <= c <= 'z':
        out.append(chr(219 - ord(c)))
    else:
        out.append(c)
print("".join(out))
PY
}

hex_op() {
    local mode="$1" text="$2"
    mode="${mode,,}"
    if [[ "$mode" == "encode" ]]; then
        printf "%s" "$text" | xxd -p | tr -d '\n'
        echo
    elif [[ "$mode" == "decode" ]]; then
        printf "%s" "$text" | xxd -p -r 2>/dev/null || echo "Hex error"
    else
        echo "Invalid hex mode."
    fi
}

reverse_op() {
    local text="$1"
    printf "%s" "$text" | rev
}

print_help() {
    print_art
    echo "Usage:"
    echo "  $0                          # Interactive menu"
    echo "  $0 --file <path> --hash     # SHA256 hash of a file"
    echo "  $0 -m <method> -a <action> -t <text>"
    echo "  $0 -m <method> -t <text>    # for one-way ciphers (rot13, rot47, atbash, reverse, sha256)"
    echo "  $0 --version"
    echo "  $0 --help"
    echo
    echo "Methods:"
    echo "  base64, base32, ascii85, url, binary, hex"
    echo "  rot13, rot47, atbash, reverse, sha256"
    echo
    echo "Actions (where applicable):"
    echo "  encode | decode"
    echo
    echo "Examples:"
    echo "  $0 -m base64 -a encode -t \"hello\""
    echo "  $0 -m base64 -a decode -t \"aGVsbG8=\""
    echo "  $0 -m rot13 -t \"Hello World\""
    echo "  $0 --file secret.txt --hash"
}

menu_mode() {
    print_art
    while true; do
        echo
        echo "Choose an option:"
        echo "1. Base64"
        echo "2. SHA256 Hash Compare"
        echo "3. Binary"
        echo "4. ROT13"
        echo "5. ROT47"
        echo "6. Atbash"
        echo "7. Hex"
        echo "8. Base32"
        echo "9. ASCII85"
        echo "10. URL Encode/Decode"
        echo "11. Reverse"
        echo "12. File SHA256 Hash"
        echo "0. Exit"
        read -r -p "Enter your choice: " choice

        case "$choice" in
            1)
                read -r -p "Mode [encode/decode]: " mode
                read -r -p "Enter text: " text
                base64_op "$mode" "$text"
                ;;
            2)
                read -r -p "Enter original string: " original
                read -r -p "Enter SHA256 hash: " hashed
                hash_compare_sha256 "$original" "$hashed"
                ;;
            3)
                read -r -p "Mode [encode/decode]: " mode
                read -r -p "Enter text: " text
                binary_op "$mode" "$text"
                ;;
            4)
                read -r -p "Enter text: " text
                rot13_op "$text"
                ;;
            5)
                read -r -p "Enter text: " text
                rot47_op "$text"
                ;;
            6)
                read -r -p "Enter text: " text
                atbash_op "$text"
                ;;
            7)
                read -r -p "Mode [encode/decode]: " mode
                read -r -p "Enter text: " text
                hex_op "$mode" "$text"
                ;;
            8)
                read -r -p "Mode [encode/decode]: " mode
                read -r -p "Enter text: " text
                base32_op "$mode" "$text"
                ;;
            9)
                read -r -p "Mode [encode/decode]: " mode
                read -r -p "Enter text: " text
                ascii85_op "$mode" "$text"
                ;;
            10)
                read -r -p "Mode [encode/decode]: " mode
                read -r -p "Enter text: " text
                url_op "$mode" "$text"
                ;;
            11)
                read -r -p "Enter text: " text
                reverse_op "$text"
                echo
                ;;
            12)
                read -r -p "Enter file path: " filepath
                file_hash_sha256 "$filepath"
                ;;
            0)
                echo "Exiting..."
                break
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac
    done
}

main() {
    # If no args: interactive menu
    if [[ $# -eq 0 ]]; then
        menu_mode
        return
    fi

    local METHOD="" ACTION="" TEXT="" FILE=""
    local HASH_FLAG=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help)
                print_help
                exit 0
                ;;
            --version)
                echo "Cipher Tool Version: $VERSION"
                exit 0
                ;;
            --file)
                FILE="$2"
                shift 2
                ;;
            --hash)
                HASH_FLAG=1
                shift
                ;;
            -m|--method)
                METHOD="$2"
                shift 2
                ;;
            -a|--action)
                ACTION="$2"
                shift 2
                ;;
            -t|--text)
                TEXT="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                print_help
                exit 1
                ;;
        esac
    done

    # File hash mode
    if [[ -n "$FILE" && $HASH_FLAG -eq 1 ]]; then
        print_art
        echo "File: $FILE"
        echo "SHA256: $(file_hash_sha256 "$FILE")"
        exit 0
    fi

    # CLI cipher mode
    if [[ -n "$METHOD" && -n "$TEXT" ]]; then
        case "${METHOD,,}" in
            base64)
                [[ -z "$ACTION" ]] && ACTION="encode"
                base64_op "$ACTION" "$TEXT"
                ;;
            base32)
                [[ -z "$ACTION" ]] && ACTION="encode"
                base32_op "$ACTION" "$TEXT"
                ;;
            ascii85)
                [[ -z "$ACTION" ]] && ACTION="encode"
                ascii85_op "$ACTION" "$TEXT"
                ;;
            url)
                [[ -z "$ACTION" ]] && ACTION="encode"
                url_op "$ACTION" "$TEXT"
                ;;
            binary)
                [[ -z "$ACTION" ]] && ACTION="encode"
                binary_op "$ACTION" "$TEXT"
                ;;
            hex)
                [[ -z "$ACTION" ]] && ACTION="encode"
                hex_op "$ACTION" "$TEXT"
                ;;
            rot13)
                rot13_op "$TEXT"
                ;;
            rot47)
                rot47_op "$TEXT"
                ;;
            atbash)
                atbash_op "$TEXT"
                ;;
            reverse)
                reverse_op "$TEXT"; echo
                ;;
            sha256)
                string_hash_sha256 "$TEXT"
                ;;
            *)
                echo "Unknown method: $METHOD"
                print_help
                exit 1
                ;;
        esac
        exit 0
    fi

    # If we got here, args were incomplete
    print_help
    exit 1
}

main "$@"
