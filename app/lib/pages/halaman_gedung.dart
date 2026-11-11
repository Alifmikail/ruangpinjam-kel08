import 'package:flutter/material.dart';

import '../models/ruang.dart';
import '../services/ruang_service.dart';

/// Menampilkan hasil endpoint khas GET /gedung.
class HalamanGedung extends StatefulWidget {
  final RuangService service;

  const HalamanGedung({super.key, required this.service});

  @override
  State<HalamanGedung> createState() => _HalamanGedungState();
}

class _HalamanGedungState extends State<HalamanGedung> {
  late Future<List<Gedung>> _futureGedung;

  @override
  void initState() {
    super.initState();
    _futureGedung = widget.service.ambilGedung();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Gedung')),
      body: FutureBuilder<List<Gedung>>(
        future: _futureGedung,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gagal memuat gedung',
                      style: TextStyle(color: cs.error)),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => setState(() {
                      _futureGedung = widget.service.ambilGedung();
                    }),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final daftar = snapshot.data ?? [];
          return ListView.builder(
            itemCount: daftar.length,
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.primaryContainer,
                child: Icon(Icons.apartment_rounded,
                    color: cs.onPrimaryContainer),
              ),
              title: Text(daftar[i].nama),
              trailing: Text('${daftar[i].jumlahRuang} ruang'),
            ),
          );
        },
      ),
    );
  }
}
