#!/bin/bash

# Build script for C++ compiler
# This script compiles the native C++ library for optimal performance

echo "Building C++ compiler for Learn C++ App..."

# Create build directory
mkdir -p build

# Detect platform
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
    EXTENSION="so"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    EXTENSION="dylib"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    PLATFORM="windows"
    EXTENSION="dll"
else
    echo "Unsupported platform: $OSTYPE"
    exit 1
fi

echo "Detected platform: $PLATFORM"

# Compile with maximum optimization
if [[ "$PLATFORM" == "windows" ]]; then
    # Windows compilation
    g++ -shared -fPIC -std=c++17 -O3 -DNDEBUG -march=native -mtune=native \
        -o build/cpp_compiler.$EXTENSION cpp_compiler_optimized.cpp \
        -static-libgcc -static-libstdc++
else
    # Linux/macOS compilation
    g++ -shared -fPIC -std=c++17 -O3 -DNDEBUG -march=native -mtune=native \
        -o build/libcpp_compiler.$EXTENSION cpp_compiler_optimized.cpp \
        -pthread
fi

if [ $? -eq 0 ]; then
    echo "✅ C++ compiler built successfully!"
    echo "Library location: build/libcpp_compiler.$EXTENSION"
    
    # Copy to appropriate Flutter directory
    if [ -d "android/app/src/main/jniLibs" ]; then
        mkdir -p android/app/src/main/jniLibs/arm64-v8a
        cp build/libcpp_compiler.$EXTENSION android/app/src/main/jniLibs/arm64-v8a/
        echo "✅ Copied to Android JNI libs"
    fi
    
    if [ -d "ios" ]; then
        mkdir -p ios/Frameworks
        cp build/libcpp_compiler.$EXTENSION ios/Frameworks/
        echo "✅ Copied to iOS Frameworks"
    fi
    
    echo "🚀 C++ compiler ready for use!"
else
    echo "❌ Build failed!"
    exit 1
fi
