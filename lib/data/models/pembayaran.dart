class Pembayaran {
  int? id;
  String namaPenghuniPembayaran; // nama_penghuni_pembayaran
  String nomorKamarPembayar; // nomor_kamar_pembayar
  double jumlahPembayaran; // jumlah_pembayaran
  String metodeBayar; // metode_bayar
  String periodePembayaran; // periode_pembayaran
  String tanggalPembayaran; // tanggal_pembayaran
  String statusPembayaran; // status_pembayaran
  String? buktiPembayaran; // bukti_pembayaran
  int? kamarId; // kamar_id
  int? penghuniId; // penghuni_id

  Pembayaran({
    this.id,
    required this.namaPenghuniPembayaran,
    required this.nomorKamarPembayar,
    required this.jumlahPembayaran,
    required this.metodeBayar,
    required this.periodePembayaran,
    required this.tanggalPembayaran,
    this.statusPembayaran = 'Lunas',
    this.buktiPembayaran,
    this.kamarId,
    this.penghuniId,
  });

  // Konversi ke Map untuk insert ke SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_penghuni_pembayaran': namaPenghuniPembayaran,
      'nomor_kamar_pembayar': nomorKamarPembayar,
      'jumlah_pembayaran': jumlahPembayaran,
      'metode_bayar': metodeBayar,
      'periode_pembayaran': periodePembayaran,
      'tanggal_pembayaran': tanggalPembayaran,
      'status_pembayaran': statusPembayaran,
      'bukti_pembayaran': buktiPembayaran,
      'kamar_id': kamarId,
      'penghuni_id': penghuniId,
    };
  }

  // Tambahkan factory fromMap jika sewaktu-waktu ingin mengambil data
  factory Pembayaran.fromMap(Map<String, dynamic> map) {
    return Pembayaran(
      id: map['id'],
      namaPenghuniPembayaran: map['nama_penghuni_pembayaran'],
      nomorKamarPembayar: map['nomor_kamar_pembayar'],
      jumlahPembayaran: map['jumlah_pembayaran'],
      metodeBayar: map['metode_bayar'],
      periodePembayaran: map['periode_pembayaran'],
      tanggalPembayaran: map['tanggal_pembayaran'],
      statusPembayaran: map['status_pembayaran'],
      buktiPembayaran: map['bukti_pembayaran'],
      kamarId: map['kamar_id'],
      penghuniId: map['penghuni_id'],
    );
  }
}
