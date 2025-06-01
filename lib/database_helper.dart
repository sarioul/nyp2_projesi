import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database; // Dışarıdan erişilemez

  DatabaseHelper._internal();

  Future<Database> get database async {
    // Kontrollü erişim
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'hasta_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE appointments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            surname TEXT NOT NULL,
            complaint TEXT NOT NULL,
            clinic TEXT NOT NULL,
            doctor TEXT NOT NULL,
            isConfirmed INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> hastaEkle(Map<String, dynamic> hasta) async {
    // Soyutlama
    final db = await database;
    return await db.insert('appointments', hasta);
  }

  Future<List<Map<String, dynamic>>> hastalariGetir() async {
    final db = await database;
    return await db.query('appointments');
  }

  Future<int> onayla(int id) async {
    // Soyutlama
    final db = await database;
    return await db.update(
      'appointments',
      {'isConfirmed': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> randevuSil(int id) async {
    // Soyutlama
    final db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> reddet(int id) async {
    final db = await database;
    return await db.update(
      'appointments',
      {'isConfirmed': 2},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Geliştirme amaçlı veritabanını sıfırlama
  Future<void> veritabaniniSifirla() async {
    final db = await database;
    await db.delete('appointments');
  }
}
