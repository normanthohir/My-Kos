import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kos_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // Tambahkan onConfigure untuk mengaktifkan Foreign Key
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabel Kamar
    await db.execute('''
      CREATE TABLE kamar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomor_kamar TEXT UNIQUE NOT NULL,
        type_kamar TEXT NOT NULL,
        harga_kamar REAL NOT NULL,
        status_kamar TEXT NOT NULL DEFAULT 'Tersedia', -- Tersedia, Terisi, Maintenance
        catatan TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Tabel Penghuni
    await db.execute('''
      CREATE TABLE penghuni (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_penghuni TEXT NOT NULL,
        tanggal_masuk TEXT NOT NULL,
        tanggal_keluar TEXT,
        status_penghuni INTEGER DEFAULT 1, -- 1: Masih ngekos, 0: Sudah keluar
        kamar_id INTEGER,
        FOREIGN KEY (kamar_id) REFERENCES kamar(id) ON DELETE CASCADE
      )
    ''');

    // Tabel Pembayaran
    await db.execute('''
      CREATE TABLE pembayaran (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_penghuni_pembayaran TEXT NOT NULL,
        nomor_kamar_pembayar TEXT NOT NULL,
        jumlah_pembayaran REAL NOT NULL,
        metode_bayar TEXT NOT NULL, -- Contoh: 'Transfer', 'Tunai'
        periode_pembayaran TEXT NOT NULL,
        tanggal_pembayaran TEXT NOT NULL,
        status_pembayaran TEXT DEFAULT 'Lunas', 
        bukti_pembayaran TEXT, -- Path ke galeri/kamera
        kamar_id INTEGER,
        penghuni_id INTEGER,
        FOREIGN KEY (kamar_id) REFERENCES kamar(id) ON DELETE SET NULL,
        FOREIGN KEY (penghuni_id) REFERENCES penghuni(id) ON DELETE SET NULL
      )
    ''');
  }
}
