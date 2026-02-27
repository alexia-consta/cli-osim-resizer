param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputFile
)

$ErrorActionPreference = 'Stop'

# 1. File & Command Check
if (-Not (Test-Path -Path $InputFile)) {
    Write-Host "[X] File not found: $InputFile" -ForegroundColor Red
    exit
}

if (-Not (Get-Command "magick" -ErrorAction SilentlyContinue)) {
    Write-Host "[X] ImageMagick 7 is required for OKLCH support." -ForegroundColor Red
    Write-Host "Install: winget install ImageMagick.ImageMagick" -ForegroundColor Yellow
    exit
}

$File = Get-Item -Path $InputFile
$Dir = $File.DirectoryName
$BaseName = $File.BaseName

Write-Host "[*] Processing: $($File.Name)..." -ForegroundColor Cyan

# 2. Check for transparency
$IsOpaque = (magick identify -format '%[opaque]' "$($File.FullName)[0]" 2>$null)
$HasTransparency = ($IsOpaque -eq "false")

$CustomColorStr = ""

if ($HasTransparency) {
    Write-Host "[!] Transparency detected!" -ForegroundColor Yellow
    $Answer = Read-Host "Do you want a custom background color? (y/N)"
    
    if ($Answer.Trim() -match "^(?i)y") {
        $RawInput = (Read-Host "[?] Enter color (Hex, RGB, HSL, OKLCH, or Name)").Trim()
        
        # --- SMART COLOR PARSER ---
        if ($RawInput -match "^([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$") {
            $CustomColorStr = "#$RawInput"
        } else {
            $CustomColorStr = $RawInput
        }
    }
}

# 3. Execution
if ($CustomColorStr) {
    $SafeColor = $CustomColorStr -replace "[^a-zA-Z0-9]", ""
    $OutPath = Join-Path $Dir "$($BaseName)_50x50mm_$($SafeColor)_bg.jpeg"
    
    try {
        # Using double quotes for $CustomColorStr to support spaces in OKLCH/RGB
        magick "$($File.FullName)[0]" -resize '591x591!' -background "$CustomColorStr" -flatten -quality 95 "$OutPath"
        Write-Host "[+] Saved: $($BaseName)_50x50mm_$($SafeColor)_bg.jpeg" -ForegroundColor Green
    } catch {
        Write-Host "[X] Invalid color format. Defaulting to white." -ForegroundColor Red
        magick "$($File.FullName)[0]" -resize '591x591!' -background white -flatten -quality 95 (Join-Path $Dir "$($BaseName)_50x50mm.jpeg")
    }
} else {
    if ($HasTransparency) {
        magick "$($File.FullName)[0]" -resize '591x591!' -background white -flatten -quality 95 (Join-Path $Dir "$($BaseName)_50x50mm_white_bg.jpeg")
        magick "$($File.FullName)[0]" -resize '591x591!' -background black -flatten -quality 95 (Join-Path $Dir "$($BaseName)_50x50mm_black_bg.jpeg")
        Write-Host "[+] Generated White & Black .jpeg versions" -ForegroundColor Green
    } else {
        magick "$($File.FullName)[0]" -resize '591x591!' -background white -flatten -quality 95 (Join-Path $Dir "$($BaseName)_50x50mm.jpeg")
        Write-Host "[+] Saved: $($BaseName)_50x50mm.jpeg" -ForegroundColor Green
    }
}
Write-Host "[*] Done!" -ForegroundColor Cyan
