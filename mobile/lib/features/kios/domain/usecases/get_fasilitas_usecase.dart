import '../entities/buku_populer.dart';
import '../repositories/kios_repository.dart';

class GetFasilitasPublikUseCase {
  final KiosRepository repository;
  GetFasilitasPublikUseCase(this.repository);

  List<Fasilitas> execute() => repository.getFasilitasPublik();
}
