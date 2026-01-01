import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kos_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // tabel kamar
    await db.execute('''
      CREATE TABLE kamar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomor_kamar TEXT UNIQUE  NOT NULL,
        type_kamar TEXT NOT NULL,
        harga_kamar REAL NOT NULL,
        status_kosong INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // tabel penghuni
    await db.execute('''
      CREATE TABLE penghuni (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_penghuni TEXT NOT NULL,
        nomor_kamar TEXT NOT NULL,
        tanggal_masuk TEXT NOT NULL,
        tanggal_keluar TEXT,
        status_penghuni INTEGER NOT NULL DEFAULT 1,
        kamar_id INTEGER,
        FOREIGN KEY (kamar_id) REFERENCES kamar(id)
      )
    ''');

    // tabel pembayaran
  }
}
