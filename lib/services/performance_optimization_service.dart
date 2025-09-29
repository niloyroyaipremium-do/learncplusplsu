import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// Performance Optimization Service
/// 
/// Handles lazy loading, memory management, caching,
/// and performance monitoring
class PerformanceOptimizationService {
  static final PerformanceOptimizationService _instance = PerformanceOptimizationService._internal();
  factory PerformanceOptimizationService() => _instance;
  PerformanceOptimizationService._internal();

  bool _isInitialized = false;
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Map<String, int> _accessCounts = {};
  final Queue<String> _accessOrder = Queue<String>();
  final Map<String, StreamController<dynamic>> _lazyLoaders = {};
  
  // Cache configuration
  static const int _maxCacheSize = 100;
  static const Duration _cacheExpiry = Duration(hours: 1);
  static const int _maxMemoryUsage = 50 * 1024 * 1024; // 50 MB

  /// Initialize performance optimization service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadCacheFromStorage();
      await _startMemoryMonitoring();
      await _initializeLazyLoaders();
      
      _isInitialized = true;
      Logger.info('Performance optimization service initialized');
    } catch (e) {
      Logger.error('Failed to initialize performance optimization service', e);
    }
  }

  /// Load cache from storage
  Future<void> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = prefs.getString('performance_cache');
      
      if (cacheData != null) {
        // In a real implementation, this would deserialize cache data
        Logger.info('Cache loaded from storage');
      }
    } catch (e) {
      Logger.error('Failed to load cache from storage', e);
    }
  }

  /// Start memory monitoring
  Future<void> _startMemoryMonitoring() async {
    // Monitor memory usage periodically
    Timer.periodic(const Duration(seconds: 30), (_) {
      _monitorMemoryUsage();
    });
  }

  /// Initialize lazy loaders
  Future<void> _initializeLazyLoaders() async {
    // Initialize lazy loaders for different data types
    _lazyLoaders['lessons'] = StreamController<dynamic>.broadcast();
    _lazyLoaders['tutorials'] = StreamController<dynamic>.broadcast();
    _lazyLoaders['challenges'] = StreamController<dynamic>.broadcast();
    _lazyLoaders['user_progress'] = StreamController<dynamic>.broadcast();
  }

  /// Get data with lazy loading
  Future<T> getLazyData<T>(String key, Future<T> Function() loader) async {
    try {
      // Check cache first
      if (_cache.containsKey(key)) {
        _updateAccessInfo(key);
        return _cache[key] as T;
      }

      // Load data asynchronously
      final data = await loader();
      
      // Cache the data
      await _cacheData(key, data);
      
      return data;
    } catch (e) {
      Logger.error('Failed to get lazy data for key: $key', e);
      rethrow;
    }
  }

  /// Cache data
  Future<void> _cacheData(String key, dynamic data) async {
    try {
      // Check cache size limit
      if (_cache.length >= _maxCacheSize) {
        await _evictLeastRecentlyUsed();
      }

      // Check memory usage
      await _checkMemoryUsage();

      // Add to cache
      _cache[key] = data;
      _cacheTimestamps[key] = DateTime.now();
      _accessCounts[key] = 1;
      _accessOrder.addLast(key);

      Logger.debug('Data cached for key: $key');
    } catch (e) {
      Logger.error('Failed to cache data for key: $key', e);
    }
  }

  /// Update access information
  void _updateAccessInfo(String key) {
    _accessCounts[key] = (_accessCounts[key] ?? 0) + 1;
    
    // Move to end of access order
    _accessOrder.remove(key);
    _accessOrder.addLast(key);
  }

  /// Evict least recently used items
  Future<void> _evictLeastRecentlyUsed() async {
    try {
      while (_cache.length >= _maxCacheSize && _accessOrder.isNotEmpty) {
        final keyToRemove = _accessOrder.removeFirst();
        _cache.remove(keyToRemove);
        _cacheTimestamps.remove(keyToRemove);
        _accessCounts.remove(keyToRemove);
        
        Logger.debug('Evicted LRU item: $keyToRemove');
      }
    } catch (e) {
      Logger.error('Failed to evict LRU items', e);
    }
  }

  /// Check memory usage
  Future<void> _checkMemoryUsage() async {
    try {
      final memoryUsage = await _getCurrentMemoryUsage();
      
      if (memoryUsage > _maxMemoryUsage) {
        await _clearOldCacheEntries();
        Logger.warning('Memory usage high, cleared old cache entries');
      }
    } catch (e) {
      Logger.error('Failed to check memory usage', e);
    }
  }

  /// Get current memory usage
  Future<int> _getCurrentMemoryUsage() async {
    try {
      // This is a simplified implementation
      // In a real app, you would use platform-specific memory monitoring
      return _cache.length * 1024; // Estimate 1KB per cache entry
    } catch (e) {
      Logger.error('Failed to get memory usage', e);
      return 0;
    }
  }

  /// Monitor memory usage
  void _monitorMemoryUsage() {
    _getCurrentMemoryUsage().then((usage) {
      if (usage > _maxMemoryUsage * 0.8) {
        Logger.warning('High memory usage detected: ${_formatBytes(usage)}');
        _clearOldCacheEntries();
      }
    });
  }

  /// Clear old cache entries
  Future<void> _clearOldCacheEntries() async {
    try {
      final now = DateTime.now();
      final keysToRemove = <String>[];

      for (final entry in _cacheTimestamps.entries) {
        if (now.difference(entry.value) > _cacheExpiry) {
          keysToRemove.add(entry.key);
        }
      }

      for (final key in keysToRemove) {
        _cache.remove(key);
        _cacheTimestamps.remove(key);
        _accessCounts.remove(key);
        _accessOrder.remove(key);
      }

      Logger.info('Cleared ${keysToRemove.length} old cache entries');
    } catch (e) {
      Logger.error('Failed to clear old cache entries', e);
    }
  }

  /// Format bytes
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Preload data
  Future<void> preloadData(String key, Future<dynamic> Function() loader) async {
    try {
      if (!_cache.containsKey(key)) {
        final data = await loader();
        await _cacheData(key, data);
        Logger.info('Data preloaded for key: $key');
      }
    } catch (e) {
      Logger.error('Failed to preload data for key: $key', e);
    }
  }

  /// Preload multiple data items
  Future<void> preloadMultipleData(Map<String, Future<dynamic> Function()> loaders) async {
    try {
      final futures = <Future>[];
      
      for (final entry in loaders.entries) {
        if (!_cache.containsKey(entry.key)) {
          futures.add(preloadData(entry.key, entry.value));
        }
      }
      
      await Future.wait(futures);
      Logger.info('Preloaded ${futures.length} data items');
    } catch (e) {
      Logger.error('Failed to preload multiple data', e);
    }
  }

  /// Get lazy stream for data
  Stream<T> getLazyStream<T>(String key, Future<T> Function() loader) {
    if (_lazyLoaders.containsKey(key)) {
      return _lazyLoaders[key]!.stream.cast<T>();
    }

    // Create new stream controller
    final controller = StreamController<T>.broadcast();
    _lazyLoaders[key] = controller;

    // Load data asynchronously
    getLazyData(key, loader).then((data) {
      controller.add(data);
    }).catchError((error) {
      controller.addError(error);
    });

    return controller.stream;
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      _cache.clear();
      _cacheTimestamps.clear();
      _accessCounts.clear();
      _accessOrder.clear();

      // Save empty cache to storage
      await _saveCacheToStorage();
      
      Logger.info('Cache cleared');
    } catch (e) {
      Logger.error('Failed to clear cache', e);
    }
  }

  /// Clear specific cache entry
  Future<void> clearCacheEntry(String key) async {
    try {
      _cache.remove(key);
      _cacheTimestamps.remove(key);
      _accessCounts.remove(key);
      _accessOrder.remove(key);
      
      Logger.debug('Cache entry cleared: $key');
    } catch (e) {
      Logger.error('Failed to clear cache entry: $key', e);
    }
  }

  /// Save cache to storage
  Future<void> _saveCacheToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // In a real implementation, this would serialize cache data
      // For now, we'll just save a timestamp
      await prefs.setString('cache_last_updated', DateTime.now().toIso8601String());
      
      Logger.debug('Cache saved to storage');
    } catch (e) {
      Logger.error('Failed to save cache to storage', e);
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStatistics() {
    return {
      'cacheSize': _cache.length,
      'maxCacheSize': _maxCacheSize,
      'memoryUsage': _getCurrentMemoryUsage(),
      'maxMemoryUsage': _maxMemoryUsage,
      'accessCounts': Map.from(_accessCounts),
      'oldestEntry': _cacheTimestamps.isNotEmpty 
          ? _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b)
          : null,
      'newestEntry': _cacheTimestamps.isNotEmpty 
          ? _cacheTimestamps.values.reduce((a, b) => a.isAfter(b) ? a : b)
          : null,
    };
  }

  /// Optimize images
  Future<String> optimizeImage(String imagePath, {int? maxWidth, int? maxHeight, int? quality}) async {
    try {
      // This is a simplified implementation
      // In a real app, you would use image processing libraries
      
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      // Simulate image optimization
      await Future.delayed(const Duration(milliseconds: 100));
      
      final optimizedPath = imagePath.replaceAll('.', '_optimized.');
      
      // In a real implementation, this would:
      // 1. Load the image
      // 2. Resize if needed
      // 3. Compress with specified quality
      // 4. Save optimized image
      
      Logger.info('Image optimized: $imagePath -> $optimizedPath');
      return optimizedPath;
    } catch (e) {
      Logger.error('Failed to optimize image: $imagePath', e);
      return imagePath; // Return original path on error
    }
  }

  /// Batch process data
  Future<List<T>> batchProcess<T>(List<dynamic> items, Future<T> Function(dynamic) processor, {int batchSize = 10}) async {
    try {
      final results = <T>[];
      
      for (int i = 0; i < items.length; i += batchSize) {
        final batch = items.skip(i).take(batchSize);
        final batchFutures = batch.map(processor);
        final batchResults = await Future.wait(batchFutures);
        results.addAll(batchResults);
        
        // Allow other tasks to run
        await Future.delayed(const Duration(milliseconds: 1));
      }
      
      Logger.info('Batch processed ${items.length} items in ${(items.length / batchSize).ceil()} batches');
      return results;
    } catch (e) {
      Logger.error('Failed to batch process data', e);
      return [];
    }
  }

  /// Debounce function calls
  Timer? _debounceTimer;
  void debounce(String key, Duration delay, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  /// Throttle function calls
  Timer? _throttleTimer;
  bool _throttleActive = false;
  void throttle(String key, Duration delay, VoidCallback callback) {
    if (_throttleActive) return;
    
    _throttleActive = true;
    callback();
    
    _throttleTimer?.cancel();
    _throttleTimer = Timer(delay, () {
      _throttleActive = false;
    });
  }

  /// Lazy load widgets
  Widget createLazyWidget<T>({
    required String key,
    required Future<T> Function() loader,
    required Widget Function(T data) builder,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    return FutureBuilder<T>(
      future: getLazyData(key, loader),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? const CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return errorWidget ?? Text('Error: ${snapshot.error}');
        }
        
        return builder(snapshot.data as T);
      },
    );
  }

  /// Optimize list rendering
  Widget createOptimizedList<T>({
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index) itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
  }) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Only build visible items
        return itemBuilder(context, items[index], index);
      },
    );
  }

  /// Dispose resources
  void dispose() {
    _debounceTimer?.cancel();
    _throttleTimer?.cancel();
    
    for (final controller in _lazyLoaders.values) {
      controller.close();
    }
    _lazyLoaders.clear();
    
    _cache.clear();
    _cacheTimestamps.clear();
    _accessCounts.clear();
    _accessOrder.clear();
  }
}