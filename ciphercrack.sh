#!/usr/bin/env bash

ascii_art='
 _____ _       _               _____                _    
/  __ (_)     | |             /  __ \              | |   
| /  \/_ _ __ | |__   ___ _ __| /  \/_ __ __ _  ___| | __
| |   | | '"'"'_ \| '"'"'_ \ / _ \ '"'"'__| |   | '"'"'__/ _` |/ __| |/ / 
| \__/\ | |_) | | | |  __/ |  | \__/\ | | (_| | (__|   <  
 \____/_| .__/|_| |_|\___|_|   \____/_|  \__,_|\___|_|\_\ 
        | |                                              
        |_|                                              
'
echo "$ascii_art"

while true; do
  echo
  echo "Choose an option:"
  echo "1. Base64"
  echo "2. Hash Compare (SHA256/MD5)"
  echo "3. Binary"
  echo "4. ROT13"
  echo "5. ROT47"
  echo "6. Atbash"
  echo "7. Hex"
  echo "8. Base32"
  echo "9. ASCII85"
  echo "10. URL Encode/Decode"
  echo "11. Reverse"
  echo "0. Exit"
  read -rp "Enter your choice: " choice

  case "$choice" in
    1)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      if [[ $mode == "encode" ]]; then
        echo "$text" | base64
      else
        echo "$text" | base64 -d 2>/dev/null || echo "Invalid Base64 input"
      fi
      ;;
    2)
      read -rp "Algorithm [sha256/md5]: " alg
      read -rp "Enter original string: " orig
      read -rp "Enter hash: " hashval
      case "$alg" in
        sha256)
          calc=$(printf "%s" "$orig" | sha256sum | awk '{print $1}')
          ;;
        md5)
          calc=$(printf "%s" "$orig" | md5sum | awk '{print $1}')
          ;;
        *)
          echo "Unsupported algorithm"
          continue
          ;;
      esac
      [[ "$calc" == "$hashval" ]] && echo "Match!" || echo "Does not match."
      ;;
    3)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      if [[ $mode == "encode" ]]; then
        for ((i=0; i<${#text}; i++)); do
          printf "%08d " "$(echo "obase=2; $(printf "%d" "'${text:$i:1}")" | bc)"
        done
        echo
      else
        out=""
        for b in $text; do
          out+=$(printf "\\$(printf '%03o' "$((2#$b))")")
        done
        echo "$out"
      fi
      ;;
    4)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      echo "$text" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
      ;;
    5)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      out=""
      for ((i=0; i<${#text}; i++)); do
        o=$(printf "%d" "'${text:$i:1}")
        if (( o >= 33 && o <= 126 )); then
          out+=$(printf "\\$(printf '%03o' $((33 + ((o - 33 + 47) % 94))))")
        else
          out+=${text:$i:1}
        fi
      done
      echo "$out"
      ;;
    6)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      out=""
      for ((i=0; i<${#text}; i++)); do
        c="${text:$i:1}"
        case "$c" in
          [A-Z]) out+=$(printf "\\$(printf '%03o' $((155 - $(printf "%d" "'$c"))))") ;;
          [a-z]) out+=$(printf "\\$(printf '%03o' $((219 - $(printf "%d" "'$c"))))") ;;
          *) out+="$c" ;;
        esac
      done
      echo "$out"
      ;;
    7)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      if [[ $mode == "encode" ]]; then
        echo -n "$text" | xxd -p
      else
        echo "$text" | xxd -r -p
      fi
      ;;
    8)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      if [[ $mode == "encode" ]]; then
        python3 -c "import base64,sys; print(base64.b32encode(sys.stdin.read().encode()).decode())" <<<"$text"
      else
        python3 -c "import base64,sys; print(base64.b32decode(sys.stdin.read().strip()).decode())" <<<"$text" || echo "Invalid Base32 input"
      fi
      ;;
    9)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      if [[ $mode == "encode" ]]; then
        python3 -c "import base64,sys; print(base64.a85encode(sys.stdin.read().encode()).decode())" <<<"$text"
      else
        python3 -c "import base64,sys; print(base64.a85decode(sys.stdin.read().strip()).decode())" <<<"$text" || echo "Invalid ASCII85 input"
      fi
      ;;
    10)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      if [[ $mode == "encode" ]]; then
        python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.stdin.read().strip()))" <<<"$text"
      else
        python3 -c "import urllib.parse,sys; print(urllib.parse.unquote(sys.stdin.read().strip()))" <<<"$text"
      fi
      ;;
    11)
      read -rp "Mode [encode/decode]: " mode
      read -rp "Enter text: " text
      echo "$text" | rev
      ;;
    0)
      echo "Exiting..."
      break
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done
