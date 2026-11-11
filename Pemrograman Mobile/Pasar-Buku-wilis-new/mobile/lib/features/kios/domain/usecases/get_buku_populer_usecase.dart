import '../entities/buku_populer.dart';
import '../repositories/kios_repository.dart';

class GetBukuPopulerUseCase {
  final KiosRepository repository;
  GetBukuPopulerUseCase(this.repository);

  List<BukuPopuler> execute() => repository.getBukuPopuler();
}
