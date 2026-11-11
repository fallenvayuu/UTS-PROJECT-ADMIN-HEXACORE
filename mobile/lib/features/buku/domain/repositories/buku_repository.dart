import '../entities/buku.dart';
import '../entities/buku_temuan.dart';
import '../entities/kategori.dart';

abstract class BukuRepository {
  Future<List<Buku>> getBukuList();
  Future<Buku> createBuku(Buku buku);
  List<KategoriRingkas> getKategoriRingkas();
  List<KategoriTematik> getKategoriTematik();
  List<BukuTemuan> getBukuTemuan();
}
