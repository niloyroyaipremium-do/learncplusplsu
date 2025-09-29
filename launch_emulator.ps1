# Android Emulator Launcher Script
Write-Host "Android Emulator Launcher" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

# Set Android SDK path
$env:ANDROID_HOME = "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"
$env:PATH += ";$env:ANDROID_HOME\emulator;$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\cmdline-tools\latest\bin"

Write-Host "`nAvailable AVDs:" -ForegroundColor Yellow
emulator -list-avds

Write-Host "`nChoose an emulator to launch:" -ForegroundColor Cyan
Write-Host "1. Pixel_9_Pro" -ForegroundColor White
Write-Host "2. Pixel_4" -ForegroundColor White
Write-Host "3. Pixel" -ForegroundColor White
Write-Host "4. Lightweight_Emulator" -ForegroundColor White

$choice = Read-Host "`nEnter your choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host "Starting Pixel_9_Pro..." -ForegroundColor Green
        Start-Process -FilePath "emulator" -ArgumentList "-avd", "Pixel_9_Pro", "-no-snapshot-load"
    }
    "2" {
        Write-Host "Starting Pixel_4..." -ForegroundColor Green
        Start-Process -FilePath "emulator" -ArgumentList "-avd", "Pixel_4", "-no-snapshot-load"
    }
    "3" {
        Write-Host "Starting Pixel..." -ForegroundColor Green
        Start-Process -FilePath "emulator" -ArgumentList "-avd", "Pixel", "-no-snapshot-load"
    }
    "4" {
        Write-Host "Starting Lightweight_Emulator..." -ForegroundColor Green
        Start-Process -FilePath "emulator" -ArgumentList "-avd", "Lightweight_Emulator", "-no-snapshot-load"
    }
    default {
        Write-Host "Invalid choice. Starting default emulator (Pixel_9_Pro)..." -ForegroundColor Yellow
        Start-Process -FilePath "emulator" -ArgumentList "-avd", "Pixel_9_Pro", "-no-snapshot-load"
    }
}

Write-Host "`nEmulator is starting... This may take a few minutes." -ForegroundColor Yellow
Write-Host "You can close this window once the emulator is running." -ForegroundColor Yellow
Read-Host "Press Enter to continue"
