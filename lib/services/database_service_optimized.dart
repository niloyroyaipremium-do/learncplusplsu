import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../utils/logger.dart';
import '../core/errors/app_exceptions.dart';

/// Optimized Database Service
///
/// This service provides high-performance database operations with:
/// - Connection pooling
/// - Query optimization
/// - Memory management
/// - Async operations
class DatabaseServiceOptimized {
  static DatabaseServiceOptimized? _instance;
  static DatabaseServiceOptimized get instance =>
      _instance ??= DatabaseServiceOptimized._();

  DatabaseServiceOptimized._();

  Database? _database;
  bool _isInitialized = false;
  final Completer<void> _initCompleter = Completer<void>();

  // Connection pool for better performance
  static const int _maxConnections = 5;
  final List<Database> _connectionPool = [];
  final Queue<Completer<Database>> _waitingConnections =
      Queue<Completer<Database>>();

  // Query cache for frequently used queries
  final Map<String, List<Map<String, dynamic>>> _queryCache = {};
  static const int _maxCacheSize = 100;
  static const Duration _cacheExpiry = Duration(minutes: 5);
  final Map<String, DateTime> _cacheTimestamps = {};

  /// Initialize the database service
  Future<void> initialize() async {
    if (_isInitialized) {
      await _initCompleter.future;
      return;
    }

    try {
      await _createDatabase();
      await _initializeConnectionPool();
      _isInitialized = true;
      _initCompleter.complete();
      Logger.info('Optimized database service initialized successfully');
    } catch (e) {
      _initCompleter.completeError(e);
      Logger.error('Failed to initialize database service', e);
      rethrow;
    }
  }

