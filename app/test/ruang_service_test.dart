import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ruang_pinjam/models/pengajuan.dart';
import 'package:ruang_pinjam/models/ruang.dart';
import 'package:ruang_pinjam/services/ruang_service.dart';

import 'data_contoh.dart';

void main() {
  group('RuangService dengan MockClient', () {
    test('ambilDaftarRuang mengubah JSON menjadi List<Ruang>', () async {
      final service = RuangService(
        baseUrl: 'http://tes',
        client: MockClient((req) async {
          expect(req.url.toString(), 'http://tes/ruang');
          return http.Response(jsonEncode(contohJsonRuang), 200);
        }),
      );

      final hasil = await service.ambilDaftarRuang();

      expect(hasil.length, 3);
      expect(hasil.first.kode, 'TULT-0604');
      expect(hasil.first.adaProyektor, isTrue);
      expect(hasil.first.tersediaMulai, DateTime(2026, 11, 12, 7));
    });

    test('ambilRuang mengambil satu ruang berdasarkan id', () async {
      final service = RuangService(
        baseUrl: 'http://tes',
        client: MockClient((req) async {
          expect(req.url.path, '/ruang/3');
          return http.Response(jsonEncode(contohJsonRuang[1]), 200);
        }),
      );

      final ruang = await service.ambilRuang(3);
      expect(ruang.kode, 'TULT-1401');
      expect(ruang.jenis, 'Lab');
    });

    test('ambilGedung membaca endpoint khas /gedung', () async {
      final service = RuangService(
        baseUrl: 'http://tes',
        client: MockClient((req) async => http.Response(
              jsonEncode([
                {'gedung': 'TULT', 'jumlahRuang': 4},
                {'gedung': 'Gedung FIT', 'jumlahRuang': 2},
              ]),
              200,
            )),
      );

      final daftar = await service.ambilGedung();
      expect(daftar.length, 2);
      expect(daftar.first.nama, 'TULT');
      expect(daftar.first.jumlahRuang, 4);
    });

    test('status selain 200 melempar Exception', () async {
      expect(serviceGagal().ambilDaftarRuang(), throwsException);
    });

    test('kirimPengajuan mengirim JSON dengan POST', () async {
      final service = RuangService(
        baseUrl: 'http://tes',
        client: MockClient((req) async {
          expect(req.method, 'POST');
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['kodeRuang'], 'TULT-0604');
          return http.Response(req.body, 201);
        }),
      );

      final ok = await service.kirimPengajuan(Pengajuan(
        kodeRuang: 'TULT-0604',
        tanggal: DateTime(2026, 11, 20),
        jamMulai: '08:00',
        jamSelesai: '10:00',
        keperluan: 'Rapat',
      ));
      expect(ok, isTrue);
    });
  });

  test('Ruang toJson lalu fromJson menghasilkan data yang sama', () {
    final json = contohRuang.toJson();
    final balik = Ruang.fromJson(json);
    expect(balik.kode, contohRuang.kode);
    expect(balik.tersediaMulai, contohRuang.tersediaMulai);
    expect(json['tersediaMulai'], '2026-11-12T07:00:00.000');
  });
}
