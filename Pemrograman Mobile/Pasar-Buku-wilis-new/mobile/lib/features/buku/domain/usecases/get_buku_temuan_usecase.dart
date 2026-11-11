import '../entities/buku_temuan.dart';
import '../repositories/buku_repository.dart';

class GetBukuTemuanUseCase {
  final BukuRepository repository;
  GetBukuTemuanUseCase(this.repository);

  List<BukuTemuan> execute() => repository.getBukuTemuan();
}
