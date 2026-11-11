import 'package:flutter/material.dart';

import '../models/pengajuan.dart';
import '../models/ruang.dart';
import '../services/ruang_service.dart';
import 'halaman_form_pengajuan.dart';
import 'halaman_pengajuan.dart';
import 'halaman_profil.dart';
import 'halaman_ruang.dart';

/// Kerangka utama: NavigationBar 3 tab + IndexedStack.
class HalamanUtama extends StatefulWidget {
  final RuangService service;

  const HalamanUtama({super.key, required this.service});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _indexTab = 0;

  /// Data dari form tambah disimpan di memori aplikasi (State).
  final List<Pengajuan> _daftarPengajuan = [];

  Future<void> _bukaForm({Ruang? ruang}) async {
    // Form mengembalikan data lewat Navigator.pop(context, pengajuan)
    final hasil = await Navigator.push<Pengajuan>(
      context,
      MaterialPageRoute(
        builder: (_) => HalamanFormPengajuan(ruangAwal: ruang),
      ),
    );

    // Cek mounted sebelum memakai context setelah await
    if (!mounted || hasil == null) return;

    setState(() {
      _daftarPengajuan.insert(0, hasil);
      _indexTab = 1; // langsung tampilkan di tab Pengajuan Saya
    });

    // Nilai tambah: kirim juga ke server dengan POST
    var terkirim = false;
    try {
      terkirim = await widget.service.kirimPengajuan(hasil);
    } catch (_) {
      terkirim = false;
    }
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          terkirim
              ? 'Pengajuan ${hasil.kodeRuang} terkirim ke server'
              : 'Pengajuan ${hasil.kodeRuang} disimpan (server tidak terjangkau)',
        ),
      ),
    );
  }

  void _setujui(int index) {
    setState(() {
      _daftarPengajuan[index] =
          _daftarPengajuan[index].copyWith(status: StatusPengajuan.disetujui);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Pengajuan ${_daftarPengajuan[index].kodeRuang} disetujui'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const judul = ['Ruang', 'Pengajuan Saya', 'Profil'];

    return Scaffold(
      appBar: AppBar(title: Text(judul[_indexTab])),
      body: IndexedStack(
        index: _indexTab,
        children: [
          HalamanRuang(
            service: widget.service,
            onAjukan: (ruang) => _bukaForm(ruang: ruang),
          ),
          HalamanPengajuan(
            daftar: _daftarPengajuan,
            onSetujui: _setujui,
          ),
          HalamanProfil(service: widget.service),
        ],
      ),
      floatingActionButton: _indexTab == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _bukaForm(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Ajukan'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexTab,
        onDestinationSelected: (i) => setState(() => _indexTab = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.meeting_room_outlined),
            selectedIcon: Icon(Icons.meeting_room_rounded),
            label: 'Ruang',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _daftarPengajuan.isNotEmpty,
              label: Text('${_daftarPengajuan.length}'),
              child: const Icon(Icons.assignment_outlined),
            ),
            selectedIcon: const Icon(Icons.assignment_rounded),
            label: 'Pengajuan Saya',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
