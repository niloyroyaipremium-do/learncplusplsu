#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <chrono>
#include <thread>
#include <future>
#include <memory>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <random>
#include <algorithm>

#ifdef _WIN32
#include <windows.h>
#include <process.h>
#else
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#endif

// High-performance C++ compiler and executor
class CppCompiler {
private:
    std::string tempDir;
    std::string compilerPath;
    std::string executablePath;
    std::vector<std::string> optimizationFlags;
    
    // Performance optimizations
    static constexpr size_t MAX_CODE_SIZE = 1024 * 1024; // 1MB
    static constexpr int MAX_EXECUTION_TIME = 30; // 30 seconds
    static constexpr int MAX_MEMORY_MB = 512; // 512MB
    
    // Thread pool for parallel compilation
    static constexpr int THREAD_POOL_SIZE = 4;
    std::vector<std::thread> threadPool;
    std::queue<std::function<void()>> taskQueue;
    std::mutex queueMutex;
    std::condition_variable condition;
    bool stopThreads = false;

public:
    CppCompiler() {
        initializeCompiler();
        initializeThreadPool();
    }
    
    ~CppCompiler() {
        cleanup();
    }
    
    struct CompilationResult {
        bool success;
        std::string output;
        std::string error;
        double compileTime;
        double executionTime;
    };
    
    CompilationResult compileAndExecute(const std::string& code, int timeoutSeconds = 30) {
        auto startTime = std::chrono::high_resolution_clock::now();
        
        try {
            // Validate code size
            if (code.size() > MAX_CODE_SIZE) {
                return {
                    false,
                    "",
                    "Code size exceeds maximum limit of 1MB",
                    0.0,
                    0.0
                };
            }
            
            // Generate unique filename
            std::string filename = generateUniqueFilename();
            std::string sourcePath = tempDir + "/" + filename + ".cpp";
            std::string executablePath = tempDir + "/" + filename + getExecutableExtension();
            
            // Write code to file
            if (!writeCodeToFile(code, sourcePath)) {
                return {
                    false,
                    "",
                    "Failed to write code to temporary file",
                    0.0,
                    0.0
                };
            }
            
            // Compile code
            auto compileStart = std::chrono::high_resolution_clock::now();
            bool compileSuccess = compileCode(sourcePath, executablePath);
            auto compileEnd = std::chrono::high_resolution_clock::now();
            
            double compileTime = std::chrono::duration<double, std::milli>(compileEnd - compileStart).count();
            
            if (!compileSuccess) {
                return {
                    false,
                    "",
                    "Compilation failed",
                    compileTime,
                    0.0
                };
            }
            
            // Execute code
            auto execStart = std::chrono::high_resolution_clock::now();
            auto execResult = executeCode(executablePath, timeoutSeconds);
            auto execEnd = std::chrono::high_resolution_clock::now();
            
            double executionTime = std::chrono::duration<double, std::milli>(execEnd - execStart).count();
            
            // Cleanup
            cleanupFile(sourcePath);
            cleanupFile(executablePath);
            
            return {
                execResult.success,
                execResult.output,
                execResult.error,
                compileTime,
                executionTime
            };
            
        } catch (const std::exception& e) {
            return {
                false,
                "",
                std::string("Exception: ") + e.what(),
                0.0,
                0.0
            };
        }
    }
    
private:
    void initializeCompiler() {
        // Create temporary directory
        tempDir = createTempDirectory();
        
        // Find compiler
        compilerPath = findCompiler();
        
        // Set optimization flags
        optimizationFlags = {
            "-O3",           // Maximum optimization
            "-march=native", // Use native CPU instructions
            "-mtune=native", // Tune for native CPU
            "-flto",         // Link-time optimization
            "-ffast-math",   // Fast math operations
            "-funroll-loops", // Unroll loops
            "-finline-functions", // Inline functions
            "-fomit-frame-pointer", // Omit frame pointer
            "-DNDEBUG",      // Disable debug assertions
            "-Wall",         // Enable warnings
            "-Wextra",       // Extra warnings
            "-std=c++17"     // C++17 standard
        };
    }
    
    void initializeThreadPool() {
        for (int i = 0; i < THREAD_POOL_SIZE; ++i) {
            threadPool.emplace_back([this]() {
                while (true) {
                    std::function<void()> task;
                    {
                        std::unique_lock<std::mutex> lock(queueMutex);
                        condition.wait(lock, [this] { return !taskQueue.empty() || stopThreads; });
                        
                        if (stopThreads && taskQueue.empty()) {
                            return;
                        }
                        
                        task = std::move(taskQueue.front());
                        taskQueue.pop();
                    }
                    task();
                }
            });
        }
    }
    
    std::string createTempDirectory() {
        std::string tempPath;
        
#ifdef _WIN32
        char tempPathBuffer[MAX_PATH];
        if (GetTempPathA(MAX_PATH, tempPathBuffer)) {
            tempPath = std::string(tempPathBuffer) + "cpp_compiler_" + std::to_string(GetCurrentProcessId());
        }
#else
        tempPath = "/tmp/cpp_compiler_" + std::to_string(getpid());
#endif
        
        std::filesystem::create_directories(tempPath);
        return tempPath;
    }
    
    std::string findCompiler() {
        std::vector<std::string> possiblePaths = {
            "g++",
            "clang++",
            "/usr/bin/g++",
            "/usr/bin/clang++",
            "/usr/local/bin/g++",
            "/usr/local/bin/clang++"
        };
        
        for (const auto& path : possiblePaths) {
            if (system(("which " + path + " > /dev/null 2>&1").c_str()) == 0) {
                return path;
            }
        }
        
        return "g++"; // Default fallback
    }
    
