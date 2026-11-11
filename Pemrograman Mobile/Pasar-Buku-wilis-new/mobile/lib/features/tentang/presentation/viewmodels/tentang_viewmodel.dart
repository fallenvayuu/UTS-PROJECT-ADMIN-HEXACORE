import 'package:flutter/foundation.dart';

import '../../domain/entities/faq.dart';
import '../../domain/repositories/tentang_repository.dart';

/// ViewModel halaman Tentang: memegang data FAQ dan fasilitas beserta
/// status memuat / gagal. State lokal tampilan (FAQ mana yang terbuka)
/// tetap di widget karena hanya dipakai satu halaman (ephemeral state).
class TentangViewModel extends ChangeNotifier {
  final GetFaqUseCase getFaqUseCase;
  final GetFasilitasPengunjungUseCase getFasilitasPengunjungUseCase;

  List<Faq> _faqList = const [];
  List<FasilitasPengunjung> _fasilitasList = const [];
  bool _sedangMuat = false;
  bool _termuat = false;
  String? _error;

  TentangViewModel({
    required this.getFaqUseCase,
    required this.getFasilitasPengunjungUseCase,
  });

  List<Faq> get faqList => _faqList;
  List<FasilitasPengunjung> get fasilitasList => _fasilitasList;
  bool get sedangMuat => _sedangMuat;
  bool get termuat => _termuat;
  String? get error => _error;

  /// Memuat data. Use case saat ini sinkron (data lokal), jadi seluruh proses
  /// selesai seketika. Bila nanti sumber datanya berubah menjadi Future,
  /// ubah method ini menjadi async dan tambahkan await pada pemanggilan use case.
  void muat() {
    if (_sedangMuat) return;
    _sedangMuat = true;
    _error = null;
    notifyListeners();
    try {
      final faq = getFaqUseCase.execute();
      final fasilitas = getFasilitasPengunjungUseCase.execute();
      _faqList = faq;
      _fasilitasList = fasilitas;
      _termuat = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _sedangMuat = false;
      notifyListeners();
    }
  }
}
