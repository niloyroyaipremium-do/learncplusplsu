import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Collaboration Service
/// 
/// Handles code sharing, collaborative coding sessions,
/// and social learning features
class CollaborationService {
  static final CollaborationService _instance = CollaborationService._internal();
  factory CollaborationService() => _instance;
  CollaborationService._internal();

  bool _isInitialized = false;
  final List<Map<String, dynamic>> _sharedCodeSnippets = [];
  final List<Map<String, dynamic>> _collaborativeSessions = [];
  final List<Map<String, dynamic>> _userProfiles = [];
  final List<Map<String, dynamic>> _learningGroups = [];
  final Map<String, List<Map<String, dynamic>>> _comments = {};

  /// Initialize collaboration service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadSharedCodeSnippets();
      await _loadCollaborativeSessions();
      await _loadUserProfiles();
      await _loadLearningGroups();
      await _loadComments();
      
      _isInitialized = true;
      Logger.info('Collaboration service initialized');
    } catch (e) {
      Logger.error('Failed to initialize collaboration service', e);
    }
  }

  /// Load shared code snippets
  Future<void> _loadSharedCodeSnippets() async {
    _sharedCodeSnippets.clear();
    
    // Load from local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      final snippetsJson = prefs.getString('sharedCodeSnippets');
      if (snippetsJson != null) {
        final snippets = jsonDecode(snippetsJson) as List<dynamic>;
        _sharedCodeSnippets.addAll(snippets.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      Logger.error('Failed to load shared code snippets', e);
    }
  }

  /// Load collaborative sessions
  Future<void> _loadCollaborativeSessions() async {
    _collaborativeSessions.clear();
    
    // Load from local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = prefs.getString('collaborativeSessions');
      if (sessionsJson != null) {
        final sessions = jsonDecode(sessionsJson) as List<dynamic>;
        _collaborativeSessions.addAll(sessions.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      Logger.error('Failed to load collaborative sessions', e);
    }
  }

  /// Load user profiles
  Future<void> _loadUserProfiles() async {
    _userProfiles.clear();
    
    // Load from local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = prefs.getString('userProfiles');
      if (profilesJson != null) {
        final profiles = jsonDecode(profilesJson) as List<dynamic>;
        _userProfiles.addAll(profiles.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      Logger.error('Failed to load user profiles', e);
    }
  }

  /// Load learning groups
  Future<void> _loadLearningGroups() async {
    _learningGroups.clear();
    
    // Load from local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsJson = prefs.getString('learningGroups');
      if (groupsJson != null) {
        final groups = jsonDecode(groupsJson) as List<dynamic>;
        _learningGroups.addAll(groups.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      Logger.error('Failed to load learning groups', e);
    }
  }

  /// Load comments
  Future<void> _loadComments() async {
    _comments.clear();
    
    // Load from local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      final commentsJson = prefs.getString('comments');
      if (commentsJson != null) {
        final comments = jsonDecode(commentsJson) as Map<String, dynamic>;
        for (final entry in comments.entries) {
          _comments[entry.key] = (entry.value as List<dynamic>).cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      Logger.error('Failed to load comments', e);
    }
  }

  /// Share code snippet
  Future<Map<String, dynamic>> shareCodeSnippet({
    required String title,
    required String description,
    required String code,
    required String language,
    List<String>? tags,
    String? difficulty,
    bool isPublic = true,
  }) async {
    try {
      final snippet = {
        'id': _generateId(),
        'title': title,
        'description': description,
        'code': code,
        'language': language,
        'tags': tags ?? [],
        'difficulty': difficulty ?? 'intermediate',
        'isPublic': isPublic,
        'authorId': await _getCurrentUserId(),
        'authorName': await _getCurrentUserName(),
        'createdAt': DateTime.now().toIso8601String(),
        'likes': 0,
        'views': 0,
        'forks': 0,
        'comments': 0,
      };

      _sharedCodeSnippets.add(snippet);
      await _saveSharedCodeSnippets();

      Logger.info('Code snippet shared: ${snippet['id']}');
      return {
        'success': true,
        'snippetId': snippet['id'],
        'message': 'Code snippet shared successfully',
      };
    } catch (e) {
      Logger.error('Failed to share code snippet', e);
      return {
        'success': false,
        'message': 'Failed to share code snippet',
      };
    }
  }

  /// Get shared code snippets
  List<Map<String, dynamic>> getSharedCodeSnippets({
    String? language,
    String? difficulty,
    List<String>? tags,
    String? searchQuery,
    int limit = 20,
  }) {
    var snippets = List<Map<String, dynamic>>.from(_sharedCodeSnippets);

    // Filter by language
    if (language != null) {
      snippets = snippets.where((snippet) => snippet['language'] == language).toList();
    }

    // Filter by difficulty
    if (difficulty != null) {
      snippets = snippets.where((snippet) => snippet['difficulty'] == difficulty).toList();
    }

    // Filter by tags
    if (tags != null && tags.isNotEmpty) {
      snippets = snippets.where((snippet) {
        final snippetTags = snippet['tags'] as List<dynamic>;
        return tags.any((tag) => snippetTags.contains(tag));
      }).toList();
    }

    // Search by query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      snippets = snippets.where((snippet) {
        final title = snippet['title'].toString().toLowerCase();
        final description = snippet['description'].toString().toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Sort by creation date (newest first)
    snippets.sort((a, b) => (b['createdAt'] as String).compareTo(a['createdAt'] as String));

    return snippets.take(limit).toList();
  }

  /// Get code snippet by ID
  Map<String, dynamic> getCodeSnippetById(String snippetId) {
    try {
      return _sharedCodeSnippets.firstWhere((snippet) => snippet['id'] == snippetId);
    } catch (e) {
      Logger.error('Code snippet not found: $snippetId', e);
      return {};
    }
  }

  /// Like code snippet
  Future<Map<String, dynamic>> likeCodeSnippet(String snippetId) async {
    try {
      final snippet = getCodeSnippetById(snippetId);
      if (snippet.isEmpty) {
        return {
          'success': false,
          'message': 'Code snippet not found',
        };
      }

      snippet['likes'] = (snippet['likes'] as int) + 1;
      await _saveSharedCodeSnippets();

      return {
        'success': true,
        'likes': snippet['likes'],
        'message': 'Code snippet liked',
      };
    } catch (e) {
      Logger.error('Failed to like code snippet', e);
      return {
        'success': false,
        'message': 'Failed to like code snippet',
      };
    }
  }

  /// Fork code snippet
  Future<Map<String, dynamic>> forkCodeSnippet(String snippetId, {
    String? newTitle,
    String? newDescription,
  }) async {
    try {
      final originalSnippet = getCodeSnippetById(snippetId);
      if (originalSnippet.isEmpty) {
        return {
          'success': false,
          'message': 'Code snippet not found',
        };
      }

      final forkedSnippet = Map<String, dynamic>.from(originalSnippet);
      forkedSnippet['id'] = _generateId();
      forkedSnippet['title'] = newTitle ?? '${originalSnippet['title']} (Fork)';
      forkedSnippet['description'] = newDescription ?? originalSnippet['description'];
      forkedSnippet['authorId'] = await _getCurrentUserId();
      forkedSnippet['authorName'] = await _getCurrentUserName();
      forkedSnippet['createdAt'] = DateTime.now().toIso8601String();
      forkedSnippet['likes'] = 0;
      forkedSnippet['views'] = 0;
      forkedSnippet['forks'] = 0;
      forkedSnippet['comments'] = 0;
      forkedSnippet['originalId'] = snippetId;

      _sharedCodeSnippets.add(forkedSnippet);
      
      // Update original snippet's fork count
      originalSnippet['forks'] = (originalSnippet['forks'] as int) + 1;
      
      await _saveSharedCodeSnippets();

      return {
        'success': true,
        'forkedSnippetId': forkedSnippet['id'],
        'message': 'Code snippet forked successfully',
      };
    } catch (e) {
      Logger.error('Failed to fork code snippet', e);
      return {
        'success': false,
        'message': 'Failed to fork code snippet',
      };
    }
  }

  /// Add comment to code snippet
  Future<Map<String, dynamic>> addComment(String snippetId, String comment) async {
    try {
      final commentData = {
        'id': _generateId(),
        'snippetId': snippetId,
        'authorId': await _getCurrentUserId(),
        'authorName': await _getCurrentUserName(),
        'comment': comment,
        'createdAt': DateTime.now().toIso8601String(),
        'likes': 0,
      };

      if (!_comments.containsKey(snippetId)) {
        _comments[snippetId] = [];
      }
      _comments[snippetId]!.add(commentData);

      // Update snippet's comment count
      final snippet = getCodeSnippetById(snippetId);
      if (snippet.isNotEmpty) {
        snippet['comments'] = (snippet['comments'] as int) + 1;
        await _saveSharedCodeSnippets();
      }

      await _saveComments();

      return {
        'success': true,
        'commentId': commentData['id'],
        'message': 'Comment added successfully',
      };
    } catch (e) {
      Logger.error('Failed to add comment', e);
      return {
        'success': false,
        'message': 'Failed to add comment',
      };
    }
  }

  /// Get comments for code snippet
  List<Map<String, dynamic>> getComments(String snippetId) {
    return _comments[snippetId] ?? [];
  }

  /// Create collaborative coding session
  Future<Map<String, dynamic>> createCollaborativeSession({
    required String title,
    required String description,
    required String initialCode,
    String? language,
    int maxParticipants = 10,
    bool isPublic = true,
  }) async {
    try {
      final session = {
        'id': _generateId(),
        'title': title,
        'description': description,
        'initialCode': initialCode,
        'language': language ?? 'cpp',
        'maxParticipants': maxParticipants,
        'isPublic': isPublic,
        'creatorId': await _getCurrentUserId(),
        'creatorName': await _getCurrentUserName(),
        'createdAt': DateTime.now().toIso8601String(),
        'participants': [await _getCurrentUserId()],
        'currentCode': initialCode,
        'isActive': true,
        'messages': [],
      };

      _collaborativeSessions.add(session);
      await _saveCollaborativeSessions();

      Logger.info('Collaborative session created: ${session['id']}');
      return {
        'success': true,
        'sessionId': session['id'],
        'message': 'Collaborative session created successfully',
      };
    } catch (e) {
      Logger.error('Failed to create collaborative session', e);
      return {
        'success': false,
        'message': 'Failed to create collaborative session',
      };
    }
  }

  /// Join collaborative session
  Future<Map<String, dynamic>> joinCollaborativeSession(String sessionId) async {
    try {
      final session = _collaborativeSessions.firstWhere(
        (s) => s['id'] == sessionId,
        orElse: () => {},
      );

      if (session.isEmpty) {
        return {
          'success': false,
          'message': 'Session not found',
        };
      }

      final currentUserId = await _getCurrentUserId();
      final participants = session['participants'] as List<dynamic>;

      if (participants.contains(currentUserId)) {
        return {
          'success': true,
          'message': 'Already in session',
        };
      }

      if (participants.length >= session['maxParticipants']) {
        return {
          'success': false,
          'message': 'Session is full',
        };
      }

      participants.add(currentUserId);
      await _saveCollaborativeSessions();

      return {
        'success': true,
        'message': 'Joined session successfully',
      };
    } catch (e) {
      Logger.error('Failed to join collaborative session', e);
      return {
        'success': false,
        'message': 'Failed to join session',
      };
    }
  }

  /// Update collaborative session code
  Future<Map<String, dynamic>> updateSessionCode(String sessionId, String newCode) async {
    try {
      final session = _collaborativeSessions.firstWhere(
        (s) => s['id'] == sessionId,
        orElse: () => {},
      );

      if (session.isEmpty) {
        return {
          'success': false,
          'message': 'Session not found',
        };
      }

      session['currentCode'] = newCode;
      await _saveCollaborativeSessions();

      return {
        'success': true,
        'message': 'Code updated successfully',
      };
    } catch (e) {
      Logger.error('Failed to update session code', e);
      return {
        'success': false,
        'message': 'Failed to update code',
      };
    }
  }

  /// Send message in collaborative session
  Future<Map<String, dynamic>> sendSessionMessage(String sessionId, String message) async {
    try {
      final session = _collaborativeSessions.firstWhere(
        (s) => s['id'] == sessionId,
        orElse: () => {},
      );

      if (session.isEmpty) {
        return {
          'success': false,
          'message': 'Session not found',
        };
      }

      final messageData = {
        'id': _generateId(),
        'authorId': await _getCurrentUserId(),
        'authorName': await _getCurrentUserName(),
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final messages = session['messages'] as List<dynamic>;
      messages.add(messageData);
      await _saveCollaborativeSessions();

      return {
        'success': true,
        'messageId': messageData['id'],
        'message': 'Message sent successfully',
      };
    } catch (e) {
      Logger.error('Failed to send session message', e);
      return {
        'success': false,
        'message': 'Failed to send message',
      };
    }
  }

  /// Get collaborative sessions
  List<Map<String, dynamic>> getCollaborativeSessions({
    bool? isActive,
    int limit = 20,
  }) {
    var sessions = List<Map<String, dynamic>>.from(_collaborativeSessions);

    if (isActive != null) {
      sessions = sessions.where((session) => session['isActive'] == isActive).toList();
    }

    // Sort by creation date (newest first)
    sessions.sort((a, b) => (b['createdAt'] as String).compareTo(a['createdAt'] as String));

    return sessions.take(limit).toList();
  }

  /// Create learning group
  Future<Map<String, dynamic>> createLearningGroup({
    required String name,
    required String description,
    String? topic,
    int maxMembers = 50,
    bool isPublic = true,
  }) async {
    try {
      final group = {
        'id': _generateId(),
        'name': name,
        'description': description,
        'topic': topic,
        'maxMembers': maxMembers,
        'isPublic': isPublic,
        'creatorId': await _getCurrentUserId(),
        'creatorName': await _getCurrentUserName(),
        'createdAt': DateTime.now().toIso8601String(),
        'members': [await _getCurrentUserId()],
        'posts': [],
        'events': [],
      };

      _learningGroups.add(group);
      await _saveLearningGroups();

      Logger.info('Learning group created: ${group['id']}');
      return {
        'success': true,
        'groupId': group['id'],
        'message': 'Learning group created successfully',
      };
    } catch (e) {
      Logger.error('Failed to create learning group', e);
      return {
        'success': false,
        'message': 'Failed to create learning group',
      };
    }
  }

  /// Join learning group
  Future<Map<String, dynamic>> joinLearningGroup(String groupId) async {
    try {
      final group = _learningGroups.firstWhere(
        (g) => g['id'] == groupId,
        orElse: () => {},
      );

      if (group.isEmpty) {
        return {
          'success': false,
          'message': 'Group not found',
        };
      }

      final currentUserId = await _getCurrentUserId();
      final members = group['members'] as List<dynamic>;

      if (members.contains(currentUserId)) {
        return {
          'success': true,
          'message': 'Already in group',
        };
      }

      if (members.length >= group['maxMembers']) {
        return {
          'success': false,
          'message': 'Group is full',
        };
      }

      members.add(currentUserId);
      await _saveLearningGroups();

      return {
        'success': true,
        'message': 'Joined group successfully',
      };
    } catch (e) {
      Logger.error('Failed to join learning group', e);
      return {
        'success': false,
        'message': 'Failed to join group',
      };
    }
  }

  /// Get learning groups
  List<Map<String, dynamic>> getLearningGroups({
    String? topic,
    int limit = 20,
  }) {
    var groups = List<Map<String, dynamic>>.from(_learningGroups);

    if (topic != null) {
      groups = groups.where((group) => group['topic'] == topic).toList();
    }

    // Sort by creation date (newest first)
    groups.sort((a, b) => (b['createdAt'] as String).compareTo(a['createdAt'] as String));

    return groups.take(limit).toList();
  }

  /// Get user profile
  Map<String, dynamic> getUserProfile(String userId) {
    try {
      return _userProfiles.firstWhere((profile) => profile['id'] == userId);
    } catch (e) {
      Logger.error('User profile not found: $userId', e);
      return {};
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    String? name,
    String? bio,
    String? avatar,
    List<String>? skills,
    List<String>? interests,
  }) async {
    try {
      final profile = getUserProfile(userId);
      if (profile.isEmpty) {
        // Create new profile
        final newProfile = {
          'id': userId,
          'name': name ?? 'Anonymous',
          'bio': bio ?? '',
          'avatar': avatar,
          'skills': skills ?? [],
          'interests': interests ?? [],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };
        _userProfiles.add(newProfile);
      } else {
        // Update existing profile
        if (name != null) profile['name'] = name;
        if (bio != null) profile['bio'] = bio;
        if (avatar != null) profile['avatar'] = avatar;
        if (skills != null) profile['skills'] = skills;
        if (interests != null) profile['interests'] = interests;
        profile['updatedAt'] = DateTime.now().toIso8601String();
      }

      await _saveUserProfiles();

      return {
        'success': true,
        'message': 'Profile updated successfully',
      };
    } catch (e) {
      Logger.error('Failed to update user profile', e);
      return {
        'success': false,
        'message': 'Failed to update profile',
      };
    }
  }

  /// Save shared code snippets
  Future<void> _saveSharedCodeSnippets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sharedCodeSnippets', jsonEncode(_sharedCodeSnippets));
    } catch (e) {
      Logger.error('Failed to save shared code snippets', e);
    }
  }

  /// Save collaborative sessions
  Future<void> _saveCollaborativeSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('collaborativeSessions', jsonEncode(_collaborativeSessions));
    } catch (e) {
      Logger.error('Failed to save collaborative sessions', e);
    }
  }

  /// Save user profiles
  Future<void> _saveUserProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userProfiles', jsonEncode(_userProfiles));
    } catch (e) {
      Logger.error('Failed to save user profiles', e);
    }
  }

  /// Save learning groups
  Future<void> _saveLearningGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('learningGroups', jsonEncode(_learningGroups));
    } catch (e) {
      Logger.error('Failed to save learning groups', e);
    }
  }

  /// Save comments
  Future<void> _saveComments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('comments', jsonEncode(_comments));
    } catch (e) {
      Logger.error('Failed to save comments', e);
    }
  }

  /// Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           (1000 + (DateTime.now().microsecond % 9000)).toString();
  }

  /// Get current user ID
  Future<String> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userId') ?? 'anonymous_${_generateId()}';
    } catch (e) {
      return 'anonymous_${_generateId()}';
    }
  }

  /// Get current user name
  Future<String> _getCurrentUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userName') ?? 'Anonymous User';
    } catch (e) {
      return 'Anonymous User';
    }
  }
}