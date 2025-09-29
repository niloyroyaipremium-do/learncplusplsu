import 'package:flutter/material.dart';

class OopTutorialScreen extends StatefulWidget {
  const OopTutorialScreen({super.key});

  @override
  State<OopTutorialScreen> createState() => _OopTutorialScreenState();
}

class _OopTutorialScreenState extends State<OopTutorialScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPage = 0;
  bool _isDarkMode = false;
  double _fontSize = 20.0;

  final List<OopTutorialSection> _tutorialSections = [
    OopTutorialSection(
      title: "🏗️ Introduction to OOP",
      subtitle: "Understanding the fundamentals",
      content: _introductionContent,
    ),
    OopTutorialSection(
      title: "📦 Classes and Objects",
      subtitle: "Building blocks of OOP",
      content: _classesAndObjectsContent,
    ),
    OopTutorialSection(
      title: "🔒 Encapsulation",
      subtitle: "Data hiding and access control",
      content: _encapsulationContent,
    ),
    OopTutorialSection(
      title: "🧬 Inheritance",
      subtitle: "Code reuse and hierarchy",
      content: _inheritanceContent,
    ),
    OopTutorialSection(
      title: "🔄 Polymorphism",
      subtitle: "One interface, multiple implementations",
      content: _polymorphismContent,
    ),
    OopTutorialSection(
      title: "🎯 Abstraction",
      subtitle: "Hiding complexity, showing essentials",
      content: _abstractionContent,
    ),
    OopTutorialSection(
      title: "⚡ Advanced OOP",
      subtitle: "Templates, exceptions, and more",
      content: _advancedOopContent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tutorialSections.length,
      vsync: this,
    );
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '🎓 OOP Tutorial',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: _isDarkMode
            ? const Color(0xFF1E1E1E)
            : const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
          PopupMenuButton<double>(
            onSelected: (size) => setState(() => _fontSize = size),
            itemBuilder: (context) =>
                [16.0, 18.0, 20.0, 22.0, 24.0, 26.0, 28.0, 30.0]
                    .map(
                      (size) => PopupMenuItem(
                        value: size,
                        child: Text('${size.toInt()}px'),
                      ),
                    )
                    .toList(),
            tooltip: 'Font Size',
            child: const Icon(Icons.text_fields),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          tabs: _tutorialSections
              .map(
                (section) => Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          section.title.split(' ')[0], // Emoji
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          section.title.split(' ').skip(1).join(' '),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _tutorialSections.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF667eea),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${_currentPage + 1} / ${_tutorialSections.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _tabController.animateTo(index);
              },
              itemCount: _tutorialSections.length,
              itemBuilder: (context, index) {
                return _buildTutorialPage(_tutorialSections[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage(OopTutorialSection section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.subtitle,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Content
          section.content(context, _isDarkMode, _fontSize),
        ],
      ),
    );
  }
}

class OopTutorialSection {
  final String title;
  final String subtitle;
  final Widget Function(BuildContext, bool, double) content;

  const OopTutorialSection({
    required this.title,
    required this.subtitle,
    required this.content,
  });
}

// Introduction Content
Widget _introductionContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🎯 What is Object-Oriented Programming?",
        "OOP is a programming paradigm based on the concept of 'objects', which contain data (attributes) and code (methods). It's like building with LEGO blocks - each piece has its own shape and function, but together they create something amazing!",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🏛️ The Four Pillars of OOP",
        "1. **Encapsulation** - Bundling data and methods together\n2. **Inheritance** - Creating new classes from existing ones\n3. **Polymorphism** - One interface, multiple implementations\n4. **Abstraction** - Hiding complex details, showing only essentials",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🌟 Your First Class",
        '''#include <iostream>
#include <string>
using namespace std;

// 🏗️ This is a class - a blueprint for creating objects
class Person {
    // 📊 Attributes (data members)
    string name;
    int age;
    
public:
    // 🏗️ Constructor - called when object is created
    Person(string n, int a) : name(n), age(a) {
        cout << "👋 Person created: " << name << endl;
    }
    
    // 🎯 Methods (functions)
    void introduce() {
        cout << "Hello! I'm " << name << " and I'm " << age << " years old." << endl;
    }
    
    void celebrateBirthday() {
        age++;
        cout << "🎉 Happy Birthday! Now I'm " << age << " years old!" << endl;
    }
};

int main() {
    // 🎭 Creating objects from the class
    Person alice("Alice", 25);
    Person bob("Bob", 30);
    
    // 🎪 Using the objects
    alice.introduce();
    bob.introduce();
    
    alice.celebrateBirthday();
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "💡 Why Use OOP?",
        "• **Reusability** - Write once, use many times\n• **Maintainability** - Easy to update and fix\n• **Scalability** - Add new features without breaking existing code\n• **Organization** - Code is well-structured and logical",
        isDarkMode,
      ),
    ],
  );
}

// Classes and Objects Content
Widget _classesAndObjectsContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🏗️ Classes vs Objects",
        "A **class** is like a blueprint or template, while an **object** is an instance of that class. Think of a class as a cookie cutter and objects as the actual cookies!",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🚗 Car Class Example",
        '''#include <iostream>
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
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🔑 Key Concepts",
        "• **Constructor** - Special method called when object is created\n• **Destructor** - Special method called when object is destroyed\n• **Member Variables** - Data stored in the object\n• **Member Functions** - Functions that operate on the object's data",
        isDarkMode,
      ),
    ],
  );
}

