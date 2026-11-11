import '../entities/kategori.dart';
import '../repositories/buku_repository.dart';

class GetKategoriRingkasUseCase {
  final BukuRepository repository;
  GetKategoriRingkasUseCase(this.repository);

  List<KategoriRingkas> execute() => repository.getKategoriRingkas();
}
