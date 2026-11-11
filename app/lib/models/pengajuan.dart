enum StatusPengajuan { menunggu, disetujui }

extension TeksStatus on StatusPengajuan {
  String get label =>
      this == StatusPengajuan.menunggu ? 'Menunggu' : 'Disetujui';
}

/// Pengajuan peminjaman ruang yang diisi lewat form tambah.
class Pengajuan {
  final String kodeRuang;
  final DateTime tanggal;
  final String jamMulai; // format HH:mm
  final String jamSelesai; // format HH:mm
  final String keperluan;
  final StatusPengajuan status;

  const Pengajuan({
    required this.kodeRuang,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.keperluan,
    this.status = StatusPengajuan.menunggu,
  });

  Pengajuan copyWith({StatusPengajuan? status}) => Pengajuan(
        kodeRuang: kodeRuang,
        tanggal: tanggal,
        jamMulai: jamMulai,
        jamSelesai: jamSelesai,
        keperluan: keperluan,
        status: status ?? this.status,
      );

  factory Pengajuan.fromJson(Map<String, dynamic> json) => Pengajuan(
        kodeRuang: json['kodeRuang'] as String,
        tanggal: DateTime.parse(json['tanggal'] as String),
        jamMulai: json['jamMulai'] as String,
        jamSelesai: json['jamSelesai'] as String,
        keperluan: json['keperluan'] as String,
        status: json['status'] == 'Disetujui'
            ? StatusPengajuan.disetujui
            : StatusPengajuan.menunggu,
      );

  Map<String, dynamic> toJson() => {
        'kodeRuang': kodeRuang,
        'tanggal': tanggal.toIso8601String(),
        'jamMulai': jamMulai,
        'jamSelesai': jamSelesai,
        'keperluan': keperluan,
        'status': status.label,
      };
}
