import 'package:flutter/material.dart';

/// Warna khas tema RuangPinjam: merah Telkom University.
const Color warnaSeed = Color(0xFFB71C1C);

ThemeData _buatTema(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: warnaSeed,
      brightness: brightness,
    ),
  );
}

final ThemeData temaTerang = _buatTema(Brightness.light);
final ThemeData temaGelap = _buatTema(Brightness.dark);
