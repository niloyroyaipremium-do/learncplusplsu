#!/bin/bash

echo "Building optimized C++ compiler..."

# Check if g++ is available
if ! command -v g++ &> /dev/null; then
    echo "Error: g++ compiler not found. Please install g++."
    exit 1
fi

# Create build directory
mkdir -p build

# Compile the optimized C++ compiler
echo "Compiling cpp_compiler_optimized.cpp..."
g++ -O3 -march=native -mtune=native -flto -ffast-math -funroll-loops -finline-functions -fomit-frame-pointer -DNDEBUG -Wall -Wextra -std=c++17 -shared -fPIC -o build/libcpp_compiler.so cpp_compiler_optimized.cpp

if [ $? -ne 0 ]; then
    echo "Error: Compilation failed."
    exit 1
fi

echo "Build successful! libcpp_compiler.so created in build directory."
