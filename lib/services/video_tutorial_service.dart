import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/logger.dart';

/// Video Tutorial Service
/// 
/// Handles video tutorial integration, offline support,
/// and synchronized code examples
class VideoTutorialService {
  static final VideoTutorialService _instance = VideoTutorialService._internal();
  factory VideoTutorialService() => _instance;
  VideoTutorialService._internal();

  bool _isInitialized = false;
  final List<Map<String, dynamic>> _videoTutorials = [];
  final Map<String, String> _offlineVideos = {};
  final Map<String, List<Map<String, dynamic>>> _synchronizedContent = {};

  /// Initialize video tutorial service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadVideoTutorials();
      await _checkOfflineVideos();
      await _loadSynchronizedContent();
      
      _isInitialized = true;
      Logger.info('Video tutorial service initialized');
    } catch (e) {
      Logger.error('Failed to initialize video tutorial service', e);
    }
  }

  /// Load video tutorials
  Future<void> _loadVideoTutorials() async {
    _videoTutorials.clear();
    
    _videoTutorials.addAll([
      {
        'id': 'cpp_basics_intro',
        'title': 'Introduction to C++ Programming',
        'description': 'Learn the fundamentals of C++ programming language',
        'duration': 1200, // 20 minutes in seconds
        'difficulty': 'Beginner',
        'instructor': 'Dr. Sarah Johnson',
        'thumbnail': 'assets/videos/thumbnails/cpp_basics_intro.jpg',
        'videoUrl': 'https://example.com/videos/cpp_basics_intro.mp4',
        'offlineUrl': 'offline_cpp_basics_intro.mp4',
        'isDownloaded': false,
        'fileSize': 150 * 1024 * 1024, // 150 MB
        'quality': 'HD',
        'subtitleUrl': 'https://example.com/subtitles/cpp_basics_intro.srt',
        'chapters': [
          {
            'title': 'What is C++?',
            'startTime': 0,
            'endTime': 180,
            'description': 'Introduction to C++ programming language',
          },
          {
            'title': 'Setting up Development Environment',
            'startTime': 180,
            'endTime': 360,
            'description': 'Installing compiler and IDE',
          },
          {
            'title': 'Your First C++ Program',
            'startTime': 360,
            'endTime': 600,
            'description': 'Writing and running Hello World',
          },
          {
            'title': 'Variables and Data Types',
            'startTime': 600,
            'endTime': 900,
            'description': 'Understanding variables and data types',
          },
          {
            'title': 'Summary and Next Steps',
            'startTime': 900,
            'endTime': 1200,
            'description': 'Recap and what to learn next',
          },
        ],
        'synchronizedCode': [
          {
            'timestamp': 360,
            'code': '''
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}''',
            'description': 'Basic Hello World program',
          },
          {
            'timestamp': 600,
            'code': '''
#include <iostream>
using namespace std;

int main() {
    int age = 25;
    string name = "John";
    double height = 5.9;
    
    cout << "Name: " << name << endl;
    cout << "Age: " << age << endl;
    cout << "Height: " << height << endl;
    
    return 0;
}''',
            'description': 'Variables and data types example',
          },
        ],
        'relatedLessons': ['variables_and_data_types', 'input_output'],
        'tags': ['basics', 'introduction', 'setup'],
      },
      {
        'id': 'oop_concepts',
        'title': 'Object-Oriented Programming in C++',
        'description': 'Master OOP concepts including classes, objects, inheritance, and polymorphism',
        'duration': 2400, // 40 minutes
        'difficulty': 'Intermediate',
        'instructor': 'Prof. Michael Chen',
        'thumbnail': 'assets/videos/thumbnails/oop_concepts.jpg',
        'videoUrl': 'https://example.com/videos/oop_concepts.mp4',
        'offlineUrl': 'offline_oop_concepts.mp4',
        'isDownloaded': false,
        'fileSize': 300 * 1024 * 1024, // 300 MB
        'quality': 'HD',
        'subtitleUrl': 'https://example.com/subtitles/oop_concepts.srt',
        'chapters': [
          {
            'title': 'Introduction to OOP',
            'startTime': 0,
            'endTime': 300,
            'description': 'Understanding object-oriented programming',
          },
          {
            'title': 'Classes and Objects',
            'startTime': 300,
            'endTime': 720,
            'description': 'Creating and using classes and objects',
          },
          {
            'title': 'Inheritance',
            'startTime': 720,
            'endTime': 1200,
            'description': 'Building class hierarchies',
          },
          {
            'title': 'Polymorphism',
            'startTime': 1200,
            'endTime': 1800,
            'description': 'Runtime and compile-time polymorphism',
          },
          {
            'title': 'Encapsulation',
            'startTime': 1800,
            'endTime': 2100,
            'description': 'Data hiding and access control',
          },
          {
            'title': 'Practical Example',
            'startTime': 2100,
            'endTime': 2400,
            'description': 'Building a complete OOP application',
          },
        ],
        'synchronizedCode': [
          {
            'timestamp': 300,
            'code': '''
class Car {
private:
    string brand;
    string model;
    int year;
    
public:
    Car(string b, string m, int y) {
        brand = b;
        model = m;
        year = y;
    }
    
    void displayInfo() {
        cout << brand << " " << model << " (" << year << ")" << endl;
    }
};''',
            'description': 'Basic class definition',
          },
          {
            'timestamp': 720,
            'code': '''
class Vehicle {
protected:
    string type;
    
public:
    Vehicle(string t) : type(t) {}
    virtual void start() = 0;
};

class Car : public Vehicle {
public:
    Car() : Vehicle("Car") {}
    void start() override {
        cout << "Car engine started!" << endl;
    }
};''',
            'description': 'Inheritance example',
          },
        ],
        'relatedLessons': ['classes_and_objects', 'inheritance', 'polymorphism'],
        'tags': ['oop', 'classes', 'inheritance', 'polymorphism'],
      },
      {
        'id': 'stl_containers',
        'title': 'STL Containers and Algorithms',
        'description': 'Learn about Standard Template Library containers and algorithms',
        'duration': 1800, // 30 minutes
        'difficulty': 'Advanced',
        'instructor': 'Dr. Emily Rodriguez',
        'thumbnail': 'assets/videos/thumbnails/stl_containers.jpg',
        'videoUrl': 'https://example.com/videos/stl_containers.mp4',
        'offlineUrl': 'offline_stl_containers.mp4',
        'isDownloaded': false,
        'fileSize': 200 * 1024 * 1024, // 200 MB
        'quality': 'HD',
        'subtitleUrl': 'https://example.com/subtitles/stl_containers.srt',
        'chapters': [
          {
            'title': 'Introduction to STL',
            'startTime': 0,
            'endTime': 240,
            'description': 'What is STL and why use it',
          },
          {
            'title': 'Vector Container',
            'startTime': 240,
            'endTime': 600,
            'description': 'Dynamic arrays with vector',
          },
          {
            'title': 'Map and Set',
            'startTime': 600,
            'endTime': 960,
            'description': 'Associative containers',
          },
          {
            'title': 'STL Algorithms',
            'startTime': 960,
            'endTime': 1320,
            'description': 'Common algorithms like sort, find, etc.',
          },
          {
            'title': 'Iterators',
            'startTime': 1320,
            'endTime': 1560,
            'description': 'Traversing containers with iterators',
          },
          {
            'title': 'Practical Examples',
            'startTime': 1560,
            'endTime': 1800,
            'description': 'Real-world STL usage',
          },
        ],
        'synchronizedCode': [
          {
            'timestamp': 240,
            'code': '''
#include <vector>
#include <iostream>
using namespace std;

int main() {
    vector<int> numbers = {1, 2, 3, 4, 5};
    
    for (int num : numbers) {
        cout << num << " ";
    }
    cout << endl;
    
    return 0;
}''',
            'description': 'Basic vector usage',
          },
          {
            'timestamp': 600,
            'code': '''
#include <map>
#include <iostream>
using namespace std;

int main() {
    map<string, int> ages;
    ages["Alice"] = 25;
    ages["Bob"] = 30;
    ages["Charlie"] = 35;
    
    for (auto& pair : ages) {
        cout << pair.first << ": " << pair.second << endl;
    }
    
    return 0;
}''',
            'description': 'Map container example',
          },
        ],
        'relatedLessons': ['stl_containers', 'algorithms', 'templates'],
        'tags': ['stl', 'containers', 'algorithms', 'templates'],
      },
    ]);
  }

  /// Check offline videos
  Future<void> _checkOfflineVideos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final videoDir = Directory('${directory.path}/videos');
      
      if (await videoDir.exists()) {
        final files = await videoDir.list().toList();
        for (final file in files) {
          if (file is File && file.path.endsWith('.mp4')) {
            final fileName = file.path.split('/').last;
            _offlineVideos[fileName] = file.path;
          }
        }
      }
      
      // Update download status
      for (final tutorial in _videoTutorials) {
        final offlineFileName = tutorial['offlineUrl'] as String;
        tutorial['isDownloaded'] = _offlineVideos.containsKey(offlineFileName);
      }
      
      Logger.info('Found ${_offlineVideos.length} offline videos');
    } catch (e) {
      Logger.error('Failed to check offline videos', e);
    }
  }

  /// Load synchronized content
  Future<void> _loadSynchronizedContent() async {
    for (final tutorial in _videoTutorials) {
      final tutorialId = tutorial['id'] as String;
      _synchronizedContent[tutorialId] = tutorial['synchronizedCode'] as List<Map<String, dynamic>>;
    }
  }

  /// Get all video tutorials
  List<Map<String, dynamic>> getAllTutorials() {
    return List.from(_videoTutorials);
  }

  /// Get tutorials by difficulty
  List<Map<String, dynamic>> getTutorialsByDifficulty(String difficulty) {
    return _videoTutorials.where((tutorial) => 
      tutorial['difficulty'].toLowerCase() == difficulty.toLowerCase()
    ).toList();
  }

  /// Get tutorial by ID
  Map<String, dynamic> getTutorialById(String tutorialId) {
    try {
      return _videoTutorials.firstWhere((tutorial) => tutorial['id'] == tutorialId);
    } catch (e) {
      Logger.error('Tutorial not found: $tutorialId', e);
      return {};
    }
  }

  /// Download video for offline viewing
  Future<Map<String, dynamic>> downloadVideo(String tutorialId) async {
    try {
      final tutorial = getTutorialById(tutorialId);
      if (tutorial.isEmpty) {
        return {
          'success': false,
          'message': 'Tutorial not found',
        };
      }

      if (tutorial['isDownloaded'] == true) {
        return {
          'success': true,
          'message': 'Video already downloaded',
        };
      }

      // Simulate download process
      final progress = await _simulateDownload(tutorial);
      
      if (progress['success']) {
        // Update download status
        tutorial['isDownloaded'] = true;
        _offlineVideos[tutorial['offlineUrl']] = progress['filePath'];
        
        // Save to preferences
        await _saveDownloadStatus(tutorialId);
      }

      return progress;
    } catch (e) {
      Logger.error('Failed to download video: $tutorialId', e);
      return {
        'success': false,
        'message': 'Download failed: ${e.toString()}',
      };
    }
  }

  /// Simulate video download
  Future<Map<String, dynamic>> _simulateDownload(Map<String, dynamic> tutorial) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final videoDir = Directory('${directory.path}/videos');
      
      if (!await videoDir.exists()) {
        await videoDir.create(recursive: true);
      }

      final fileName = tutorial['offlineUrl'] as String;
      final filePath = '${videoDir.path}/$fileName';
      
      // Simulate download progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        // In real implementation, this would update actual download progress
      }

      // Create a placeholder file (in real implementation, this would be the actual video)
      final file = File(filePath);
      await file.writeAsString('Video content placeholder');

      return {
        'success': true,
        'message': 'Video downloaded successfully',
        'filePath': filePath,
        'fileSize': tutorial['fileSize'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Download failed: ${e.toString()}',
      };
    }
  }

  /// Save download status
  Future<void> _saveDownloadStatus(String tutorialId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadedTutorials = prefs.getStringList('downloadedTutorials') ?? [];
      
      if (!downloadedTutorials.contains(tutorialId)) {
        downloadedTutorials.add(tutorialId);
        await prefs.setStringList('downloadedTutorials', downloadedTutorials);
      }
    } catch (e) {
      Logger.error('Failed to save download status', e);
    }
  }

  /// Get synchronized code for timestamp
  List<Map<String, dynamic>> getSynchronizedCode(String tutorialId, int timestamp) {
    final synchronizedCode = _synchronizedContent[tutorialId] ?? [];
    
    return synchronizedCode.where((code) {
      final codeTimestamp = code['timestamp'] as int;
      return codeTimestamp <= timestamp;
    }).toList();
  }

  /// Get video progress
  Future<Map<String, dynamic>> getVideoProgress(String tutorialId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressKey = 'video_progress_$tutorialId';
      final progress = prefs.getInt(progressKey) ?? 0;
      
      return {
        'tutorialId': tutorialId,
        'currentTime': progress,
        'isCompleted': progress >= 0.9, // 90% watched = completed
      };
    } catch (e) {
      Logger.error('Failed to get video progress', e);
      return {
        'tutorialId': tutorialId,
        'currentTime': 0,
        'isCompleted': false,
      };
    }
  }

  /// Update video progress
  Future<void> updateVideoProgress(String tutorialId, int currentTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressKey = 'video_progress_$tutorialId';
      await prefs.setInt(progressKey, currentTime);
      
      // Check if video is completed
      final tutorial = getTutorialById(tutorialId);
      final duration = tutorial['duration'] as int;
      
      if (currentTime >= duration * 0.9) {
        await _markVideoCompleted(tutorialId);
      }
    } catch (e) {
      Logger.error('Failed to update video progress', e);
    }
  }

  /// Mark video as completed
  Future<void> _markVideoCompleted(String tutorialId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completedVideos = prefs.getStringList('completedVideos') ?? [];
      
      if (!completedVideos.contains(tutorialId)) {
        completedVideos.add(tutorialId);
        await prefs.setStringList('completedVideos', completedVideos);
        
        // Award points
        final tutorial = getTutorialById(tutorialId);
        final points = _calculateVideoPoints(tutorial);
        await _awardPoints(points);
        
        Logger.info('Video completed: $tutorialId');
      }
    } catch (e) {
      Logger.error('Failed to mark video as completed', e);
    }
  }

  /// Calculate video points
  int _calculateVideoPoints(Map<String, dynamic> tutorial) {
    final difficulty = tutorial['difficulty'] as String;
    final duration = tutorial['duration'] as int;
    
    int basePoints = 0;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        basePoints = 10;
        break;
      case 'intermediate':
        basePoints = 20;
        break;
      case 'advanced':
        basePoints = 30;
        break;
    }
    
    // Bonus points for longer videos
    final durationBonus = (duration / 60).floor() * 2; // 2 points per minute
    
    return basePoints + durationBonus;
  }

  /// Award points
  Future<void> _awardPoints(int points) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final totalPoints = prefs.getInt('totalPoints') ?? 0;
      await prefs.setInt('totalPoints', totalPoints + points);
      
      Logger.info('Awarded $points points for video completion');
    } catch (e) {
      Logger.error('Failed to award points', e);
    }
  }

  /// Delete downloaded video
  Future<Map<String, dynamic>> deleteDownloadedVideo(String tutorialId) async {
    try {
      final tutorial = getTutorialById(tutorialId);
      if (tutorial.isEmpty) {
        return {
          'success': false,
          'message': 'Tutorial not found',
        };
      }

      final offlineFileName = tutorial['offlineUrl'] as String;
      final filePath = _offlineVideos[offlineFileName];
      
      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
        
        _offlineVideos.remove(offlineFileName);
        tutorial['isDownloaded'] = false;
        
        // Update preferences
        final prefs = await SharedPreferences.getInstance();
        final downloadedTutorials = prefs.getStringList('downloadedTutorials') ?? [];
        downloadedTutorials.remove(tutorialId);
        await prefs.setStringList('downloadedTutorials', downloadedTutorials);
      }

      return {
        'success': true,
        'message': 'Video deleted successfully',
      };
    } catch (e) {
      Logger.error('Failed to delete video: $tutorialId', e);
      return {
        'success': false,
        'message': 'Delete failed: ${e.toString()}',
      };
    }
  }

  /// Get offline storage usage
  Future<Map<String, dynamic>> getOfflineStorageUsage() async {
    try {
      int totalSize = 0;
      int videoCount = 0;
      
      for (final filePath in _offlineVideos.values) {
        final file = File(filePath);
        if (await file.exists()) {
          final stat = await file.stat();
          totalSize += stat.size;
          videoCount++;
        }
      }
      
      return {
        'totalSize': totalSize,
        'videoCount': videoCount,
        'formattedSize': _formatFileSize(totalSize),
      };
    } catch (e) {
      Logger.error('Failed to get offline storage usage', e);
      return {
        'totalSize': 0,
        'videoCount': 0,
        'formattedSize': '0 MB',
      };
    }
  }

  /// Format file size
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Search tutorials
  List<Map<String, dynamic>> searchTutorials(String query) {
    final lowercaseQuery = query.toLowerCase();
    
    return _videoTutorials.where((tutorial) {
      final title = tutorial['title'].toString().toLowerCase();
      final description = tutorial['description'].toString().toLowerCase();
      final tags = (tutorial['tags'] as List<dynamic>).map((tag) => tag.toString().toLowerCase()).toList();
      
      return title.contains(lowercaseQuery) ||
             description.contains(lowercaseQuery) ||
             tags.any((tag) => tag.contains(lowercaseQuery));
    }).toList();
  }

  /// Get related tutorials
  List<Map<String, dynamic>> getRelatedTutorials(String tutorialId) {
    final tutorial = getTutorialById(tutorialId);
    if (tutorial.isEmpty) return [];
    
    final relatedLessonIds = tutorial['relatedLessons'] as List<dynamic>;
    final currentTags = tutorial['tags'] as List<dynamic>;
    
    return _videoTutorials.where((t) {
      if (t['id'] == tutorialId) return false;
      
      final tTags = t['tags'] as List<dynamic>;
      final hasCommonTags = tTags.any((tag) => currentTags.contains(tag));
      
      return hasCommonTags;
    }).take(3).toList();
  }
}