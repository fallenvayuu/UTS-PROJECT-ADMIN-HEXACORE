import '../entities/buku.dart';
import '../repositories/buku_repository.dart';

class CreateBukuUseCase {
  final BukuRepository repository;
  CreateBukuUseCase(this.repository);

  Future<Buku> execute(Buku buku) => repository.createBuku(buku);
}
