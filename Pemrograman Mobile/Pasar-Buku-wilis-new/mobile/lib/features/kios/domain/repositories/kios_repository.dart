import '../entities/buku_populer.dart';
import '../entities/kios.dart';

abstract class KiosRepository {
  List<Kios> getDaftarKios();
  List<BukuPopuler> getBukuPopuler();
  List<Fasilitas> getFasilitasPublik();
}
