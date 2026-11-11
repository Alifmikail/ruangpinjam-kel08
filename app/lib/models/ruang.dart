/// Model utama: satu ruang kelas, lab, atau aula yang bisa dipinjam.
class Ruang {
  final int id;
  final String kode;
  final String gedung;
  final String jenis; // Kelas / Lab / Aula
  final int kapasitas;
  final bool adaProyektor;
  final DateTime tersediaMulai;

  const Ruang({
    required this.id,
    required this.kode,
    required this.gedung,
    required this.jenis,
    required this.kapasitas,
    required this.adaProyektor,
    required this.tersediaMulai,
  });

  factory Ruang.fromJson(Map<String, dynamic> json) {
    return Ruang(
      id: json['id'] as int,
      kode: json['kode'] as String,
      gedung: json['gedung'] as String,
      jenis: json['jenis'] as String,
      kapasitas: json['kapasitas'] as int,
      adaProyektor: json['adaProyektor'] as bool,
      tersediaMulai: DateTime.parse(json['tersediaMulai'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kode': kode,
        'gedung': gedung,
        'jenis': jenis,
        'kapasitas': kapasitas,
        'adaProyektor': adaProyektor,
        'tersediaMulai': tersediaMulai.toIso8601String(),
      };
}

/// Ringkasan gedung dari endpoint khas GET /gedung.
class Gedung {
  final String nama;
  final int jumlahRuang;

  const Gedung({required this.nama, required this.jumlahRuang});

  factory Gedung.fromJson(Map<String, dynamic> json) => Gedung(
        nama: json['gedung'] as String,
        jumlahRuang: json['jumlahRuang'] as int,
      );
}
