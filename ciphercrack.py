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

def binary_to_text(binary_str):
    try:
        binary_values = binary_str.split(' ')
        ascii_characters = [chr(int(b, 2)) for b in binary_values]
        return ''.join(ascii_characters)
    except Exception as e:
        return f"Error converting binary to text: {e}"

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
        rail = [['\n' for i in range(len(ciphertext))]
                for j in range(key)]
        dir_down = None
        row, col = 0, 0

        for i in range(len(ciphertext)):
            if row == 0:
                dir_down = True
            if row == key - 1:
                dir_down = False

            rail[row][col] = '*'
            col += 1

            if dir_down:
                row += 1
            else:
                row -= 1

        index = 0
        for i in range(key):
            for j in range(len(ciphertext)):
                if rail[i][j] == '*' and index < len(ciphertext):
                    rail[i][j] = ciphertext[index]
                    index += 1

        result = []
        row, col = 0, 0
        for i in range(len(ciphertext)):
            if row == 0:
                dir_down = True
            if row == key - 1:
                dir_down = False

            if rail[row][col] != '*':
                result.append(rail[row][col])
                col += 1

            if dir_down:
                row += 1
            else:
                row -= 1

        return "".join(result)
    except Exception as e:
        return f"Error decoding Rail Fence Cipher: {e}"

def hex_to_text(hex_str):
    try:
        bytes_object = bytes.fromhex(hex_str)
        return bytes_object.decode('utf-8')
    except Exception as e:
        return f"Error converting hexadecimal to text: {e}"

def atbash_decrypt(encoded_str):
    try:
        decoded_str = ''.join([chr(155 - ord(c)) if 'A' <= c <= 'Z' else chr(219 - ord(c)) if 'a' <= c <= 'z' else c for c in encoded_str])
        return decoded_str
    except Exception as e:
        return f"Error decoding Atbash: {e}"

def main():
    try:
        while True:
            print("\nChoose an option:")
            print("1. Decrypt Base64 (e.g., 'SGVsbG8gd29ybGQ=')")
            print("2. Compare SHA256 hash (e.g., 'hello' and '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824')")
            print("3. Compare MD5 hash (e.g., 'hello' and '5d41402abc4b2a76b9719d911017c592')")
            print("4. Convert Binary to Text (e.g., '01001000 01100101 01101100 01101100 01101111')")
            print("5. Decrypt ROT13 (e.g., 'Uryyb jbeyq')")
            print("6. Decrypt Morse Code (e.g., '.... . .-.. .-.. --- / .-- --- .-. .-.. -..')")
            print("7. Decrypt Rail Fence Cipher (e.g., 'Hoo!el,Wrdl l' with key 3)")
            print("8. Convert Hexadecimal to Text (e.g., '48656c6c6f')")
            print("9. Decrypt Atbash (e.g., 'Zgyzhs')")
            print("10. Exit")
            
            choice = input("Enter your choice: ")
            
            if choice == '1':
                encoded_str = input("Enter Base64 encoded string: ")
                print("Decoded string:", base64_decrypt(encoded_str))
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
                binary_str = input("Enter binary string (space-separated): ")
                print("Converted text:", binary_to_text(binary_str))
            elif choice == '5':
                encoded_str = input("Enter ROT13 encoded string: ")
                print("Decoded string:", rot13_decrypt(encoded_str))
            elif choice == '6':
                morse_str = input("Enter Morse code (space-separated, '/' for word separation): ")
                print("Decoded text:", morse_to_text(morse_str))
            elif choice == '7':
                ciphertext = input("Enter Rail Fence Cipher text: ")
                key = int(input("Enter the key: "))
                offset = int(input("Enter the offset: "))
                print("Decoded text:", rail_fence_decrypt(ciphertext, key, offset))
            elif choice == '8':
                hex_str = input("Enter hexadecimal string: ")
                print("Converted text:", hex_to_text(hex_str))
            elif choice == '9':
                encoded_str = input("Enter Atbash encoded string: ")
                print("Decoded string:", atbash_decrypt(encoded_str))
            elif choice == '10':
                print("Exiting...")
                break
            else:
                print("Invalid choice. Please try again.")
    except KeyboardInterrupt:
        print("\nExiting...")

if __name__ == "__main__":
    main()