import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/buku.dart';
import '../../domain/usecases/get_buku_list_usecase.dart';

class StokKategoriViewModel extends ChangeNotifier {
  final GetBukuListUseCase getBukuListUseCase;

  List<Buku> _buku = const [];
  String _tanda = '';
  bool _termuat = false;
  bool _sedangMuat = false;
  String? _error;
  Timer? _timer;
  int _pemantau = 0;

  StokKategoriViewModel({required this.getBukuListUseCase});

  bool get termuat => _termuat;
  String? get error => _error;
  List<Buku> get buku => _buku;

  int? jumlah(List<String> kategori) {
    if (!_termuat || kategori.isEmpty) return null;
    return bukuUntuk(kategori).fold<int>(0, (s, b) => s + b.jumlah);
  }

  List<Buku> bukuUntuk(List<String> kategori) =>
      _buku.where((b) => kategori.contains(b.kategori)).toList();

  void mulaiPantau({Duration setiap = const Duration(seconds: 10)}) {
    _pemantau++;
    muat();
    _timer ??= Timer.periodic(setiap, (_) => muat());
  }

  void berhenti() {
    if (_pemantau > 0) _pemantau--;
    if (_pemantau == 0) {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<void> muat() async {
    if (_sedangMuat) return;
    _sedangMuat = true;
    var berubah = false;
    try {
      final data = await getBukuListUseCase.execute();
      final tanda = data
          .map((b) => '${b.id}|${b.tanggal}|${b.judul}|${b.kategori}|${b.penulis}|${b.jumlah}|${b.pemasok}|${b.harga}')
          .join('\n');
      berubah = !_termuat || _error != null || tanda != _tanda;
      _buku = data;
      _tanda = tanda;
      _termuat = true;
      _error = null;
    } catch (e) {
      final pesan = e.toString();
      berubah = _error != pesan;
      _error = pesan;
    } finally {
      _sedangMuat = false;
      if (berubah) notifyListeners();
    }
  }
}
