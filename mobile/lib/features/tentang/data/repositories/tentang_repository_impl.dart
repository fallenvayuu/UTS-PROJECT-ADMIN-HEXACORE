import '../../domain/entities/faq.dart';
import '../../domain/repositories/tentang_repository.dart';
import '../datasources/tentang_local_datasource.dart';

class TentangRepositoryImpl implements TentangRepository {
  final TentangLocalDataSource localDataSource;

  TentangRepositoryImpl(this.localDataSource);

  @override
  List<Faq> getFaqList() => localDataSource.getFaqList();

  @override
  List<FasilitasPengunjung> getFasilitasPengunjungList() =>
      localDataSource.getFasilitasPengunjungList();
}
