import 'package:flutter/foundation.dart';

import '../../domain/entities/buku_populer.dart';
import '../../domain/entities/kios.dart';
import '../../domain/usecases/get_buku_populer_usecase.dart';
import '../../domain/usecases/get_daftar_kios_usecase.dart';
import '../../domain/usecases/get_fasilitas_usecase.dart';

class DenahViewModel extends ChangeNotifier {
  final GetDaftarKiosUseCase getDaftarKiosUseCase;
  final GetBukuPopulerUseCase getBukuPopulerUseCase;
  final GetFasilitasPublikUseCase getFasilitasPublikUseCase;

  late final List<Kios> daftarKios;
  late final List<BukuPopuler> bukuPopuler;
  late final List<Fasilitas> fasilitasPublik;

  int _terpilih = 3; // Kios A-04 default
  double _zoom = 1.0;
  bool _tidakDitemukan = false;
  final Set<String> _disimpan = {};

  DenahViewModel({
    required this.getDaftarKiosUseCase,
    required this.getBukuPopulerUseCase,
    required this.getFasilitasPublikUseCase,
  }) {
    daftarKios = getDaftarKiosUseCase.execute();
    bukuPopuler = getBukuPopulerUseCase.execute();
    fasilitasPublik = getFasilitasPublikUseCase.execute();
  }

  int get terpilih => _terpilih;
  double get zoom => _zoom;
  bool get tidakDitemukan => _tidakDitemukan;
  Kios get kiosTerpilih => daftarKios[_terpilih];
  bool isDisimpan(String kode) => _disimpan.contains(kode);

  void setTerpilih(int index) {
    if (index >= 0 && index < daftarKios.length) {
      _terpilih = index;
      _tidakDitemukan = false;
      notifyListeners();
    }
  }

  void cariKios(String teks) {
    final q = teks.toLowerCase().replaceAll('kios', '').trim();
    if (q.isEmpty) {
      _tidakDitemukan = false;
      notifyListeners();
      return;
    }
    final i = daftarKios.indexWhere(
        (k) => k.kode.toLowerCase().contains(q) || k.nama.toLowerCase().contains(q));
    _tidakDitemukan = i < 0;
    if (i >= 0) _terpilih = i;
    notifyListeners();
  }

  void ubahZoom(double nilai) {
    _zoom = nilai.clamp(1.0, 1.8).toDouble();
    notifyListeners();
  }

  void toggleSimpan(String kode) {
    if (_disimpan.contains(kode)) {
      _disimpan.remove(kode);
    } else {
      _disimpan.add(kode);
    }
    notifyListeners();
  }
}
