import 'package:flutter/material.dart';

import '../config.dart';
import '../services/ruang_service.dart';
import 'halaman_gedung.dart';

/// Tab Profil: identitas pengguna dan akses ke daftar gedung.
class HalamanProfil extends StatelessWidget {
  final RuangService service;

  const HalamanProfil({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset('assets/images/logo.png', width: 96),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Muhammad Alif Mikail Widayaka',
            textAlign: TextAlign.center,
            style: teks.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Center(
          child: Text(
            'NIM 102022300094 · S1 Sistem Informasi',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.apartment_rounded, color: cs.primary),
                title: const Text('Daftar Gedung'),
                subtitle: const Text('Gedung dan jumlah ruangnya'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HalamanGedung(service: service),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.group_rounded, color: cs.primary),
                title: const Text('Kelompok'),
                subtitle: const Text('Kelompok 08 · RuangPinjam'),
              ),
              ListTile(
                leading: Icon(Icons.dns_rounded, color: cs.primary),
                title: const Text('Alamat API'),
                subtitle: const Text(apiUrl),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
