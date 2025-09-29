import 'package:flutter/material.dart';
import '../services/cpp_execution_service.dart';
import '../widgets/syntax_highlighted_editor.dart';

class CppPlayStoreScreen extends StatefulWidget {
  const CppPlayStoreScreen({super.key});

  @override
  State<CppPlayStoreScreen> createState() => _CppPlayStoreScreenState();
}

class _CppPlayStoreScreenState extends State<CppPlayStoreScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isExecuting = false;
  String _executionResult = '';

  @override
  void initState() {
    super.initState();
    _loadDefaultCode();
  }

  void _loadDefaultCode() {
    _codeController.text = '''#include <iostream>
#include <string>
#include <vector>
#include <map>
using namespace std;

// App class representing a mobile application
class App {
private:
    string name;
    string developer;
    double rating;
    int downloads;
    double price;
    string category;
    vector<string> features;
    
public:
    // Constructor
    App(string n, string dev, double r, int d, double p, string cat) {
        name = n;
        developer = dev;
        rating = r;
        downloads = d;
        price = p;
        category = cat;
    }
    
    // Getters
    string getName() { return name; }
    string getDeveloper() { return developer; }
    double getRating() { return rating; }
    int getDownloads() { return downloads; }
    double getPrice() { return price; }
    string getCategory() { return category; }
    
    // Add feature
    void addFeature(string feature) {
        features.push_back(feature);
    }
    
    // Display app info
    void displayInfo() {
        cout << "\\n=== " << name << " ===" << endl;
        cout << "Developer: " << developer << endl;
        cout << "Rating: " << rating << "/5.0" << endl;
        cout << "Downloads: " << downloads << endl;
        cout << "Price: " << price << endl;
        cout << "Category: " << category << endl;
        cout << "Features: ";
        for(int i = 0; i < features.size(); i++) {
            cout << features[i];
            if(i < features.size() - 1) cout << ", ";
        }
        cout << endl;
    }
};

// Play Store class
class PlayStore {
private:
    vector<App> apps;
    map<string, vector<App>> categories;
    
public:
    // Add app to store
    void addApp(App app) {
        apps.push_back(app);
        categories[app.getCategory()].push_back(app);
        cout << "Added " << app.getName() << " to Play Store" << endl;
    }
    
    // Search apps by name
    vector<App> searchApps(string query) {
        vector<App> results;
        for(App app : apps) {
            if(app.getName().find(query) != string::npos) {
                results.push_back(app);
            }
        }
        return results;
    }
    
    // Get apps by category
    vector<App> getAppsByCategory(string category) {
        return categories[category];
    }
    
    // Display all apps
    void displayAllApps() {
        cout << "\\n=== ALL APPS IN PLAY STORE ===" << endl;
        for(App app : apps) {
            app.displayInfo();
        }
    }
    
    // Display apps by category
    void displayAppsByCategory(string category) {
        cout << "\\n=== " << category << " APPS ===" << endl;
        vector<App> categoryApps = getAppsByCategory(category);
        for(App app : categoryApps) {
            app.displayInfo();
        }
    }
};

int main() {
    cout << "=== C++ PLAY STORE CLONE ===" << endl;
    
    // Create Play Store
    PlayStore playStore;
    
    // Create some apps
    App app1("WhatsApp", "WhatsApp Inc.", 4.5, 5000000000, 0.0, "Communication");
    app1.addFeature("Messaging");
    app1.addFeature("Voice Calls");
    app1.addFeature("Video Calls");
    
    App app2("Instagram", "Meta", 4.3, 2000000000, 0.0, "Social");
    app2.addFeature("Photo Sharing");
    app2.addFeature("Stories");
    app2.addFeature("Reels");
    
    App app3("Minecraft", "Mojang", 4.7, 300000000, 6.99, "Games");
    app3.addFeature("Creative Mode");
    app3.addFeature("Survival Mode");
    app3.addFeature("Multiplayer");
    
    App app4("Spotify", "Spotify AB", 4.2, 1000000000, 9.99, "Music");
    app4.addFeature("Music Streaming");
    app4.addFeature("Playlists");
    app4.addFeature("Offline Mode");
    
    // Add apps to store
    playStore.addApp(app1);
    playStore.addApp(app2);
    playStore.addApp(app3);
    playStore.addApp(app4);
    
    // Display all apps
    playStore.displayAllApps();
    
    // Display apps by category
    playStore.displayAppsByCategory("Games");
    
    // Search functionality
    cout << "\\n=== SEARCH RESULTS FOR 'APP' ===" << endl;
    vector<App> searchResults = playStore.searchApps("App");
    for(App app : searchResults) {
        app.displayInfo();
    }
    
    return 0;
}''';
  }

  Future<void> _executeCode() async {
    if (_isExecuting) return;

    setState(() {
      _isExecuting = true;
      _executionResult = 'Executing...';
    });

    try {
      final result = await CppExecutionService.executeCode(
        _codeController.text,
      );
      setState(() {
        _executionResult = result.output;
      });
    } catch (e) {
      setState(() {
        _executionResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isExecuting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏪 C++ Play Store Clone'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.store, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'C++ Play Store Clone',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'A complete Play Store simulation built with C++ OOP concepts including classes, objects, vectors, and maps.',
                    ),
                    const SizedBox(height: 8),
                    const Text('Features:'),
                    const SizedBox(height: 4),
                    const Text('• App management system'),
                    const Text('• Category-based organization'),
                    const Text('• Search functionality'),
                    const Text('• Rating and download tracking'),
                    const Text('• Feature management'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Code Editor
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.code, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Code Editor',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _isExecuting ? null : _executeCode,
                          icon: _isExecuting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.play_arrow),
                          label: Text(_isExecuting ? 'Running...' : 'Run Code'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: SyntaxHighlightedEditor(
                        controller: _codeController,
                        language: 'cpp',
                        fontSize: 14,
                        isDarkMode: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Execution Result
            if (_executionResult.isNotEmpty)
              Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.play_circle, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Execution Result',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.orange[600],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _executionResult,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
