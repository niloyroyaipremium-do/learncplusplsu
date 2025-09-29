@echo off
echo Setting up Android development environment...

REM Set Android SDK path
set ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk
set ANDROID_SDK_ROOT=%ANDROID_HOME%

REM Add Android tools to PATH
set PATH=%PATH%;%ANDROID_HOME%\emulator
set PATH=%PATH%;%ANDROID_HOME%\platform-tools
set PATH=%PATH%;%ANDROID_HOME%\cmdline-tools\latest\bin
set PATH=%PATH%;%ANDROID_HOME%\tools\bin

REM Set Java home (if needed)
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr

echo Environment variables set:
echo ANDROID_HOME=%ANDROID_HOME%
echo.

echo Available AVDs:
emulator -list-avds
echo.

echo Starting emulator...
emulator -avd Pixel_9_Pro -no-snapshot-load -no-snapshot-save

pause
