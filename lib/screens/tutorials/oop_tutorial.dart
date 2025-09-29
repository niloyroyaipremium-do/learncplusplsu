import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/syntax_highlighted_editor.dart';

/// Comprehensive OOP Tutorial Screen
/// This screen provides a complete guide to Object-Oriented Programming in C++
class OopTutorialScreen extends StatefulWidget {
  const OopTutorialScreen({super.key});

  @override
  State<OopTutorialScreen> createState() => _OopTutorialScreenState();
}

class _OopTutorialScreenState extends State<OopTutorialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentSection = 0;

  final List<TutorialSection> _sections = [
    TutorialSection(
      title: 'Introduction to OOP',
      content: '''
Object-Oriented Programming (OOP) is a programming paradigm based on the concept of "objects", which can contain data and code.

Key Concepts:
• Classes: Blueprints for creating objects
• Objects: Instances of classes
• Encapsulation: Bundling data and methods together
• Inheritance: Creating new classes based on existing ones
• Polymorphism: One interface, multiple implementations
• Abstraction: Hiding complex implementation details
      ''',
      codeExample: r'''
#include <iostream>
#include <string>
using namespace std;

// Class definition
class Car {
private:
    string brand;
    int year;
    
public:
    // Constructor
    Car(string b, int y) : brand(b), year(y) {}
    
    // Methods
    void start() {
        cout << brand << " " << year << " is starting..." << endl;
    }
    
    void displayInfo() {
        cout << "Brand: " << brand << ", Year: " << year << endl;
    }
};

int main() {
    // Creating objects
    Car myCar("Toyota", 2023);
    Car yourCar("Honda", 2022);
    
    // Using objects
    myCar.displayInfo();
    myCar.start();
    
    yourCar.displayInfo();
    yourCar.start();
    
    return 0;
}
      ''',
    ),
    TutorialSection(
      title: 'Classes and Objects',
      content: '''
A class is a user-defined data type that serves as a blueprint for creating objects.

Key Components:
• Data Members (Attributes): Variables that store data
• Member Functions (Methods): Functions that operate on the data
• Access Specifiers: public, private, protected
• Constructors: Special functions for object initialization
• Destructors: Special functions for cleanup
      ''',
      codeExample: r'''
#include <iostream>
#include <string>
using namespace std;

class Student {
private:
    string name;
    int age;
    double gpa;
    
public:
    // Constructor
    Student(string n, int a, double g) {
        name = n;
        age = a;
        gpa = g;
    }
    
    // Getter methods
    string getName() { return name; }
    int getAge() { return age; }
    double getGPA() { return gpa; }
    
    // Setter methods
    void setName(string n) { name = n; }
    void setAge(int a) { age = a; }
    void setGPA(double g) { gpa = g; }
    
    // Display method
    void display() {
        cout << "Name: " << name << endl;
        cout << "Age: " << age << endl;
        cout << "GPA: " << gpa << endl;
    }
};

int main() {
    // Creating objects
    Student student1("Alice", 20, 3.8);
    Student student2("Bob", 22, 3.5);
    
    // Using objects
    student1.display();
    student2.display();
    
    // Modifying data
    student1.setGPA(3.9);
    cout << "Updated GPA: " << student1.getGPA() << endl;
    
    return 0;
}
      ''',
    ),
    TutorialSection(
      title: 'Encapsulation',
      content: '''
Encapsulation is the bundling of data and methods that work on that data within a single unit (class).

Benefits:
• Data Hiding: Private members cannot be accessed directly
• Data Integrity: Controlled access through methods
• Modularity: Code is organized into logical units
• Security: Prevents unauthorized access to data
      ''',
      codeExample: r'''
#include <iostream>
#include <string>
using namespace std;

class BankAccount {
private:
    string accountNumber;
    double balance;
    string ownerName;
    
public:
    // Constructor
    BankAccount(string accNum, string owner, double initialBalance) {
        accountNumber = accNum;
        ownerName = owner;
        balance = initialBalance;
    }
    
    // Public methods for controlled access
    void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            cout << "Deposited $" << amount << ". New balance: $" << balance << endl;
        } else {
            cout << "Invalid deposit amount!" << endl;
        }
    }
    
    void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            cout << "Withdrew $" << amount << ". New balance: $" << balance << endl;
        } else {
            cout << "Invalid withdrawal amount!" << endl;
        }
    }
    
    double getBalance() {
        return balance;
    }
    
    string getAccountInfo() {
        return "Account: " + accountNumber + ", Owner: " + ownerName;
    }
};

int main() {
    BankAccount account("12345", "John Doe", 1000.0);
    
    cout << account.getAccountInfo() << endl;
    cout << "Initial balance: $" << account.getBalance() << endl;
    
    account.deposit(500.0);
    account.withdraw(200.0);
    account.withdraw(2000.0); // This will fail
    
    return 0;
}
      ''',
    ),
    TutorialSection(
      title: 'Inheritance',
      content: '''
Inheritance allows a class to inherit properties and methods from another class.

Types of Inheritance:
• Single Inheritance: One base class, one derived class
• Multiple Inheritance: Multiple base classes, one derived class
• Multilevel Inheritance: Chain of inheritance
• Hierarchical Inheritance: One base class, multiple derived classes

Key Concepts:
• Base Class (Parent): The class being inherited from
• Derived Class (Child): The class that inherits
• Access Specifiers: public, private, protected
      ''',
      codeExample: r'''
#include <iostream>
#include <string>
using namespace std;

// Base class
class Vehicle {
protected:
    string brand;
    int year;
    double speed;
    
public:
    Vehicle(string b, int y) : brand(b), year(y), speed(0) {}
    
    void start() {
        cout << brand << " " << year << " is starting..." << endl;
    }
    
    void accelerate(double amount) {
        speed += amount;
        cout << "Speed increased to " << speed << " km/h" << endl;
    }
    
    void displayInfo() {
        cout << "Brand: " << brand << ", Year: " << year << ", Speed: " << speed << " km/h" << endl;
    }
};

// Derived class
class Car : public Vehicle {
private:
    int doors;
    string fuelType;
    
public:
    Car(string b, int y, int d, string fuel) : Vehicle(b, y), doors(d), fuelType(fuel) {}
    
    void honk() {
        cout << "Beep beep!" << endl;
    }
    
    void displayCarInfo() {
        displayInfo(); // Call parent method
        cout << "Doors: " << doors << ", Fuel: " << fuelType << endl;
    }
};

// Another derived class
class Motorcycle : public Vehicle {
private:
    bool hasWindshield;
    
public:
    Motorcycle(string b, int y, bool windshield) : Vehicle(b, y), hasWindshield(windshield) {}
    
    void wheelie() {
        cout << "Doing a wheelie!" << endl;
    }
    
    void displayMotorcycleInfo() {
        displayInfo();
        cout << "Windshield: " << (hasWindshield ? "Yes" : "No") << endl;
    }
};

int main() {
    Car myCar("Toyota", 2023, 4, "Gasoline");
    Motorcycle myBike("Honda", 2022, true);
    
    myCar.start();
    myCar.accelerate(60);
    myCar.honk();
    myCar.displayCarInfo();
    
    cout << endl;
    
    myBike.start();
    myBike.accelerate(80);
    myBike.wheelie();
    myBike.displayMotorcycleInfo();
    
    return 0;
}
      ''',
    ),
    TutorialSection(
      title: 'Polymorphism',
      content: '''
Polymorphism allows objects of different types to be treated as objects of a common base type.

Types of Polymorphism:
• Compile-time Polymorphism: Function overloading, operator overloading
• Runtime Polymorphism: Virtual functions, function overriding

Key Concepts:
• Virtual Functions: Functions that can be overridden in derived classes
• Pure Virtual Functions: Abstract functions that must be implemented
• Abstract Classes: Classes with pure virtual functions
• Function Overriding: Redefining base class functions in derived classes
      ''',
      codeExample: r'''
#include <iostream>
#include <vector>
using namespace std;

// Abstract base class
class Shape {
protected:
    string name;
    
public:
    Shape(string n) : name(n) {}
    
    // Pure virtual function - must be implemented by derived classes
    virtual double getArea() = 0;
    virtual double getPerimeter() = 0;
    
    // Virtual function - can be overridden
    virtual void displayInfo() {
        cout << "Shape: " << name << endl;
    }
    
    // Virtual destructor
    virtual ~Shape() {}
};

// Derived class
class Circle : public Shape {
private:
    double radius;
    
public:
    Circle(double r) : Shape("Circle"), radius(r) {}
    
    double getArea() override {
        return 3.14159 * radius * radius;
    }
    
    double getPerimeter() override {
        return 2 * 3.14159 * radius;
    }
    
    void displayInfo() override {
        Shape::displayInfo();
        cout << "Radius: " << radius << endl;
        cout << "Area: " << getArea() << endl;
        cout << "Perimeter: " << getPerimeter() << endl;
    }
};

// Another derived class
class Rectangle : public Shape {
private:
    double width, height;
    
public:
    Rectangle(double w, double h) : Shape("Rectangle"), width(w), height(h) {}
    
    double getArea() override {
        return width * height;
    }
    
    double getPerimeter() override {
        return 2 * (width + height);
    }
    
    void displayInfo() override {
        Shape::displayInfo();
        cout << "Width: " << width << ", Height: " << height << endl;
        cout << "Area: " << getArea() << endl;
        cout << "Perimeter: " << getPerimeter() << endl;
    }
};

int main() {
    // Using polymorphism
    vector<Shape*> shapes;
    
    shapes.push_back(new Circle(5.0));
    shapes.push_back(new Rectangle(4.0, 6.0));
    shapes.push_back(new Circle(3.0));
    
    for (Shape* shape : shapes) {
        shape->displayInfo();
        cout << "---" << endl;
    }
    
    // Clean up memory
    for (Shape* shape : shapes) {
        delete shape;
    }
    
    return 0;
}
      ''',
    ),
    TutorialSection(
      title: 'Advanced OOP Concepts',
      content: '''
Advanced OOP concepts include templates, operator overloading, friend functions, and more.

Key Topics:
• Templates: Generic programming with type parameters
• Operator Overloading: Defining custom behavior for operators
• Friend Functions: Functions that can access private members
• Static Members: Shared among all instances of a class
• Const Objects: Objects that cannot be modified
• Exception Handling: Managing runtime errors
      ''',
      codeExample: r'''
#include <iostream>
#include <string>
using namespace std;

// Template class
template<typename T>
class Stack {
private:
    T* data;
    int top;
    int capacity;
    
public:
    Stack(int size) : capacity(size), top(-1) {
        data = new T[capacity];
    }
    
    ~Stack() {
        delete[] data;
    }
    
    void push(T item) {
        if (top < capacity - 1) {
            data[++top] = item;
        } else {
            cout << "Stack overflow!" << endl;
        }
    }
    
    T pop() {
        if (top >= 0) {
            return data[top--];
        } else {
            cout << "Stack underflow!" << endl;
            return T();
        }
    }
    
    bool isEmpty() {
        return top == -1;
    }
    
    int size() {
        return top + 1;
    }
};

// Class with operator overloading
class Complex {
private:
    double real, imag;
    
public:
    Complex(double r = 0, double i = 0) : real(r), imag(i) {}
    
    // Operator overloading
    Complex operator+(const Complex& other) const {
        return Complex(real + other.real, imag + other.imag);
    }
    
    Complex operator-(const Complex& other) const {
        return Complex(real - other.real, imag - other.imag);
    }
    
    // Friend function for output
    friend ostream& operator<<(ostream& os, const Complex& c) {
        os << c.real << " + " << c.imag << "i";
        return os;
    }
    
    void display() {
        cout << real << " + " << imag << "i" << endl;
    }
};

int main() {
    // Using template class
    Stack<int> intStack(5);
    Stack<string> stringStack(3);
    
    intStack.push(10);
    intStack.push(20);
    intStack.push(30);
    
    cout << "Popped: " << intStack.pop() << endl;
    cout << "Stack size: " << intStack.size() << endl;
    
    stringStack.push("Hello");
    stringStack.push("World");
    
    cout << "Popped: " << stringStack.pop() << endl;
    
    // Using operator overloading
    Complex c1(3, 4);
    Complex c2(1, 2);
    
    Complex c3 = c1 + c2;
    Complex c4 = c1 - c2;
    
    cout << "c1: " << c1 << endl;
    cout << "c2: " << c2 << endl;
    cout << "c1 + c2: " << c3 << endl;
    cout << "c1 - c2: " << c4 << endl;
    
    return 0;
}
      ''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _sections.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          backgroundColor: appProvider.isDarkMode
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: const Text('OOP Tutorial'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: _sections
                  .map((section) => Tab(text: section.title))
                  .toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: _sections
                .map((section) => _buildSectionContent(section, appProvider))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildSectionContent(
    TutorialSection section,
    AppProvider appProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appProvider.isDarkMode
                  ? const Color(0xFF2D2D30)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              section.content,
              style: TextStyle(
                fontSize: 16,
                color: appProvider.isDarkMode ? Colors.white : Colors.black87,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Code Example
          Container(
            decoration: BoxDecoration(
              color: appProvider.isDarkMode
                  ? const Color(0xFF0C0C0C)
                  : const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: appProvider.isDarkMode
                        ? const Color(0xFF37373D)
                        : Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.code, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Code Example',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 400,
                  padding: const EdgeInsets.all(12),
                  child: SyntaxHighlightedEditor(
                    controller: TextEditingController(
                      text: section.codeExample,
                    ),
                    isDarkMode: appProvider.isDarkMode,
                    fontSize: 14.0,
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentSection > 0)
                ElevatedButton.icon(
                  onPressed: () {
                    _tabController.animateTo(_currentSection - 1);
                    setState(() {
                      _currentSection--;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                )
              else
                const SizedBox.shrink(),

              if (_currentSection < _sections.length - 1)
                ElevatedButton.icon(
                  onPressed: () {
                    _tabController.animateTo(_currentSection + 1);
                    setState(() {
                      _currentSection++;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}

class TutorialSection {
  final String title;
  final String content;
  final String codeExample;

  TutorialSection({
    required this.title,
    required this.content,
    required this.codeExample,
  });
}
