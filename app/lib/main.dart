import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'pages/halaman_utama.dart';
import 'services/ruang_service.dart';
import 'theme.dart';

void main() {
  final service = RuangService(client: http.Client(), baseUrl: apiUrl);
  runApp(RuangPinjamApp(service: service));
}

class RuangPinjamApp extends StatelessWidget {
  final RuangService service;

  const RuangPinjamApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuangPinjam',
      debugShowCheckedModeBanner: false,
      theme: temaTerang,
      darkTheme: temaGelap,
      themeMode: ThemeMode.system,
      home: HalamanUtama(service: service),
    );
  }
}
