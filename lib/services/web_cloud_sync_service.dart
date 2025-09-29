import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Web Cloud Sync Service
/// 
/// Handles cloud synchronization for web platform,
/// including progress sync, code backup, and cross-device access
class WebCloudSyncService {
  static final WebCloudSyncService _instance = WebCloudSyncService._internal();
  factory WebCloudSyncService() => _instance;
  WebCloudSyncService._internal();

  bool _isInitialized = false;
  final String _storageKey = 'codelingo_cloud_sync';
  final String _apiBaseUrl = 'https://api.codelingo.app'; // Replace with actual API
  final Map<String, dynamic> _syncQueue = {};
  Timer? _syncTimer;
  bool _isOnline = true;

  /// Initialize web cloud sync service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _setupOnlineDetection();
      await _loadSyncQueue();
      await _startPeriodicSync();
      
      _isInitialized = true;
      Logger.info('Web cloud sync service initialized');
    } catch (e) {
      Logger.error('Failed to initialize web cloud sync service', e);
    }
  }

  /// Setup online/offline detection
  Future<void> _setupOnlineDetection() async {
    _isOnline = html.window.navigator.onLine ?? true;
    
    html.window.addEventListener('online', (event) {
      _isOnline = true;
      Logger.info('Connection restored, starting sync');
      _processSyncQueue();
    });
    
    html.window.addEventListener('offline', (event) {
      _isOnline = false;
      Logger.warning('Connection lost, queuing sync operations');
    });
  }

  /// Load sync queue from local storage
  Future<void> _loadSyncQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueData = prefs.getString('sync_queue');
      
      if (queueData != null) {
        final queue = jsonDecode(queueData) as Map<String, dynamic>;
        _syncQueue.addAll(queue);
        Logger.info('Loaded ${_syncQueue.length} queued sync operations');
      }
    } catch (e) {
      Logger.error('Failed to load sync queue', e);
    }
  }

  /// Start periodic sync
  Future<void> _startPeriodicSync() async {
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (_isOnline) {
        _processSyncQueue();
      }
    });
  }

  /// Sync user progress
  Future<Map<String, dynamic>> syncUserProgress(Map<String, dynamic> progressData) async {
    try {
      if (!_isOnline) {
        await _queueSyncOperation('user_progress', progressData);
        return {
          'success': true,
          'message': 'Progress queued for sync when online',
        };
      }

      final result = await _sendToCloud('sync/progress', progressData);
      
      if (result['success']) {
        await _clearSyncOperation('user_progress');
        Logger.info('User progress synced successfully');
      }
      
      return result;
    } catch (e) {
      Logger.error('Failed to sync user progress', e);
      await _queueSyncOperation('user_progress', progressData);
      return {
        'success': false,
        'message': 'Failed to sync progress, queued for retry',
      };
    }
  }

  /// Sync code snippets
  Future<Map<String, dynamic>> syncCodeSnippets(List<Map<String, dynamic>> snippets) async {
    try {
      if (!_isOnline) {
        await _queueSyncOperation('code_snippets', {'snippets': snippets});
        return {
          'success': true,
          'message': 'Code snippets queued for sync when online',
        };
      }

      final result = await _sendToCloud('sync/snippets', {'snippets': snippets});
      
      if (result['success']) {
        await _clearSyncOperation('code_snippets');
        Logger.info('Code snippets synced successfully');
      }
      
      return result;
    } catch (e) {
      Logger.error('Failed to sync code snippets', e);
      await _queueSyncOperation('code_snippets', {'snippets': snippets});
      return {
        'success': false,
        'message': 'Failed to sync snippets, queued for retry',
      };
    }
  }

  /// Sync learning progress
  Future<Map<String, dynamic>> syncLearningProgress(Map<String, dynamic> learningData) async {
    try {
      if (!_isOnline) {
        await _queueSyncOperation('learning_progress', learningData);
        return {
          'success': true,
          'message': 'Learning progress queued for sync when online',
        };
      }

      final result = await _sendToCloud('sync/learning', learningData);
      
      if (result['success']) {
        await _clearSyncOperation('learning_progress');
        Logger.info('Learning progress synced successfully');
      }
      
      return result;
    } catch (e) {
      Logger.error('Failed to sync learning progress', e);
      await _queueSyncOperation('learning_progress', learningData);
      return {
        'success': false,
        'message': 'Failed to sync learning progress, queued for retry',
      };
    }
  }

  /// Backup code to cloud
  Future<Map<String, dynamic>> backupCode(String codeId, String code, Map<String, dynamic> metadata) async {
    try {
      if (!_isOnline) {
        await _queueSyncOperation('code_backup_$codeId', {
          'codeId': codeId,
          'code': code,
          'metadata': metadata,
        });
        return {
          'success': true,
          'message': 'Code backup queued for sync when online',
        };
      }

      final result = await _sendToCloud('backup/code', {
        'codeId': codeId,
        'code': code,
        'metadata': metadata,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      if (result['success']) {
        await _clearSyncOperation('code_backup_$codeId');
        Logger.info('Code backed up successfully: $codeId');
      }
      
      return result;
    } catch (e) {
      Logger.error('Failed to backup code: $codeId', e);
      await _queueSyncOperation('code_backup_$codeId', {
        'codeId': codeId,
        'code': code,
        'metadata': metadata,
      });
      return {
        'success': false,
        'message': 'Failed to backup code, queued for retry',
      };
    }
  }

  /// Restore code from cloud
  Future<Map<String, dynamic>> restoreCode(String codeId) async {
    try {
      if (!_isOnline) {
        return {
          'success': false,
          'message': 'Cannot restore code while offline',
        };
      }

      final result = await _getFromCloud('backup/code/$codeId');
      
      if (result['success']) {
        Logger.info('Code restored successfully: $codeId');
      }
      
      return result;
    } catch (e) {
      Logger.error('Failed to restore code: $codeId', e);
      return {
        'success': false,
        'message': 'Failed to restore code',
      };
    }
  }

  /// Get cloud backup list
  Future<List<Map<String, dynamic>>> getCloudBackups() async {
    try {
      if (!_isOnline) {
        return [];
      }

      final result = await _getFromCloud('backup/list');
      
      if (result['success']) {
        return List<Map<String, dynamic>>.from(result['data'] ?? []);
      }
      
      return [];
    } catch (e) {
      Logger.error('Failed to get cloud backups', e);
      return [];
    }
  }

  /// Sync settings
  Future<Map<String, dynamic>> syncSettings(Map<String, dynamic> settings) async {
    try {
      if (!_isOnline) {
        await _queueSyncOperation('settings', settings);
        return {
          'success': true,
          'message': 'Settings queued for sync when online',
        };
      }

      final result = await _sendToCloud('sync/settings', settings);
      
      if (result['success']) {
        await _clearSyncOperation('settings');
        Logger.info('Settings synced successfully');
      }
      
      return result;
    } catch (e) {
      Logger.error('Failed to sync settings', e);
      await _queueSyncOperation('settings', settings);
      return {
        'success': false,
        'message': 'Failed to sync settings, queued for retry',
      };
    }
  }

  /// Get cloud data
  Future<Map<String, dynamic>> getCloudData(String endpoint) async {
    try {
      if (!_isOnline) {
        return {
          'success': false,
          'message': 'Cannot fetch data while offline',
        };
      }

      return await _getFromCloud(endpoint);
    } catch (e) {
      Logger.error('Failed to get cloud data from $endpoint', e);
      return {
        'success': false,
        'message': 'Failed to fetch data',
      };
    }
  }

  /// Send data to cloud
  Future<Map<String, dynamic>> _sendToCloud(String endpoint, Map<String, dynamic> data) async {
    try {
      // This is a simplified implementation
      // In a real app, you would use proper HTTP client with authentication
      
      final url = '$_apiBaseUrl/$endpoint';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getAuthToken()}',
      };
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real implementation, this would make an actual HTTP request
      Logger.info('Data sent to cloud: $endpoint');
      
      return {
        'success': true,
        'message': 'Data synced successfully',
        'data': data,
      };
    } catch (e) {
      Logger.error('Failed to send data to cloud: $endpoint', e);
      return {
        'success': false,
        'message': 'Failed to sync data',
      };
    }
  }

  /// Get data from cloud
  Future<Map<String, dynamic>> _getFromCloud(String endpoint) async {
    try {
      // This is a simplified implementation
      // In a real app, you would use proper HTTP client with authentication
      
      final url = '$_apiBaseUrl/$endpoint';
      final headers = {
        'Authorization': 'Bearer ${await _getAuthToken()}',
      };
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real implementation, this would make an actual HTTP request
      Logger.info('Data fetched from cloud: $endpoint');
      
      return {
        'success': true,
        'data': {},
      };
    } catch (e) {
      Logger.error('Failed to get data from cloud: $endpoint', e);
      return {
        'success': false,
        'message': 'Failed to fetch data',
      };
    }
  }

  /// Get authentication token
  Future<String> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token') ?? '';
    } catch (e) {
      Logger.error('Failed to get auth token', e);
      return '';
    }
  }

  /// Queue sync operation
  Future<void> _queueSyncOperation(String key, Map<String, dynamic> data) async {
    try {
      _syncQueue[key] = {
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
        'retryCount': (_syncQueue[key]?['retryCount'] ?? 0) + 1,
      };
      
      await _saveSyncQueue();
      Logger.info('Sync operation queued: $key');
    } catch (e) {
      Logger.error('Failed to queue sync operation: $key', e);
    }
  }

  /// Clear sync operation
  Future<void> _clearSyncOperation(String key) async {
    try {
      _syncQueue.remove(key);
      await _saveSyncQueue();
      Logger.info('Sync operation cleared: $key');
    } catch (e) {
      Logger.error('Failed to clear sync operation: $key', e);
    }
  }

  /// Process sync queue
  Future<void> _processSyncQueue() async {
    if (!_isOnline || _syncQueue.isEmpty) return;

    try {
      Logger.info('Processing ${_syncQueue.length} queued sync operations');
      
      for (final entry in _syncQueue.entries) {
        final key = entry.key;
        final operation = entry.value as Map<String, dynamic>;
        final data = operation['data'] as Map<String, dynamic>;
        final retryCount = operation['retryCount'] as int;
        
        // Skip operations that have been retried too many times
        if (retryCount > 5) {
          Logger.warning('Skipping operation with too many retries: $key');
          _syncQueue.remove(key);
          continue;
        }
        
        // Process different types of operations
        Map<String, dynamic> result;
        if (key.startsWith('user_progress')) {
          result = await syncUserProgress(data);
        } else if (key.startsWith('code_snippets')) {
          result = await syncCodeSnippets(data['snippets'] as List<Map<String, dynamic>>);
        } else if (key.startsWith('learning_progress')) {
          result = await syncLearningProgress(data);
        } else if (key.startsWith('code_backup_')) {
          result = await backupCode(data['codeId'], data['code'], data['metadata']);
        } else if (key == 'settings') {
          result = await syncSettings(data);
        } else {
          Logger.warning('Unknown sync operation type: $key');
          continue;
        }
        
        if (result['success']) {
          _syncQueue.remove(key);
        } else {
          // Update retry count
          operation['retryCount'] = retryCount + 1;
        }
      }
      
      await _saveSyncQueue();
      Logger.info('Sync queue processing completed');
    } catch (e) {
      Logger.error('Failed to process sync queue', e);
    }
  }

  /// Save sync queue
  Future<void> _saveSyncQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sync_queue', jsonEncode(_syncQueue));
    } catch (e) {
      Logger.error('Failed to save sync queue', e);
    }
  }

  /// Force sync all data
  Future<Map<String, dynamic>> forceSyncAll() async {
    try {
      if (!_isOnline) {
        return {
          'success': false,
          'message': 'Cannot sync while offline',
        };
      }

      await _processSyncQueue();
      
      return {
        'success': true,
        'message': 'All data synced successfully',
      };
    } catch (e) {
      Logger.error('Failed to force sync all data', e);
      return {
        'success': false,
        'message': 'Failed to sync all data',
      };
    }
  }

  /// Get sync status
  Map<String, dynamic> getSyncStatus() {
    return {
      'isOnline': _isOnline,
      'queuedOperations': _syncQueue.length,
      'lastSync': _getLastSyncTime(),
    };
  }

  /// Get last sync time
  String? _getLastSyncTime() {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('last_sync_time');
    } catch (e) {
      return null;
    }
  }

  /// Update last sync time
  Future<void> _updateLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_sync_time', DateTime.now().toIso8601String());
    } catch (e) {
      Logger.error('Failed to update last sync time', e);
    }
  }

  /// Clear all cloud data
  Future<Map<String, dynamic>> clearCloudData() async {
    try {
      if (!_isOnline) {
        return {
          'success': false,
          'message': 'Cannot clear data while offline',
        };
      }

      final result = await _sendToCloud('clear/all', {});
      
      if (result['success']) {
        _syncQueue.clear();
        await _saveSyncQueue();
        Logger.info('All cloud data cleared');
      }
      
      return result;
    } catch (e) {
      Logger.error('Failed to clear cloud data', e);
      return {
        'success': false,
        'message': 'Failed to clear cloud data',
      };
    }
  }

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
}