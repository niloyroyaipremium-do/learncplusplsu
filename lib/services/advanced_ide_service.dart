import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Advanced IDE Service
/// 
/// Handles file management, project structure, debugging tools,
/// and advanced IDE features
class AdvancedIDEService {
  static final AdvancedIDEService _instance = AdvancedIDEService._internal();
  factory AdvancedIDEService() => _instance;
  AdvancedIDEService._internal();

  bool _isInitialized = false;
  final Map<String, dynamic> _projects = {};
  final Map<String, List<Map<String, dynamic>>> _files = {};
  final Map<String, dynamic> _openFiles = {};
  final Map<String, dynamic> _breakpoints = {};
  final Map<String, dynamic> _watchExpressions = {};
  String? _currentProjectId;

  /// Initialize advanced IDE service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadProjects();
      await _loadOpenFiles();
      await _loadBreakpoints();
      await _loadWatchExpressions();
      
      _isInitialized = true;
      Logger.info('Advanced IDE service initialized');
    } catch (e) {
      Logger.error('Failed to initialize advanced IDE service', e);
    }
  }

  /// Load projects from storage
  Future<void> _loadProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsData = prefs.getString('ide_projects');
      
      if (projectsData != null) {
        final projects = jsonDecode(projectsData) as Map<String, dynamic>;
        _projects.addAll(projects);
      }
    } catch (e) {
      Logger.error('Failed to load projects', e);
    }
  }

  /// Load open files from storage
  Future<void> _loadOpenFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final openFilesData = prefs.getString('ide_open_files');
      
      if (openFilesData != null) {
        final openFiles = jsonDecode(openFilesData) as Map<String, dynamic>;
        _openFiles.addAll(openFiles);
      }
    } catch (e) {
      Logger.error('Failed to load open files', e);
    }
  }

  /// Load breakpoints from storage
  Future<void> _loadBreakpoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final breakpointsData = prefs.getString('ide_breakpoints');
      
      if (breakpointsData != null) {
        final breakpoints = jsonDecode(breakpointsData) as Map<String, dynamic>;
        _breakpoints.addAll(breakpoints);
      }
    } catch (e) {
      Logger.error('Failed to load breakpoints', e);
    }
  }

  /// Load watch expressions from storage
  Future<void> _loadWatchExpressions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final watchExpressionsData = prefs.getString('ide_watch_expressions');
      
      if (watchExpressionsData != null) {
        final watchExpressions = jsonDecode(watchExpressionsData) as Map<String, dynamic>;
        _watchExpressions.addAll(watchExpressions);
      }
    } catch (e) {
      Logger.error('Failed to load watch expressions', e);
    }
  }

  /// Create new project
  Future<Map<String, dynamic>> createProject({
    required String name,
    String? description,
    String? template,
  }) async {
    try {
      final projectId = _generateId();
      final project = {
        'id': projectId,
        'name': name,
        'description': description ?? '',
        'template': template ?? 'console',
        'createdAt': DateTime.now().toIso8601String(),
        'lastModified': DateTime.now().toIso8601String(),
        'files': <String>[],
        'settings': {
          'compiler': 'g++',
          'std': 'c++17',
          'warnings': true,
          'optimization': 'none',
        },
        'buildConfig': {
          'outputDir': 'build',
          'includeDirs': <String>[],
          'libDirs': <String>[],
          'defines': <String>[],
        },
      };

      _projects[projectId] = project;
      _files[projectId] = [];
      await _saveProjects();

      Logger.info('Project created: $name ($projectId)');
      return {
        'success': true,
        'projectId': projectId,
        'message': 'Project created successfully',
      };
    } catch (e) {
      Logger.error('Failed to create project', e);
      return {
        'success': false,
        'message': 'Failed to create project',
      };
    }
  }

  /// Open project
  Future<Map<String, dynamic>> openProject(String projectId) async {
    try {
      if (!_projects.containsKey(projectId)) {
        return {
          'success': false,
          'message': 'Project not found',
        };
      }

      _currentProjectId = projectId;
      await _loadProjectFiles(projectId);

      Logger.info('Project opened: $projectId');
      return {
        'success': true,
        'message': 'Project opened successfully',
        'project': _projects[projectId],
      };
    } catch (e) {
      Logger.error('Failed to open project', e);
      return {
        'success': false,
        'message': 'Failed to open project',
      };
    }
  }

  /// Load project files
  Future<void> _loadProjectFiles(String projectId) async {
    try {
      final project = _projects[projectId];
      if (project == null) return;

      final files = project['files'] as List<dynamic>;
      _files[projectId] = files.cast<Map<String, dynamic>>();
    } catch (e) {
      Logger.error('Failed to load project files', e);
    }
  }

  /// Create new file
  Future<Map<String, dynamic>> createFile({
    required String fileName,
    String? content,
    String? fileType,
  }) async {
    try {
      if (_currentProjectId == null) {
        return {
          'success': false,
          'message': 'No project open',
        };
      }

      final fileId = _generateId();
      final file = {
        'id': fileId,
        'name': fileName,
        'type': fileType ?? _getFileType(fileName),
        'content': content ?? '',
        'createdAt': DateTime.now().toIso8601String(),
        'lastModified': DateTime.now().toIso8601String(),
        'isOpen': false,
        'cursorPosition': 0,
        'selectionStart': 0,
        'selectionEnd': 0,
      };

      _files[_currentProjectId!]!.add(file);
      _projects[_currentProjectId!]!['files'].add(fileId);
      _projects[_currentProjectId!]!['lastModified'] = DateTime.now().toIso8601String();

      await _saveProjects();
      await _saveProjectFiles(_currentProjectId!);

      Logger.info('File created: $fileName');
      return {
        'success': true,
        'fileId': fileId,
        'message': 'File created successfully',
      };
    } catch (e) {
      Logger.error('Failed to create file', e);
      return {
        'success': false,
        'message': 'Failed to create file',
      };
    }
  }

  /// Open file
  Future<Map<String, dynamic>> openFile(String fileId) async {
    try {
      if (_currentProjectId == null) {
        return {
          'success': false,
          'message': 'No project open',
        };
      }

      final file = _files[_currentProjectId!]?.firstWhere(
        (f) => f['id'] == fileId,
        orElse: () => {},
      );

      if (file.isEmpty) {
        return {
          'success': false,
          'message': 'File not found',
        };
      }

      file['isOpen'] = true;
      _openFiles[fileId] = {
        'projectId': _currentProjectId,
        'fileId': fileId,
        'openedAt': DateTime.now().toIso8601String(),
      };

      await _saveOpenFiles();

      Logger.info('File opened: ${file['name']}');
      return {
        'success': true,
        'message': 'File opened successfully',
        'file': file,
      };
    } catch (e) {
      Logger.error('Failed to open file', e);
      return {
        'success': false,
        'message': 'Failed to open file',
      };
    }
  }

  /// Close file
  Future<Map<String, dynamic>> closeFile(String fileId) async {
    try {
      if (_currentProjectId == null) {
        return {
          'success': false,
          'message': 'No project open',
        };
      }

      final file = _files[_currentProjectId!]?.firstWhere(
        (f) => f['id'] == fileId,
        orElse: () => {},
      );

      if (file.isEmpty) {
        return {
          'success': false,
          'message': 'File not found',
        };
      }

      file['isOpen'] = false;
      _openFiles.remove(fileId);

      await _saveOpenFiles();

      Logger.info('File closed: ${file['name']}');
      return {
        'success': true,
        'message': 'File closed successfully',
      };
    } catch (e) {
      Logger.error('Failed to close file', e);
      return {
        'success': false,
        'message': 'Failed to close file',
      };
    }
  }

  /// Save file
  Future<Map<String, dynamic>> saveFile(String fileId, String content) async {
    try {
      if (_currentProjectId == null) {
        return {
          'success': false,
          'message': 'No project open',
        };
      }

      final file = _files[_currentProjectId!]?.firstWhere(
        (f) => f['id'] == fileId,
        orElse: () => {},
      );

      if (file.isEmpty) {
        return {
          'success': false,
          'message': 'File not found',
        };
      }

      file['content'] = content;
      file['lastModified'] = DateTime.now().toIso8601String();
      _projects[_currentProjectId!]!['lastModified'] = DateTime.now().toIso8601String();

      await _saveProjects();
      await _saveProjectFiles(_currentProjectId!);

      Logger.info('File saved: ${file['name']}');
      return {
        'success': true,
        'message': 'File saved successfully',
      };
    } catch (e) {
      Logger.error('Failed to save file', e);
      return {
        'success': false,
        'message': 'Failed to save file',
      };
    }
  }

  /// Delete file
  Future<Map<String, dynamic>> deleteFile(String fileId) async {
    try {
      if (_currentProjectId == null) {
        return {
          'success': false,
          'message': 'No project open',
        };
      }

      final fileIndex = _files[_currentProjectId!]?.indexWhere(
        (f) => f['id'] == fileId,
      );

      if (fileIndex == null || fileIndex == -1) {
        return {
          'success': false,
          'message': 'File not found',
        };
      }

      final file = _files[_currentProjectId!]![fileIndex];
      _files[_currentProjectId!]!.removeAt(fileIndex);
      _projects[_currentProjectId!]!['files'].remove(fileId);
      _openFiles.remove(fileId);
      _breakpoints.remove(fileId);

      await _saveProjects();
      await _saveProjectFiles(_currentProjectId!);
      await _saveOpenFiles();
      await _saveBreakpoints();

      Logger.info('File deleted: ${file['name']}');
      return {
        'success': true,
        'message': 'File deleted successfully',
      };
    } catch (e) {
      Logger.error('Failed to delete file', e);
      return {
        'success': false,
        'message': 'Failed to delete file',
      };
    }
  }

  /// Get file type from extension
  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'cpp':
      case 'cc':
      case 'cxx':
        return 'cpp';
      case 'h':
      case 'hpp':
      case 'hxx':
        return 'header';
      case 'c':
        return 'c';
      case 'txt':
        return 'text';
      case 'md':
        return 'markdown';
      case 'json':
        return 'json';
      case 'xml':
        return 'xml';
      case 'yaml':
      case 'yml':
        return 'yaml';
      default:
        return 'text';
    }
  }

  /// Add breakpoint
  Future<Map<String, dynamic>> addBreakpoint(String fileId, int lineNumber) async {
    try {
      if (!_breakpoints.containsKey(fileId)) {
        _breakpoints[fileId] = [];
      }

      final breakpoint = {
        'id': _generateId(),
        'fileId': fileId,
        'lineNumber': lineNumber,
        'enabled': true,
        'condition': '',
        'hitCount': 0,
        'createdAt': DateTime.now().toIso8601String(),
      };

      _breakpoints[fileId]!.add(breakpoint);
      await _saveBreakpoints();

      Logger.info('Breakpoint added: $fileId:$lineNumber');
      return {
        'success': true,
        'breakpointId': breakpoint['id'],
        'message': 'Breakpoint added successfully',
      };
    } catch (e) {
      Logger.error('Failed to add breakpoint', e);
      return {
        'success': false,
        'message': 'Failed to add breakpoint',
      };
    }
  }

  /// Remove breakpoint
  Future<Map<String, dynamic>> removeBreakpoint(String breakpointId) async {
    try {
      for (final fileBreakpoints in _breakpoints.values) {
        fileBreakpoints.removeWhere((bp) => bp['id'] == breakpointId);
      }

      await _saveBreakpoints();

      Logger.info('Breakpoint removed: $breakpointId');
      return {
        'success': true,
        'message': 'Breakpoint removed successfully',
      };
    } catch (e) {
      Logger.error('Failed to remove breakpoint', e);
      return {
        'success': false,
        'message': 'Failed to remove breakpoint',
      };
    }
  }

  /// Add watch expression
  Future<Map<String, dynamic>> addWatchExpression(String expression) async {
    try {
      final watchId = _generateId();
      final watch = {
        'id': watchId,
        'expression': expression,
        'value': '',
        'type': '',
        'enabled': true,
        'createdAt': DateTime.now().toIso8601String(),
      };

      _watchExpressions[watchId] = watch;
      await _saveWatchExpressions();

      Logger.info('Watch expression added: $expression');
      return {
        'success': true,
        'watchId': watchId,
        'message': 'Watch expression added successfully',
      };
    } catch (e) {
      Logger.error('Failed to add watch expression', e);
      return {
        'success': false,
        'message': 'Failed to add watch expression',
      };
    }
  }

  /// Remove watch expression
  Future<Map<String, dynamic>> removeWatchExpression(String watchId) async {
    try {
      _watchExpressions.remove(watchId);
      await _saveWatchExpressions();

      Logger.info('Watch expression removed: $watchId');
      return {
        'success': true,
        'message': 'Watch expression removed successfully',
      };
    } catch (e) {
      Logger.error('Failed to remove watch expression', e);
      return {
        'success': false,
        'message': 'Failed to remove watch expression',
      };
    }
  }

  /// Build project
  Future<Map<String, dynamic>> buildProject() async {
    try {
      if (_currentProjectId == null) {
        return {
          'success': false,
          'message': 'No project open',
        };
      }

      final project = _projects[_currentProjectId!];
      final settings = project['settings'] as Map<String, dynamic>;
      final buildConfig = project['buildConfig'] as Map<String, dynamic>;

      // Simulate build process
      await Future.delayed(const Duration(seconds: 2));

      Logger.info('Project built: $_currentProjectId');
      return {
        'success': true,
        'message': 'Project built successfully',
        'output': 'Build completed successfully',
      };
    } catch (e) {
      Logger.error('Failed to build project', e);
      return {
        'success': false,
        'message': 'Build failed: ${e.toString()}',
      };
    }
  }

  /// Run project
  Future<Map<String, dynamic>> runProject() async {
    try {
      if (_currentProjectId == null) {
        return {
          'success': false,
          'message': 'No project open',
        };
      }

      // Simulate run process
      await Future.delayed(const Duration(seconds: 1));

      Logger.info('Project run: $_currentProjectId');
      return {
        'success': true,
        'message': 'Project run successfully',
        'output': 'Hello, World!\nProgram executed successfully.',
      };
    } catch (e) {
      Logger.error('Failed to run project', e);
      return {
        'success': false,
        'message': 'Run failed: ${e.toString()}',
      };
    }
  }

  /// Debug project
  Future<Map<String, dynamic>> debugProject() async {
    try {
      if (_currentProjectId == null) {
        return {
          'success': false,
          'message': 'No project open',
        };
      }

      // Simulate debug process
      await Future.delayed(const Duration(seconds: 1));

      Logger.info('Project debug: $_currentProjectId');
      return {
        'success': true,
        'message': 'Debug session started',
        'sessionId': _generateId(),
      };
    } catch (e) {
      Logger.error('Failed to debug project', e);
      return {
        'success': false,
        'message': 'Debug failed: ${e.toString()}',
      };
    }
  }

  /// Get all projects
  List<Map<String, dynamic>> getAllProjects() {
    return _projects.values.toList();
  }

  /// Get current project
  Map<String, dynamic>? getCurrentProject() {
    if (_currentProjectId == null) return null;
    return _projects[_currentProjectId];
  }

  /// Get project files
  List<Map<String, dynamic>> getProjectFiles(String projectId) {
    return _files[projectId] ?? [];
  }

  /// Get open files
  List<Map<String, dynamic>> getOpenFiles() {
    return _openFiles.values.toList();
  }

  /// Get breakpoints for file
  List<Map<String, dynamic>> getBreakpoints(String fileId) {
    return _breakpoints[fileId] ?? [];
  }

  /// Get all watch expressions
  List<Map<String, dynamic>> getWatchExpressions() {
    return _watchExpressions.values.toList();
  }

  /// Save projects
  Future<void> _saveProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ide_projects', jsonEncode(_projects));
    } catch (e) {
      Logger.error('Failed to save projects', e);
    }
  }

  /// Save project files
  Future<void> _saveProjectFiles(String projectId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'ide_project_files_$projectId';
      await prefs.setString(key, jsonEncode(_files[projectId] ?? []));
    } catch (e) {
      Logger.error('Failed to save project files', e);
    }
  }

  /// Save open files
  Future<void> _saveOpenFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ide_open_files', jsonEncode(_openFiles));
    } catch (e) {
      Logger.error('Failed to save open files', e);
    }
  }

  /// Save breakpoints
  Future<void> _saveBreakpoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ide_breakpoints', jsonEncode(_breakpoints));
    } catch (e) {
      Logger.error('Failed to save breakpoints', e);
    }
  }

  /// Save watch expressions
  Future<void> _saveWatchExpressions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ide_watch_expressions', jsonEncode(_watchExpressions));
    } catch (e) {
      Logger.error('Failed to save watch expressions', e);
    }
  }

  /// Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           (1000 + (DateTime.now().microsecond % 9000)).toString();
  }

  /// Dispose resources
  void dispose() {
    _projects.clear();
    _files.clear();
    _openFiles.clear();
    _breakpoints.clear();
    _watchExpressions.clear();
    _currentProjectId = null;
  }
}