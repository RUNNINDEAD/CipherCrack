import tkinter as tk
from tkinter import ttk, messagebox
import ciphercrack

def perform_operation():
    op = operation_var.get()
    if op == 'Encode/Decode':
        algorithm = algorithm_var.get()
        mode = mode_var.get()
        text = input_text.get("1.0", tk.END).strip()
        if not text:
            output_text.delete("1.0", tk.END)
            return
        try:
            if algorithm == 'Base64':
                result = ciphercrack.base64_op(mode, text)
            elif algorithm == 'Base32':
                result = ciphercrack.base32_op(mode, text)
            elif algorithm == 'Ascii85':
                result = ciphercrack.ascii85_op(mode, text)
            elif algorithm == 'URL':
                result = ciphercrack.url_op(mode, text)
            else:
                result = 'Unsupported algorithm'
        except Exception as e:
            result = str(e)
        output_text.delete("1.0", tk.END)
        output_text.insert(tk.END, result)
    else:
        algorithm = hash_alg_var.get()
        input_str = hash_input_entry.get()
        hashed_str = hash_hashed_entry.get()
        if not input_str or not hashed_str:
            messagebox.showinfo("Error", "Please enter both input and hashed strings.")
            return
        if ciphercrack.hash_compare(algorithm, input_str, hashed_str):
            messagebox.showinfo("Result", "The hash matches!")
        else:
            messagebox.showinfo("Result", "The hash does not match.")

def switch_frames(event=None):
    op = operation_var.get()
    if op == 'Encode/Decode':
        encode_frame.pack(fill='both', expand=True)
        hash_frame.pack_forget()
    else:
        hash_frame.pack(fill='both', expand=True)
        encode_frame.pack_forget()

root = tk.Tk()
root.title("CipherCrack GUI")

operation_var = tk.StringVar(value='Encode/Decode')
operation_option = ttk.Combobox(root, textvariable=operation_var, values=['Encode/Decode','Hash Compare'], state='readonly')
operation_option.pack(pady=5)
operation_option.bind('<<ComboboxSelected>>', switch_frames)

encode_frame = tk.Frame(root)
encode_frame.pack(fill='both', expand=True)

mode_var = tk.StringVar(value='encode')
mode_option = ttk.Combobox(encode_frame, textvariable=mode_var, values=['encode','decode'], state='readonly')
mode_option.pack(pady=5)

algorithm_var = tk.StringVar(value='Base64')
algorithm_option = ttk.Combobox(encode_frame, textvariable=algorithm_var, values=['Base64','Base32','Ascii85','URL'], state='readonly')
algorithm_option.pack(pady=5)

input_text = tk.Text(encode_frame, height=5, width=50)
input_text.pack(pady=5)
output_text = tk.Text(encode_frame, height=5, width=50)
output_text.pack(pady=5)

process_button = tk.Button(encode_frame, text='Process', command=perform_operation)
process_button.pack(pady=5)

hash_frame = tk.Frame(root)

hash_alg_var = tk.StringVar(value='sha256')
hash_alg_option = ttk.Combobox(hash_frame, textvariable=hash_alg_var, values=['sha256','md5'], state='readonly')
hash_alg_option.pack(pady=5)

hash_input_entry = tk.Entry(hash_frame, width=50)
hash_input_entry.pack(pady=5)
hash_hashed_entry = tk.Entry(hash_frame, width=50)
hash_hashed_entry.pack(pady=5)

compare_button = tk.Button(hash_frame, text='Compare Hash', command=perform_operation)
compare_button.pack(pady=5)

switch_frames()

root.mainloop()
