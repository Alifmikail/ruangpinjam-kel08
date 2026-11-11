import 'package:flutter/material.dart';

import '../models/pengajuan.dart';
import '../models/ruang.dart';
import '../utils/format.dart';

/// Form tambah: pengajuan peminjaman ruang.
/// Hasilnya dikembalikan lewat Navigator.pop(context, pengajuan).
class HalamanFormPengajuan extends StatefulWidget {
  final Ruang? ruangAwal;

  const HalamanFormPengajuan({super.key, this.ruangAwal});

  @override
  State<HalamanFormPengajuan> createState() => _HalamanFormPengajuanState();
}

class _HalamanFormPengajuanState extends State<HalamanFormPengajuan> {
  late final TextEditingController _kodeController;
  final TextEditingController _keperluanController = TextEditingController();

  DateTime? _tanggal;
  TimeOfDay? _jamMulai;
  TimeOfDay? _jamSelesai;

  @override
  void initState() {
    super.initState();
    _kodeController =
        TextEditingController(text: widget.ruangAwal?.kode ?? '');
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _keperluanController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final sekarang = DateTime.now();
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? sekarang,
      firstDate: DateTime(sekarang.year, sekarang.month, sekarang.day),
      lastDate: sekarang.add(const Duration(days: 90)),
      helpText: 'Pilih tanggal peminjaman',
    );
    if (!mounted || hasil == null) return;
    setState(() => _tanggal = hasil);
  }

  Future<void> _pilihJam({required bool mulai}) async {
    final hasil = await showTimePicker(
      context: context,
      initialTime: (mulai ? _jamMulai : _jamSelesai) ??
          const TimeOfDay(hour: 8, minute: 0),
      helpText: mulai ? 'Jam mulai' : 'Jam selesai',
    );
    if (!mounted || hasil == null) return;
    setState(() {
      if (mulai) {
        _jamMulai = hasil;
      } else {
        _jamSelesai = hasil;
      }
    });
  }

  int _menit(TimeOfDay t) => t.hour * 60 + t.minute;

  void _simpan() {
    final kode = _kodeController.text.trim();
    final keperluan = _keperluanController.text.trim();

    String? galat;
    if (kode.isEmpty) {
      galat = 'Kode ruang wajib diisi';
    } else if (_tanggal == null) {
      galat = 'Tanggal belum dipilih';
    } else if (_jamMulai == null || _jamSelesai == null) {
      galat = 'Jam mulai dan selesai belum dipilih';
    } else if (_menit(_jamSelesai!) <= _menit(_jamMulai!)) {
      galat = 'Jam selesai harus setelah jam mulai';
    } else if (keperluan.isEmpty) {
      galat = 'Keperluan wajib diisi';
    }

    if (galat != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(galat)));
      return;
    }

    final pengajuan = Pengajuan(
      kodeRuang: kode.toUpperCase(),
      tanggal: _tanggal!,
      jamMulai: formatJam(_jamMulai!.hour, _jamMulai!.minute),
      jamSelesai: formatJam(_jamSelesai!.hour, _jamSelesai!.minute),
      keperluan: keperluan,
    );
    Navigator.pop(context, pengajuan);
  }

  @override
  Widget build(BuildContext context) {
    final jamMulai = _jamMulai == null
        ? 'Jam mulai'
        : formatJam(_jamMulai!.hour, _jamMulai!.minute);
    final jamSelesai = _jamSelesai == null
        ? 'Jam selesai'
        : formatJam(_jamSelesai!.hour, _jamSelesai!.minute);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajukan Peminjaman')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            key: const Key('input-kode'),
            controller: _kodeController,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Kode ruang',
              hintText: 'mis. TULT-0604',
              prefixIcon: Icon(Icons.meeting_room_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pilihTanggal,
            icon: const Icon(Icons.calendar_month_rounded),
            label: Text(
              _tanggal == null ? 'Pilih tanggal' : formatTanggal(_tanggal!),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pilihJam(mulai: true),
                  icon: const Icon(Icons.schedule_rounded),
                  label: Text(jamMulai),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pilihJam(mulai: false),
                  icon: const Icon(Icons.schedule_rounded),
                  label: Text(jamSelesai),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('input-keperluan'),
            controller: _keperluanController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Keperluan',
              hintText: 'mis. Rapat himpunan, praktikum pengganti',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _simpan,
            icon: const Icon(Icons.send_rounded),
            label: const Text('Kirim Pengajuan'),
          ),
        ],
      ),
    );
  }
}
