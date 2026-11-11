import '../entities/kategori.dart';
import '../repositories/buku_repository.dart';

class GetKategoriTematikUseCase {
  final BukuRepository repository;
  GetKategoriTematikUseCase(this.repository);

  List<KategoriTematik> execute() => repository.getKategoriTematik();
}
