import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();
  factory DBHelper() => instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'playstation_rental.db');

    return await openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE consoles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          image TEXT,
          price_per_hour REAL,
          available INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE customers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT,
          password TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE rentals (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_id INTEGER,
          total REAL,
          status TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE rental_details (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          rental_id INTEGER,
          console_id INTEGER,
          hours INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE payments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          rental_id INTEGER,
          amount REAL,
          method TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE tariffs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          price_per_hour REAL
        )
      ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE customers ADD COLUMN password TEXT');
      }
    });
  }

  Future<void> close() async {
    final dbClient = _db;
    if (dbClient != null) {
      await dbClient.close();
      _db = null;
    }
  }

  // Authentication methods
  Future<int> registerCustomer(String name, String phone, String password) async {
    final db = await database;
    return await db.insert('customers', {
      'name': name,
      'phone': phone,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> loginCustomer(String name, String phone, String password) async {
    final db = await database;
    final result = await db.query(
      'customers',
      where: 'name = ? AND phone = ? AND password = ?',
      whereArgs: [name, phone, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