    std::string generateUniqueFilename() {
        static std::random_device rd;
        static std::mt19937 gen(rd());
        static std::uniform_int_distribution<> dis(100000, 999999);
        
        return "cpp_" + std::to_string(dis(gen)) + "_" + std::to_string(std::time(nullptr));
    }
    
    std::string getExecutableExtension() {
#ifdef _WIN32
        return ".exe";
#else
        return "";
#endif
    }
    
    bool writeCodeToFile(const std::string& code, const std::string& filepath) {
        std::ofstream file(filepath);
        if (!file.is_open()) {
            return false;
        }
        
        file << code;
        file.close();
        return true;
    }
    
    bool compileCode(const std::string& sourcePath, const std::string& executablePath) {
        std::stringstream command;
        command << compilerPath;
        
        for (const auto& flag : optimizationFlags) {
            command << " " << flag;
        }
        
        command << " -o " << executablePath << " " << sourcePath;
        
        int result = system(command.str().c_str());
        return result == 0;
    }
    
    struct ExecutionResult {
        bool success;
        std::string output;
        std::string error;
    };
    
    ExecutionResult executeCode(const std::string& executablePath, int timeoutSeconds) {
        std::string output, error;
        bool success = false;
        
        try {
            // Use async execution with timeout
            auto future = std::async(std::launch::async, [&]() {
                return executeWithTimeout(executablePath, timeoutSeconds);
            });
            
            auto status = future.wait_for(std::chrono::seconds(timeoutSeconds));
            
            if (status == std::future_status::ready) {
                auto result = future.get();
                success = result.success;
                output = result.output;
                error = result.error;
            } else {
                success = false;
                error = "Execution timeout exceeded";
            }
            
        } catch (const std::exception& e) {
            success = false;
            error = std::string("Execution error: ") + e.what();
        }
        
        return {success, output, error};
    }
    
    ExecutionResult executeWithTimeout(const std::string& executablePath, int timeoutSeconds) {
        std::string output, error;
        bool success = false;
        
#ifdef _WIN32
        // Windows implementation
        STARTUPINFOA si;
        PROCESS_INFORMATION pi;
        ZeroMemory(&si, sizeof(si));
        si.cb = sizeof(si);
        ZeroMemory(&pi, sizeof(pi));
        
        std::string command = executablePath;
        
        if (CreateProcessA(NULL, const_cast<char*>(command.c_str()), NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
            // Wait for process with timeout
            DWORD waitResult = WaitForSingleObject(pi.hProcess, timeoutSeconds * 1000);
            
            if (waitResult == WAIT_OBJECT_0) {
                DWORD exitCode;
                GetExitCodeProcess(pi.hProcess, &exitCode);
                success = (exitCode == 0);
            } else {
                error = "Process timeout";
                TerminateProcess(pi.hProcess, 1);
            }
            
            CloseHandle(pi.hProcess);
            CloseHandle(pi.hThread);
        } else {
            error = "Failed to create process";
        }
#else
        // Unix implementation
        int pipefd[2];
        if (pipe(pipefd) == -1) {
            error = "Failed to create pipe";
            return {false, "", error};
        }
        
        pid_t pid = fork();
        if (pid == 0) {
            // Child process
            close(pipefd[0]);
            dup2(pipefd[1], STDOUT_FILENO);
            dup2(pipefd[1], STDERR_FILENO);
            close(pipefd[1]);
            
            execl(executablePath.c_str(), executablePath.c_str(), (char*)NULL);
            exit(1);
        } else if (pid > 0) {
            // Parent process
            close(pipefd[1]);
            
            // Set up alarm for timeout
            signal(SIGALRM, [](int) { exit(1); });
            alarm(timeoutSeconds);
            
            char buffer[4096];
            ssize_t bytesRead;
            while ((bytesRead = read(pipefd[0], buffer, sizeof(buffer) - 1)) > 0) {
                buffer[bytesRead] = '\0';
                output += buffer;
            }
            
            close(pipefd[0]);
            
            int status;
            waitpid(pid, &status, 0);
            alarm(0); // Cancel alarm
            
            success = WIFEXITED(status) && WEXITSTATUS(status) == 0;
        } else {
            error = "Failed to fork process";
        }
#endif
        
        return {success, output, error};
    }
    
    void cleanupFile(const std::string& filepath) {
        std::filesystem::remove(filepath);
    }
    
    void cleanup() {
        // Stop thread pool
        {
            std::unique_lock<std::mutex> lock(queueMutex);
            stopThreads = true;
        }
        condition.notify_all();
        
        for (auto& thread : threadPool) {
            if (thread.joinable()) {
                thread.join();
            }
        }
        
        // Cleanup temp directory
        std::filesystem::remove_all(tempDir);
    }
};

// C interface for Dart FFI
extern "C" {
    struct CppResult {
        bool success;
        char* output;
        char* error;
        double compileTime;
        double executionTime;
    };
    
    CppResult* compileCppCode(const char* code, int timeoutSeconds) {
        static CppCompiler compiler;
        
        std::string codeStr(code);
        auto result = compiler.compileAndExecute(codeStr, timeoutSeconds);
        
        CppResult* cppResult = new CppResult;
        cppResult->success = result.success;
        cppResult->output = strdup(result.output.c_str());
        cppResult->error = strdup(result.error.c_str());
        cppResult->compileTime = result.compileTime;
        cppResult->executionTime = result.executionTime;
        
        return cppResult;
    }
    
    void freeCppResult(CppResult* result) {
        if (result) {
            free(result->output);
            free(result->error);
            delete result;
        }
    }
}