# **DOKUMEN OPERASIONAL: INSTALLER WINHANCE PORTABLE**

**Target OS:** Windows 10 / 11 (PowerShell)

**Fitur Utama:** Auto-Restore Point, Portable Isolation, Auto-Cleanup.

---

## **1. TEKNOLOGI YANG DIGUNAKAN**

* **VSS (Volume Shadow Copy Service):** Teknologi Windows untuk membuat **System Restore Point**. Ini adalah jaring pengaman sistem sebelum modifikasi dilakukan.
* **PowerShell Object-Oriented Scripting:** Lingkungan otomasi Windows yang mengolah data sebagai **Objek**, memungkinkan interaksi langsung dengan API sistem.
* **WScript.Shell (COM Interface):** Antarmuka komunikasi untuk menciptakan file `.lnk` (Shortcut) secara dinamis di Windows Explorer.
* **GitHub Raw Content:** Layanan untuk menyajikan kode dalam format teks polos (*plain text*), yang diperlukan agar skrip dapat dibaca langsung oleh PowerShell tanpa terhalang kode HTML situs web.

---

## **2. SKRIP UTAMA: `Install-Winhance.ps1**`

```powershell
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

```

---

## **3. PANDUAN: CARA MEMASUKKAN SKRIP KE GITHUB**

Agar skrip PowerShell (`.ps1`) Anda bisa dipanggil melalui One-Liner, Anda harus mengunggahnya ke GitHub dengan prosedur berikut:

### **1. Membuat Repositori Baru**

* Login ke akun GitHub Anda.
* Klik ikon **"+"** di pojok kanan atas, lalu pilih **New repository**.
* Berikan nama pada **Repository name** (contoh: `my-scripts`).
* Pilih **Public** (Wajib Public agar One-Liner bisa mengunduh file tanpa token rahasia).
* Klik **Create repository**.

### **2. Mengunggah File Skrip**

* Di halaman repositori yang baru dibuat, klik **uploading an existing file**.
* Tarik (*drag & drop*) file `Install-Winhance.ps1` Anda ke kotak yang tersedia.
* Klik tombol **Commit changes** di bagian bawah.

### **3. Mengambil Link "Raw" (Sangat Penting)**

One-Liner tidak akan berfungsi jika Anda menggunakan URL yang ada di address bar browser saat melihat kode. Anda harus mengambil **Raw Link**:

* Klik nama file `Install-Winhance.ps1` di daftar file repositori.
* Di bagian atas bingkai kode, cari dan klik tombol **Raw**.
* Sekarang, lihat address bar browser Anda. URL-nya harus berubah menjadi: `https://raw.githubusercontent.com/USERNAME/REPO/main/Install-Winhance.ps1`
* **Salin URL tersebut** untuk dimasukkan ke dalam perintah One-Liner Anda.

---

## **4. REKAPITULASI PENYESUAIAN ONE-LINER**

Setelah Anda mendapatkan link Raw tersebut, masukkan ke dalam perintah ini:

```powershell
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope Process -Force; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iwr -useb [MASUKKAN_LINK_RAW_DI_SINI] | iex"

```

### **Rincian yang harus Anda sesuaikan:**

* **USERNAME:** Nama akun GitHub Anda.
* **REPO:** Nama repositori yang Anda buat (misal: `my-scripts`).
* **main:** Nama branch (biasanya `main` secara otomatis).
* **Install-Winhance.ps1:** Pastikan nama file sama persis dengan yang Anda unggah.

---

## **5. PANDUAN IMPLEMENTASI & PENGGUNAAN**

### **Langkah Persiapan (Admin)**

Karena skrip ini membuat **System Restore Point**, Anda **WAJIB** menjalankan terminal sebagai **Administrator**.

1. Klik kanan pada tombol Start, pilih **Terminal (Admin)** atau **PowerShell (Admin)**.
2. Tempelkan perintah One-Liner yang sudah disesuaikan, lalu tekan Enter.

### **Alur Kerja Skrip**

1. **System Restore:** Menciptakan cadangan sistem melalui VSS.
2. **Portable Isolation:** Mengunduh biner aplikasi ke folder khusus agar tidak mengotori `Program Files`.
3. **Deployment:** Membuka installer. Pengguna harus mengarahkan jalur instalasi ke folder `$HOME\Desktop\PortableApps\Winhance`.
4. **Shortcut & Cleanup:** Membuat akses cepat di desktop dan secara otomatis menghapus file `.exe` installer asli untuk menjaga kebersihan folder.

---
