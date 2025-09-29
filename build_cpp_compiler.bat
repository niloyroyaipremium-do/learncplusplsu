@echo off
echo Building C++ compiler for Learn C++ App...

REM Create build directory
if not exist build mkdir build

REM Compile with maximum optimization for Windows
g++ -shared -fPIC -std=c++17 -O3 -DNDEBUG -march=native -mtune=native -o build\cpp_compiler.dll cpp_compiler_optimized.cpp -static-libgcc -static-libstdc++

if %ERRORLEVEL% EQU 0 (
    echo ✅ C++ compiler built successfully!
    echo Library location: build\cpp_compiler.dll
    
    REM Copy to Android directory if it exists
    if exist "android\app\src\main\jniLibs" (
        if not exist "android\app\src\main\jniLibs\arm64-v8a" mkdir "android\app\src\main\jniLibs\arm64-v8a"
        copy "build\cpp_compiler.dll" "android\app\src\main\jniLibs\arm64-v8a\"
        echo ✅ Copied to Android JNI libs
    )
    
    echo 🚀 C++ compiler ready for use!
) else (
    echo ❌ Build failed!
    exit /b 1
)