// Encapsulation Content
Widget _encapsulationContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🔒 What is Encapsulation?",
        "Encapsulation is the bundling of data and methods that work on that data within one unit. It's like a capsule that protects the medicine inside - the data is protected and can only be accessed through controlled methods.",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🏦 Bank Account Example",
        '''#include <iostream>
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
            cout << "💰 \$" << amount << " deposited. New balance: \$" << balance << endl;
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
            cout << "💸 \$" << amount << " withdrawn. New balance: \$" << balance << endl;
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
        cout << "   Balance: \$" << balance << endl;
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
    cout << "\\n💰 Final Balance: \$" << myAccount.getBalance() << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🛡️ Access Specifiers",
        "• **private** - Only accessible within the same class\n• **public** - Accessible from anywhere\n• **protected** - Accessible within the class and its derived classes",
        isDarkMode,
      ),
    ],
  );
}

// Inheritance Content
Widget _inheritanceContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🧬 What is Inheritance?",
        "Inheritance allows a class to inherit properties and methods from another class. It's like a family tree - children inherit traits from their parents, but can also have their own unique characteristics!",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🐾 Animal Kingdom Example",
        '''#include <iostream>
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
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🔑 Inheritance Benefits",
        "• **Code Reuse** - Don't repeat yourself (DRY principle)\n• **Extensibility** - Easy to add new features\n• **Maintainability** - Changes in base class affect all derived classes\n• **Polymorphism** - Same interface, different implementations",
        isDarkMode,
      ),
    ],
  );
}

// Polymorphism Content
Widget _polymorphismContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🔄 What is Polymorphism?",
        "Polymorphism means 'many forms'. It allows objects of different types to be treated as objects of a common base type. It's like having a universal remote that can control different devices!",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🎵 Music Player Example",
        '''#include <iostream>
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
    
    // 🎪 Demonstrate polymorphism
    player.displayPlaylist();
    
    cout << "\\n" << string(50, '=') << "\\n" << endl;
    
    // 🎵 Play different types of media
    player.play();
    player.pause();
    player.play();
    player.next();
    player.play();
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🎯 Polymorphism Types",
        "• **Compile-time** - Function overloading, operator overloading\n• **Runtime** - Virtual functions, method overriding\n• **Ad-hoc** - Function overloading with different parameters\n• **Parametric** - Templates and generics",
        isDarkMode,
      ),
    ],
  );
}

// Abstraction Content
Widget _abstractionContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "🎯 What is Abstraction?",
        "Abstraction is the process of hiding complex implementation details and showing only the essential features. It's like driving a car - you don't need to know how the engine works, just how to use the steering wheel and pedals!",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🚗 Vehicle Management System",
        '''#include <iostream>
#include <string>
#include <vector>
using namespace std;

// 🚗 Abstract base class
class Vehicle {
protected:
    string make;
    string model;
    int year;
    double fuelLevel;
    double maxFuel;
    bool isRunning;
    
public:
    Vehicle(string m, string mod, int y, double maxF) 
        : make(m), model(mod), year(y), maxFuel(maxF), fuelLevel(maxF), isRunning(false) {}
    
    // 🎯 Pure virtual functions - must be implemented by derived classes
    virtual void start() = 0;
    virtual void stop() = 0;
    virtual void accelerate() = 0;
    virtual void brake() = 0;
    virtual void refuel() = 0;
    
