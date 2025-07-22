import base64
import hashlib
import codecs

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

print(ascii_art)

MORSE_CODE_DICT = {
    '.-': 'A', '-...': 'B', '-.-.': 'C', '-..': 'D', '.': 'E', '..-.': 'F',
    '--.': 'G', '....': 'H', '..': 'I', '.---': 'J', '-.-': 'K', '.-..': 'L',
    '--': 'M', '-.': 'N', '---': 'O', '.--.': 'P', '--.-': 'Q', '.-.': 'R',
    '...': 'S', '-': 'T', '..-': 'U', '...-': 'V', '.--': 'W', '-..-': 'X',
    '-.--': 'Y', '--..': 'Z', '-----': '0', '.----': '1', '..---': '2',
    '...--': '3', '....-': '4', '.....': '5', '-....': '6', '--...': '7',
    '---..': '8', '----.': '9', '.-.-.-': '.', '--..--': ',', '..--..': '?',
    '-.-.--': '!', '-....-': '-', '-..-.': '/', '.--.-.': '@', '-.--.': '(',
    '-.--.-': ')'
}

def base64_encrypt(input_str):
    try:
        encoded_bytes = base64.b64encode(input_str.encode('utf-8'))
        return encoded_bytes.decode('utf-8')
    except Exception as e:
        return f"Error encoding Base64: {e}"

def base64_decrypt(encoded_str):
    try:
        decoded_bytes = base64.b64decode(encoded_str)
        return decoded_bytes.decode('utf-8')
    except Exception as e:
        return f"Error decoding Base64: {e}"

def sha256_compare(input_str, hashed_str):
    input_hash = hashlib.sha256(input_str.encode()).hexdigest()
    return input_hash == hashed_str

def md5_compare(input_str, hashed_str):
    input_hash = hashlib.md5(input_str.encode()).hexdigest()
    return input_hash == hashed_str

def binary_encode(text):
    try:
        return ' '.join(format(ord(char), '08b') for char in text)
    except Exception as e:
        return f"Error encoding binary: {e}"

def binary_to_text(binary_str):
    try:
        binary_values = binary_str.split(' ')
        ascii_characters = [chr(int(b, 2)) for b in binary_values]
        return ''.join(ascii_characters)
    except Exception as e:
        return f"Error converting binary to text: {e}"

def rot13_encrypt(input_str):
    return codecs.encode(input_str, 'rot_13')

def rot13_decrypt(encoded_str):
    try:
        return codecs.decode(encoded_str, 'rot_13')
    except Exception as e:
        return f"Error decoding ROT13: {e}"

def morse_to_text(morse_str):
    try:
        morse_words = morse_str.split(' / ')
        decoded_words = []
        for word in morse_words:
            decoded_chars = [MORSE_CODE_DICT[char] for char in word.split()]
            decoded_words.append(''.join(decoded_chars))
        return ' '.join(decoded_words)
    except Exception as e:
        return f"Error decoding Morse code: {e}"

def rail_fence_decrypt(ciphertext, key, offset):
    try:
        rail = [['\n' for _ in range(len(ciphertext))] for _ in range(key)]
        dir_down = None
        row, col = 0, 0

        for _ in range(len(ciphertext)):
            if row == 0:
                dir_down = True
            if row == key - 1:
                dir_down = False

            rail[row][col] = '*'
            col += 1

            row += 1 if dir_down else -1

        index = 0
        for i in range(key):
            for j in range(len(ciphertext)):
                if rail[i][j] == '*' and index < len(ciphertext):
                    rail[i][j] = ciphertext[index]
                    index += 1

        result = []
        row, col = 0, 0
        for _ in range(len(ciphertext)):
            if row == 0:
                dir_down = True
            if row == key - 1:
                dir_down = False

            if rail[row][col] != '*':
                result.append(rail[row][col])
                col += 1

            row += 1 if dir_down else -1

        return "".join(result)
    except Exception as e:
        return f"Error decoding Rail Fence Cipher: {e}"

def hex_encode(text):
    try:
        return text.encode().hex()
    except Exception as e:
        return f"Error encoding hexadecimal: {e}"

