import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task.dart';

class TaskRepository {
  TaskRepository._privateConstructor();
  static final TaskRepository instance = TaskRepository._privateConstructor();

  Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, priority INTEGER, dueDate TEXT, isCompleted INTEGER)',
        );
      },
    );
  }

  Future<List<Task>> getAllTasks() async {
    final db = await _db;
    final maps = await db.query('tasks', orderBy: 'dueDate ASC');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<int> insertTask(Task task) async {
    final db = await _db;
    return await db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final db = await _db;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await _db;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