    // 📊 Concrete methods
    string getMake() const { return make; }
    string getModel() const { return model; }
    int getYear() const { return year; }
    double getFuelLevel() const { return fuelLevel; }
    bool getIsRunning() const { return isRunning; }
    
    // 📝 Display basic info
    virtual void displayInfo() {
        cout << "🚗 " << make << " " << model << " (" << year << ")" << endl;
        cout << "   Fuel: " << fuelLevel << "/" << maxFuel << " L" << endl;
        cout << "   Status: " << (isRunning ? "Running" : "Stopped") << endl;
    }
    
    // 🏗️ Virtual destructor
    virtual ~Vehicle() = default;
};

// 🚙 Car class
class Car : public Vehicle {
private:
    int doors;
    string transmission;
    
public:
    Car(string m, string mod, int y, int d, string t) 
        : Vehicle(m, mod, y, 60.0), doors(d), transmission(t) {}
    
    void start() override {
        if (!isRunning && fuelLevel > 0) {
            isRunning = true;
            cout << "🔑 " << make << " " << model << " started with " << doors << " doors!" << endl;
        } else {
            cout << "⚠️ Cannot start - " << (fuelLevel <= 0 ? "no fuel" : "already running") << endl;
        }
    }
    
    void stop() override {
        if (isRunning) {
            isRunning = false;
            cout << "🛑 " << make << " " << model << " stopped!" << endl;
        }
    }
    
    void accelerate() override {
        if (isRunning && fuelLevel > 0) {
            fuelLevel -= 0.5;
            cout << "🏎️ " << make << " " << model << " accelerating! Fuel: " << fuelLevel << "L" << endl;
        } else {
            cout << "⚠️ Cannot accelerate - " << (isRunning ? "no fuel" : "start the car first") << endl;
        }
    }
    
    void brake() override {
        cout << "🛑 " << make << " " << model << " braking!" << endl;
    }
    
    void refuel() override {
        fuelLevel = maxFuel;
        cout << "⛽ " << make << " " << model << " refueled! Fuel: " << fuelLevel << "L" << endl;
    }
    
    void displayInfo() override {
        Vehicle::displayInfo();
        cout << "   Doors: " << doors << endl;
        cout << "   Transmission: " << transmission << endl;
    }
};

// 🏍️ Motorcycle class
class Motorcycle : public Vehicle {
private:
    string engineType;
    bool hasWindshield;
    
public:
    Motorcycle(string m, string mod, int y, string e, bool w) 
        : Vehicle(m, mod, y, 20.0), engineType(e), hasWindshield(w) {}
    
    void start() override {
        if (!isRunning && fuelLevel > 0) {
            isRunning = true;
            cout << "🏍️ " << make << " " << model << " started! Vroom vroom!" << endl;
        } else {
            cout << "⚠️ Cannot start - " << (fuelLevel <= 0 ? "no fuel" : "already running") << endl;
        }
    }
    
    void stop() override {
        if (isRunning) {
            isRunning = false;
            cout << "🛑 " << make << " " << model << " stopped!" << endl;
        }
    }
    
    void accelerate() override {
        if (isRunning && fuelLevel > 0) {
            fuelLevel -= 0.3;
            cout << "🏍️ " << make << " " << model << " accelerating! Fuel: " << fuelLevel << "L" << endl;
        } else {
            cout << "⚠️ Cannot accelerate - " << (isRunning ? "no fuel" : "start the bike first") << endl;
        }
    }
    
    void brake() override {
        cout << "🛑 " << make << " " << model << " braking!" << endl;
    }
    
    void refuel() override {
        fuelLevel = maxFuel;
        cout << "⛽ " << make << " " << model << " refueled! Fuel: " << fuelLevel << "L" << endl;
    }
    
    void displayInfo() override {
        Vehicle::displayInfo();
        cout << "   Engine: " << engineType << endl;
        cout << "   Windshield: " << (hasWindshield ? "Yes" : "No") << endl;
    }
};

// 🏢 Fleet Manager class
class FleetManager {
private:
    vector<unique_ptr<Vehicle>> fleet;
    
public:
    // ➕ Add vehicle to fleet
    void addVehicle(unique_ptr<Vehicle> vehicle) {
        fleet.push_back(move(vehicle));
        cout << "➕ Vehicle added to fleet!" << endl;
    }
    
    // 🎯 Operate all vehicles (demonstrates abstraction)
    void operateAllVehicles() {
        cout << "\\n🚗 Operating all vehicles in fleet:" << endl;
        for (auto& vehicle : fleet) {
            vehicle->start();
            vehicle->accelerate();
            vehicle->brake();
            vehicle->stop();
            cout << endl;
        }
    }
    
