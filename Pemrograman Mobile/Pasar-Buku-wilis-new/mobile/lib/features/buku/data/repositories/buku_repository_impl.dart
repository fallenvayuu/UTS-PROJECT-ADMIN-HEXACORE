import '../../domain/entities/buku.dart';
import '../../domain/entities/buku_temuan.dart';
import '../../domain/entities/kategori.dart';
import '../../domain/repositories/buku_repository.dart';
import '../datasources/buku_local_datasource.dart';
import '../datasources/buku_remote_datasource.dart';
import '../models/buku_model.dart';

class BukuRepositoryImpl implements BukuRepository {
  final BukuRemoteDataSource remoteDataSource;
  final BukuLocalDataSource localDataSource;

  BukuRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Buku>> getBukuList() async {
    final list = await remoteDataSource.getBuku();
    return list;
  }

  @override
  Future<Buku> createBuku(Buku buku) async {
    final model = BukuModel.fromEntity(buku);
    return await remoteDataSource.createBuku(model);
  }

  @override
  List<KategoriRingkas> getKategoriRingkas() => localDataSource.getKategoriRingkas();

  @override
  List<KategoriTematik> getKategoriTematik() => localDataSource.getKategoriTematik();

  @override
  List<BukuTemuan> getBukuTemuan() => localDataSource.getBukuTemuan();
}
