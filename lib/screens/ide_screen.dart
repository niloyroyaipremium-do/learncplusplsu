// IDE Screen - Paste your code here
import 'package:flutter/material.dart';
import '../services/cpp_execution_service.dart';
import '../widgets/syntax_highlighted_editor.dart';

class AdvancedCppIDEScreen extends StatefulWidget {
  const AdvancedCppIDEScreen({super.key});

  @override
  State<AdvancedCppIDEScreen> createState() => _AdvancedCppIDEScreenState();
}

class _AdvancedCppIDEScreenState extends State<AdvancedCppIDEScreen>
    with TickerProviderStateMixin {
  late TextEditingController _codeController;
  late TextEditingController _outputController;
  late TabController _tabController;
  bool _isRunning = false;
  String _selectedTemplate = 'basic';
  final List<String> _outputHistory = [];

  // Advanced C++ program templates
  final Map<String, String> _templates = {
    'basic': '''#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <map>
#include <set>
#include <queue>
#include <stack>
#include <cmath>
#include <iomanip>
using namespace std;

// Advanced C++ Program: Student Management System
class Student {
private:
    string name;
    int id;
    vector<double> grades;
    double gpa;
    
public:
    Student(string n, int i) : name(n), id(i), gpa(0.0) {}
    
    void addGrade(double grade) {
        grades.push_back(grade);
        calculateGPA();
    }
    
    void calculateGPA() {
        if (grades.empty()) {
            gpa = 0.0;
            return;
        }
        double sum = 0.0;
        for (double grade : grades) {
            sum += grade;
        }
        gpa = sum / grades.size();
    }
    
    string getName() const { return name; }
    int getID() const { return id; }
    double getGPA() const { return gpa; }
    vector<double> getGrades() const { return grades; }
    
    void displayInfo() const {
        cout << "Student: " << name << " (ID: " << id << ")" << endl;
        cout << "Grades: ";
        for (size_t i = 0; i < grades.size(); ++i) {
            cout << grades[i];
            if (i < grades.size() - 1) cout << ", ";
        }
        cout << endl;
        cout << "GPA: " << fixed << setprecision(2) << gpa << endl;
    }
};

class StudentManager {
private:
    vector<Student> students;
    map<int, Student*> studentMap;
    
public:
    void addStudent(const Student& student) {
        students.push_back(student);
        studentMap[student.getID()] = &students.back();
    }
    
    Student* findStudent(int id) {
        auto it = studentMap.find(id);
        return (it != studentMap.end()) ? it->second : nullptr;
    }
    
    void displayAllStudents() const {
        cout << "\\n=== All Students ===" << endl;
        for (const auto& student : students) {
            student.displayInfo();
            cout << "---" << endl;
        }
    }
    
    void displayTopStudents(int count = 3) const {
        vector<Student> sortedStudents = students;
        sort(sortedStudents.begin(), sortedStudents.end(),
             [](const Student& a, const Student& b) {
                 return a.getGPA() > b.getGPA();
             });
        
        cout << "\\n=== Top " << count << " Students ===" << endl;
        for (int i = 0; i < min(count, (int)sortedStudents.size()); ++i) {
            cout << (i + 1) << ". ";
            sortedStudents[i].displayInfo();
            cout << "---" << endl;
        }
    }
    
    double getAverageGPA() const {
        if (students.empty()) return 0.0;
        double total = 0.0;
        for (const auto& student : students) {
            total += student.getGPA();
        }
        return total / students.size();
    }
    
    int getStudentCount() const { return students.size(); }
};

// Template function for generic operations
template<typename T>
void printVector(const vector<T>& vec, const string& name = "Vector") {
    cout << name << ": [";
    for (size_t i = 0; i < vec.size(); ++i) {
        cout << vec[i];
        if (i < vec.size() - 1) cout << ", ";
    }
    cout << "]" << endl;
}

// Advanced algorithm implementations
class Algorithms {
public:
    // Binary Search
    template<typename T>
    static int binarySearch(const vector<T>& arr, T target) {
        int left = 0, right = arr.size() - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] == target) return mid;
            if (arr[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1;
    }
    
    // Quick Sort
    template<typename T>
    static void quickSort(vector<T>& arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            quickSort(arr, low, pi - 1);
            quickSort(arr, pi + 1, high);
        }
    }
    
private:
    template<typename T>
    static int partition(vector<T>& arr, int low, int high) {
        T pivot = arr[high];
        int i = low - 1;
        
        for (int j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                i++;
                swap(arr[i], arr[j]);
            }
        }
        swap(arr[i + 1], arr[high]);
        return i + 1;
    }
};

// Exception handling class
class StudentException : public exception {
private:
    string message;
public:
    StudentException(const string& msg) : message(msg) {}
    const char* what() const noexcept override {
        return message.c_str();
    }
};

// Smart pointer demonstration
class ResourceManager {
private:
    unique_ptr<StudentManager> manager;
    
public:
    ResourceManager() : manager(make_unique<StudentManager>()) {}
    
    StudentManager* getManager() { return manager.get(); }
    
    void demonstrateSmartPointers() {
        cout << "\\n=== Smart Pointer Demonstration ===" << endl;
        
        // Unique pointer
        auto uniqueStudent = make_unique<Student>("Smart Student", 999);
        cout << "Created unique student: " << uniqueStudent->getName() << endl;
        
        // Shared pointer
        auto sharedStudent = make_shared<Student>("Shared Student", 998);
        cout << "Created shared student: " << sharedStudent->getName() << endl;
        cout << "Reference count: " << sharedStudent.use_count() << endl;
        
        // Weak pointer
        weak_ptr<Student> weakStudent = sharedStudent;
        cout << "Created weak reference" << endl;
        cout << "Reference count after weak: " << sharedStudent.use_count() << endl;
    }
};

// Lambda functions and STL algorithms
class AdvancedFeatures {
public:
    static void demonstrateLambdas() {
        cout << "\\n=== Lambda Functions ===" << endl;
        
        vector<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        
        // Lambda for filtering even numbers
        auto isEven = [](int n) { return n % 2 == 0; };
        vector<int> evenNumbers;
        copy_if(numbers.begin(), numbers.end(), 
                back_inserter(evenNumbers), isEven);
        
        cout << "Even numbers: ";
        for (int num : evenNumbers) cout << num << " ";
        cout << endl;
        
        // Lambda for transformation
        auto square = [](int n) { return n * n; };
        vector<int> squares;
        transform(numbers.begin(), numbers.end(), 
                 back_inserter(squares), square);
        
        cout << "Squares: ";
        for (int num : squares) cout << num << " ";
        cout << endl;
        
        // Lambda for reduction
        auto sum = [](int a, int b) { return a + b; };
        int total = accumulate(numbers.begin(), numbers.end(), 0, sum);
        cout << "Sum of all numbers: " << total << endl;
    }
    
    static void demonstrateSTL() {
        cout << "\\n=== STL Containers and Algorithms ===" << endl;
        
        // Set operations
        set<int> set1 = {1, 2, 3, 4, 5};
        set<int> set2 = {4, 5, 6, 7, 8};
        
        set<int> intersection;
        set_intersection(set1.begin(), set1.end(),
                        set2.begin(), set2.end(),
                        inserter(intersection, intersection.begin()));
        
        cout << "Set 1: ";
        for (int x : set1) cout << x << " ";
        cout << endl;
        
        cout << "Set 2: ";
        for (int x : set2) cout << x << " ";
        cout << endl;
        
        cout << "Intersection: ";
        for (int x : intersection) cout << x << " ";
        cout << endl;
        
        // Map operations
        map<string, int> wordCount;
        vector<string> words = {"hello", "world", "hello", "cpp", "world", "hello"};
        
        for (const string& word : words) {
            wordCount[word]++;
        }
        
        cout << "\\nWord count:" << endl;
        for (const auto& pair : wordCount) {
            cout << pair.first << ": " << pair.second << endl;
        }
    }
};

// Threading demonstration
#include <thread>
#include <mutex>
#include <chrono>

class ThreadingDemo {
private:
    static mutex mtx;
    static int counter;
    
public:
    static void incrementCounter() {
        for (int i = 0; i < 1000; ++i) {
            lock_guard<mutex> lock(mtx);
            counter++;
        }
    }
    
    static void demonstrateThreading() {
        cout << "\\n=== Threading Demonstration ===" << endl;
        counter = 0;
        
        auto start = chrono::high_resolution_clock::now();
        
        thread t1(incrementCounter);
        thread t2(incrementCounter);
        
        t1.join();
        t2.join();
        
        auto end = chrono::high_resolution_clock::now();
        auto duration = chrono::duration_cast<chrono::microseconds>(end - start);
        
        cout << "Final counter value: " << counter << endl;
        cout << "Execution time: " << duration.count() << " microseconds" << endl;
    }
};

// Static member definitions
mutex ThreadingDemo::mtx;
int ThreadingDemo::counter = 0;

int main() {
    cout << "=== Advanced C++ Program: Student Management System ===" << endl;
    cout << "Demonstrating OOP, Templates, STL, Threading, and more!" << endl;
    
    try {
        // Create student manager
        StudentManager manager;
        
        // Add some students
        Student s1("Alice Johnson", 1001);
        s1.addGrade(85.5);
        s1.addGrade(92.0);
        s1.addGrade(78.5);
        manager.addStudent(s1);
        
        Student s2("Bob Smith", 1002);
        s2.addGrade(95.0);
        s2.addGrade(88.5);
        s2.addGrade(91.0);
        manager.addStudent(s2);
        
        Student s3("Charlie Brown", 1003);
        s3.addGrade(76.0);
        s3.addGrade(82.5);
        s3.addGrade(79.0);
        manager.addStudent(s3);
        
        Student s4("Diana Prince", 1004);
        s4.addGrade(98.0);
        s4.addGrade(96.5);
        s4.addGrade(97.0);
        manager.addStudent(s4);
        
        // Display all students
        manager.displayAllStudents();
        
        // Display top students
        manager.displayTopStudents(2);
        
        // Show statistics
        cout << "\\n=== Statistics ===" << endl;
        cout << "Total students: " << manager.getStudentCount() << endl;
        cout << "Average GPA: " << fixed << setprecision(2) 
             << manager.getAverageGPA() << endl;
        
        // Demonstrate algorithms
        cout << "\\n=== Algorithm Demonstrations ===" << endl;
        vector<int> numbers = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19};
        printVector(numbers, "Sorted numbers");
        
        int searchValue = 11;
        int index = Algorithms::binarySearch(numbers, searchValue);
        if (index != -1) {
            cout << "Found " << searchValue << " at index " << index << endl;
        } else {
            cout << searchValue << " not found" << endl;
        }
        
        // Demonstrate sorting
        vector<int> unsorted = {64, 34, 25, 12, 22, 11, 90};
        cout << "Before sorting: ";
        printVector(unsorted, "");
        
        Algorithms::quickSort(unsorted, 0, unsorted.size() - 1);
        cout << "After sorting: ";
        printVector(unsorted, "");
        
        // Demonstrate advanced features
        AdvancedFeatures::demonstrateLambdas();
        AdvancedFeatures::demonstrateSTL();
        
        // Demonstrate smart pointers
        ResourceManager resourceManager;
        resourceManager.demonstrateSmartPointers();
        
        // Demonstrate threading
        ThreadingDemo::demonstrateThreading();
        
        // Exception handling demonstration
        cout << "\\n=== Exception Handling ===" << endl;
        try {
            Student* student = manager.findStudent(9999);
            if (student == nullptr) {
                throw StudentException("Student with ID 9999 not found!");
            }
        } catch (const StudentException& e) {
            cout << "Caught exception: " << e.what() << endl;
        }
        
        cout << "\\n=== Program completed successfully! ===" << endl;
        
    } catch (const exception& e) {
        cout << "Error: " << e.what() << endl;
        return 1;
    }
    
    return 0;
}''',

    'data_structures': '''#include <iostream>
#include <vector>
#include <list>
#include <deque>
#include <stack>
#include <queue>
#include <set>
#include <map>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>
#include <memory>
using namespace std;

// Advanced Data Structures Implementation
template<typename T>
class BinaryTree {
private:
    struct Node {
        T data;
        unique_ptr<Node> left;
        unique_ptr<Node> right;
        
        Node(T value) : data(value), left(nullptr), right(nullptr) {}
    };
    
    unique_ptr<Node> root;
    
    void insertHelper(unique_ptr<Node>& node, T value) {
        if (!node) {
            node = make_unique<Node>(value);
            return;
        }
        
        if (value < node->data) {
            insertHelper(node->left, value);
        } else if (value > node->data) {
            insertHelper(node->right, value);
        }
    }
    
    void inorderHelper(const unique_ptr<Node>& node, vector<T>& result) const {
        if (!node) return;
        inorderHelper(node->left, result);
        result.push_back(node->data);
        inorderHelper(node->right, result);
    }
    
public:
    void insert(T value) {
        insertHelper(root, value);
    }
    
    vector<T> inorder() const {
        vector<T> result;
        inorderHelper(root, result);
        return result;
    }
    
    bool search(T value) const {
        Node* current = root.get();
        while (current) {
            if (value == current->data) return true;
            if (value < current->data) {
                current = current->left.get();
            } else {
                current = current->right.get();
            }
        }
        return false;
    }
};

template<typename T>
class Graph {
private:
    map<T, vector<T>> adjacencyList;
    
public:
    void addVertex(T vertex) {
        adjacencyList[vertex] = vector<T>();
    }
    
    void addEdge(T from, T to) {
        adjacencyList[from].push_back(to);
        adjacencyList[to].push_back(from); // Undirected graph
    }
    
    vector<T> getNeighbors(T vertex) const {
        auto it = adjacencyList.find(vertex);
        return (it != adjacencyList.end()) ? it->second : vector<T>();
    }
    
    void dfs(T start, set<T>& visited) const {
        visited.insert(start);
        cout << start << " ";
        
        for (T neighbor : getNeighbors(start)) {
            if (visited.find(neighbor) == visited.end()) {
                dfs(neighbor, visited);
            }
        }
    }
    
    void bfs(T start) const {
        set<T> visited;
        queue<T> q;
        
        q.push(start);
        visited.insert(start);
        
        while (!q.empty()) {
            T current = q.front();
            q.pop();
            cout << current << " ";
            
            for (T neighbor : getNeighbors(current)) {
                if (visited.find(neighbor) == visited.end()) {
                    visited.insert(neighbor);
                    q.push(neighbor);
                }
            }
        }
    }
};

template<typename T>
class MinHeap {
private:
    vector<T> heap;
    
    void heapifyUp(int index) {
        if (index == 0) return;
        
        int parent = (index - 1) / 2;
        if (heap[index] < heap[parent]) {
            swap(heap[index], heap[parent]);
            heapifyUp(parent);
        }
    }
    
    void heapifyDown(int index) {
        int left = 2 * index + 1;
        int right = 2 * index + 2;
        int smallest = index;
        
        if (left < heap.size() && heap[left] < heap[smallest]) {
            smallest = left;
        }
        
        if (right < heap.size() && heap[right] < heap[smallest]) {
            smallest = right;
        }
        
        if (smallest != index) {
            swap(heap[index], heap[smallest]);
            heapifyDown(smallest);
        }
    }
    
public:
    void insert(T value) {
        heap.push_back(value);
        heapifyUp(heap.size() - 1);
    }
    
    T extractMin() {
        if (heap.empty()) {
            throw runtime_error("Heap is empty");
        }
        
        T min = heap[0];
        heap[0] = heap.back();
        heap.pop_back();
        
        if (!heap.empty()) {
            heapifyDown(0);
        }
        
        return min;
    }
    
    bool empty() const {
        return heap.empty();
    }
    
    size_t size() const {
        return heap.size();
    }
};

template<typename T>
class Trie {
private:
    struct TrieNode {
        map<char, unique_ptr<TrieNode>> children;
        bool isEndOfWord;
        T value;
        
        TrieNode() : isEndOfWord(false) {}
    };
    
    unique_ptr<TrieNode> root;
    
public:
    Trie() : root(make_unique<TrieNode>()) {}
    
    void insert(const string& key, T value) {
        TrieNode* current = root.get();
        
        for (char c : key) {
            if (current->children.find(c) == current->children.end()) {
                current->children[c] = make_unique<TrieNode>();
            }
            current = current->children[c].get();
        }
        
        current->isEndOfWord = true;
        current->value = value;
    }
    
    bool search(const string& key, T& value) const {
        TrieNode* current = root.get();
        
        for (char c : key) {
            if (current->children.find(c) == current->children.end()) {
                return false;
            }
            current = current->children[c].get();
        }
        
        if (current->isEndOfWord) {
            value = current->value;
            return true;
        }
        
        return false;
    }
    
    bool startsWith(const string& prefix) const {
        TrieNode* current = root.get();
        
        for (char c : prefix) {
            if (current->children.find(c) == current->children.end()) {
                return false;
            }
            current = current->children[c].get();
        }
        
        return true;
    }
};

int main() {
    cout << "=== Advanced Data Structures Demonstration ===" << endl;
    
    // Binary Tree
    cout << "\\n1. Binary Search Tree:" << endl;
    BinaryTree<int> bst;
    vector<int> values = {50, 30, 70, 20, 40, 60, 80, 10, 25, 35, 45};
    
    for (int val : values) {
        bst.insert(val);
    }
    
    vector<int> inorder = bst.inorder();
    cout << "Inorder traversal: ";
    for (int val : inorder) {
        cout << val << " ";
    }
    cout << endl;
    
    cout << "Search for 40: " << (bst.search(40) ? "Found" : "Not found") << endl;
    cout << "Search for 100: " << (bst.search(100) ? "Found" : "Not found") << endl;
    
    // Graph
    cout << "\\n2. Graph (DFS and BFS):" << endl;
    Graph<string> graph;
    
    vector<string> cities = {"A", "B", "C", "D", "E", "F"};
    for (const string& city : cities) {
        graph.addVertex(city);
    }
    
    graph.addEdge("A", "B");
    graph.addEdge("A", "C");
    graph.addEdge("B", "D");
    graph.addEdge("C", "E");
    graph.addEdge("D", "F");
    graph.addEdge("E", "F");
    
    cout << "DFS from A: ";
    set<string> visited;
    graph.dfs("A", visited);
    cout << endl;
    
    cout << "BFS from A: ";
    graph.bfs("A");
    cout << endl;
    
    // Min Heap
    cout << "\\n3. Min Heap:" << endl;
    MinHeap<int> minHeap;
    vector<int> heapValues = {10, 5, 15, 3, 8, 12, 20, 1, 7, 9};
    
    for (int val : heapValues) {
        minHeap.insert(val);
        cout << "Inserted " << val << ", heap size: " << minHeap.size() << endl;
    }
    
    cout << "\\nExtracting minimum values:" << endl;
    while (!minHeap.empty()) {
        cout << "Min: " << minHeap.extractMin() << ", remaining size: " 
             << minHeap.size() << endl;
    }
    
    // Trie
    cout << "\\n4. Trie (Prefix Tree):" << endl;
    Trie<string> trie;
    
    trie.insert("apple", "A fruit");
    trie.insert("application", "A software program");
    trie.insert("apply", "To make a formal request");
    trie.insert("app", "Short for application");
    trie.insert("banana", "Another fruit");
    trie.insert("band", "A musical group");
    
    vector<string> searchWords = {"app", "apple", "application", "ban", "band"};
    for (const string& word : searchWords) {
        string meaning;
        if (trie.search(word, meaning)) {
            cout << word << ": " << meaning << endl;
        } else {
            cout << word << ": Not found" << endl;
        }
    }
    
    cout << "\\nPrefix search for 'app':" << endl;
    vector<string> prefixes = {"app", "ban", "xyz"};
    for (const string& prefix : prefixes) {
        cout << "Starts with '" << prefix << "': " 
             << (trie.startsWith(prefix) ? "Yes" : "No") << endl;
    }
    
    // STL Containers comparison
    cout << "\\n5. STL Containers Performance Test:" << endl;
    
    const int SIZE = 10000;
    vector<int> vec;
    list<int> lst;
    set<int> st;
    unordered_set<int> ust;
    
    // Vector operations
    auto start = chrono::high_resolution_clock::now();
    for (int i = 0; i < SIZE; ++i) {
        vec.push_back(i);
    }
    auto end = chrono::high_resolution_clock::now();
    auto vecTime = chrono::duration_cast<chrono::microseconds>(end - start);
    
    // List operations
    start = chrono::high_resolution_clock::now();
    for (int i = 0; i < SIZE; ++i) {
        lst.push_back(i);
    }
    end = chrono::high_resolution_clock::now();
    auto listTime = chrono::duration_cast<chrono::microseconds>(end - start);
    
    // Set operations
    start = chrono::high_resolution_clock::now();
    for (int i = 0; i < SIZE; ++i) {
        st.insert(i);
    }
    end = chrono::high_resolution_clock::now();
    auto setTime = chrono::duration_cast<chrono::microseconds>(end - start);
    
    // Unordered set operations
    start = chrono::high_resolution_clock::now();
    for (int i = 0; i < SIZE; ++i) {
        ust.insert(i);
    }
    end = chrono::high_resolution_clock::now();
    auto uSetTime = chrono::duration_cast<chrono::microseconds>(end - start);
    
    cout << "Insertion times for " << SIZE << " elements:" << endl;
    cout << "Vector: " << vecTime.count() << " microseconds" << endl;
    cout << "List: " << listTime.count() << " microseconds" << endl;
    cout << "Set: " << setTime.count() << " microseconds" << endl;
    cout << "Unordered Set: " << uSetTime.count() << " microseconds" << endl;
    
    cout << "\\n=== Data Structures demonstration completed! ===" << endl;
    
    return 0;
}''',

    'algorithms': '''#include <iostream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <random>
#include <queue>
#include <stack>
#include <map>
#include <set>
using namespace std;

// Advanced Algorithms Implementation
class SortingAlgorithms {
public:
    // Merge Sort
    static void mergeSort(vector<int>& arr, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2;
            mergeSort(arr, left, mid);
            mergeSort(arr, mid + 1, right);
            merge(arr, left, mid, right);
        }
    }
    
private:
    static void merge(vector<int>& arr, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;
        
        vector<int> L(n1), R(n2);
        
        for (int i = 0; i < n1; i++) L[i] = arr[left + i];
        for (int j = 0; j < n2; j++) R[j] = arr[mid + 1 + j];
        
        int i = 0, j = 0, k = left;
        
        while (i < n1 && j < n2) {
            if (L[i] <= R[j]) {
                arr[k] = L[i];
                i++;
            } else {
                arr[k] = R[j];
                j++;
            }
            k++;
        }
        
        while (i < n1) {
            arr[k] = L[i];
            i++;
            k++;
        }
        
        while (j < n2) {
            arr[k] = R[j];
            j++;
            k++;
        }
    }
    
public:
    // Heap Sort
    static void heapSort(vector<int>& arr) {
        int n = arr.size();
        
        for (int i = n / 2 - 1; i >= 0; i--) {
            heapify(arr, n, i);
        }
        
        for (int i = n - 1; i > 0; i--) {
            swap(arr[0], arr[i]);
            heapify(arr, i, 0);
        }
    }
    
private:
    static void heapify(vector<int>& arr, int n, int i) {
        int largest = i;
        int left = 2 * i + 1;
        int right = 2 * i + 2;
        
        if (left < n && arr[left] > arr[largest]) {
            largest = left;
        }
        
        if (right < n && arr[right] > arr[largest]) {
            largest = right;
        }
        
        if (largest != i) {
            swap(arr[i], arr[largest]);
            heapify(arr, n, largest);
        }
    }
    
public:
    // Counting Sort
    static void countingSort(vector<int>& arr) {
        int maxVal = *max_element(arr.begin(), arr.end());
        int minVal = *min_element(arr.begin(), arr.end());
        int range = maxVal - minVal + 1;
        
        vector<int> count(range), output(arr.size());
        
        for (int i = 0; i < arr.size(); i++) {
            count[arr[i] - minVal]++;
        }
        
        for (int i = 1; i < range; i++) {
            count[i] += count[i - 1];
        }
        
        for (int i = arr.size() - 1; i >= 0; i--) {
            output[count[arr[i] - minVal] - 1] = arr[i];
            count[arr[i] - minVal]--;
        }
        
        arr = output;
    }
};

class GraphAlgorithms {
public:
    // Dijkstra's Algorithm
    static vector<int> dijkstra(const vector<vector<pair<int, int>>>& graph, int start) {
        int n = graph.size();
        vector<int> dist(n, INT_MAX);
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
        
        dist[start] = 0;
        pq.push({0, start});
        
        while (!pq.empty()) {
            int u = pq.top().second;
            int d = pq.top().first;
            pq.pop();
            
            if (d > dist[u]) continue;
            
            for (const auto& edge : graph[u]) {
                int v = edge.first;
                int weight = edge.second;
                
                if (dist[u] + weight < dist[v]) {
                    dist[v] = dist[u] + weight;
                    pq.push({dist[v], v});
                }
            }
        }
        
        return dist;
    }
    
    // Floyd-Warshall Algorithm
    static vector<vector<int>> floydWarshall(const vector<vector<int>>& graph) {
        int n = graph.size();
        vector<vector<int>> dist = graph;
        
        for (int k = 0; k < n; k++) {
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    if (dist[i][k] != INT_MAX && dist[k][j] != INT_MAX) {
                        dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j]);
                    }
                }
            }
        }
        
        return dist;
    }
    
    // Topological Sort
    static vector<int> topologicalSort(const vector<vector<int>>& graph) {
        int n = graph.size();
        vector<int> inDegree(n, 0);
        queue<int> q;
        vector<int> result;
        
        for (int i = 0; i < n; i++) {
            for (int neighbor : graph[i]) {
                inDegree[neighbor]++;
            }
        }
        
        for (int i = 0; i < n; i++) {
            if (inDegree[i] == 0) {
                q.push(i);
            }
        }
        
        while (!q.empty()) {
            int u = q.front();
            q.pop();
            result.push_back(u);
            
            for (int v : graph[u]) {
                inDegree[v]--;
                if (inDegree[v] == 0) {
                    q.push(v);
                }
            }
        }
        
        return result;
    }
};

class DynamicProgramming {
public:
    // Longest Common Subsequence
    static int lcs(const string& s1, const string& s2) {
        int m = s1.length();
        int n = s2.length();
        vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
        
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (s1[i - 1] == s2[j - 1]) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        
        return dp[m][n];
    }
    
    // Knapsack Problem
    static int knapsack(const vector<int>& weights, const vector<int>& values, int capacity) {
        int n = weights.size();
        vector<vector<int>> dp(n + 1, vector<int>(capacity + 1, 0));
        
        for (int i = 1; i <= n; i++) {
            for (int w = 1; w <= capacity; w++) {
                if (weights[i - 1] <= w) {
                    dp[i][w] = max(values[i - 1] + dp[i - 1][w - weights[i - 1]], 
                                  dp[i - 1][w]);
                } else {
                    dp[i][w] = dp[i - 1][w];
                }
            }
        }
        
        return dp[n][capacity];
    }
    
    // Fibonacci with Memoization
    static long long fibonacci(int n, map<int, long long>& memo) {
        if (n <= 1) return n;
        if (memo.find(n) != memo.end()) return memo[n];
        
        memo[n] = fibonacci(n - 1, memo) + fibonacci(n - 2, memo);
        return memo[n];
    }
};

class StringAlgorithms {
public:
    // KMP Algorithm
    static vector<int> kmpSearch(const string& text, const string& pattern) {
        vector<int> result;
        vector<int> lps = computeLPS(pattern);
        
        int i = 0, j = 0;
        while (i < text.length()) {
            if (pattern[j] == text[i]) {
                i++;
                j++;
            }
            
            if (j == pattern.length()) {
                result.push_back(i - j);
                j = lps[j - 1];
            } else if (i < text.length() && pattern[j] != text[i]) {
                if (j != 0) {
                    j = lps[j - 1];
                } else {
                    i++;
                }
            }
        }
        
        return result;
    }
    
private:
    static vector<int> computeLPS(const string& pattern) {
        int m = pattern.length();
        vector<int> lps(m, 0);
        int len = 0;
        
        for (int i = 1; i < m; i++) {
            while (len > 0 && pattern[i] != pattern[len]) {
                len = lps[len - 1];
            }
            
            if (pattern[i] == pattern[len]) {
                len++;
            }
            
            lps[i] = len;
        }
        
        return lps;
    }
    
public:
    // Rabin-Karp Algorithm
    static vector<int> rabinKarpSearch(const string& text, const string& pattern) {
        vector<int> result;
        int n = text.length();
        int m = pattern.length();
        
        if (m > n) return result;
        
        const int base = 256;
        const int mod = 101;
        
        int patternHash = 0;
        int textHash = 0;
        int h = 1;
        
        for (int i = 0; i < m - 1; i++) {
            h = (h * base) % mod;
        }
        
        for (int i = 0; i < m; i++) {
            patternHash = (base * patternHash + pattern[i]) % mod;
            textHash = (base * textHash + text[i]) % mod;
        }
        
        for (int i = 0; i <= n - m; i++) {
            if (patternHash == textHash) {
                bool match = true;
                for (int j = 0; j < m; j++) {
                    if (text[i + j] != pattern[j]) {
                        match = false;
                        break;
                    }
                }
                if (match) {
                    result.push_back(i);
                }
            }
            
            if (i < n - m) {
                textHash = (base * (textHash - text[i] * h) + text[i + m]) % mod;
                if (textHash < 0) {
                    textHash += mod;
                }
            }
        }
        
        return result;
    }
};

// Utility function to generate random data
vector<int> generateRandomArray(int size, int minVal = 1, int maxVal = 1000) {
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> dis(minVal, maxVal);
    
    vector<int> arr(size);
    for (int i = 0; i < size; i++) {
        arr[i] = dis(gen);
    }
    return arr;
}

// Utility function to measure execution time
template<typename Func>
long long measureTime(Func func) {
    auto start = chrono::high_resolution_clock::now();
    func();
    auto end = chrono::high_resolution_clock::now();
    return chrono::duration_cast<chrono::microseconds>(end - start).count();
}

int main() {
    cout << "=== Advanced Algorithms Demonstration ===" << endl;
    
    // Sorting Algorithms Performance Test
    cout << "\\n1. Sorting Algorithms Performance Test:" << endl;
    const int ARRAY_SIZE = 10000;
    vector<int> originalArray = generateRandomArray(ARRAY_SIZE);
    
    // Merge Sort
    vector<int> arr1 = originalArray;
    long long mergeTime = measureTime([&]() {
        SortingAlgorithms::mergeSort(arr1, 0, arr1.size() - 1);
    });
    cout << "Merge Sort: " << mergeTime << " microseconds" << endl;
    
    // Heap Sort
    vector<int> arr2 = originalArray;
    long long heapTime = measureTime([&]() {
        SortingAlgorithms::heapSort(arr2);
    });
    cout << "Heap Sort: " << heapTime << " microseconds" << endl;
    
    // Counting Sort
    vector<int> arr3 = originalArray;
    long long countingTime = measureTime([&]() {
        SortingAlgorithms::countingSort(arr3);
    });
    cout << "Counting Sort: " << countingTime << " microseconds" << endl;
    
    // STL Sort
    vector<int> arr4 = originalArray;
    long long stlTime = measureTime([&]() {
        sort(arr4.begin(), arr4.end());
    });
    cout << "STL Sort: " << stlTime << " microseconds" << endl;
    
    // Graph Algorithms
    cout << "\\n2. Graph Algorithms:" << endl;
    
    // Dijkstra's Algorithm
    int n = 6;
    vector<vector<pair<int, int>>> graph(n);
    graph[0] = {{1, 4}, {2, 2}};
    graph[1] = {{2, 1}, {3, 5}};
    graph[2] = {{3, 8}, {4, 10}};
    graph[3] = {{4, 2}, {5, 6}};
    graph[4] = {{5, 3}};
    
    vector<int> distances = GraphAlgorithms::dijkstra(graph, 0);
    cout << "Dijkstra's shortest distances from node 0:" << endl;
    for (int i = 0; i < n; i++) {
        cout << "Node " << i << ": " << distances[i] << endl;
    }
    
    // Floyd-Warshall Algorithm
    vector<vector<int>> adjMatrix = {
        {0, 4, 2, INT_MAX, INT_MAX, INT_MAX},
        {4, 0, 1, 5, INT_MAX, INT_MAX},
        {2, 1, 0, 8, 10, INT_MAX},
        {INT_MAX, 5, 8, 0, 2, 6},
        {INT_MAX, INT_MAX, 10, 2, 0, 3},
        {INT_MAX, INT_MAX, INT_MAX, 6, 3, 0}
    };
    
    vector<vector<int>> allPairsDist = GraphAlgorithms::floydWarshall(adjMatrix);
    cout << "\\nFloyd-Warshall all-pairs shortest distances:" << endl;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (allPairsDist[i][j] == INT_MAX) {
                cout << "INF ";
            } else {
                cout << allPairsDist[i][j] << " ";
            }
        }
        cout << endl;
    }
    
    // Dynamic Programming
    cout << "\\n3. Dynamic Programming:" << endl;
    
    // LCS
    string s1 = "ABCDGH";
    string s2 = "AEDFHR";
    int lcsLength = DynamicProgramming::lcs(s1, s2);
    cout << "LCS of '" << s1 << "' and '" << s2 << "': " << lcsLength << endl;
    
    // Knapsack
    vector<int> weights = {10, 20, 30};
    vector<int> values = {60, 100, 120};
    int capacity = 50;
    int maxValue = DynamicProgramming::knapsack(weights, values, capacity);
    cout << "Knapsack max value (capacity " << capacity << "): " << maxValue << endl;
    
    // Fibonacci with memoization
    map<int, long long> memo;
    int fibN = 40;
    long long fibResult = DynamicProgramming::fibonacci(fibN, memo);
    cout << "Fibonacci(" << fibN << "): " << fibResult << endl;
    
    // String Algorithms
    cout << "\\n4. String Algorithms:" << endl;
    
    string text = "ABABDABACDABABCABAB";
    string pattern = "ABABCABAB";
    
    vector<int> kmpResult = StringAlgorithms::kmpSearch(text, pattern);
    cout << "KMP search for '" << pattern << "' in '" << text << "': ";
    for (int pos : kmpResult) {
        cout << pos << " ";
    }
    cout << endl;
    
    vector<int> rkResult = StringAlgorithms::rabinKarpSearch(text, pattern);
    cout << "Rabin-Karp search for '" << pattern << "' in '" << text << "': ";
    for (int pos : rkResult) {
        cout << pos << " ";
    }
    cout << endl;
    
    // Topological Sort
    cout << "\\n5. Topological Sort:" << endl;
    vector<vector<int>> dag = {
        {1, 2},
        {3},
        {3, 4},
        {5},
        {5},
        {}
    };
    
    vector<int> topoOrder = GraphAlgorithms::topologicalSort(dag);
    cout << "Topological order: ";
    for (int node : topoOrder) {
        cout << node << " ";
    }
    cout << endl;
    
    cout << "\\n=== Algorithms demonstration completed! ===" << endl;
    
    return 0;
}''',
  };

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: _templates[_selectedTemplate],
    );
    _outputController = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _outputController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _runCode() async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    try {
      final result = await CppExecutionService.executeCode(
        _codeController.text,
      );

      _outputHistory.add(result.output);
      _outputController.text = result.output;
    } catch (e) {
      _outputController.text = 'Error: $e';
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _selectTemplate(String template) {
    setState(() {
      _selectedTemplate = template;
      _codeController.text = _templates[template]!;
    });
  }

  void _clearCode() {
    setState(() {
      _codeController.clear();
    });
  }

  void _clearOutput() {
    setState(() {
      _outputController.clear();
      _outputHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D30),
        title: const Text(
          'Advanced C++ IDE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedTemplate,
            dropdownColor: const Color(0xFF2D2D30),
            style: const TextStyle(color: Colors.white),
            items: _templates.keys.map((String template) {
              return DropdownMenuItem<String>(
                value: template,
                child: Text(template.toUpperCase()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                _selectTemplate(newValue);
              }
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.white),
            onPressed: _clearCode,
            tooltip: 'Clear Code',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all, color: Colors.white),
            onPressed: _clearOutput,
            tooltip: 'Clear Output',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2D2D30),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runCode,
                  icon: _isRunning
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_isRunning ? 'Running...' : 'Run Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007ACC),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SyntaxHighlightedEditor(
                    controller: _codeController,
                    language: 'cpp',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _outputController,
                    maxLines: null,
                    expands: true,
                    readOnly: true,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Output will appear here...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: _templates.keys.map((template) {
                      return Card(
                        color: const Color(0xFF2D2D30),
                        child: ListTile(
                          title: Text(
                            template.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            _getTemplateDescription(template),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: _selectedTemplate == template
                              ? const Icon(Icons.check, color: Colors.green)
                              : const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white54,
                                ),
                          onTap: () => _selectTemplate(template),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFF2D2D30),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: const Color(0xFF007ACC),
              tabs: const [
                Tab(icon: Icon(Icons.code), text: 'Code'),
                Tab(icon: Icon(Icons.terminal), text: 'Output'),
                Tab(icon: Icon(Icons.library_books), text: 'Templates'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTemplateDescription(String template) {
    switch (template) {
      case 'basic':
        return 'Advanced C++ Program with OOP, Templates, STL, Threading';
      case 'data_structures':
        return 'Binary Tree, Graph, Min Heap, Trie implementations';
      case 'algorithms':
        return 'Sorting, Graph Algorithms, Dynamic Programming, String Algorithms';
      default:
        return 'C++ Program Template';
    }
  }
}
