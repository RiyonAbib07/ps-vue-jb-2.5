# build_download0dat.ps1
# Builds and packages the ps-vue-jb-2.5 exploit into a download0.dat for PS4
# Run this script from the repo root: .\build_download0dat.ps1
# Requires: Node.js (https://nodejs.org) and 7-Zip (https://7-zip.org)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "=== PS VUE JB 2.5 - Build + Package ==="
Write-Host ""

# 1. Install deps
Write-Host "[1/4] Installing npm dependencies..."
npm install

# 2. Build TypeScript --> JavaScript
Write-Host "[2/4] Building exploit JavaScript..."
npm run build

# 3. Create download0.dat (zip of the dist/download0 folder)
#    The PS4 expects the exploit folder packed as a zip renamed to download0.dat
Write-Host "[3/4] Packaging dist/download0 into download0.dat..."

$distPath   = Join-Path $PSScriptRoot "dist\download0"
$outputDat  = Join-Path $PSScriptRoot "download0.dat"

if (!(Test-Path $distPath)) {
    Write-Error "ERROR: dist\download0 not found. Did the build succeed?"
    exit 1
}

# Use Compress-Archive (built-in PowerShell, no 7-Zip needed)
if (Test-Path $outputDat) { Remove-Item $outputDat -Force }

# Compress contents of dist/download0 to a zip, then rename to .dat
$tmpZip = Join-Path $PSScriptRoot "download0.zip"
if (Test-Path $tmpZip) { Remove-Item $tmpZip -Force }

Compress-Archive -Path "$distPath\*" -DestinationPath $tmpZip -CompressionLevel Optimal
Rename-Item -Path $tmpZip -NewName "download0.dat" -Force

Write-Host "[4/4] Done!"
Write-Host ""
Write-Host "Output: $outputDat"
Write-Host ""
Write-Host "Place download0.dat at: /user/download/CUSA00960/download0.dat  on your PS4"
Write-Host "Delete /user/download/CUSA00960/download0_info.dat if present."
