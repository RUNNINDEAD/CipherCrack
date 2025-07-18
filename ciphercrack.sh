#!/bin/bash

ascii_art=$(cat << "EOF"
 _____ _       _               _____                _    
/  __ (_)     | |             /  __ \              | |   
| /  \/_ _ __ | |__   ___ _ __| /  \/_ __ __ _  ___| | __
| |   | | '_ \| '_ \ / _ \ '__| |   | '__/ _` |/ __| |/ /
| \__/\ | |_) | | | |  __/ |  | \__/\ | | (_| | (__|   < 
 \____/_| .__/|_| |_|\___|_|   \____/_|  \__,_|\___|_|\_\
        | |                                              
        |_|                                              
EOF
)

echo "$ascii_art"

declare -A MORSE_CODE_DICT=(
[".-"]="A" ["-..."]="B" ["-.-."]="C" ["-.."]="D" ["."]="E" ["..-."]="F"
["--."]="G" ["...."]="H" [".."]="I" [".---"]="J" ["-.-"]="K" [".-.."]="L"
["--"]="M" ["-."]="N" ["---"]="O" [".--."]="P" ["--.-"]="Q" [".-."]="R"
["..."]="S" ["-"]="T" ["..-"]="U" ["...-"]="V" [".--"]="W" ["-..-"]="X"
["-.--"]="Y" ["--.."]="Z" ["-----"]="0" [".----"]="1" ["..---"]="2"
["...--"]="3" ["....-"]="4" ["....."]="5" ["-...."]="6" ["--..."]="7"
["---.."]="8" ["----."]="9" [".-.-.-"]="." ["--..--"]=","
["..--.."]="?" ["-.-.--"]="!" ["-....-"]="-"
["-..-."]="/" [".--.-."]="@" ["-.--."]="(" ["-.--.-"]=")"
)

base64_action() {
    read -p "Encode or Decode? [e/d]: " mode
    read -p "Enter string: " input

    if [[ "$input" =~ ^(0|1){8}(\ (0|1){8})+$ ]]; then
        echo "This input looks like binary, not Base64."
        echo "Try option 4: Binary Encode/Decode instead."
        return
    fi

    if [[ $mode == "e" ]]; then
        echo -n "$input" | base64
    elif [[ $mode == "d" ]]; then
        decoded=$(echo "$input" | base64 --decode 2>/dev/null)
        if [[ $? -ne 0 || -z "$decoded" ]]; then
            echo "Invalid Base64 string."
            echo "Example Base64: SGVsbG8gd29ybGQ= (decodes to 'Hello world')"
        else
            echo "$decoded"
        fi
    else
        echo "Invalid option."
    fi
}

rot13_action() {
    read -p "Enter string: " input
    echo "$input" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
}

sha256_compare() {
    read -p "Enter original string: " input
    read -p "Enter SHA256 hash (64 hex chars): " hash

    if [[ ! "$hash" =~ ^[A-Fa-f0-9]{64}$ ]]; then
        echo "That doesn't look like a valid SHA256 hash."
        echo "Example SHA256: 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
        return
    fi

    computed=$(echo -n "$input" | sha256sum | awk '{print $1}')
    if [[ "$computed" == "$hash" ]]; then
        echo "Match"
    else
        echo "No match"
        echo "Computed: $computed"
    fi
}

md5_compare() {
    read -p "Enter original string: " input
    read -p "Enter MD5 hash (32 hex chars): " hash

    if [[ ! "$hash" =~ ^[A-Fa-f0-9]{32}$ ]]; then
        echo "That doesn't look like a valid MD5 hash."
        echo "Example MD5: 5d41402abc4b2a76b9719d911017c592 (from 'hello')"
        return
    fi

    computed=$(echo -n "$input" | md5sum | awk '{print $1}')
    if [[ "$computed" == "$hash" ]]; then
        echo "Match"
    else
        echo "No match"
        echo "Computed: $computed"
    fi
}

binary_action() {
    read -p "Encode or Decode? [e/d]: " mode
    if [[ $mode == "e" ]]; then
        read -p "Enter text: " input
        for ((i=0; i<${#input}; i++)); do
            printf "%08d " "$(echo "obase=2; $(printf "%d" "'${input:$i:1}")" | bc)"
        done
        echo
    elif [[ $mode == "d" ]]; then
        read -p "Enter binary string (space-separated): " input
        for bin in $input; do
            dec=$((2#$bin))
            printf "\\$(printf '%03o' "$dec")"
        done
        echo
    else
        echo "Invalid option."
    fi
}

hex_action() {
    read -p "Encode or Decode? [e/d]: " mode
    if [[ $mode == "e" ]]; then
        read -p "Enter text: " input
        echo -n "$input" | xxd -p
    elif [[ $mode == "d" ]]; then
        read -p "Enter hex string: " input
        echo -n "$input" | xxd -r -p 2>/dev/null || echo "Error decoding hex."
    else
        echo "Invalid option."
    fi
}

morse_action() {
    read -p "Encode or Decode? [e/d]: " mode
    if [[ $mode == "e" ]]; then
        read -p "Enter text: " input
        input=$(echo "$input" | tr '[:lower:]' '[:upper:]')
        for ((i=0; i<${#input}; i++)); do
            char="${input:$i:1}"
            if [[ "$char" == " " ]]; then
                echo -n "/ "
            else
                for k in "${!MORSE_CODE_DICT[@]}"; do
                    if [[ "${MORSE_CODE_DICT[$k]}" == "$char" ]]; then
                        echo -n "$k "
                        break
                    fi
                done
            fi
        done
        echo
    elif [[ $mode == "d" ]]; then
        read -p "Enter Morse Code (space-separated, '/' for word break): " input
        output=""
        IFS='/' read -ra words <<< "$input"
        for word in "${words[@]}"; do
            for char in $word; do
                output+="${MORSE_CODE_DICT[$char]}"
            done
            output+=" "
        done
        echo "$output"
    else
        echo "Invalid option."
    fi
}

atbash_action() {
    read -p "Enter string: " input
    output=""
    for ((i=0; i<${#input}; i++)); do
        c="${input:$i:1}"
        if [[ $c =~ [A-Z] ]]; then
            ascii=$(printf "%d" "'$c")
            mapped=$((155 - ascii))
            printf -v char "\\$(printf '%03o' "$mapped")"
            output+="$char"
        elif [[ $c =~ [a-z] ]]; then
            ascii=$(printf "%d" "'$c")
            mapped=$((219 - ascii))
            printf -v char "\\$(printf '%03o' "$mapped")"
            output+="$char"
        else
            output+="$c"
        fi
    done
    echo -e "$output"
}

rail_fence_decrypt() {
    read -p "Enter ciphertext: " cipher
    read -p "Enter key (number of rails): " key
    read -p "Enter offset (starting shift): " offset

    len=${#cipher}
    matrix=()
    for ((i=0; i<key; i++)); do
        matrix[i]=$(printf '_%.0s' $(seq 1 $len))
    done

    row=0
    dir=1
    for ((i=offset; i<len+offset; i++)); do
        matrix[$row]=$(echo "${matrix[$row]}" | sed "s/_/*/")
        ((row+=dir))
        if ((row==key-1)); then dir=-1; fi
        if ((row==0)); then dir=1; fi
    done

    idx=0
    for ((r=0; r<key; r++)); do
        rowstr=${matrix[$r]}
        for ((c=0; c<len; c++)); do
            if [[ ${rowstr:$c:1} == "*" ]]; then
                matrix[$r]="${rowstr:0:$c}${cipher:$idx:1}${rowstr:$((c + 1))}"
                ((idx++))
            fi
        done
    done

    row=0
    dir=1
    result=""
    for ((i=offset; i<len+offset; i++)); do
        result+="${matrix[$row]:$((i % len)):1}"
        ((row+=dir))
        if ((row==key-1)); then dir=-1; fi
        if ((row==0)); then dir=1; fi
    done

    echo "$result"
}

while true; do
    echo
    echo "Choose an option:"
    echo "1. Base64 Encode/Decode"
    echo "2. Compare SHA256"
    echo "3. Compare MD5"
    echo "4. Binary Encode/Decode"
    echo "5. ROT13 Encode/Decode"
    echo "6. Hex Encode/Decode"
    echo "7. Morse Code Encode/Decode"
    echo "8. Rail Fence Decode"
    echo "9. Atbash Encode/Decode"
    echo "10. Exit"
    read -p "Choice: " choice

    case "$choice" in
        1) base64_action ;;
        2) sha256_compare ;;
        3) md5_compare ;;
        4) binary_action ;;
        5) rot13_action ;;
        6) hex_action ;;
        7) morse_action ;;
        8) rail_fence_decrypt ;;
        9) atbash_action ;;
        10) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option." ;;
    esac
done
