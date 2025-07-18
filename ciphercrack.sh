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

function base64_decode() {
    read -p "Enter Base64 string: " encoded
    echo "$encoded" | base64 --decode 2>/dev/null || echo "Error decoding Base64."
}

function rot13() {
    read -p "Enter ROT13 string: " input
    echo "$input" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
}

function sha256_compare() {
    read -p "Enter original string: " input
    read -p "Enter SHA256 hash: " hash
    echo -n "$input" | sha256sum | awk '{print $1}' | grep -q "^$hash$" && echo "Match ✅" || echo "No match ❌"
}

function md5_compare() {
    read -p "Enter original string: " input
    read -p "Enter MD5 hash: " hash
    echo -n "$input" | md5sum | awk '{print $1}' | grep -q "^$hash$" && echo "Match ✅" || echo "No match ❌"
}

function binary_to_text() {
    read -p "Enter binary string (space-separated): " binstr
    for b in $binstr; do
        printf "\x$(printf %x "$((2#$b))")"
    done
    echo
}

function hex_to_text() {
    read -p "Enter hex string: " hexstr
    echo "$hexstr" | xxd -r -p || echo "Error decoding hex."
}

while true; do
    echo
    echo "Choose an option:"
    echo "1. Decode Base64"
    echo "2. Compare SHA256"
    echo "3. Compare MD5"
    echo "4. Binary to Text"
    echo "5. ROT13 Decode"
    echo "6. Hex to Text"
    echo "7. Exit"
    read -p "Choice: " choice

    case $choice in
        1) base64_decode ;;
        2) sha256_compare ;;
        3) md5_compare ;;
        4) binary_to_text ;;
        5) rot13 ;;
        6) hex_to_text ;;
        7) echo "Bye!"; exit 0 ;;
        *) echo "Invalid option." ;;
    esac
done
