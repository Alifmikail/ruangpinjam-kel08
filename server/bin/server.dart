import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

/// Data ruang dimuat dari data/ruang.json saat server dinyalakan.
late final List<Map<String, dynamic>> daftarRuang;

/// Pengajuan yang dikirim aplikasi lewat POST (disimpan di memori server).
final List<Map<String, dynamic>> daftarPengajuan = [];

const _jsonHeader = {'content-type': 'application/json; charset=utf-8'};

Response _json(Object data, {int status = 200}) =>
    Response(status, body: jsonEncode(data), headers: _jsonHeader);

Router buatRouter() {
  final router = Router();

  // GET /ruang  -> daftar semua ruang (opsional ?jenis=Kelas|Lab|Aula)
  router.get('/ruang', (Request req) {
    final jenis = req.url.queryParameters['jenis'];
    final hasil = jenis == null
        ? daftarRuang
        : daftarRuang.where((r) => r['jenis'] == jenis).toList();
    return _json(hasil);
  });

  // GET /ruang/<id> -> satu ruang berdasarkan id
  router.get('/ruang/<id|[0-9]+>', (Request req, String id) {
    final cari = int.parse(id);
    for (final r in daftarRuang) {
      if (r['id'] == cari) return _json(r);
    }
    return _json({'pesan': 'Ruang dengan id $id tidak ditemukan'}, status: 404);
  });

  // GET /gedung -> endpoint khas: daftar gedung dan jumlah ruangnya
  router.get('/gedung', (Request req) {
    final hitung = <String, int>{};
    for (final r in daftarRuang) {
      final g = r['gedung'] as String;
      hitung[g] = (hitung[g] ?? 0) + 1;
    }
    final hasil = hitung.entries
        .map((e) => {'gedung': e.key, 'jumlahRuang': e.value})
        .toList();
    return _json(hasil);
  });

  // GET /pengajuan -> pengajuan yang sudah masuk ke server
  router.get('/pengajuan', (Request req) => _json(daftarPengajuan));

  // POST /pengajuan -> nilai tambah: simpan pengajuan baru dari aplikasi
  router.post('/pengajuan', (Request req) async {
    try {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      body['id'] = daftarPengajuan.length + 1;
      daftarPengajuan.add(body);
      return _json(body, status: 201);
    } catch (e) {
      return _json({'pesan': 'Body tidak valid: $e'}, status: 400);
    }
  });

  return router;
}

Future<void> main(List<String> args) async {
  final file = File('data/ruang.json');
  daftarRuang = (jsonDecode(await file.readAsString()) as List)
      .cast<Map<String, dynamic>>();

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(buatRouter().call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('RuangPinjam API berjalan di http://${server.address.host}:${server.port}');
  print('Data: ${daftarRuang.length} ruang');
}
