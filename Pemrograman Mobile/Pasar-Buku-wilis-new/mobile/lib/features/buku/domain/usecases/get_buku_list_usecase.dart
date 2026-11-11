import '../entities/buku.dart';
import '../repositories/buku_repository.dart';

class GetBukuListUseCase {
  final BukuRepository repository;
  GetBukuListUseCase(this.repository);

  Future<List<Buku>> execute() => repository.getBukuList();
}
