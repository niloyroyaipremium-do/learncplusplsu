import '../../domain/entities/lesson.dart';

class Grade6Lessons {
  static List<Lesson> getLessons() {
    return [
      Lesson(
        id: '1',
        title: '🌟 Welcome to C++ Programming!',
        description:
            'Let\'s start our coding adventure! Learn what C++ is and why it\'s fun!',
        duration: '10 minutes',
        difficulty: 'Beginner',
        isCompleted: false,
        content: '''
# 🌟 Welcome to C++ Programming!

Hey there, future programmer! 👋

## What is C++? 🤔

C++ is like a special language that helps us talk to computers! Just like you learn English to talk to your friends, we learn C++ to talk to computers.

## Why Learn C++? 🎯

- **It's FUN!** 🎮 - You can make games, apps, and cool programs
- **It's POWERFUL!** ⚡ - Computers understand it really well
- **It's EVERYWHERE!** 🌍 - Used in phones, games, and websites

## Your First Magic Spell! ✨

Let's write our first program together! It's like a magic spell that makes the computer say "Hello" to us:

```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    cout << "I am learning C++!" << endl;
    return 0;
}
```

## What Each Line Does 🧐

- `#include <iostream>` - This is like opening a magic book 📚
- `using namespace std;` - This helps us use simple words
- `int main()` - This is where our program starts! 🚀
- `cout <<` - This makes the computer "speak" to us! 🗣️
- `return 0;` - This means "everything went great!" ✅

## Fun Activities! 🎨

1. **Try changing the message!** 
   - Change "Hello, World!" to "Hi, I'm [Your Name]!"
   
2. **Add more messages!**
   - Add another `cout <<` line with your favorite color!

3. **Make it personal!**
   - Tell the computer about your favorite hobby!

## Did You Know? 🤓

- The first C++ program was written in 1979!
- Many video games like Minecraft use C++!
- Your phone's apps are made with languages like C++!

## Ready for the Next Adventure? 🚀

Great job! You've just written your first computer program! In the next lesson, we'll learn about numbers and how to make the computer do math for us!
        ''',
        codeExample: '''
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    cout << "I am learning C++!" << endl;
    cout << "This is so much fun!" << endl;
    return 0;
}
        ''',
        tags: ['beginner', 'introduction', 'hello-world'],
        estimatedTimeMinutes: 10,
        category: 'Getting Started',
        order: 1,
        metadata: {
          'age_group': '6th_grade',
          'difficulty_level': 1,
          'fun_factor': 5,
          'interactive': true,
        },
      ),

      Lesson(
        id: '2',
        title: '🔢 Numbers and Math Magic!',
        description: 'Learn how to make the computer do math for you!',
        duration: '12 minutes',
        difficulty: 'Beginner',
        isCompleted: false,
        content: '''
# 🔢 Numbers and Math Magic!

Welcome back, math wizard! 🧙‍♂️

## What We'll Learn Today

Today we'll learn how to make the computer do math for us! It's like having a super-smart calculator that can do millions of calculations in a second!

## Types of Numbers in C++

Just like in math class, we have different types of numbers:

### 1. Whole Numbers (Integers) 🔢
- These are numbers without decimals: 1, 2, 3, 100, 999
- In C++, we call them `int`

### 2. Decimal Numbers (Floats) 📊
- These have decimal points: 3.14, 2.5, 99.99
- In C++, we call them `float` or `double`

## Let's Do Some Math! 🧮

```cpp
#include <iostream>
using namespace std;

int main() {
    // Let's add two numbers!
    int firstNumber = 10;
    int secondNumber = 5;
    int sum = firstNumber + secondNumber;
    
    cout << "The sum of " << firstNumber << " and " << secondNumber;
    cout << " is " << sum << endl;
    
    return 0;
}
```

## Math Operations We Can Do ➕➖✖️➗

- `+` Addition (plus)
- `-` Subtraction (minus)  
- `*` Multiplication (times)
- `/` Division (divided by)
- `%` Remainder (what's left over)

## Fun Math Challenge! 🎯

Try this program and see what happens:

```cpp
#include <iostream>
using namespace std;

int main() {
    int myAge = 12;  // Change this to your age!
    int yearsToDrive = 16 - myAge;
    
    cout << "I am " << myAge << " years old." << endl;
    cout << "I can drive in " << yearsToDrive << " years!" << endl;
    
    return 0;
}
```

## Interactive Activities! 🎮

1. **Calculator Challenge**: Make a program that adds your age and your best friend's age
2. **Pizza Math**: Calculate how many slices each person gets if you have 8 slices and 4 people
3. **Birthday Countdown**: Calculate days until your next birthday!

## Fun Facts! 🤓

- Computers can do over 1 billion calculations per second!
- The first computer bug was a real bug (a moth) stuck in a computer!
- Your calculator at home is actually a tiny computer!

## Ready for More? 🚀

Awesome! You're becoming a math wizard! Next time, we'll learn about storing information in boxes called variables!
        ''',
        codeExample: '''
#include <iostream>
using namespace std;

int main() {
    int myAge = 12;
    int friendAge = 13;
    int totalAge = myAge + friendAge;
    
    cout << "My age: " << myAge << endl;
    cout << "Friend's age: " << friendAge << endl;
    cout << "Together we are " << totalAge << " years old!" << endl;
    
    return 0;
}
        ''',
        tags: ['math', 'numbers', 'variables', 'beginner'],
        estimatedTimeMinutes: 12,
        category: 'Basics',
        order: 2,
        metadata: {
          'age_group': '6th_grade',
          'difficulty_level': 2,
          'fun_factor': 4,
          'interactive': true,
        },
      ),

      Lesson(
        id: '3',
        title: '📦 Variables - Your Data Storage Boxes!',
        description:
            'Learn how to store and organize information in your programs!',
        duration: '15 minutes',
        difficulty: 'Beginner',
        isCompleted: false,
        content: '''
# 📦 Variables - Your Data Storage Boxes!

Hello, data organizer! 📊

## What are Variables? 🤔

Think of variables like labeled boxes where you can store different things:
- A box labeled "myName" might contain "Sarah"
- A box labeled "myAge" might contain 12
- A box labeled "myFavoriteColor" might contain "blue"

## Types of Variables 📋

### 1. Text Variables (Strings) 📝
Store words and sentences:
```cpp
string myName = "Alex";
string mySchool = "Sunshine Elementary";
```

### 2. Number Variables (Integers) 🔢
Store whole numbers:
```cpp
int myAge = 12;
int myGrade = 6;
```

### 3. Decimal Variables (Floats) 📊
Store numbers with decimals:
```cpp
float myHeight = 4.5;
float myWeight = 85.2;
```

## Let's Create Our Own Variables! 🎨

```cpp
#include <iostream>
using namespace std;

int main() {
    // Personal information
    string myName = "Alex";
    int myAge = 12;
    string myFavoriteColor = "blue";
    
    // Tell the computer about ourselves
    cout << "Hi! My name is " << myName << endl;
    cout << "I am " << myAge << " years old" << endl;
    cout << "My favorite color is " << myFavoriteColor << endl;
    
    return 0;
}
```

## Variable Rules! 📏

1. **Names must start with a letter** ✅
   - Good: `myName`, `age`, `color1`
   - Bad: `1name`, `my-name`, `my name`

2. **No spaces allowed** ✅
   - Good: `myName`, `favoriteColor`
   - Bad: `my name`, `favorite color`

3. **Use descriptive names** ✅
   - Good: `studentName`, `testScore`
   - Bad: `a`, `x`, `temp`

## Fun Variable Activities! 🎮

### Activity 1: Personal Profile
Create variables for:
- Your name
- Your age
- Your favorite food
- Your favorite game

### Activity 2: School Information
Store information about:
- Your school name
- Your grade
- Your teacher's name
- Number of students in your class

### Activity 3: Math Variables
Create variables for two numbers and add them together!

## Interactive Challenge! 🏆

```cpp
#include <iostream>
using namespace std;

int main() {
    // Create your own variables here!
    string myName = "Your Name Here";
    int myAge = 0;  // Put your age here
    string myHobby = "Your Hobby Here";
    
    cout << "=== My Personal Profile ===" << endl;
    cout << "Name: " << myName << endl;
    cout << "Age: " << myAge << endl;
    cout << "Hobby: " << myHobby << endl;
    cout << "=========================" << endl;
    
    return 0;
}
```

## Fun Facts! 🤓

- Variables are like labeled boxes in your computer's memory
- You can change what's inside a variable anytime!
- Variables help make programs more organized and easier to understand

## What's Next? 🚀

Great job learning about variables! Next time, we'll learn how to make the computer ask questions and get answers from users!
        ''',
        codeExample: '''
#include <iostream>
using namespace std;

int main() {
    string myName = "Alex";
    int myAge = 12;
    string myFavoriteColor = "blue";
    string myHobby = "coding";
    
    cout << "=== My Profile ===" << endl;
    cout << "Name: " << myName << endl;
    cout << "Age: " << myAge << endl;
    cout << "Favorite Color: " << myFavoriteColor << endl;
    cout << "Hobby: " << myHobby << endl;
    cout << "=================" << endl;
    
    return 0;
}
        ''',
        tags: ['variables', 'data-types', 'strings', 'beginner'],
        estimatedTimeMinutes: 15,
        category: 'Basics',
        order: 3,
        metadata: {
          'age_group': '6th_grade',
          'difficulty_level': 3,
          'fun_factor': 4,
          'interactive': true,
        },
      ),

      // OOP Tutorial Lessons
      Lesson(
        id: '4',
        title: '🏗️ Introduction to Object-Oriented Programming',
        description:
            'Learn the fundamentals of OOP and how to think in objects!',
        duration: '20 minutes',
        difficulty: 'Intermediate',
        isCompleted: false,
        content: '''
# 🏗️ Introduction to Object-Oriented Programming

Welcome to the amazing world of Object-Oriented Programming! 🎉

## What is OOP? 🤔

Object-Oriented Programming (OOP) is like building with magical LEGO blocks! Each block (called an 'object') has its own special powers and can do amazing things. When you put them together, you can create anything from a simple calculator to a video game!

## The Four Super Powers of OOP 🏛️

### 1. 🔒 Encapsulation - Keep Your Data Safe!
Think of encapsulation like a treasure chest with a lock. Only the right key (methods) can access what's inside!

### 2. 🧬 Inheritance - Create New Things from Existing Ones!
Just like how you might inherit your mom's eyes or dad's smile, classes can inherit features from other classes!

### 3. 🔄 Polymorphism - One Thing, Many Different Forms!
It's like having a universal remote that can control different devices - same button, different actions!

### 4. 🎯 Abstraction - Hide the Hard Stuff, Show the Fun Stuff!
Like driving a car - you don't need to know how the engine works, just how to use the steering wheel!

## Your First Magical Class! ✨

Let's create our first class together:

```cpp
#include <iostream>
#include <string>
using namespace std;

// 🏗️ This is a class - like a blueprint for creating magical creatures!
class Person {
    // 📊 Attributes (the things that make each person unique)
    string name;        // What they're called
    int age;           // How old they are
    string favoriteColor; // Their favorite color
    
public:
    // 🏗️ Constructor - the magic spell that creates a new person!
    Person(string n, int a, string color) : name(n), age(a), favoriteColor(color) {
        cout << "✨ " << name << " has been created! They love " << color << "!" << endl;
    }
    
    // 🎯 Methods (the things a person can do)
    void introduce() {
        cout << "👋 Hi! I'm " << name << " and I'm " << age << " years old!" << endl;
        cout << "🌈 My favorite color is " << favoriteColor << "!" << endl;
    }
    
    void celebrateBirthday() {
        age++;
        cout << "🎉 Happy Birthday " << name << "! You're now " << age << " years old!" << endl;
    }
    
    void tellJoke() {
        cout << "😄 " << name << " says: Why don't scientists trust atoms? Because they make up everything!" << endl;
    }
};

int main() {
    cout << "🎪 Welcome to our magical person factory!" << endl;
    cout << "=========================================" << endl;
    
    // 🎭 Creating magical people from our class
    Person alice("Alice", 12, "blue");
    Person bob("Bob", 13, "green");
    Person charlie("Charlie", 11, "purple");
    
    cout << "\\n🎪 Let's meet our magical people!" << endl;
    cout << "=================================" << endl;
    
    // 🎪 Using the objects (making them do things!)
    alice.introduce();
    alice.tellJoke();
    
    cout << "\\n" << string(30, '-') << endl;
    
    bob.introduce();
    bob.celebrateBirthday();
    
    cout << "\\n" << string(30, '-') << endl;
    
    charlie.introduce();
    charlie.tellJoke();
    
    cout << "\\n🎉 What a fun day with our magical friends!" << endl;
    
    return 0;
}
```

## Why OOP is Like Having Super Powers! 💡

- **🔄 Reusability** - Write once, use everywhere! Like having a magic spell you can cast anytime!
- **🛠️ Easy to Fix** - When something breaks, you know exactly where to look! It's like having a map!
- **📈 Grows with You** - Add new features without breaking old ones! Like adding rooms to your house!
- **🗂️ Super Organized** - Everything has its place! Like having the neatest room ever!

## Ready for More Magic? 🚀

Great job! You've just learned the basics of OOP! In the next lessons, we'll dive deeper into each of the four super powers and learn how to create even more amazing programs!
        ''',
        codeExample: '''
#include <iostream>
#include <string>
using namespace std;

class Person {
    string name;
    int age;
    string favoriteColor;
    
public:
    Person(string n, int a, string color) : name(n), age(a), favoriteColor(color) {
        cout << "✨ " << name << " has been created! They love " << color << "!" << endl;
    }
    
    void introduce() {
        cout << "👋 Hi! I'm " << name << " and I'm " << age << " years old!" << endl;
        cout << "🌈 My favorite color is " << favoriteColor << "!" << endl;
    }
    
    void celebrateBirthday() {
        age++;
        cout << "🎉 Happy Birthday " << name << "! You're now " << age << " years old!" << endl;
    }
};

int main() {
    Person alice("Alice", 12, "blue");
    Person bob("Bob", 13, "green");
    
    alice.introduce();
    bob.introduce();
    alice.celebrateBirthday();
    
    return 0;
}
        ''',
        tags: ['oop', 'classes', 'objects', 'intermediate'],
        estimatedTimeMinutes: 20,
        category: 'Object-Oriented Programming',
        order: 4,
        metadata: {
          'age_group': '6th_grade',
          'difficulty_level': 4,
          'fun_factor': 5,
          'interactive': true,
        },
      ),

      Lesson(
        id: '5',
        title: '📦 Classes and Objects - Your Building Blocks!',
        description: 'Learn how to create and use classes and objects in C++!',
        duration: '25 minutes',
        difficulty: 'Intermediate',
        isCompleted: false,
        content: '''
# 📦 Classes and Objects - Your Building Blocks!

Welcome back, future programmer! 🎉

## Classes vs Objects 🏗️

A **class** is like a blueprint or template, while an **object** is an instance of that class. Think of a class as a cookie cutter and objects as the actual cookies!

## Let's Build a Car! 🚗

```cpp
#include <iostream>
#include <string>
using namespace std;

class Car {
private:
    // 🔒 Private members - only accessible within the class
    string brand;
    string model;
    int year;
    double speed;
    bool isRunning;
    
public:
    // 🏗️ Constructor with default parameters
    Car(string b = "Unknown", string m = "Unknown", int y = 2023) 
        : brand(b), model(m), year(y), speed(0), isRunning(false) {
        cout << "🚗 " << brand << " " << model << " (" << year << ") created!" << endl;
    }
    
    // 🚀 Public methods
    void start() {
        if (!isRunning) {
            isRunning = true;
            cout << "🔑 " << brand << " " << model << " started!" << endl;
        } else {
            cout << "⚠️ Car is already running!" << endl;
        }
    }
    
    void stop() {
        if (isRunning) {
            isRunning = false;
            speed = 0;
            cout << "🛑 " << brand << " " << model << " stopped!" << endl;
        } else {
            cout << "⚠️ Car is already stopped!" << endl;
        }
    }
    
    void accelerate(double amount) {
        if (isRunning) {
            speed += amount;
            cout << "🏎️ Speed increased to " << speed << " km/h" << endl;
        } else {
            cout << "⚠️ Start the car first!" << endl;
        }
    }
    
    void brake(double amount) {
        if (speed > 0) {
            speed = max(0.0, speed - amount);
            cout << "🛑 Speed reduced to " << speed << " km/h" << endl;
        }
    }
    
    // 📊 Getter methods
    string getBrand() const { return brand; }
    string getModel() const { return model; }
    int getYear() const { return year; }
    double getSpeed() const { return speed; }
    bool getIsRunning() const { return isRunning; }
    
    // 📝 Display information
    void displayInfo() const {
        cout << "🚗 Car Info:" << endl;
        cout << "   Brand: " << brand << endl;
        cout << "   Model: " << model << endl;
        cout << "   Year: " << year << endl;
        cout << "   Speed: " << speed << " km/h" << endl;
        cout << "   Status: " << (isRunning ? "Running" : "Stopped") << endl;
    }
};

int main() {
    // 🎭 Creating different car objects
    Car myCar("Toyota", "Camry", 2022);
    Car sportsCar("Ferrari", "F8", 2023);
    Car defaultCar; // Using default constructor
    
    // 🎪 Using the objects
    myCar.displayInfo();
    myCar.start();
    myCar.accelerate(50);
    myCar.accelerate(30);
    myCar.brake(20);
    myCar.displayInfo();
    myCar.stop();
    
    cout << "\\n" << string(50, '=') << "\\n" << endl;
    
    sportsCar.start();
    sportsCar.accelerate(100);
    sportsCar.displayInfo();
    
    return 0;
}
```

## Key Concepts 🔑

- **Constructor** - Special method called when object is created
- **Destructor** - Special method called when object is destroyed  
- **Member Variables** - Data stored in the object
- **Member Functions** - Functions that operate on the object's data
- **Private vs Public** - Control who can access what!

## Fun Activities! 🎮

1. **Create Your Own Class** - Make a class for your favorite animal!
2. **Add More Methods** - Give your car the ability to honk or turn on lights!
3. **Create Multiple Objects** - Make a whole fleet of cars!

## What's Next? 🚀

Awesome! You now know how to create classes and objects! Next, we'll learn about encapsulation - how to keep your data safe and secure!
        ''',
        codeExample: '''
#include <iostream>
#include <string>
using namespace std;

class Car {
private:
    string brand;
    string model;
    int year;
    double speed;
    bool isRunning;
    
public:
    Car(string b, string m, int y) : brand(b), model(m), year(y), speed(0), isRunning(false) {
        cout << "🚗 " << brand << " " << model << " created!" << endl;
    }
    
    void start() {
        if (!isRunning) {
            isRunning = true;
            cout << "🔑 " << brand << " started!" << endl;
        }
    }
    
    void accelerate(double amount) {
        if (isRunning) {
            speed += amount;
            cout << "🏎️ Speed: " << speed << " km/h" << endl;
        }
    }
    
    void displayInfo() {
        cout << "🚗 " << brand << " " << model << " (" << year << ")" << endl;
        cout << "   Speed: " << speed << " km/h" << endl;
    }
};

int main() {
    Car myCar("Toyota", "Camry", 2022);
    myCar.start();
    myCar.accelerate(50);
    myCar.displayInfo();
    
    return 0;
}
        ''',
        tags: ['classes', 'objects', 'constructors', 'methods', 'intermediate'],
        estimatedTimeMinutes: 25,
        category: 'Object-Oriented Programming',
        order: 5,
        metadata: {
          'age_group': '6th_grade',
          'difficulty_level': 5,
          'fun_factor': 4,
          'interactive': true,
        },
      ),

      Lesson(
        id: '6',
        title: '🔒 Encapsulation - Keep Your Data Safe!',
        description: 'Learn how to protect your data with encapsulation!',
        duration: '22 minutes',
        difficulty: 'Intermediate',
        isCompleted: false,
        content: '''
# 🔒 Encapsulation - Keep Your Data Safe!

Hello, data protector! 🛡️

## What is Encapsulation? 🤔

Encapsulation is the bundling of data and methods that work on that data within one unit. It's like a capsule that protects the medicine inside - the data is protected and can only be accessed through controlled methods!

## Bank Account Example 🏦

Let's create a secure bank account system:

```cpp
#include <iostream>
#include <string>
using namespace std;

class BankAccount {
private:
    // 🔒 Private data - cannot be accessed directly
    string accountNumber;
    string accountHolder;
    double balance;
    string pin;
    
public:
    // 🏗️ Constructor
    BankAccount(string accNum, string holder, string p, double initialBalance = 0) 
        : accountNumber(accNum), accountHolder(holder), pin(p), balance(initialBalance) {
        cout << "🏦 Account created for " << accountHolder << endl;
    }
    
    // 🔐 Getter methods (read-only access)
    string getAccountNumber() const { return accountNumber; }
    string getAccountHolder() const { return accountHolder; }
    double getBalance() const { return balance; }
    
    // 💰 Deposit money
    bool deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            cout << "💰 USD " << amount << " deposited. New balance: USD " << balance << endl;
            return true;
        } else {
            cout << "❌ Invalid deposit amount!" << endl;
            return false;
        }
    }
    
    // 💸 Withdraw money
    bool withdraw(double amount, string enteredPin) {
        if (enteredPin != pin) {
            cout << "🔒 Incorrect PIN!" << endl;
            return false;
        }
        
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            cout << "💸 USD " << amount << " withdrawn. New balance: USD " << balance << endl;
            return true;
        } else {
            cout << "❌ Invalid amount or insufficient funds!" << endl;
            return false;
        }
    }
    
    // 🔄 Change PIN
    bool changePin(string oldPin, string newPin) {
        if (oldPin == pin && newPin.length() >= 4) {
            pin = newPin;
            cout << "🔑 PIN changed successfully!" << endl;
            return true;
        } else {
            cout << "❌ Invalid old PIN or new PIN too short!" << endl;
            return false;
        }
    }
    
    // 📊 Display account info (without sensitive data)
    void displayInfo() const {
        cout << "\\n🏦 Account Information:" << endl;
        cout << "   Account Number: " << accountNumber << endl;
        cout << "   Account Holder: " << accountHolder << endl;
        cout << "   Balance: USD " << balance << endl;
        cout << "   PIN: ****" << endl; // Hidden for security
    }
    
    // 🔒 Private helper method
private:
    bool isValidAmount(double amount) const {
        return amount > 0 && amount <= 10000; // Max transaction limit
    }
};

int main() {
    // 🎭 Creating a bank account
    BankAccount myAccount("123456789", "Alice Johnson", "1234", 1000.0);
    
    // 📊 Display initial info
    myAccount.displayInfo();
    
    // 💰 Perform transactions
    myAccount.deposit(500.0);
    myAccount.withdraw(200.0, "1234"); // Correct PIN
    myAccount.withdraw(100.0, "0000"); // Wrong PIN
    myAccount.changePin("1234", "5678");
    myAccount.withdraw(100.0, "5678"); // New PIN
    
    // 📊 Final balance
    cout << "\\n💰 Final Balance: USD " << myAccount.getBalance() << endl;
    
    return 0;
}
```

## Access Specifiers 🛡️

- **private** - Only accessible within the same class
- **public** - Accessible from anywhere  
- **protected** - Accessible within the class and its derived classes

## Why Encapsulation is Important! 💡

- **Security** - Keeps sensitive data safe from unauthorized access
- **Data Integrity** - Ensures data is only modified through controlled methods
- **Easier Maintenance** - Changes to internal implementation don't affect other code
- **Better Organization** - Related data and methods are grouped together

## Fun Challenge! 🎯

Create a class for a video game character with:
- Private health, level, and experience points
- Public methods to level up, take damage, and heal
- Getter methods to check status without modifying data

## Ready for Inheritance? 🚀

Great job learning about encapsulation! Next, we'll learn about inheritance - how to create new classes from existing ones!
        ''',
        codeExample: '''
#include <iostream>
#include <string>
using namespace std;

class BankAccount {
private:
    string accountNumber;
    string accountHolder;
    double balance;
    string pin;
    
public:
    BankAccount(string accNum, string holder, string p, double initialBalance = 0) 
        : accountNumber(accNum), accountHolder(holder), pin(p), balance(initialBalance) {
        cout << "🏦 Account created for " << accountHolder << endl;
    }
    
    double getBalance() const { return balance; }
    
    bool deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            cout << "💰 USD " << amount << " deposited. Balance: USD " << balance << endl;
            return true;
        }
        return false;
    }
    
    bool withdraw(double amount, string enteredPin) {
        if (enteredPin != pin) {
            cout << "🔒 Incorrect PIN!" << endl;
            return false;
        }
        
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            cout << "💸 USD " << amount << " withdrawn. Balance: USD " << balance << endl;
            return true;
        }
        return false;
    }
};

int main() {
    BankAccount account("123456789", "Alice", "1234", 1000.0);
    account.deposit(500.0);
    account.withdraw(200.0, "1234");
    account.withdraw(100.0, "0000"); // Wrong PIN
    
    return 0;
}
        ''',
        tags: [
          'encapsulation',
          'private',
          'public',
          'getters',
          'setters',
          'intermediate',
        ],
        estimatedTimeMinutes: 22,
        category: 'Object-Oriented Programming',
        order: 6,
        metadata: {
          'age_group': '6th_grade',
          'difficulty_level': 6,
          'fun_factor': 4,
          'interactive': true,
        },
      ),

      Lesson(
        id: '7',
        title: '🧬 Inheritance - Create New Classes from Existing Ones!',
        description:
            'Learn how to use inheritance to build upon existing code!',
        duration: '28 minutes',
        difficulty: 'Intermediate',
        isCompleted: false,
        content: '''
# 🧬 Inheritance - Create New Classes from Existing Ones!

Welcome to the world of inheritance! 🎉

## What is Inheritance? 🤔

Inheritance allows a class to inherit properties and methods from another class. It's like a family tree - children inherit traits from their parents, but can also have their own unique characteristics!

## Animal Kingdom Example 🐾

Let's create a family of animals:

```cpp
#include <iostream>
#include <string>
using namespace std;

// 🐾 Base class (Parent)
class Animal {
protected:
    string name;
    int age;
    string species;
    
public:
    // 🏗️ Constructor
    Animal(string n, int a, string s) : name(n), age(a), species(s) {
        cout << "🐾 " << name << " the " << species << " is born!" << endl;
    }
    
    // 🎯 Virtual methods (can be overridden)
    virtual void makeSound() {
        cout << name << " makes a generic animal sound." << endl;
    }
    
    virtual void move() {
        cout << name << " moves around." << endl;
    }
    
    // 📊 Regular methods
    void eat() {
        cout << name << " is eating." << endl;
    }
    
    void sleep() {
        cout << name << " is sleeping." << endl;
    }
    
    // 📝 Display info
    virtual void displayInfo() {
        cout << "\\n🐾 Animal Info:" << endl;
        cout << "   Name: " << name << endl;
        cout << "   Age: " << age << endl;
        cout << "   Species: " << species << endl;
    }
    
    // 🏗️ Virtual destructor
    virtual ~Animal() {
        cout << "💔 " << name << " has passed away." << endl;
    }
};

// 🐕 Derived class (Child)
class Dog : public Animal {
private:
    string breed;
    bool isTrained;
    
public:
    // 🏗️ Constructor
    Dog(string n, int a, string b, bool trained = false) 
        : Animal(n, a, "Dog"), breed(b), isTrained(trained) {
        cout << "🐕 " << name << " is a " << breed << "!" << endl;
    }
    
    // 🎯 Override virtual methods
    void makeSound() override {
        cout << name << " barks: Woof! Woof!" << endl;
    }
    
    void move() override {
        cout << name << " runs around happily!" << endl;
    }
    
    // 🎾 Dog-specific methods
    void fetch() {
        cout << name << " fetches the ball!" << endl;
    }
    
    void sit() {
        if (isTrained) {
            cout << name << " sits down obediently." << endl;
        } else {
            cout << name << " looks confused and doesn't sit." << endl;
        }
    }
    
    // 📝 Override display info
    void displayInfo() override {
        Animal::displayInfo(); // Call parent's method
        cout << "   Breed: " << breed << endl;
        cout << "   Trained: " << (isTrained ? "Yes" : "No") << endl;
    }
};

// 🐱 Another derived class
class Cat : public Animal {
private:
    string color;
    bool isIndoor;
    
public:
    // 🏗️ Constructor
    Cat(string n, int a, string c, bool indoor = true) 
        : Animal(n, a, "Cat"), color(c), isIndoor(indoor) {
        cout << "🐱 " << name << " is a " << color << " cat!" << endl;
    }
    
    // 🎯 Override virtual methods
    void makeSound() override {
        cout << name << " meows: Meow! Meow!" << endl;
    }
    
    void move() override {
        cout << name << " sneaks around quietly." << endl;
    }
    
    // 🐾 Cat-specific methods
    void purr() {
        cout << name << " purrs contentedly." << endl;
    }
    
    void climb() {
        cout << name << " climbs up high!" << endl;
    }
    
    // 📝 Override display info
    void displayInfo() override {
        Animal::displayInfo(); // Call parent's method
        cout << "   Color: " << color << endl;
        cout << "   Indoor: " << (isIndoor ? "Yes" : "No") << endl;
    }
};

int main() {
    // 🎭 Creating objects of different types
    Dog buddy("Buddy", 3, "Golden Retriever", true);
    Cat whiskers("Whiskers", 2, "Orange", true);
    
    // 🎪 Using inherited methods
    buddy.eat();
    buddy.makeSound();
    buddy.move();
    buddy.fetch();
    buddy.sit();
    buddy.displayInfo();
    
    cout << "\\n" << string(50, '=') << "\\n" << endl;
    
    whiskers.eat();
    whiskers.makeSound();
    whiskers.move();
    whiskers.purr();
    whiskers.climb();
    whiskers.displayInfo();
    
    return 0;
}
```

## Inheritance Benefits 🔑

- **Code Reuse** - Don't repeat yourself (DRY principle)
- **Extensibility** - Easy to add new features
- **Maintainability** - Changes in base class affect all derived classes
- **Polymorphism** - Same interface, different implementations

## Key Terms 📚

- **Base Class (Parent)** - The class being inherited from
- **Derived Class (Child)** - The class that inherits
- **Override** - Replacing a parent's method with your own
- **Virtual** - Allows methods to be overridden
- **Protected** - Accessible to derived classes

## Fun Challenge! 🎯

Create a class hierarchy for vehicles:
- Base class: Vehicle (with speed, fuel level)
- Derived classes: Car, Motorcycle, Truck
- Each should have unique features and behaviors!

## Ready for Polymorphism? 🚀

Awesome! You now understand inheritance! Next, we'll learn about polymorphism - how one thing can have many different forms!
        ''',
        codeExample: '''
#include <iostream>
#include <string>
using namespace std;

class Animal {
protected:
    string name;
    int age;
    
public:
    Animal(string n, int a) : name(n), age(a) {
        cout << "🐾 " << name << " is born!" << endl;
    }
    
    virtual void makeSound() {
        cout << name << " makes a sound." << endl;
    }
    
    void eat() {
        cout << name << " is eating." << endl;
    }
};

class Dog : public Animal {
public:
    Dog(string n, int a) : Animal(n, a) {}
    
    void makeSound() override {
        cout << name << " barks: Woof! Woof!" << endl;
    }
    
    void fetch() {
        cout << name << " fetches the ball!" << endl;
    }
};

class Cat : public Animal {
public:
    Cat(string n, int a) : Animal(n, a) {}
    
    void makeSound() override {
        cout << name << " meows: Meow! Meow!" << endl;
    }
    
    void purr() {
        cout << name << " purrs contentedly." << endl;
    }
};

int main() {
    Dog buddy("Buddy", 3);
    Cat whiskers("Whiskers", 2);
    
    buddy.makeSound();
    buddy.fetch();
    
    whiskers.makeSound();
    whiskers.purr();
    
    return 0;
}
        ''',
        tags: [
          'inheritance',
          'virtual',
          'override',
          'base-class',
          'derived-class',
          'intermediate',
        ],
        estimatedTimeMinutes: 28,
        category: 'Object-Oriented Programming',
        order: 7,
        metadata: {
          'age_group': '6th_grade',
          'difficulty_level': 7,
          'fun_factor': 4,
          'interactive': true,
        },
      ),

      Lesson(
        id: '8',
        title: '🔄 Polymorphism - One Thing, Many Forms!',
        description:
            'Learn how to use polymorphism to create flexible and powerful code!',
        duration: '30 minutes',
        difficulty: 'Advanced',
        isCompleted: false,
        content: '''
# 🔄 Polymorphism - One Thing, Many Forms!

Welcome to the amazing world of polymorphism! 🎭

## What is Polymorphism? 🤔

Polymorphism means 'many forms'. It allows objects of different types to be treated as objects of a common base type. It's like having a universal remote that can control different devices!

## Music Player Example 🎵

Let's create a music player that can handle different types of media:

```cpp
#include <iostream>
#include <vector>
#include <memory>
using namespace std;

// 🎵 Base class for all media types
class Media {
protected:
    string title;
    string artist;
    int duration; // in seconds
    
public:
    Media(string t, string a, int d) : title(t), artist(a), duration(d) {}
    
    // 🎯 Pure virtual function - must be implemented by derived classes
    virtual void play() = 0;
    virtual void pause() = 0;
    virtual void stop() = 0;
    
    // 📊 Regular methods
    string getTitle() const { return title; }
    string getArtist() const { return artist; }
    int getDuration() const { return duration; }
    
    // 📝 Display info
    virtual void displayInfo() {
        cout << "🎵 " << title << " by " << artist << " (" << duration << "s)" << endl;
    }
    
    // 🏗️ Virtual destructor
    virtual ~Media() = default;
};

// 🎶 Song class
class Song : public Media {
private:
    string genre;
    
public:
    Song(string t, string a, int d, string g) : Media(t, a, d), genre(g) {}
    
    void play() override {
        cout << "🎵 Playing song: " << title << " (" << genre << ")" << endl;
    }
    
    void pause() override {
        cout << "⏸️ Song paused: " << title << endl;
    }
    
    void stop() override {
        cout << "⏹️ Song stopped: " << title << endl;
    }
    
    void displayInfo() override {
        Media::displayInfo();
        cout << "   Genre: " << genre << endl;
    }
};

// 🎙️ Podcast class
class Podcast : public Media {
private:
    string host;
    int episode;
    
public:
    Podcast(string t, string h, int d, int ep) : Media(t, h, d), host(h), episode(ep) {}
    
    void play() override {
        cout << "🎙️ Playing podcast: " << title << " (Episode " << episode << ")" << endl;
    }
    
    void pause() override {
        cout << "⏸️ Podcast paused: " << title << endl;
    }
    
    void stop() override {
        cout << "⏹️ Podcast stopped: " << title << endl;
    }
    
    void displayInfo() override {
        Media::displayInfo();
        cout << "   Host: " << host << endl;
        cout << "   Episode: " << episode << endl;
    }
};

// 🎧 Music Player class
class MusicPlayer {
private:
    vector<unique_ptr<Media>> playlist;
    int currentTrack;
    bool isPlaying;
    
public:
    MusicPlayer() : currentTrack(0), isPlaying(false) {}
    
    // ➕ Add media to playlist
    void addMedia(unique_ptr<Media> media) {
        playlist.push_back(move(media));
        cout << "➕ Added to playlist: " << playlist.back()->getTitle() << endl;
    }
    
    // ▶️ Play current track
    void play() {
        if (!playlist.empty() && currentTrack < playlist.size()) {
            isPlaying = true;
            playlist[currentTrack]->play();
        } else {
            cout << "❌ No tracks in playlist!" << endl;
        }
    }
    
    // ⏸️ Pause current track
    void pause() {
        if (isPlaying && !playlist.empty()) {
            playlist[currentTrack]->pause();
        }
    }
    
    // ⏹️ Stop current track
    void stop() {
        if (isPlaying && !playlist.empty()) {
            playlist[currentTrack]->stop();
            isPlaying = false;
        }
    }
    
    // ⏭️ Next track
    void next() {
        if (!playlist.empty()) {
            stop();
            currentTrack = (currentTrack + 1) % playlist.size();
            cout << "⏭️ Next track: " << playlist[currentTrack]->getTitle() << endl;
        }
    }
    
    // 📋 Display playlist
    void displayPlaylist() {
        cout << "\\n📋 Playlist:" << endl;
        for (int i = 0; i < playlist.size(); i++) {
            cout << (i == currentTrack ? "▶️ " : "  ") << (i + 1) << ". ";
            playlist[i]->displayInfo();
        }
    }
};

int main() {
    // 🎧 Create music player
    MusicPlayer player;
    
    // 🎵 Add different types of media
    player.addMedia(make_unique<Song>("Bohemian Rhapsody", "Queen", 355, "Rock"));
    player.addMedia(make_unique<Podcast>("Tech Talk", "John Doe", 1800, 42));
    player.addMedia(make_unique<Song>("Imagine", "John Lennon", 183, "Pop"));
    
    // 🎪 Demonstrate polymorphism
    player.displayPlaylist();
    
    cout << "\\n" << string(50, '=') << "\\n" << endl;
    
    // 🎵 Play different types of media
    player.play();
    player.pause();
    player.play();
    player.next();
    player.play();
    player.next();
    player.play();
    
    return 0;
}
```

## Polymorphism Types 🎯

- **Compile-time** - Function overloading, operator overloading
- **Runtime** - Virtual functions, method overriding
- **Ad-hoc** - Function overloading with different parameters
- **Parametric** - Templates and generics

## Key Concepts 🔑

- **Virtual Functions** - Functions that can be overridden
- **Pure Virtual Functions** - Must be implemented by derived classes
- **Abstract Classes** - Classes with pure virtual functions
- **Dynamic Binding** - Function call determined at runtime

## Why Polymorphism is Powerful! 💡

- **Flexibility** - Same interface, different implementations
- **Extensibility** - Easy to add new types
- **Maintainability** - Changes don't affect existing code
- **Code Reuse** - Write once, use many times

## Fun Challenge! 🎯

Create a shape drawing system:
- Base class: Shape (with virtual draw method)
- Derived classes: Circle, Rectangle, Triangle
- Use polymorphism to draw different shapes!

## Ready for Abstraction? 🚀

Excellent! You now understand polymorphism! Next, we'll learn about abstraction - how to hide complexity and show only what's essential!
        ''',
        codeExample: '''
#include <iostream>
#include <vector>
#include <memory>
using namespace std;

class Media {
protected:
    string title;
    string artist;
    
public:
    Media(string t, string a) : title(t), artist(a) {}
    
    virtual void play() = 0;
    virtual void displayInfo() {
        cout << "🎵 " << title << " by " << artist << endl;
    }
    
    virtual ~Media() = default;
};

class Song : public Media {
private:
    string genre;
    
public:
    Song(string t, string a, string g) : Media(t, a), genre(g) {}
    
    void play() override {
        cout << "🎵 Playing: " << title << " (" << genre << ")" << endl;
    }
    
    void displayInfo() override {
        Media::displayInfo();
        cout << "   Genre: " << genre << endl;
    }
};

class Podcast : public Media {
private:
    int episode;
    
public:
    Podcast(string t, string a, int ep) : Media(t, a), episode(ep) {}
    
    void play() override {
        cout << "🎙️ Playing: " << title << " (Episode " << episode << ")" << endl;
    }
    
    void displayInfo() override {
        Media::displayInfo();
        cout << "   Episode: " << episode << endl;
    }
};

int main() {
    vector<unique_ptr<Media>> playlist;
    
    playlist.push_back(make_unique<Song>("Bohemian Rhapsody", "Queen", "Rock"));
    playlist.push_back(make_unique<Podcast>("Tech Talk", "John Doe", 42));
    
    for (auto& media : playlist) {
        media->displayInfo();
        media->play();
        cout << endl;
    }
    
    return 0;
}
        ''',
        tags: [
          'polymorphism',
          'virtual',
          'abstract',
          'pure-virtual',
          'advanced',
        ],
        estimatedTimeMinutes: 30,
        category: 'Object-Oriented Programming',
        order: 8,
        metadata: {
          'age_group': '6th_grade',
          'difficulty_level': 8,
          'fun_factor': 5,
          'interactive': true,
        },
      ),
    ];
  }
}
