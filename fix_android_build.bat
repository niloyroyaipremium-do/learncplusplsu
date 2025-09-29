@echo off
echo ========================================
echo    CodeLingo Android Build Fix Script
echo ========================================
echo.

echo [1/6] Cleaning previous builds...
call flutter clean
if exist android\app\build rmdir /s /q android\app\build
if exist android\build rmdir /s /q android\build
if exist build rmdir /s /q build

echo.
echo [2/6] Getting Flutter dependencies...
call flutter pub get

echo.
echo [3/6] Updating Gradle wrapper...
cd android
call gradlew wrapper --gradle-version=8.11.1
cd ..

echo.
echo [4/6] Running Gradle clean...
cd android
call gradlew clean
cd ..

echo.
echo [5/6] Building Android APK (Debug)...
call flutter build apk --debug

echo.
echo [6/6] Building Android APK (Release)...
call flutter build apk --release

echo.
echo ========================================
echo    Build Fix Completed Successfully!
echo ========================================
echo.
echo If you encounter any issues:
echo 1. Run: flutter doctor
echo 2. Run: flutter doctor --android-licenses
echo 3. Update Android Studio to latest version
echo 4. Ensure Java 17 is installed and set as JAVA_HOME
echo.
pause