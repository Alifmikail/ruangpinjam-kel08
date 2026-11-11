import 'package:flutter/material.dart';

import '../models/ruang.dart';
import '../utils/format.dart';

IconData ikonJenis(String jenis) {
  switch (jenis) {
    case 'Lab':
      return Icons.computer_rounded;
    case 'Aula':
      return Icons.groups_rounded;
    default:
      return Icons.meeting_room_rounded;
  }
}

/// Kartu ruang buatan sendiri: memakai Row, Column, Expanded, dan Stack.
class KartuRuang extends StatelessWidget {
  final Ruang ruang;
  final VoidCallback? onTap;

  const KartuRuang({super.key, required this.ruang, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Stack: kotak ikon + lencana proyektor di sudutnya
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: 'ruang-${ruang.id}',
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        ikonJenis(ruang.jenis),
                        color: cs.onPrimaryContainer,
                        size: 30,
                      ),
                    ),
                  ),
                  if (ruang.adaProyektor)
                    Positioned(
                      right: -6,
                      bottom: -6,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: cs.tertiary,
                        child: Icon(
                          Icons.videocam_rounded,
                          size: 14,
                          color: cs.onTertiary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ruang.kode,
                      style: teks.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ruang.gedung,
                      style: teks.bodyMedium
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.people_alt_outlined,
                            size: 16, color: cs.primary),
                        const SizedBox(width: 4),
                        Text('${ruang.kapasitas} orang',
                            style: teks.bodySmall),
                        const SizedBox(width: 12),
                        Icon(Icons.schedule_rounded,
                            size: 16, color: cs.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formatTanggalJam(ruang.tersediaMulai),
                            style: teks.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(ruang.jenis),
                visualDensity: VisualDensity.compact,
                backgroundColor: cs.secondaryContainer,
                labelStyle: TextStyle(color: cs.onSecondaryContainer),
                side: BorderSide.none,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
