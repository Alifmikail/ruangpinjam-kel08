import 'package:flutter/material.dart';

import '../models/ruang.dart';
import '../utils/format.dart';
import '../widgets/kartu_ruang.dart';

/// Halaman detail: menerima objek Ruang lewat konstruktor.
class HalamanDetail extends StatelessWidget {
  final Ruang ruang;

  const HalamanDetail({super.key, required this.ruang});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(ruang.kode)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Hero(
              tag: 'ruang-${ruang.id}',
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  ikonJenis(ruang.jenis),
                  size: 60,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              ruang.kode,
              style: teks.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: Text(
              ruang.gedung,
              style: teks.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                _Info(
                  ikon: Icons.category_rounded,
                  label: 'Jenis ruang',
                  nilai: ruang.jenis,
                ),
                _Info(
                  ikon: Icons.people_alt_rounded,
                  label: 'Kapasitas',
                  nilai: '${ruang.kapasitas} orang',
                ),
                _Info(
                  ikon: Icons.videocam_rounded,
                  label: 'Proyektor',
                  nilai: ruang.adaProyektor ? 'Tersedia' : 'Tidak ada',
                ),
                _Info(
                  ikon: Icons.event_available_rounded,
                  label: 'Tersedia mulai',
                  nilai: formatTanggalJam(ruang.tersediaMulai),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.edit_calendar_rounded),
            label: const Text('Ajukan Peminjaman'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;

  const _Info({required this.ikon, required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(ikon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: Text(
        nilai,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
