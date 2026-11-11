import '../entities/kios.dart';
import '../repositories/kios_repository.dart';

class GetDaftarKiosUseCase {
  final KiosRepository repository;
  GetDaftarKiosUseCase(this.repository);

  List<Kios> execute() => repository.getDaftarKios();
}
