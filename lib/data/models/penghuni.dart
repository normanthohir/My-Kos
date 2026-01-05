class Penghuni {
  int? id;
  String namaPenghuni;
  // String nomorhanphone;
  bool statusPenghuni;
  DateTime tanggalMasuk;
  DateTime? tanggalKeluar;
  int? kamarId;

  String? nomorKamar;
  double? hargaKamar;

  Penghuni({
    this.id,
    required this.namaPenghuni,
    // required this.nomorhanphone,
    required this.statusPenghuni,
    required this.tanggalMasuk,
    this.tanggalKeluar,
    this.kamarId,
    this.nomorKamar,
    this.hargaKamar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_penghuni': namaPenghuni,
      // 'nomor_hp': nomorhanphone,
      'tanggal_masuk': tanggalMasuk.toIso8601String(),
      'tanggal_keluar': tanggalKeluar?.toIso8601String(),
      'status_penghuni': statusPenghuni ? 1 : 0,
      'kamar_id': kamarId,
    };
  }

  factory Penghuni.fromMap(Map<String, dynamic> map) {
    return Penghuni(
      id: map['id'],
      namaPenghuni: map['nama_penghuni'],
      // nomorhanphone: map['nomor_hp'],
      tanggalMasuk: DateTime.parse(map['tanggal_masuk']),
      tanggalKeluar: map['tanggal_keluar'] != null
          ? DateTime.parse(map['tanggal_keluar'])
          : null,
      statusPenghuni: map['status_penghuni'] == 1,
      kamarId: map['kamar_id'],
      nomorKamar: map['nomor_kamar'],
      hargaKamar: map['harga_kamar'] != null
          ? (map['harga_kamar'] as num).toDouble()
          : null,
    );
  }
}
