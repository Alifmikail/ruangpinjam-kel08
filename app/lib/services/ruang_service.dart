import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pengajuan.dart';
import '../models/ruang.dart';

/// Layanan pemanggil REST API RuangPinjam.
/// Client disuntikkan lewat konstruktor agar bisa diganti MockClient saat test.
class RuangService {
  final http.Client client;
  final String baseUrl;

  RuangService({required this.client, required this.baseUrl});

  Future<List<Ruang>> ambilDaftarRuang() async {
    final res = await client
        .get(Uri.parse('$baseUrl/ruang'))
        .timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat ruang (kode ${res.statusCode})');
    }
    final data = jsonDecode(res.body) as List;
    return data
        .map((e) => Ruang.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Ruang> ambilRuang(int id) async {
    final res = await client.get(Uri.parse('$baseUrl/ruang/$id'));
    if (res.statusCode != 200) {
      throw Exception('Ruang $id tidak ditemukan');
    }
    return Ruang.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Endpoint khas tema: GET /gedung
  Future<List<Gedung>> ambilGedung() async {
    final res = await client.get(Uri.parse('$baseUrl/gedung'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat gedung (kode ${res.statusCode})');
    }
    final data = jsonDecode(res.body) as List;
    return data
        .map((e) => Gedung.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Nilai tambah: kirim pengajuan baru ke server dengan POST.
  Future<bool> kirimPengajuan(Pengajuan pengajuan) async {
    final res = await client.post(
      Uri.parse('$baseUrl/pengajuan'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(pengajuan.toJson()),
    );
    return res.statusCode == 201;
  }
}
