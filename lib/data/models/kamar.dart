class Kamar {
  int? id;
  String nomorKamar;
  String typeKamar;
  double hargaKamar;
  bool statusKamar;

  Kamar({
    this.id,
    required this.nomorKamar,
    required this.typeKamar,
    required this.hargaKamar,
    required this.statusKamar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomor_kamar': nomorKamar,
      'type_kamar': typeKamar,
      'harga_kamar': hargaKamar,
      'status_kamar': statusKamar ? 1 : 0,
    };
  }

  factory Kamar.fromMap(Map<String, dynamic> map) {
    return Kamar(
      id: map['id'],
      nomorKamar: map['nomor_kamar'],
      typeKamar: map['type_kamar'],
      hargaKamar: map['harga_kamar'].toDouble(),
      statusKamar: map['status_kamar'] == 1,
    );
  }
}
