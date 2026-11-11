import 'package:flutter/material.dart';

import '../models/pengajuan.dart';

/// Penanda status pengajuan. Warnanya diambil dari colorScheme.
class LabelStatus extends StatelessWidget {
  final StatusPengajuan status;

  const LabelStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final disetujui = status == StatusPengajuan.disetujui;
    final latar = disetujui ? cs.primaryContainer : cs.tertiaryContainer;
    final depan = disetujui ? cs.onPrimaryContainer : cs.onTertiaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            disetujui ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
            size: 14,
            color: depan,
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: depan,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
