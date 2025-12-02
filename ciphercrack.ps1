param(
    [switch]$Help,
    [switch]$ShowVersion,
    [string]$File,
    [switch]$Hash
)

$ToolVersion = "3.0.0"

$ascii_art = @"
 _____ _       _               _____                _    
/  __ (_)     | |             /  __ \              | |   
| /  \/_ _ __ | |__   ___ _ __| /  \/_ __ __ _  ___| | __
| |   | | '_ \| '_ \ / _ \ '__| |   | '__/ _` |/ __| |/ / 
| \__/\ | |_) | | | |  __/ |  | \__/\ | | (_| | (__|   <  
 \____/_| .__/|_| |_|\___|_|   \____/_|  \__,_|\___|_|\_\ 
        | |                CipherCrack v3.0
        |_|
"@

function Show-Art {
    Write-Host $ascii_art
}

function Base64-Op {
    param(
        [string]$Mode,
        [string]$Text
    )
    $mode = $Mode.ToLower()
    if ($mode -eq "encode") {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        [System.Convert]::ToBase64String($bytes)
    } elseif ($mode -eq "decode") {
        try {
            $bytes = [System.Convert]::FromBase64String($Text)
            [System.Text.Encoding]::UTF8.GetString($bytes)
        } catch {
            "Base64 error"
        }
    } else {
        "Invalid Base64 mode."
    }
}

function Base32-Op {
    param(
        [string]$Mode,
        [string]$Text
    )
    "Base32 not implemented in PowerShell version yet."
}

function Ascii85-Op {
    param(
        [string]$Mode,
        [string]$Text
    )
    "ASCII85 not implemented in PowerShell version yet."
}

function Url-Op {
    param(
        [string]$Mode,
        [string]$Text
    )
    $mode = $Mode.ToLower()
    if ($mode -eq "encode") {
        [System.Net.WebUtility]::UrlEncode($Text)
    } elseif ($mode -eq "decode") {
        [System.Net.WebUtility]::UrlDecode($Text)
    } else {
        "Invalid URL mode."
    }
}

function String-Hash-Sha256 {
    param(
        [string]$Text
    )
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        $sha = [System.Security.Cryptography.SHA256]::Create()
        $hashBytes = $sha.ComputeHash($bytes)
        ($hashBytes | ForEach-Object { $_.ToString("x2") }) -join ""
    } catch {
        "SHA256 string hash error: $($_.Exception.Message)"
    }
}

function File-Hash-Sha256 {
    param(
        [string]$Path
    )
    if (-not (Test-Path -Path $Path -PathType Leaf)) {
        "Error: File not found."
        return
    }
    try {
        $hash = Get-FileHash -Path $Path -Algorithm SHA256
        $hash.Hash.ToLower()
    } catch {
        "File hash error: $($_.Exception.Message)"
    }
}

function Hash-Compare-Sha256 {
    param(
        [string]$InputString,
        [string]$HashString
    )
    try {
        $computed = String-Hash-Sha256 -Text $InputString
        if ($computed -eq $HashString) {
            "Match!"
        } else {
            "Does not match."
        }
    } catch {
        "Hash compare error: $($_.Exception.Message)"
    }
}

function Binary-Op {
    param(
        [string]$Mode,
        [string]$Text
    )
    $mode = $Mode.ToLower()
    if ($mode -eq "encode") {
        $out = ""
        foreach ($ch in $Text.ToCharArray()) {
            $code = [int][char]$ch
            $bin = [Convert]::ToString($code, 2).PadLeft(8, '0')
            $out += "$bin "
        }
        $out.TrimEnd()
    } elseif ($mode -eq "decode") {
        $bits = $Text -split '\s+' | Where-Object { $_ -ne "" }
        $sb = New-Object System.Text.StringBuilder
        foreach ($b in $bits) {
            try {
                $code = [Convert]::ToInt32($b, 2)
                [void]$sb.Append([char]$code)
            } catch {
                return "Binary error."
            }
        }
        $sb.ToString()
    } else {
        "Invalid binary mode."
    }
}

function Rot13-Op {
    param(
        [string]$Text
    )
    $sb = New-Object System.Text.StringBuilder
    foreach ($c in $Text.ToCharArray()) {
        $code = [int][char]$c
        if ($code -ge 65 -and $code -le 90) {
            $sb.Append([char](65 + (($code - 65 + 13) % 26))) | Out-Null
        } elseif ($code -ge 97 -and $code -le 122) {
            $sb.Append([char](97 + (($code - 97 + 13) % 26))) | Out-Null
        } else {
            $sb.Append($c) | Out-Null
        }
    }
    $sb.ToString()
}

function Rot47-Op {
    param(
        [string]$Text
    )
    $sb = New-Object System.Text.StringBuilder
    foreach ($c in $Text.ToCharArray()) {
        $code = [int][char]$c
        if ($code -ge 33 -and $code -le 126) {
            $sb.Append([char](33 + (($code - 33 + 47) % 94))) | Out-Null
        } else {
            $sb.Append($c) | Out-Null
        }
    }
    $sb.ToString()
}

function Atbash-Op {
    param(
        [string]$Text
    )
    $sb = New-Object System.Text.StringBuilder
    foreach ($c in $Text.ToCharArray()) {
        if ($c -ge 'A' -and $c -le 'Z') {
            $sb.Append([char](155 - [int][char]$c)) | Out-Null
        } elseif ($c -ge 'a' -and $c -le 'z') {
            $sb.Append([char](219 - [int][char]$c)) | Out-Null
        } else {
            $sb.Append($c) | Out-Null
        }
    }
    $sb.ToString()
}

function Hex-Op {
    param(
        [string]$Mode,
        [string]$Text
    )
    $mode = $Mode.ToLower()
    if ($mode -eq "encode") {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
        ($bytes | ForEach-Object { $_.ToString("x2") }) -join ""
    } elseif ($mode -eq "decode") {
        try {
            if ($Text.Length % 2 -ne 0) {
                return "Hex error"
            }
            $bytes = New-Object byte[] ($Text.Length / 2)
            for ($i = 0; $i -lt $Text.Length; $i += 2) {
                $bytes[$i / 2] = [Convert]::ToByte($Text.Substring($i, 2), 16)
            }
            [System.Text.Encoding]::UTF8.GetString($bytes)
        } catch {
            "Hex error"
        }
    } else {
        "Invalid hex mode."
    }
}

function Reverse-Op {
    param(
        [string]$Text
    )
    $chars = $Text.ToCharArray()
    [Array]::Reverse($chars)
    -join $chars
}

function Caesar-Op {
    param(
        [string]$Mode,
        [int]$Shift,
        [string]$Text
    )
    $mode = $Mode.ToLower()
    $shift = $Shift % 26
    if ($mode -eq "decode") {
        $shift = -$shift
    }
    $sb = New-Object System.Text.StringBuilder
    foreach ($c in $Text.ToCharArray()) {
        $code = [int][char]$c
        if ($code -ge 65 -and $code -le 90) {
            $sb.Append([char](65 + (($code - 65 + $shift) % 26))) | Out-Null
        } elseif ($code -ge 97 -and $code -le 122) {
            $sb.Append([char](97 + (($code - 97 + $shift) % 26))) | Out-Null
        } else {
            $sb.Append($c) | Out-Null
        }
    }
    $sb.ToString()
}

function Vigenere-Op {
    param(
        [string]$Mode,
        [string]$Key,
        [string]$Text
    )
    $mode = $Mode.ToLower()
    $keyFiltered = -join ($Key.ToCharArray() | Where-Object { $_ -match '[A-Za-z]' })
    if ([string]::IsNullOrEmpty($keyFiltered)) {
        return "Key must contain at least one letter."
    }
    $keyLower = $keyFiltered.ToLower()
    $klen = $keyLower.Length
    $sb = New-Object System.Text.StringBuilder
    $j = 0
    foreach ($c in $Text.ToCharArray()) {
        if ($c -match '[A-Za-z]') {
            $shift = [int][char]$keyLower[$j % $klen] - [int][char]'a'
            if ($mode -eq "decode") {
                $shift = -$shift
            }
            $code = [int][char]$c
            if ($c -cmatch '[A-Z]') {
                $sb.Append([char](65 + (($code - 65 + $shift) % 26))) | Out-Null
            } else {
                $sb.Append([char](97 + (($code - 97 + $shift) % 26))) | Out-Null
            }
            $j++
        } else {
            $sb.Append($c) | Out-Null
        }
    }
    $sb.ToString()
}

function Xor-Op {
    param(
        [string]$Mode,
        [string]$Key,
        [string]$Text
    )
    $mode = $Mode.ToLower()
    if ([string]::IsNullOrEmpty($Key)) {
        return "Key cannot be empty."
    }
    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($Key)
    if ($mode -eq "encode") {
        $data = [System.Text.Encoding]::UTF8.GetBytes($Text)
        $outBytes = New-Object byte[] $data.Length
        for ($i = 0; $i -lt $data.Length; $i++) {
            $outBytes[$i] = $data[$i] -bxor $keyBytes[$i % $keyBytes.Length]
        }
        ($outBytes | ForEach-Object { $_.ToString("x2") }) -join ""
    } elseif ($mode -eq "decode") {
        try {
            if ($Text.Length % 2 -ne 0) {
                return "Invalid hex input for XOR decode."
            }
            $data = New-Object byte[] ($Text.Length / 2)
            for ($i = 0; $i -lt $Text.Length; $i += 2) {
                $data[$i / 2] = [Convert]::ToByte($Text.Substring($i, 2), 16)
            }
        } catch {
            return "Invalid hex input for XOR decode."
        }
        $outBytes = New-Object byte[] $data.Length
        for ($i = 0; $i -lt $data.Length; $i++) {
            $outBytes[$i] = $data[$i] -bxor $keyBytes[$i % $keyBytes.Length]
        }
        [System.Text.Encoding]::UTF8.GetString($outBytes)
    } else {
        "Invalid XOR mode."
    }
}

function Show-Help {
    Show-Art
    Write-Host "Usage:"
    Write-Host "  pwsh -File ciphercrack.ps1                 # Interactive menu"
    Write-Host "  pwsh -File ciphercrack.ps1 -File <path> -Hash"
    Write-Host "  pwsh -File ciphercrack.ps1 -ShowVersion"
    Write-Host "  pwsh -File ciphercrack.ps1 -Help"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Help             Show this help"
    Write-Host "  -ShowVersion      Show version ($ToolVersion)"
    Write-Host "  -File <path>      Specify file to hash with SHA256"
    Write-Host "  -Hash             Show SHA256 hash of the provided file"
    Write-Host ""
    Write-Host "Interactive menu includes:"
    Write-Host "  Base64, Base32, ASCII85, URL, Hex, Binary, Reverse"
    Write-Host "  ROT13, ROT47, Atbash"
    Write-Host "  Caesar, Vigenère, XOR"
    Write-Host "  SHA256 string compare and file hashing"
}

function Menu-Mode {
    Show-Art
    while ($true) {
        Write-Host ""
        Write-Host "Choose an option:"
        Write-Host "1. Base64"
        Write-Host "2. SHA256 Hash Compare"
        Write-Host "3. Binary"
        Write-Host "4. ROT13"
        Write-Host "5. ROT47"
        Write-Host "6. Atbash"
        Write-Host "7. Hex"
        Write-Host "8. Base32"
        Write-Host "9. ASCII85"
        Write-Host "10. URL Encode/Decode"
        Write-Host "11. Reverse"
        Write-Host "12. File SHA256 Hash"
        Write-Host "13. Caesar"
        Write-Host "14. Vigenère"
        Write-Host "15. XOR"
        Write-Host "0. Exit"
        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            "1" {
                $mode = Read-Host "Mode [encode/decode]"
                $text = Read-Host "Enter text"
                Base64-Op -Mode $mode -Text $text | Write-Host
            }
            "2" {
                $original = Read-Host "Enter original string"
                $hashed = Read-Host "Enter SHA256 hash"
                Hash-Compare-Sha256 -InputString $original -HashString $hashed | Write-Host
            }
            "3" {
                $mode = Read-Host "Mode [encode/decode]"
                $text = Read-Host "Enter text"
                Binary-Op -Mode $mode -Text $text | Write-Host
            }
            "4" {
                $text = Read-Host "Enter text"
                Rot13-Op -Text $text | Write-Host
            }
            "5" {
                $text = Read-Host "Enter text"
                Rot47-Op -Text $text | Write-Host
            }
            "6" {
                $text = Read-Host "Enter text"
                Atbash-Op -Text $text | Write-Host
            }
            "7" {
                $mode = Read-Host "Mode [encode/decode]"
                $text = Read-Host "Enter text"
                Hex-Op -Mode $mode -Text $text | Write-Host
            }
            "8" {
                $mode = Read-Host "Mode [encode/decode]"
                $text = Read-Host "Enter text"
                Base32-Op -Mode $mode -Text $text | Write-Host
            }
            "9" {
                $mode = Read-Host "Mode [encode/decode]"
                $text = Read-Host "Enter text"
                Ascii85-Op -Mode $mode -Text $text | Write-Host
            }
            "10" {
                $mode = Read-Host "Mode [encode/decode]"
                $text = Read-Host "Enter text"
                Url-Op -Mode $mode -Text $text | Write-Host
            }
            "11" {
                $text = Read-Host "Enter text"
                Reverse-Op -Text $text | Write-Host
            }
            "12" {
                $path = Read-Host "Enter file path"
                File-Hash-Sha256 -Path $path | Write-Host
            }
            "13" {
                $mode = Read-Host "Mode [encode/decode]"
                $shift = Read-Host "Shift (0-25)"
                if (-not [int]::TryParse($shift, [ref]([int]$null))) {
                    Write-Host "Invalid shift value."
                } else {
                    $text = Read-Host "Enter text"
                    Caesar-Op -Mode $mode -Shift ([int]$shift) -Text $text | Write-Host
                }
            }
            "14" {
                $mode = Read-Host "Mode [encode/decode]"
                $key = Read-Host "Enter key"
                $text = Read-Host "Enter text"
                Vigenere-Op -Mode $mode -Key $key -Text $text | Write-Host
            }
            "15" {
                $mode = Read-Host "Mode [encode/decode]"
                $key = Read-Host "Enter key"
                $text = Read-Host "Enter text (hex if decoding)"
                Xor-Op -Mode $mode -Key $key -Text $text | Write-Host
            }
            "0" {
                Write-Host "Exiting..."
                break
            }
            Default {
                Write-Host "Invalid choice."
            }
        }
    }
}

if ($Help) {
    Show-Help
    exit 0
}

if ($ShowVersion) {
    Write-Host "CipherCrack Version: $ToolVersion"
    exit 0
}

if ($File -and $Hash) {
    Show-Art
    Write-Host "File: $File"
    $h = File-Hash-Sha256 -Path $File
    Write-Host "SHA256: $h"
    exit 0
}

if ($PSBoundParameters.Count -eq 0) {
    Menu-Mode
} else {
    Show-Help
}
