cmake_minimum_required(VERSION 3.10)
project(CppCompiler)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set optimization flags for maximum performance
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG -march=native -mtune=native")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -Wall -Wextra")

# Create shared library for Flutter FFI
add_library(cpp_compiler SHARED cpp_compiler_optimized.cpp)

# Set output directory
set_target_properties(cpp_compiler PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/build"
)

# Link required libraries
target_link_libraries(cpp_compiler pthread)

# Create executable for testing
add_executable(cpp_compiler_test cpp_compiler_optimized.cpp)
target_link_libraries(cpp_compiler_test pthread)

# Install targets
install(TARGETS cpp_compiler
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
