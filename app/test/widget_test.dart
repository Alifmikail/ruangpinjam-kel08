import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ruang_pinjam/main.dart';
import 'package:ruang_pinjam/models/pengajuan.dart';
import 'package:ruang_pinjam/pages/halaman_form_pengajuan.dart';
import 'package:ruang_pinjam/pages/halaman_pengajuan.dart';
import 'package:ruang_pinjam/widgets/kartu_ruang.dart';

import 'data_contoh.dart';

Widget bungkus(Widget anak) => MaterialApp(home: Scaffold(body: anak));

void main() {
  testWidgets('KartuRuang menampilkan kode, gedung, dan jenis ruang',
      (tester) async {
    await tester.pumpWidget(bungkus(KartuRuang(ruang: contohRuang)));

    expect(find.text('TULT-0604'), findsOneWidget);
    expect(find.text('TULT'), findsOneWidget);
    expect(find.text('Kelas'), findsOneWidget);
    expect(find.text('40 orang'), findsOneWidget);
  });

  testWidgets('Aplikasi memuat daftar ruang lalu bisa difilter jenis Lab',
      (tester) async {
    await tester.pumpWidget(RuangPinjamApp(service: serviceBerhasil()));

    // keadaan memuat
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    // keadaan berhasil, ada 3 tab di NavigationBar
    expect(find.byType(NavigationDestination), findsNWidgets(3));
    expect(find.byType(KartuRuang), findsNWidgets(3));

    // SegmentedButton: pilih Lab
    await tester.tap(find.text('Lab').first);
    await tester.pumpAndSettle();
    expect(find.byType(KartuRuang), findsOneWidget);
    expect(find.text('TULT-1401'), findsOneWidget);
  });

  testWidgets('Pencarian kode ruang menyaring daftar', (tester) async {
    await tester.pumpWidget(RuangPinjamApp(service: serviceBerhasil()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('cari-kode')), '1601');
    await tester.pumpAndSettle();

    expect(find.byType(KartuRuang), findsOneWidget);
    expect(find.text('TULT-1601'), findsOneWidget);
  });

  testWidgets('Keadaan gagal menampilkan tombol Coba lagi', (tester) async {
    await tester.pumpWidget(RuangPinjamApp(service: serviceGagal()));
    await tester.pumpAndSettle();

    expect(find.text('Gagal memuat data ruang'), findsOneWidget);
    expect(find.text('Coba lagi'), findsOneWidget);
  });

  testWidgets('Form kosong memunculkan SnackBar peringatan', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HalamanFormPengajuan()),
    );

    await tester.tap(find.text('Kirim Pengajuan'));
    await tester.pump();

    expect(find.text('Kode ruang wajib diisi'), findsOneWidget);
  });

  testWidgets('HalamanPengajuan menampilkan status dan bisa disetujui',
      (tester) async {
    var indexDisetujui = -1;
    final daftar = [
      Pengajuan(
        kodeRuang: 'TULT-0604',
        tanggal: DateTime(2026, 11, 20),
        jamMulai: '08:00',
        jamSelesai: '10:00',
        keperluan: 'Rapat himpunan',
      ),
    ];

    await tester.pumpWidget(bungkus(HalamanPengajuan(
      daftar: daftar,
      onSetujui: (i) => indexDisetujui = i,
    )));

    expect(find.text('Menunggu'), findsOneWidget);
    expect(find.text('20 Nov 2026 · 08:00–10:00'), findsOneWidget);

    await tester.tap(find.byTooltip('Tandai disetujui'));
    expect(indexDisetujui, 0);
  });
}
