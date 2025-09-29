#!/bin/bash

echo "========================================"
echo "   CodeLingo Android Build Fix Script"
echo "========================================"
echo

echo "[1/6] Cleaning previous builds..."
flutter clean
rm -rf android/app/build
rm -rf android/build
rm -rf build

echo
echo "[2/6] Getting Flutter dependencies..."
flutter pub get

echo
echo "[3/6] Updating Gradle wrapper..."
cd android
./gradlew wrapper --gradle-version=8.11.1
cd ..

echo
echo "[4/6] Running Gradle clean..."
cd android
./gradlew clean
cd ..

echo
echo "[5/6] Building Android APK (Debug)..."
flutter build apk --debug

echo
echo "[6/6] Building Android APK (Release)..."
flutter build apk --release

echo
echo "========================================"
echo "   Build Fix Completed Successfully!"
echo "========================================"
echo
echo "If you encounter any issues:"
echo "1. Run: flutter doctor"
echo "2. Run: flutter doctor --android-licenses"
echo "3. Update Android Studio to latest version"
echo "4. Ensure Java 17 is installed and set as JAVA_HOME"