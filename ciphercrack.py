import base64
import hashlib
import codecs
import urllib.parse

ascii_art = r"""
 _____ _       _               _____                _    
/  __ (_)     | |             /  __ \              | |   
| /  \/_ _ __ | |__   ___ _ __| /  \/_ __ __ _  ___| | __
| |   | | '_ \| '_ \ / _ \ '__| |   | '__/ _` |/ __| |/ / 
| \__/\ | |_) | | | |  __/ |  | \__/\ | | (_| | (__|   <  
 \____/_| .__/|_| |_|\___|_|   \____/_|  \__,_|\___|_|\_\ 
        | |                                              
        |_|                                              
"""
 def base64_op(mode: str, text: str) -> str:
    try:
        match mode:
            case 'encode':
                return base64.b64encode(text.encode('utf-8')).decode('utf-8')
            case 'decode':
                return base64.b64decode(text).decode('utf-8')
            case _:
                return "Invalid Base64 mode."
    except Exception as e:
        return f"Base64 error: {e}"

def base32_op(mode: str, text: str) -> str:
    try:
        match mode:
            case 'encode':
                return base64.b32encode(text.encode()).decode()
            case 'decode':
                return base64.b32decode(text).decode()
            case _:
                return "Invalid Base32 mode."
    except Exception as e:
        return f"Base32 error: {e}"

def ascii85_op(mode: str, text: str) -> str:
    try:
        match mode:
            case 'encode':
                return base64.a85encode(text.encode()).decode()
            case 'decode':
                return base64.a85decode(text).decode()
            case _:
                return "Invalid ASCII85 mode."
    except Exception as e:
        return f"ASCII85 error: {e}"

def url_op(mode: str, text: str) -> str:
    match mode:
        case 'encode':
            return urllib.parse.quote(text)
        case 'decode':
            return urllib.parse.unquote(text)
        case _:
            return "Invalid URL mode."

def hash_compare(alg: str, input_str: str, hashed_str: str) -> bool | str:
    try:
        match alg.lower():
            case 'sha256':
                return hashlib.sha256(input_str.encode()).hexdigest() == hashed_str
            case 'md5':
                return hashlib.md5(input_str.encode()).hexdigest() == hashed_str
            case _:
                return "Unsupported hash algorithm. Use 'sha256' or 'md5'."
    except Exception as e:
        return f"Hash compare error: {e}"

def binary_op(mode: str, text: str) -> str:
    try:
        match mode:
            case 'encode':
                return ' '.join(format(ord(c), '08b') for c in text)
            case 'decode':
                bits = [b for b in text.strip().split() if b]
                return ''.join(chr(int(b, 2)) for b in bits)
            case _:
                return "Invalid binary mode."
    except Exception as e:
        return f"Binary error: {e}"

def rot13_op(mode: str, text: str) -> str:
    match mode:
        case 'encode' | 'decode':
            return codecs.encode(text, 'rot_13')
        case _:
            return "Invalid ROT13 mode."

def rot47_op(mode: str, text: str) -> str:
    match mode:
        case 'encode' | 'decode':
            out = []
            for ch in text:
                o = ord(ch)
                if 33 <= o <= 126:
                    out.append(chr(33 + ((o - 33 + 47) % 94)))
                else:
                    out.append(ch)
            return ''.join(out)
        case _:
            return "Invalid ROT47 mode."

def atbash_op(mode: str, text: str) -> str:
    match mode:
        case 'encode' | 'decode':
            return ''.join(
                chr(155 - ord(c)) if 'A' <= c <= 'Z'
                else chr(219 - ord(c)) if 'a' <= c <= 'z'
                else c for c in text
            )
        case _:
            return "Invalid Atbash mode."

def hex_op(mode: str, text: str) -> str:
    try:
        match mode:
            case 'encode':
                return text.encode('utf-8').hex()
            case 'decode':
                return bytes.fromhex(text).decode('utf-8')
            case _:
                return "Invalid hex mode."
    except Exception as e:
        return f"Hex error: {e}"

def reverse_op(mode: str, text: str) -> str:
    match mode:
        case 'encode' | 'decode':
            return text[::-1]
        case _:
            return "Invalid reverse mode."

# ---------------- Menu ---------------- #

def main():
    try:
        while True:
            print("\nChoose an option:")
            print("1. Base64")
            print("2. Hash Compare (SHA256/MD5)")
            print("3. Binary")
            print("4. ROT13")
            print("5. ROT47")
            print("6. Atbash")
            print("7. Hex")
            print("8. Base32")
            print("9. ASCII85")
            print("10. URL Encode/Decode")
            print("11. Reverse")
            print("0. Exit")

            choice = input("Enter your choice: ").strip()

            match choice:
                case '1':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", base64_op(mode, text))

                case '2':
                    alg = input("Algorithm [sha256/md5]: ").strip().lower()
                    original = input("Enter original string: ")
                    hashed = input("Enter hash: ").strip()
                    res = hash_compare(alg, original, hashed)
                    if isinstance(res, bool):
                        print("Match!" if res else "Does not match.")
                    else:
                        print(res)

                case '3':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", binary_op(mode, text))

                case '4':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", rot13_op(mode, text))

                case '5':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", rot47_op(mode, text))

                case '6':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", atbash_op(mode, text))

                case '7':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", hex_op(mode, text))

                case '8':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", base32_op(mode, text))

                case '9':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", ascii85_op(mode, text))

                case '10':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", url_op(mode, text))

                case '11':
                    mode = input("Mode [encode/decode]: ").strip().lower()
                    text = input("Enter text: ")
                    print("Result:", reverse_op(mode, text))

                case '0':
                    print("Exiting...")
                    break

                case _:
                    print("Invalid choice. Please try again.")
    except KeyboardInterrupt:
        print("\nExiting...")

if __name__ == "__main__":
    main()


