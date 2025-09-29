@echo off
echo Building optimized C++ compiler...

REM Check if g++ is available
where g++ >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: g++ compiler not found. Please install MinGW or MSYS2.
    pause
    exit /b 1
)

REM Create build directory
if not exist "build" mkdir build

REM Compile the optimized C++ compiler
echo Compiling cpp_compiler_optimized.cpp...
g++ -O3 -march=native -mtune=native -flto -ffast-math -funroll-loops -finline-functions -fomit-frame-pointer -DNDEBUG -Wall -Wextra -std=c++17 -shared -fPIC -o build/cpp_compiler.dll cpp_compiler_optimized.cpp

if %errorlevel% neq 0 (
    echo Error: Compilation failed.
    pause
    exit /b 1
)

echo Build successful! cpp_compiler.dll created in build directory.
pause
