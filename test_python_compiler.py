#!/usr/bin/env python3
"""
Test script for the Python C++ compiler integration
"""

import sys
import os
import json

# Add current directory to path to import cpp_compiler
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from cpp_compiler import CppCompiler

def test_compiler():
    """Test the C++ compiler functionality"""
    print("Testing Python C++ Compiler Integration")
    print("=" * 50)
    
    compiler = CppCompiler()
    
    # Test 1: Simple Hello World
    print("\n1. Testing Hello World program:")
    hello_world_code = '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}'''
    
    result = compiler.compile_and_run(hello_world_code)
    print(f"Success: {result['success']}")
    print(f"Output: {result['output']}")
    print(f"Error: {result['error']}")
    print(f"Execution Time: {result['execution_time']}ms")
    
    # Test 2: Code with input
    print("\n2. Testing program with input:")
    input_code = '''#include <iostream>
using namespace std;

int main() {
    int number;
    cout << "Enter a number: ";
    cin >> number;
    cout << "You entered: " << number << endl;
    return 0;
}'''
    
    result = compiler.compile_and_run(input_code, "42")
    print(f"Success: {result['success']}")
    print(f"Output: {result['output']}")
    print(f"Error: {result['error']}")
    print(f"Execution Time: {result['execution_time']}ms")
    
    # Test 3: Code with compilation error
    print("\n3. Testing code with compilation error:")
    error_code = '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello" << endl;
    return 0;
}'''
    
    result = compiler.compile_and_run(error_code)
    print(f"Success: {result['success']}")
    print(f"Output: {result['output']}")
    print(f"Error: {result['error']}")
    print(f"Execution Time: {result['execution_time']}ms")
    
    # Test 4: Validation
    print("\n4. Testing code validation:")
    validation_result = compiler.validate_code(hello_world_code)
    print(f"Valid: {validation_result['is_valid']}")
    print(f"Issues: {validation_result['issues']}")
    print(f"Suggestions: {validation_result['suggestions']}")
    
    print("\n" + "=" * 50)
    print("Test completed!")

if __name__ == '__main__':
    test_compiler()
