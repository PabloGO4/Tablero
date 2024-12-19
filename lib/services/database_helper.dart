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
      version: 2, // Incrementa la versión para incluir migraciones
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

        db.execute('''
          CREATE TABLE cards(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            list_id INTEGER,
            FOREIGN KEY (list_id) REFERENCES lists (id)
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          // Crear la tabla cards si se actualiza desde una versión anterior
          db.execute('''
            CREATE TABLE cards(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              list_id INTEGER,
              FOREIGN KEY (list_id) REFERENCES lists (id)
            );
          ''');
        }
      },
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

  Future<List<Map<String, dynamic>>> queryWithCondition(
      String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> update(String table, Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
  final db = await database;
  return await db.update(table, data, where: where, whereArgs: whereArgs);
}





}
