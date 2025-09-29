import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/entities/lesson.dart';
import '../services/error_service.dart';
import '../utils/logger.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  bool _isInitialized = false;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'codelingo.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

      _isInitialized = true;
      Logger.info('Database initialized successfully');
      return _database!;
    } catch (e) {
      ErrorService().reportException(
        e,
        message: 'Failed to initialize database',
      );
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      // Lessons table
      await db.execute('''
        CREATE TABLE lessons (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          duration TEXT NOT NULL,
          difficulty TEXT NOT NULL,
          is_completed INTEGER NOT NULL DEFAULT 0,
          content TEXT NOT NULL,
          code_example TEXT NOT NULL,
          tags TEXT,
          estimated_time_minutes INTEGER DEFAULT 5,
          category TEXT DEFAULT 'General',
          order_index INTEGER DEFAULT 0,
          metadata TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // User progress table
      await db.execute('''
        CREATE TABLE user_progress (
          id TEXT PRIMARY KEY,
          total_xp INTEGER NOT NULL DEFAULT 0,
          current_level INTEGER NOT NULL DEFAULT 1,
          current_streak INTEGER NOT NULL DEFAULT 0,
          longest_streak INTEGER NOT NULL DEFAULT 0,
          hearts INTEGER NOT NULL DEFAULT 5,
          lessons_completed INTEGER NOT NULL DEFAULT 0,
          quizzes_passed INTEGER NOT NULL DEFAULT 0,
          last_active_date INTEGER,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Create indexes for better performance
      await db.execute(
        'CREATE INDEX idx_lessons_difficulty ON lessons(difficulty)',
      );
      await db.execute(
        'CREATE INDEX idx_lessons_completed ON lessons(is_completed)',
      );

      Logger.info('Database tables created successfully');
    } catch (e) {
      ErrorService().reportException(
        e,
        message: 'Failed to create database tables',
      );
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    Logger.info('Database upgrade from version $oldVersion to $newVersion');
  }

  // Lesson operations
  Future<void> insertLesson(Lesson lesson) async {
    try {
      final db = await database;
      await db.insert('lessons', {
        'id': lesson.id,
        'title': lesson.title,
        'description': lesson.description,
        'duration': lesson.duration,
        'difficulty': lesson.difficulty,
        'is_completed': lesson.isCompleted ? 1 : 0,
        'content': lesson.content,
        'code_example': lesson.codeExample,
        'tags': lesson.tags.join(','),
        'estimated_time_minutes': lesson.estimatedTimeMinutes,
        'category': lesson.category,
        'order_index': lesson.order,
        'metadata': lesson.metadata.toString(),
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      Logger.info('Lesson inserted: ${lesson.title}');
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to insert lesson');
    }
  }

  Future<List<Lesson>> getAllLessons() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'lessons',
        orderBy: 'order_index ASC',
      );

      return maps
          .map(
            (map) => Lesson(
              id: map['id'],
              title: map['title'],
              description: map['description'],
              duration: map['duration'],
              difficulty: map['difficulty'],
              isCompleted: map['is_completed'] == 1,
              content: map['content'],
              codeExample: map['code_example'],
              tags: map['tags']?.split(',') ?? [],
              estimatedTimeMinutes: map['estimated_time_minutes'] ?? 5,
              category: map['category'] ?? 'General',
              order: map['order_index'] ?? 0,
              metadata: {},
            ),
          )
          .toList();
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to get all lessons');
      return [];
    }
  }

  Future<Lesson?> getLessonById(String id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'lessons',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        final map = maps.first;
        return Lesson(
          id: map['id'],
          title: map['title'],
          description: map['description'],
          duration: map['duration'],
          difficulty: map['difficulty'],
          isCompleted: map['is_completed'] == 1,
          content: map['content'],
          codeExample: map['code_example'],
          tags: map['tags']?.split(',') ?? [],
          estimatedTimeMinutes: map['estimated_time_minutes'] ?? 5,
          category: map['category'] ?? 'General',
          order: map['order_index'] ?? 0,
          metadata: {},
        );
      }
      return null;
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to get lesson by id');
      return null;
    }
  }

  Future<void> updateLesson(Lesson lesson) async {
    try {
      final db = await database;
      await db.update(
        'lessons',
        {
          'title': lesson.title,
          'description': lesson.description,
          'duration': lesson.duration,
          'difficulty': lesson.difficulty,
          'is_completed': lesson.isCompleted ? 1 : 0,
          'content': lesson.content,
          'code_example': lesson.codeExample,
          'tags': lesson.tags.join(','),
          'estimated_time_minutes': lesson.estimatedTimeMinutes,
          'category': lesson.category,
          'order_index': lesson.order,
          'metadata': lesson.metadata.toString(),
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [lesson.id],
      );
      Logger.info('Lesson updated: ${lesson.title}');
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to update lesson');
    }
  }

  Future<void> deleteLesson(String id) async {
    try {
      final db = await database;
      await db.delete('lessons', where: 'id = ?', whereArgs: [id]);
      Logger.info('Lesson deleted: $id');
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to delete lesson');
    }
  }

  // User progress operations
  Future<void> updateUserProgress({
    required int totalXP,
    required int currentLevel,
    required int currentStreak,
    required int longestStreak,
    required int hearts,
    required int lessonsCompleted,
    required int quizzesPassed,
    DateTime? lastActiveDate,
  }) async {
    try {
      final db = await database;
      await db.insert('user_progress', {
        'id': 'main_progress',
        'total_xp': totalXP,
        'current_level': currentLevel,
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'hearts': hearts,
        'lessons_completed': lessonsCompleted,
        'quizzes_passed': quizzesPassed,
        'last_active_date': lastActiveDate?.millisecondsSinceEpoch,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      Logger.info('User progress updated');
    } catch (e) {
      ErrorService().reportException(
        e,
        message: 'Failed to update user progress',
      );
    }
  }

  Future<Map<String, dynamic>?> getUserProgress() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'user_progress',
        where: 'id = ?',
        whereArgs: ['main_progress'],
      );

      if (maps.isNotEmpty) {
        return maps.first;
      }
      return null;
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to get user progress');
      return null;
    }
  }

  // Statistics
  Future<Map<String, int>> getStatistics() async {
    try {
      final db = await database;

      final lessonCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM lessons'),
          ) ??
          0;
      final completedLessons =
          Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT COUNT(*) FROM lessons WHERE is_completed = 1',
            ),
          ) ??
          0;
      return {
        'total_lessons': lessonCount,
        'completed_lessons': completedLessons,
      };
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to get statistics');
      return {};
    }
  }

  // Cleanup operations
  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.delete('lessons');
      await db.delete('user_progress');
      Logger.info('All data cleared from database');
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to clear all data');
    }
  }

  Future<void> close() async {
    try {
      final db = _database;
      if (db != null) {
        await db.close();
        _database = null;
        _isInitialized = false;
        Logger.info('Database closed');
      }
    } catch (e) {
      ErrorService().reportException(e, message: 'Failed to close database');
    }
  }

  bool get isInitialized => _isInitialized;
}
