import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'trello_clone.db'),
      onCreate: (db, version) {
  db.execute('''
    CREATE TABLE boards(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    );
  ''');

  db.execute('''
    CREATE TABLE lists(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      board_id INTEGER,
      FOREIGN KEY (board_id) REFERENCES boards (id)
    );
  ''');
},

      version: 1,
    );
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }
}
