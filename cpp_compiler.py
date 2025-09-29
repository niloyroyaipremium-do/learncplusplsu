#!/usr/bin/env python3
"""
C++ Compiler and Runner using Python
This script compiles and runs C++ code locally using g++ compiler
"""

import subprocess
import tempfile
import os
import sys
import json
import time
import shutil
from pathlib import Path
import signal

class CppCompiler:
    def __init__(self):
        self.temp_dir = None
        self.compiler_path = self._find_compiler()
        
    def _find_compiler(self):
        """Find the C++ compiler on the system"""
        # Try different compiler names
        compilers = ['g++', 'clang++', 'gcc', 'clang']
        
        for compiler in compilers:
            if shutil.which(compiler):
                return compiler
                
        # If no compiler found, return None
        return None
    
    def compile_and_run(self, code, input_data=None, timeout=10):
        """
        Compile and run C++ code with improved resource management
        
        Args:
            code (str): C++ source code
            input_data (str): Input data for the program
            timeout (int): Timeout in seconds
            
        Returns:
            dict: Result with success, output, error, execution_time
        """
        if not self.compiler_path:
            return {
                'success': False,
                'output': '',
                'error': 'No C++ compiler found. Please install g++ or clang++',
                'execution_time': 0
            }
        
        temp_dir = None
        process = None
        
        try:
            # Create temporary directory
            temp_dir = tempfile.mkdtemp()
            
            # Write C++ code to file
            cpp_file = os.path.join(temp_dir, 'main.cpp')
            with open(cpp_file, 'w', encoding='utf-8') as f:
                f.write(code)
            
            # Compile the code with memory and optimization flags
            exe_file = os.path.join(temp_dir, 'main.exe' if os.name == 'nt' else 'main')
            compile_cmd = [
                self.compiler_path, 
                '-std=c++17', 
                '-O2',  # Optimize for performance
                '-Wall',  # Enable warnings
                '-Wextra',  # Extra warnings
                '-o', exe_file, cpp_file
            ]
            
            # Compile with timeout and resource limits
            compile_result = subprocess.run(
                compile_cmd,
                capture_output=True,
                text=True,
                timeout=30,
                cwd=temp_dir
            )
            
            if compile_result.returncode != 0:
                return {
                    'success': False,
                    'output': '',
                    'error': f'Compilation error:\n{compile_result.stderr}',
                    'execution_time': 0
                }
            
            # Run the compiled program with proper resource management
            start_time = time.time()
            
            run_cmd = [exe_file]
            # Use a simpler approach for better Windows compatibility
            process = subprocess.Popen(
                run_cmd,
                stdin=subprocess.PIPE if input_data else None,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                cwd=temp_dir
            )
            
            try:
                # Send input and get output with timeout
                stdout, stderr = process.communicate(
                    input=input_data,
                    timeout=timeout
                )
                
                execution_time = int((time.time() - start_time) * 1000)
                
                return {
                    'success': process.returncode == 0,
                    'output': stdout,
                    'error': stderr if process.returncode != 0 else '',
                    'execution_time': execution_time
                }
                
            except subprocess.TimeoutExpired:
                # Kill the process
                try:
                    process.terminate()
                    process.wait(timeout=2)
                except (OSError, ProcessLookupError, subprocess.TimeoutExpired):
                    try:
                        process.kill()
                    except (OSError, ProcessLookupError):
                        pass
                
                return {
                    'success': False,
                    'output': '',
                    'error': f'Execution timed out after {timeout} seconds',
                    'execution_time': timeout * 1000
                }
                
        except Exception as e:
            return {
                'success': False,
                'output': '',
                'error': f'Error: {str(e)}',
                'execution_time': 0
            }
        finally:
            # Ensure process is terminated
            if process and process.poll() is None:
                try:
                    process.terminate()
                    process.wait(timeout=1)
                except (OSError, ProcessLookupError, subprocess.TimeoutExpired):
                    try:
                        process.kill()
                    except (OSError, ProcessLookupError):
                        pass
            
            # Clean up temporary directory
            if temp_dir and os.path.exists(temp_dir):
                try:
                    shutil.rmtree(temp_dir, ignore_errors=True)
                except:
                    pass
    
    def validate_code(self, code):
        """
        Validate C++ code syntax (basic validation)
        
        Args:
            code (str): C++ source code
            
        Returns:
            dict: Validation result with is_valid, issues, suggestions
        """
        issues = []
        suggestions = []
        
        # Basic syntax checks
        if not code.strip():
            issues.append('Code is empty')
            return {'is_valid': False, 'issues': issues, 'suggestions': suggestions}
        
        # Check for main function
        if 'int main(' not in code and 'void main(' not in code:
            issues.append('Missing main function')
            suggestions.append('Add int main() function')
        
        # Check for includes
        if 'cout' in code and '#include <iostream>' not in code:
            issues.append('Missing iostream include for cout')
            suggestions.append('Add #include <iostream> at the top')
        
        if 'cin' in code and '#include <iostream>' not in code:
            issues.append('Missing iostream include for cin')
            suggestions.append('Add #include <iostream> at the top')
        
        # Check for balanced braces
        open_braces = code.count('{')
        close_braces = code.count('}')
        if open_braces != close_braces:
            issues.append(f'Mismatched braces: {open_braces} opening, {close_braces} closing')
        
        # Check for balanced parentheses
        open_parens = code.count('(')
        close_parens = code.count(')')
        if open_parens != close_parens:
            issues.append(f'Mismatched parentheses: {open_parens} opening, {close_parens} closing')
        
        # Check for semicolons
        lines = code.split('\n')
        for i, line in enumerate(lines, 1):
            line = line.strip()
            if (line and not line.startswith('#') and 
                not line.startswith('//') and 
                not line.startswith('/*') and
                not line.endswith(';') and
                not line.endswith('{') and
                not line.endswith('}') and
                not line.startswith('if') and
                not line.startswith('for') and
                not line.startswith('while') and
                not line.startswith('switch') and
                not line.startswith('catch') and
                not line.startswith('else') and
                'return' not in line):
                issues.append(f'Missing semicolon at line {i}: {line}')
        
        # Add suggestions
        if 'cout' in code and 'using namespace std;' not in code:
            suggestions.append('Consider adding "using namespace std;" or use std::cout')
        
        if 'cin' in code and 'cout' not in code:
            suggestions.append('Consider adding output statements to see the results')
        
        if 'int main(' in code and 'return 0;' not in code:
            suggestions.append('Consider adding "return 0;" at the end of main function')
        
        return {
            'is_valid': len(issues) == 0,
            'issues': issues,
            'suggestions': suggestions
        }

def main():
    """Main function for command line usage"""
    if len(sys.argv) < 3:
        print("Usage: python cpp_compiler.py <command> <code> [input]")
        print("Commands:")
        print("  compile <code> [input] - Compile and run C++ code")
        print("  validate <code> - Validate C++ code syntax")
        sys.exit(1)
    
    command = sys.argv[1]
    compiler = CppCompiler()
    
    if command == 'compile':
        code = sys.argv[2]
        input_data = sys.argv[3] if len(sys.argv) > 3 else None
        
        result = compiler.compile_and_run(code, input_data)
        print(json.dumps(result, indent=2))
        
    elif command == 'validate':
        code = sys.argv[2]
        result = compiler.validate_code(code)
        print(json.dumps(result, indent=2))
        
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)

if __name__ == '__main__':
    main()
