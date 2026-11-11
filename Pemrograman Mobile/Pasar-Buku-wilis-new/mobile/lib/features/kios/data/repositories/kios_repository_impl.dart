import '../../domain/entities/buku_populer.dart';
import '../../domain/entities/kios.dart';
import '../../domain/repositories/kios_repository.dart';
import '../datasources/kios_local_datasource.dart';

class KiosRepositoryImpl implements KiosRepository {
  final KiosLocalDataSource localDataSource;

  KiosRepositoryImpl(this.localDataSource);

  @override
  List<Kios> getDaftarKios() => localDataSource.getDaftarKios();

  @override
  List<BukuPopuler> getBukuPopuler() => localDataSource.getBukuPopuler();

  @override
  List<Fasilitas> getFasilitasPublik() => localDataSource.getFasilitasPublik();
}
