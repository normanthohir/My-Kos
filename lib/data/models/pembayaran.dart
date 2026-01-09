import 'dart:ffi';

class Pembayaran {
  int? id;
  String namaPembayar;
  String nomorkamarPembayar;
  String metodePembayaran;
  Bool jumlahPembayaran;
  bool statusPembayaran;
  DateTime priodePembayaran;
  DateTime tanggalPembayaran;
  int kamarId;
  int penghuniId;

  Pembayaran({
    this.id,
    required this.namaPembayar,
    required this.nomorkamarPembayar,
    required this.jumlahPembayaran,
    required this.metodePembayaran,
    required this.statusPembayaran,
    required this.priodePembayaran,
    required this.tanggalPembayaran,
    required this.kamarId,
    required this.penghuniId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_pembayar': namaPembayar,
      'nomor_kamar_pembayar': nomorkamarPembayar,
      'jumlah_pembayaran': jumlahPembayaran,
      'metode_pembayaran': metodePembayaran,
      'status_pembayaran': statusPembayaran ? 1 : 0,
      'periode_pembayaran': priodePembayaran.toIso8601String(),
      'tanggal_pembayaran': tanggalPembayaran.toIso8601String(),
      'kamar_id': kamarId,
      'penghuni_id': penghuniId
    };
  }

  factory Pembayaran.fromMap(Map<String, dynamic> map) {
    return Pembayaran(
      id: map['id'],
      namaPembayar: map['nama_pembayar'],
      nomorkamarPembayar: map['nomor_kamar_pembayar'],
      jumlahPembayaran: map['jumlah_pembayaran'].toDouble(),
      priodePembayaran: map['periode_pembayaran'],
      metodePembayaran: map['metode_pembayaran'],
      tanggalPembayaran: DateTime.parse(map['tanggal_pembayaran']),
      statusPembayaran: map['status_pembayaran'] == 1,
      kamarId: map['kamar_id'],
      penghuniId: map['penghuni_id'],
    );
  }
}