def hex_to_text(hex_str):
    try:
        bytes_object = bytes.fromhex(hex_str)
        return bytes_object.decode('utf-8')
    except Exception as e:
        return f"Error converting hexadecimal to text: {e}"

def atbash_encrypt(encoded_str):
    try:
        decoded_str = ''.join(
            [chr(155 - ord(c)) if 'A' <= c <= 'Z' else chr(219 - ord(c)) if 'a' <= c <= 'z' else c for c in encoded_str])
        return decoded_str
    except Exception as e:
        return f"Error decoding Atbash: {e}"

def main():
    try:
        while True:
            print("\nChoose an option:")
            print("1. Base64 Encode/Decode")
            print("2. Compare SHA256")
            print("3. Compare MD5")
            print("4. Binary Encode/Decode")
            print("5. ROT13 Encode/Decode")
            print("6. Decode Morse Code")
            print("7. Decrypt Rail Fence Cipher")
            print("8. Hexadecimal Encode/Decode")
            print("9. Atbash Encode/Decode")
            print("10. Exit")

            choice = input("Enter your choice: ")

            if choice == '1':
                mode = input("Encode or Decode? [e/d]: ")
                if mode == 'e':
                    text = input("Enter text to encode: ")
                    print("Encoded string:", base64_encrypt(text))
                elif mode == 'd':
                    encoded_str = input("Enter Base64 encoded string: ")
                    print("Decoded string:", base64_decrypt(encoded_str))
                else:
                    print("Invalid mode selected.")

            elif choice == '2':
                input_str = input("Enter the original string: ")
                hashed_str = input("Enter the SHA256 hash: ")
                if sha256_compare(input_str, hashed_str):
                    print("The hash matches the input string.")
                else:
                    print("The hash does not match the input string.")

            elif choice == '3':
                input_str = input("Enter the original string: ")
                hashed_str = input("Enter the MD5 hash: ")
                if md5_compare(input_str, hashed_str):
                    print("The hash matches the input string.")
                else:
                    print("The hash does not match the input string.")

            elif choice == '4':
                mode = input("Encode or Decode? [e/d]: ")
                if mode == 'e':
                    text = input("Enter text to encode: ")
                    print("Binary encoded:", binary_encode(text))
                elif mode == 'd':
                    binary_str = input("Enter binary string (space-separated): ")
                    print("Converted text:", binary_to_text(binary_str))
                else:
                    print("Invalid mode selected.")

            elif choice == '5':
                mode = input("Encode or Decode? [e/d]: ")
                text = input("Enter text: ")
                if mode == 'e':
                    print("ROT13 Encoded:", rot13_encrypt(text))
                elif mode == 'd':
                    print("ROT13 Decoded:", rot13_decrypt(text))
                else:
                    print("Invalid mode selected.")

            elif choice == '6':
                morse_str = input("Enter Morse code (space-separated, '/' for word separation): ")
                print("Decoded text:", morse_to_text(morse_str))

            elif choice == '7':
                ciphertext = input("Enter Rail Fence Cipher text: ")
                key = int(input("Enter the key: "))
                offset = int(input("Enter the offset (currently unused): "))
                print("Decoded text:", rail_fence_decrypt(ciphertext, key, offset))

            elif choice == '8':
                mode = input("Encode or Decode? [e/d]: ")
                if mode == 'e':
                    text = input("Enter text to encode: ")
                    print("Hex encoded:", hex_encode(text))
                elif mode == 'd':
                    hex_str = input("Enter hexadecimal string: ")
                    print("Converted text:", hex_to_text(hex_str))
                else:
                    print("Invalid mode selected.")

            elif choice == '9':
                mode = input("Encode or Decode? [e/d]: ")
                text = input("Enter text: ")
                print("Result:", atbash_encrypt(text))  # Atbash is symmetric

            elif choice == '10':
                print("Exiting...")
                break
            else:
                print("Invalid choice. Please try again.")
    except KeyboardInterrupt:
        print("\nExiting...")

if __name__ == "__main__":
    main()