  /// Get database instance
  Future<Database> get database async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _getConnection();
  }

  /// Create database with optimized settings
  Future<void> _createDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'niloylearncplusplus_optimized.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  /// Configure database for optimal performance
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA journal_mode = WAL');
    await db.execute('PRAGMA synchronous = NORMAL');
    await db.execute('PRAGMA cache_size = 10000');
    await db.execute('PRAGMA temp_store = MEMORY');
    await db.execute('PRAGMA mmap_size = 268435456'); // 256MB
    await db.execute('PRAGMA optimize');
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await _createUserProfileTable(db);
    await _createLessonProgressTable(db);
    await _createQuizResultsTable(db);
    await _createCodeSnippetsTable(db);
    await _createPerformanceMetricsTable(db);

    // Create indexes for better performance
    await _createIndexes(db);
  }

  /// Upgrade database schema
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createPerformanceMetricsTable(db);
      await _createIndexes(db);
    }
  }

  /// Create user profile table
  Future<void> _createUserProfileTable(Database db) async {
    await db.execute('''
      CREATE TABLE user_profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT,
        level INTEGER NOT NULL DEFAULT 1,
        total_xp INTEGER NOT NULL DEFAULT 0,
        joined_date TEXT NOT NULL,
        current_streak INTEGER NOT NULL DEFAULT 0,
        longest_streak INTEGER NOT NULL DEFAULT 0,
        hearts INTEGER NOT NULL DEFAULT 5,
        lessons_completed INTEGER NOT NULL DEFAULT 0,
        quizzes_passed INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  /// Create lesson progress table
  Future<void> _createLessonProgressTable(Database db) async {
    await db.execute('''
      CREATE TABLE lesson_progress (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        lesson_id TEXT NOT NULL,
        is_completed BOOLEAN NOT NULL DEFAULT 0,
        completion_percentage REAL NOT NULL DEFAULT 0.0,
        time_spent INTEGER NOT NULL DEFAULT 0,
        last_accessed INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user_profiles (id),
        UNIQUE(user_id, lesson_id)
      )
    ''');
  }

  /// Create quiz results table
  Future<void> _createQuizResultsTable(Database db) async {
    await db.execute('''
      CREATE TABLE quiz_results (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        quiz_id TEXT NOT NULL,
        score REAL NOT NULL,
        total_questions INTEGER NOT NULL,
        correct_answers INTEGER NOT NULL,
        time_taken INTEGER NOT NULL,
        completed_at INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user_profiles (id)
      )
    ''');
  }

  /// Create code snippets table
  Future<void> _createCodeSnippetsTable(Database db) async {
    await db.execute('''
      CREATE TABLE code_snippets (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        code TEXT NOT NULL,
        language TEXT NOT NULL DEFAULT 'cpp',
        is_favorite BOOLEAN NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user_profiles (id)
      )
    ''');
  }

  /// Create performance metrics table
  Future<void> _createPerformanceMetricsTable(Database db) async {
    await db.execute('''
      CREATE TABLE performance_metrics (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        operation_type TEXT NOT NULL,
        execution_time REAL NOT NULL,
        memory_usage INTEGER NOT NULL,
        success BOOLEAN NOT NULL,
        error_message TEXT,
        metadata TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user_profiles (id)
      )
    ''');
  }

  /// Create database indexes for better performance
  Future<void> _createIndexes(Database db) async {
    await db.execute(
      'CREATE INDEX idx_user_profiles_email ON user_profiles(email)',
    );
    await db.execute(
      'CREATE INDEX idx_lesson_progress_user_id ON lesson_progress(user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_lesson_progress_lesson_id ON lesson_progress(lesson_id)',
    );
    await db.execute(
      'CREATE INDEX idx_quiz_results_user_id ON quiz_results(user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_quiz_results_quiz_id ON quiz_results(quiz_id)',
    );
    await db.execute(
      'CREATE INDEX idx_code_snippets_user_id ON code_snippets(user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_performance_metrics_user_id ON performance_metrics(user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_performance_metrics_operation_type ON performance_metrics(operation_type)',
    );
    await db.execute(
      'CREATE INDEX idx_performance_metrics_created_at ON performance_metrics(created_at)',
    );
  }

  /// Initialize connection pool
  Future<void> _initializeConnectionPool() async {
    for (int i = 0; i < _maxConnections; i++) {
      final db = await _createNewConnection();
      _connectionPool.add(db);
    }
  }

  /// Create new database connection
  Future<Database> _createNewConnection() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'niloylearncplusplus_optimized.db');

    return await openDatabase(path, version: 2, onConfigure: _onConfigure);
  }

  /// Get connection from pool
  Future<Database> _getConnection() async {
    if (_connectionPool.isNotEmpty) {
      return _connectionPool.removeLast();
    }

    // If no connections available, wait for one
    final completer = Completer<Database>();
    _waitingConnections.add(completer);
    return await completer.future;
  }

  /// Return connection to pool
  void _returnConnection(Database db) {
    if (_waitingConnections.isNotEmpty) {
      final completer = _waitingConnections.removeFirst();
      completer.complete(db);
    } else {
      _connectionPool.add(db);
    }
  }

  /// Execute query with caching
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
    bool useCache = true,
  }) async {
    final db = await database;

    try {
      final cacheKey = _generateCacheKey(
        table,
        distinct,
        columns,
        where,
        whereArgs,
        groupBy,
        having,
        orderBy,
        limit,
        offset,
      );

      if (useCache && _queryCache.containsKey(cacheKey)) {
        final timestamp = _cacheTimestamps[cacheKey]!;
        if (DateTime.now().difference(timestamp) < _cacheExpiry) {
          Logger.info('Using cached query result');
          return _queryCache[cacheKey]!;
        } else {
          _queryCache.remove(cacheKey);
          _cacheTimestamps.remove(cacheKey);
        }
      }

      final result = await db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      if (useCache && _queryCache.length < _maxCacheSize) {
        _queryCache[cacheKey] = result;
        _cacheTimestamps[cacheKey] = DateTime.now();
      }

      return result;
    } finally {
      _returnConnection(db);
    }
  }

  /// Insert data with optimization
  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await database;

    try {
      final result = await db.insert(
        table,
        values,
        nullColumnHack: nullColumnHack,
        conflictAlgorithm: conflictAlgorithm,
      );

      // Clear related cache entries
      _clearCacheForTable(table);

      return result;
    } finally {
      _returnConnection(db);
    }
  }

  /// Update data with optimization
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await database;

    try {
      final result = await db.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm,
      );

      // Clear related cache entries
      _clearCacheForTable(table);

      return result;
    } finally {
      _returnConnection(db);
    }
  }

  /// Delete data with optimization
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;

    try {
      final result = await db.delete(table, where: where, whereArgs: whereArgs);

      // Clear related cache entries
      _clearCacheForTable(table);

      return result;
    } finally {
      _returnConnection(db);
    }
  }

  /// Execute raw SQL with optimization
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;

    try {
      return await db.rawQuery(sql, arguments);
    } finally {
      _returnConnection(db);
    }
  }

  /// Execute raw SQL command
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    final db = await database;

    try {
      return await db.rawUpdate(sql, arguments);
    } finally {
      _returnConnection(db);
    }
  }

  /// Generate cache key for query
  String _generateCacheKey(
    String table,
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  ) {
    return '$table|${distinct ?? false}|${columns?.join(',') ?? ''}|$where|${whereArgs?.join(',') ?? ''}|$groupBy|$having|$orderBy|${limit ?? ''}|${offset ?? ''}';
  }

  /// Clear cache for specific table
  void _clearCacheForTable(String table) {
    final keysToRemove = <String>[];
    for (final key in _queryCache.keys) {
      if (key.startsWith('$table|')) {
        keysToRemove.add(key);
      }
    }

    for (final key in keysToRemove) {
      _queryCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  /// Clear all cache
  void clearCache() {
    _queryCache.clear();
    _cacheTimestamps.clear();
    Logger.info('Database cache cleared');
  }

  /// Get database statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;

    try {
      final result = await db.rawQuery('''
        SELECT 
          name,
          sql
        FROM sqlite_master 
        WHERE type = 'table'
      ''');

      return {
        'tables': result.length,
        'cache_size': _queryCache.length,
        'connection_pool_size': _connectionPool.length,
        'waiting_connections': _waitingConnections.length,
      };
    } finally {
      _returnConnection(db);
    }
  }

  /// Optimize database
  Future<void> optimize() async {
    final db = await database;

    try {
      await db.execute('PRAGMA optimize');
      await db.execute('VACUUM');
      clearCache();
      Logger.info('Database optimized successfully');
    } finally {
      _returnConnection(db);
    }
  }

  /// Close all connections
  Future<void> close() async {
    for (final db in _connectionPool) {
      await db.close();
    }
    _connectionPool.clear();

    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    _isInitialized = false;
    Logger.info('Database service closed');
  }
}
