# =================================================================
# WINHANCE PORTABLE INSTALLER + AUTO RESTORE POINT
# =================================================================

# 1. Menjalankan Proteksi (System Restore Point)
Write-Host "[*] Menciptakan System Restore Point sebagai pengaman..." -ForegroundColor Cyan
Checkpoint-Computer -Description "Pre-Winhance Installation" -RestorePointType "APPLICATION_INSTALL"

# 2. Konfigurasi Jalur (Path)
$InstallDir = "$HOME\Desktop\PortableApps\Winhance"
$Url = "https://github.com/memstechtips/Winhance/releases/latest/download/Winhance.Installer.exe"
$ShortcutPath = "$HOME\Desktop\Winhance.lnk"
$InstallerPath = "$InstallDir\Winhance_Installer.exe"

# 3. Persiapan Folder
if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
    Write-Host "[*] Folder Portable dibuat: $InstallDir" -ForegroundColor Gray
}

# 4. Unduh Installer
Write-Host "[*] Mengunduh Winhance dari GitHub..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $Url -OutFile $InstallerPath

# 5. Eksekusi Instalasi
Write-Host "-----------------------------------------------------------" -ForegroundColor White
Write-Host "[!] PENTING: Saat installer muncul, ganti lokasi instal ke:" -ForegroundColor White -BackgroundColor DarkRed
Write-Host "    $InstallDir" -ForegroundColor White -BackgroundColor DarkRed
Write-Host "-----------------------------------------------------------" -ForegroundColor White
Start-Process -FilePath $InstallerPath -Wait

# 6. Membuat Shortcut di Desktop
Write-Host "[*] Menciptakan Shortcut di Desktop..." -ForegroundColor Cyan
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "$InstallDir\Winhance.exe"
$Shortcut.WorkingDirectory = $InstallDir
$Shortcut.Description = "Winhance Windows Optimizer Portable"
$Shortcut.Save()

# 7. Pembersihan Total (Cleanup)
if (Test-Path $InstallerPath) {
    Remove-Item -Path $InstallerPath -Force
    Write-Host "[*] Installer dihapus. Folder Portable kini bersih." -ForegroundColor Green
}

Write-Host "===========================================================" -ForegroundColor Green
Write-Host "   PROSES SELESAI! Winhance siap digunakan." -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Green