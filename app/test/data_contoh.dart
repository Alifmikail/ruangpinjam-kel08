import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ruang_pinjam/models/ruang.dart';
import 'package:ruang_pinjam/services/ruang_service.dart';

/// Data JSON tiruan, bentuknya sama dengan server/data/ruang.json.
final contohJsonRuang = [
  {
    'id': 1,
    'kode': 'TULT-0604',
    'gedung': 'TULT',
    'jenis': 'Kelas',
    'kapasitas': 40,
    'adaProyektor': true,
    'tersediaMulai': '2026-11-12T07:00:00.000',
  },
  {
    'id': 3,
    'kode': 'TULT-1401',
    'gedung': 'TULT',
    'jenis': 'Lab',
    'kapasitas': 30,
    'adaProyektor': false,
    'tersediaMulai': '2026-11-13T08:00:00.000',
  },
  {
    'id': 4,
    'kode': 'TULT-1601',
    'gedung': 'TULT',
    'jenis': 'Aula',
    'kapasitas': 200,
    'adaProyektor': true,
    'tersediaMulai': '2026-11-15T13:00:00.000',
  },
];

final contohRuang = Ruang.fromJson(contohJsonRuang.first);

/// Service dengan MockClient yang selalu berhasil.
RuangService serviceBerhasil() => RuangService(
      baseUrl: 'http://tes',
      client: MockClient((req) async {
        if (req.url.path == '/ruang') {
          return http.Response(jsonEncode(contohJsonRuang), 200);
        }
        return http.Response('[]', 200);
      }),
    );

/// Service dengan MockClient yang selalu gagal (server mati).
RuangService serviceGagal() => RuangService(
      baseUrl: 'http://tes',
      client: MockClient((req) async => http.Response('error', 500)),
    );