    // 📋 Display fleet info
    void displayFleet() {
        cout << "\\n📋 Fleet Information:" << endl;
        for (int i = 0; i < fleet.size(); i++) {
            cout << (i + 1) << ". ";
            fleet[i]->displayInfo();
            cout << endl;
        }
    }
    
    // ⛽ Refuel all vehicles
    void refuelAll() {
        cout << "\\n⛽ Refueling all vehicles:" << endl;
        for (auto& vehicle : fleet) {
            vehicle->refuel();
        }
    }
};

int main() {
    // 🏢 Create fleet manager
    FleetManager manager;
    
    // 🚗 Add different types of vehicles
    manager.addVehicle(make_unique<Car>("Toyota", "Camry", 2022, 4, "Automatic"));
    manager.addVehicle(make_unique<Motorcycle>("Honda", "CBR600", 2023, "Inline-4", true));
    
    // 📋 Display fleet
    manager.displayFleet();
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🎯 Abstraction Benefits",
        "• **Simplicity** - Hide complex implementation details\n• **Focus** - Show only what's necessary\n• **Flexibility** - Easy to change implementation\n• **Maintainability** - Changes don't affect users",
        isDarkMode,
      ),
    ],
  );
}

// Advanced OOP Content
Widget _advancedOopContent(
  BuildContext context,
  bool isDarkMode,
  double fontSize,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard(
        "⚡ Advanced OOP Concepts",
        "Now that you understand the basics, let's explore advanced OOP concepts that make C++ powerful and flexible!",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🔧 Templates and Generic Programming",
        '''#include <iostream>
#include <vector>
#include <string>
using namespace std;

// 🔧 Template class for a generic container
template<typename T>
class Container {
private:
    vector<T> items;
    string name;
    
public:
    Container(string n) : name(n) {
        cout << "📦 Container '" << name << "' created for type " << typeid(T).name() << endl;
    }
    
    void addItem(T item) {
        items.push_back(item);
        cout << "➕ Added item to " << name << ": " << item << endl;
    }
    
    void removeItem(T item) {
        for (auto it = items.begin(); it != items.end(); ++it) {
            if (*it == item) {
                items.erase(it);
                cout << "➖ Removed item from " << name << ": " << item << endl;
                return;
            }
        }
        cout << "❌ Item not found in " << name << endl;
    }
    
    void displayItems() {
        cout << "\\n📋 Items in " << name << ":" << endl;
        for (int i = 0; i < items.size(); i++) {
            cout << "  " << (i + 1) << ". " << items[i] << endl;
        }
    }
    
    int getSize() const { return items.size(); }
    bool isEmpty() const { return items.empty(); }
};

// 🎯 Template function
template<typename T>
T getMax(T a, T b) {
    return (a > b) ? a : b;
}

// 🔧 Specialized template for strings
template<>
class Container<string> {
private:
    vector<string> items;
    string name;
    
public:
    Container(string n) : name(n) {
        cout << "📝 String Container '" << name << "' created" << endl;
    }
    
    void addItem(string item) {
        items.push_back(item);
        cout << "➕ Added string to " << name << ": \\"" << item << "\\"" << endl;
    }
    
    void displayItems() {
        cout << "\\n📋 String items in " << name << ":" << endl;
        for (int i = 0; i < items.size(); i++) {
            cout << "  " << (i + 1) << ". \\"" << items[i] << "\\"" << endl;
        }
    }
    
    int getSize() const { return items.size(); }
};

int main() {
    cout << "=== TEMPLATES AND GENERIC PROGRAMMING ===" << endl;
    
    // 🔧 Create containers for different types
    Container<int> intContainer("Numbers");
    Container<double> doubleContainer("Decimals");
    Container<string> stringContainer("Words");
    
    // ➕ Add items to containers
    intContainer.addItem(42);
    intContainer.addItem(17);
    intContainer.addItem(99);
    
    doubleContainer.addItem(3.14);
    doubleContainer.addItem(2.71);
    
    stringContainer.addItem("Hello");
    stringContainer.addItem("World");
    stringContainer.addItem("C++");
    
    // 📋 Display all containers
    intContainer.displayItems();
    doubleContainer.displayItems();
    stringContainer.displayItems();
    
    // 🎯 Use template function
    cout << "\\n🎯 Template Function Examples:" << endl;
    cout << "Max of 10 and 20: " << getMax(10, 20) << endl;
    cout << "Max of 3.14 and 2.71: " << getMax(3.14, 2.71) << endl;
    cout << "Max of 'apple' and 'banana': " << getMax(string("apple"), string("banana")) << endl;
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildCodeExample(
        "🚨 Exception Handling",
        '''#include <iostream>
#include <stdexcept>
#include <string>
using namespace std;

// 🏦 Bank Account with exception handling
class BankAccount {
private:
    string accountNumber;
    double balance;
    
public:
    BankAccount(string accNum, double initialBalance = 0) 
        : accountNumber(accNum), balance(initialBalance) {
        if (initialBalance < 0) {
            throw invalid_argument("Initial balance cannot be negative!");
        }
        cout << "🏦 Account " << accountNumber << " created with balance: \$" << balance << endl;
    }
    
    void deposit(double amount) {
        if (amount <= 0) {
            throw invalid_argument("Deposit amount must be positive!");
        }
        balance += amount;
        cout << "💰 Deposited \$" << amount << ". New balance: \$" << balance << endl;
    }
    
    void withdraw(double amount) {
        if (amount <= 0) {
            throw invalid_argument("Withdrawal amount must be positive!");
        }
        if (amount > balance) {
            throw runtime_error("Insufficient funds! Available: \$" + to_string(balance));
        }
        balance -= amount;
        cout << "💸 Withdrew \$" << amount << ". New balance: \$" << balance << endl;
    }
    
    double getBalance() const { return balance; }
    string getAccountNumber() const { return accountNumber; }
};

// 🎯 Custom exception class
class BankException : public exception {
private:
    string message;
    
public:
    BankException(string msg) : message(msg) {}
    
    const char* what() const noexcept override {
        return message.c_str();
    }
};

int main() {
    cout << "=== EXCEPTION HANDLING ===" << endl;
    
    try {
        // 🏦 Create account with valid balance
        BankAccount account("123456789", 1000.0);
        
        // 💰 Valid operations
        account.deposit(500.0);
        account.withdraw(200.0);
        
        // 🚨 This will throw an exception
        account.withdraw(2000.0); // Insufficient funds
        
    } catch (const invalid_argument& e) {
        cout << "❌ Invalid Argument Error: " << e.what() << endl;
    } catch (const runtime_error& e) {
        cout << "❌ Runtime Error: " << e.what() << endl;
    } catch (const exception& e) {
        cout << "❌ General Error: " << e.what() << endl;
    }
    
    cout << "\\n" << string(50, '=') << "\\n" << endl;
    
    try {
        // 🚨 This will throw an exception
        BankAccount invalidAccount("987654321", -100.0); // Negative balance
        
    } catch (const invalid_argument& e) {
        cout << "❌ Invalid Argument Error: " << e.what() << endl;
    }
    
    return 0;
}''',
        isDarkMode,
        fontSize,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🎯 Advanced OOP Features",
        "• **Templates** - Generic programming for type safety\n• **Exception Handling** - Graceful error management\n• **Smart Pointers** - Automatic memory management\n• **RAII** - Resource Acquisition Is Initialization\n• **Move Semantics** - Efficient object transfer\n• **Lambda Expressions** - Inline function objects",
        isDarkMode,
      ),
      const SizedBox(height: 20),
      _buildInfoCard(
        "🚀 Next Steps",
        "Congratulations! You've learned the fundamentals of Object-Oriented Programming in C++. Now you can:\n\n• Build complex applications with clean, maintainable code\n• Use design patterns to solve common problems\n• Create reusable libraries and frameworks\n• Work with modern C++ features and best practices\n\nKeep practicing and building projects to master these concepts!",
        isDarkMode,
      ),
    ],
  );
}

// Helper functions for building UI components
Widget _buildInfoCard(String title, String content, bool isDarkMode) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDarkMode ? const Color(0xFF404040) : Colors.grey[300]!,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: isDarkMode ? Colors.grey[300] : Colors.black87,
          ),
        ),
      ],
    ),
  );
}

Widget _buildCodeExample(
  String title,
  String code,
  bool isDarkMode,
  double fontSize,
) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDarkMode ? const Color(0xFF404040) : Colors.grey[300]!,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF2D2D2D)
                : const Color(0xFFE9ECEF),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: fontSize,
                color: isDarkMode
                    ? const Color(0xFFD4D4D4)
                    : const Color(0xFF2D3748),
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
