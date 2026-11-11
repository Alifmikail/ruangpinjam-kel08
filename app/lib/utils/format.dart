const _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

String _duaDigit(int n) => n.toString().padLeft(2, '0');

/// Contoh: 12 Nov 2026
String formatTanggal(DateTime t) => '${t.day} ${_bulan[t.month - 1]} ${t.year}';

/// Contoh: 12 Nov 2026, 07.00
String formatTanggalJam(DateTime t) =>
    '${formatTanggal(t)}, ${_duaDigit(t.hour)}.${_duaDigit(t.minute)}';

/// Contoh: 07:30
String formatJam(int jam, int menit) => '${_duaDigit(jam)}:${_duaDigit(menit)}';
