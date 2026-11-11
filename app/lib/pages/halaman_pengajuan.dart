import 'package:flutter/material.dart';

import '../models/pengajuan.dart';
import '../utils/format.dart';
import '../widgets/label_status.dart';

/// Tab Pengajuan Saya: daftar pengajuan yang dibuat dari form tambah.
class HalamanPengajuan extends StatelessWidget {
  final List<Pengajuan> daftar;
  final ValueChanged<int> onSetujui;

  const HalamanPengajuan({
    super.key,
    required this.daftar,
    required this.onSetujui,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    if (daftar.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/kosong.png', width: 220),
              const SizedBox(height: 16),
              Text('Belum ada pengajuan', style: teks.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Tekan tombol Ajukan untuk meminjam ruang.',
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: daftar.length,
      itemBuilder: (context, i) {
        final p = daftar[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            p.kodeRuang,
                            style: teks.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          LabelStatus(status: p.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatTanggal(p.tanggal)} · ${p.jamMulai}–${p.jamSelesai}',
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 2),
                      Text(p.keperluan),
                    ],
                  ),
                ),
                if (p.status == StatusPengajuan.menunggu)
                  IconButton(
                    tooltip: 'Tandai disetujui',
                    icon: Icon(Icons.task_alt_rounded, color: cs.primary),
                    onPressed: () => onSetujui(i),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
