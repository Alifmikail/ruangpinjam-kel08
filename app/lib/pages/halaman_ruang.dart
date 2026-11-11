import 'package:flutter/material.dart';

import '../models/ruang.dart';
import '../services/ruang_service.dart';
import '../widgets/kartu_ruang.dart';
import 'halaman_detail.dart';

/// Tab Ruang: daftar ruang dari API dengan filter jenis dan pencarian kode.
class HalamanRuang extends StatefulWidget {
  final RuangService service;
  final ValueChanged<Ruang> onAjukan;

  const HalamanRuang({
    super.key,
    required this.service,
    required this.onAjukan,
  });

  @override
  State<HalamanRuang> createState() => _HalamanRuangState();
}

class _HalamanRuangState extends State<HalamanRuang> {
  static const _pilihanJenis = ['Semua', 'Kelas', 'Lab', 'Aula'];

  late Future<List<Ruang>> _futureRuang;
  final TextEditingController _cariController = TextEditingController();
  String _jenisDipilih = 'Semua';
  String _kataKunci = '';

  @override
  void initState() {
    super.initState();
    _futureRuang = widget.service.ambilDaftarRuang();
  }

  @override
  void dispose() {
    _cariController.dispose();
    super.dispose();
  }

  Future<void> _muatUlang() async {
    setState(() {
      _futureRuang = widget.service.ambilDaftarRuang();
    });
    try {
      await _futureRuang;
    } catch (_) {
      // keadaan gagal ditangani FutureBuilder
    }
  }

  List<Ruang> _saring(List<Ruang> semua) {
    return semua.where((r) {
      final cocokJenis = _jenisDipilih == 'Semua' || r.jenis == _jenisDipilih;
      final cocokKode =
          r.kode.toLowerCase().contains(_kataKunci.toLowerCase());
      return cocokJenis && cocokKode;
    }).toList();
  }

  Future<void> _bukaDetail(Ruang ruang) async {
    // Halaman detail menerima objek Ruang lewat konstruktor,
    // dan mengembalikan true bila pengguna menekan "Ajukan Peminjaman".
    final ajukan = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => HalamanDetail(ruang: ruang)),
    );
    if (!mounted) return;
    if (ajukan == true) widget.onAjukan(ruang);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            key: const Key('cari-kode'),
            controller: _cariController,
            onChanged: (v) => setState(() => _kataKunci = v),
            decoration: InputDecoration(
              hintText: 'Cari kode ruang, mis. TULT-0604',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _kataKunci.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Hapus pencarian',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _cariController.clear();
                        setState(() => _kataKunci = '');
                      },
                    ),
              filled: true,
              fillColor: cs.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: _pilihanJenis
                  .map((j) => ButtonSegment(value: j, label: Text(j)))
                  .toList(),
              selected: {_jenisDipilih},
              onSelectionChanged: (pilih) =>
                  setState(() => _jenisDipilih = pilih.first),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<List<Ruang>>(
            future: _futureRuang,
            builder: (context, snapshot) {
              // 1) Memuat
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              // 2) Gagal, dengan tombol Coba lagi
              if (snapshot.hasError) {
                return _TampilanGagal(
                  pesan: '${snapshot.error}',
                  onCobaLagi: _muatUlang,
                );
              }
              // 3) Berhasil
              final daftar = _saring(snapshot.data ?? []);
              return RefreshIndicator(
                onRefresh: _muatUlang,
                child: daftar.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(child: Text('Tidak ada ruang yang cocok')),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 96),
                        itemCount: daftar.length,
                        itemBuilder: (context, i) => KartuRuang(
                          ruang: daftar[i],
                          onTap: () => _bukaDetail(daftar[i]),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TampilanGagal extends StatelessWidget {
  final String pesan;
  final VoidCallback onCobaLagi;

  const _TampilanGagal({required this.pesan, required this.onCobaLagi});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64, color: cs.error),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat data ruang',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              pesan,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onCobaLagi,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
