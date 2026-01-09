import 'dart:async';

import 'package:flutter/material.dart';
import 'package:may_kos/data/models/kamar.dart';
import 'package:may_kos/data/models/pembayaran.dart';
import 'package:may_kos/data/models/penghuni.dart';
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

  // crud kamar
  Future<int> insertKamar(Kamar kamar) async {
    Database db = await database;
    return await db.insert('kamar', kamar.toMap());
  }

  Future<List<Kamar>> getAllKamar() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('kamar');
    return List.generate(maps.length, (i) => Kamar.fromMap(maps[i]));
  }

  Future<List<Kamar>> getKamarTersedia() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kamar',
      where: 'status_kamar = ?',
      whereArgs: ['Tersedia'],
    );
    return List.generate(maps.length, (i) => Kamar.fromMap(maps[i]));
  }

  Future<List<Kamar>> getKamarTerisi() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kamar',
      where: 'status_kamar = ?',
      whereArgs: ['terisi'],
    );
    return List.generate(
      maps.length,
      (i) => Kamar.fromMap(maps[i]),
    );
  }

  Future<int> updateKamar(Kamar kamar) async {
    Database db = await database;
    return await db.update(
      'kamar',
      kamar.toMap(),
      where: 'id = ?',
      whereArgs: [kamar.id],
    );
  }

  Future<int> deleteKamar(int id) async {
    Database db = await database;
    return await db.delete(
      'kamar',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> cekNomorKamar(String nomor, {int? idTerpasang}) async {
    final db = await database;
    // Cari nomor kamar yang sama, tapi abaikan jika ID-nya milik kamar ini sendiri (saat update)
    final result = await db.query(
      'kamar',
      where: 'nomor_kamar = ? AND id != ?',
      whereArgs: [nomor, idTerpasang ?? -1],
    );
    return result.isNotEmpty;
  }

  // Crud Penghuni
  Future<void> insertPenghuni(Penghuni penghuni) async {
    final db = await database;

    // Kita gunakan Transaction agar jika salah satu gagal, semua dibatalkan (aman)
    await db.transaction((txn) async {
      // Simpan data penghuni
      await txn.insert('penghuni', penghuni.toMap());

      //  Update status kamar menjadi 'terisi'
      if (penghuni.kamarId != null) {
        await txn.update(
          'kamar',
          {
            'status_kamar': 'terisi'
          }, // Pastikan string 'terisi' sama dengan di database kamu
          where: 'id = ?',
          whereArgs: [penghuni.kamarId],
        );
      }
    });
  }

  Future<void> updatePenghuni(Penghuni penghuni, int? idKamarLama) async {
    final db = await database;

    await db.transaction((txn) async {
      // 1. Update data penghuni di tabel penghuni
      await txn.update(
        'penghuni',
        penghuni.toMap(),
        where: 'id = ?',
        whereArgs: [penghuni.id],
      );

      // 2. Logika Perpindahan Kamar
      if (idKamarLama != penghuni.kamarId) {
        // Jika kamar berubah, kosongkan kamar lama
        if (idKamarLama != null) {
          await txn.update(
            'kamar',
            {'status_kamar': 'Tersedia'},
            where: 'id = ?',
            whereArgs: [idKamarLama],
          );
        }

        // Isi kamar yang baru
        if (penghuni.kamarId != null) {
          await txn.update(
            'kamar',
            {'status_kamar': 'terisi'},
            where: 'id = ?',
            whereArgs: [penghuni.kamarId],
          );
        }
      }
    });
  }

  Future<List<Penghuni>> getAllPenghuni() async {
    Database db = await database;

    // p adalah alias untuk penghuni, k adalah alias untuk kamar
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT 
      p.*, 
      k.nomor_kamar, 
      k.harga_kamar
    FROM penghuni p
    LEFT JOIN kamar k ON p.kamar_id = k.id
    ORDER BY p.id DESC
  ''');

    return List.generate(maps.length, (i) => Penghuni.fromMap(maps[i]));
  }

  Future<void> deletePenghuni(int id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('penghuni', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<void> keluarPenghuni(int? idPenghuni, int? idKamar) async {
    // Jika ID tidak ada, batalkan proses
    if (idPenghuni == null || idKamar == null) return;
    final db = await database;
    await db.transaction((txn) async {
      // 1. Update status penghuni jadi tidak aktif (0)
      await txn.update(
        'penghuni',
        {'status_penghuni': 0, 'tanggal_keluar': DateTime.now().toString()},
        where: 'id = ?',
        whereArgs: [idPenghuni],
      );

      // 2. Update status kamar kembali menjadi 'Tersedia'
      await txn.update(
        'kamar',
        {'status_kamar': 'Tersedia'},
        where: 'id = ?',
        whereArgs: [idKamar],
      );
    });
  }

  Future<List<Kamar>> getKamarUntukEdit(int? currentKamarId) async {
    final db = await database;

    if (currentKamarId == null) {
      // Mode Tambah Baru: Hanya ambil yang Tersedia
      return (await db.query(
        'kamar',
        where: 'status_kamar = ?',
        whereArgs: ['Tersedia'],
      ))
          .map((e) => Kamar.fromMap(e))
          .toList();
    } else {
      // Mode Edit: Ambil yang Tersedia ATAU kamar miliknya saat ini
      return (await db.query(
        'kamar',
        where: 'status_kamar = ? OR id = ?',
        whereArgs: ['Tersedia', currentKamarId],
      ))
          .map((e) => Kamar.fromMap(e))
          .toList();
    }
  }

// Crud Pembayaran
  // tambah pembayaran
  Future<void> insertPembayaran(Pembayaran pembayaran) async {
    final db = await database;
    await db.insert('pembayaran', pembayaran.toMap());
  }

  // tampilkan semua pembayaran
  Future<List<Pembayaran>> getAllPembayaran() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pembayaran');
    return List.generate(maps.length, (i) => Pembayaran.fromMap(maps[i]));
  }

  // tagihan
  Future<List<Map<String, dynamic>>> getTagihanJatuhTempo() async {
    final db = await database;
    final now = DateTime.now();
    final currentMonth = now.month.toString().padLeft(2, '0');
    final currentYear = now.year.toString();

    // Ambil penghuni yang:
    // 1. Aktif
    // 2. Belum bayar bulan ini
    // 3. Tanggal hari ini sudah >= tanggal mereka masuk (Jatuh Tempo)
    final String sql = '''
    SELECT 
      p.*, k.nomor_kamar 
    FROM penghuni p
    JOIN kamar k ON p.kamar_id = k.id
    WHERE p.status_penghuni = 1
    AND CAST(strftime('%d', p.tanggal_masuk) AS INTEGER) <= ?
    AND p.id NOT IN (
      SELECT penghuni_id FROM pembayaran 
      WHERE strftime('%m', periode_pembayaran) = ? 
      AND strftime('%Y', periode_pembayaran) = ?
    )
  ''';

    return await db.rawQuery(sql, [now.day, currentMonth, currentYear]);
  }

  Future<List<Map<String, dynamic>>> getAllTunggakan() async {
    final db = await database;
    final now = DateTime.now();

    // 1. Ambil semua penghuni aktif
    final List<Map<String, dynamic>> penghuniList = await db.rawQuery('''
    SELECT p.id, p.nama_penghuni, p.tanggal_masuk, k.harga_kamar, k.nomor_kamar, k.id as kamar_id
    FROM penghuni p
    JOIN kamar k ON p.kamar_id = k.id
    WHERE p.status_penghuni = 1
  ''');

    List<Map<String, dynamic>> semuaTagihan = [];

    for (var p in penghuniList) {
      DateTime tglMasuk = DateTime.parse(p['tanggal_masuk']);

      // 2. Loop dari bulan masuk sampai bulan sekarang
      DateTime tempDate = DateTime(tglMasuk.year, tglMasuk.month);
      DateTime targetDate = DateTime(now.year, now.month);

      while (tempDate.isBefore(targetDate) ||
          tempDate.isAtSameMomentAs(targetDate)) {
        String bulanStr = tempDate.month.toString().padLeft(2, '0');
        String tahunStr = tempDate.year.toString();

        // 3. Cek apakah bulan ini sudah dibayar oleh penghuni ini
        final String checkSql = '''
        SELECT id FROM pembayaran 
        WHERE penghuni_id = ? 
        AND strftime('%m', periode_pembayaran) = ? 
        AND strftime('%Y', periode_pembayaran) = ?
      ''';

        final res = await db.rawQuery(checkSql, [p['id'], bulanStr, tahunStr]);

        // 4. Jika tidak ditemukan di tabel pembayaran, masukkan ke list tagihan
        if (res.isEmpty) {
          semuaTagihan.add({
            'penghuni_id': p['id'],
            'nama': p['nama_penghuni'],
            'jumlah': p['harga_kamar'],
            'tanggal_masuk': p['tanggal_masuk'],
            'nomor_kamar': p['nomor_kamar'],
            'kamar_id': p['kamar_id'],
            'bulan': bulanStr,
            'tahun': tahunStr,
          });
        }

        // Tambah 1 bulan untuk pengecekan berikutnya
        tempDate = DateTime(tempDate.year, tempDate.month + 1);
      }
    }

    return semuaTagihan;
  }
}
