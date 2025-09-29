import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../utils/logger.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'learn_cpp.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      Logger.error('Failed to initialize database', e);
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      // Create lessons table
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
          estimated_time_minutes INTEGER NOT NULL DEFAULT 5,
          category TEXT NOT NULL DEFAULT 'General',
          order_index INTEGER NOT NULL DEFAULT 0,
          metadata TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Create user_progress table
      await db.execute('''
        CREATE TABLE user_progress (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id TEXT NOT NULL,
          lesson_id TEXT NOT NULL,
          completed_at INTEGER NOT NULL,
          score INTEGER,
          time_spent INTEGER,
          FOREIGN KEY (lesson_id) REFERENCES lessons (id)
        )
      ''');

      // Create achievements table
      await db.execute('''
        CREATE TABLE achievements (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          icon TEXT,
          unlocked_at INTEGER,
          created_at INTEGER NOT NULL
        )
      ''');

      Logger.info('Database tables created successfully');
    } catch (e) {
      Logger.error('Failed to create database tables', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final db = await database;
      
      final lessonCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM lessons')
      ) ?? 0;
      
      final completedCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM user_progress')
      ) ?? 0;
      
      final achievementCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM achievements WHERE unlocked_at IS NOT NULL')
      ) ?? 0;

      return {
        'total_lessons': lessonCount,
        'completed_lessons': completedCount,
        'unlocked_achievements': achievementCount,
      };
    } catch (e) {
      Logger.error('Failed to get database statistics', e);
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getAllLessons() async {
    try {
      final db = await database;
      return await db.query('lessons', orderBy: 'order_index ASC');
    } catch (e) {
      Logger.error('Failed to get all lessons', e);
      return [];
    }
  }

  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.delete('user_progress');
      await db.delete('achievements');
      Logger.info('All data cleared from database');
    } catch (e) {
      Logger.error('Failed to clear all data', e);
      rethrow;
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}