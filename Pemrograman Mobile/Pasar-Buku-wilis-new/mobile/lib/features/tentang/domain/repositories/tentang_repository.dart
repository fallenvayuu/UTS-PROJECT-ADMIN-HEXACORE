import '../entities/faq.dart';

abstract class TentangRepository {
  List<Faq> getFaqList();
  List<FasilitasPengunjung> getFasilitasPengunjungList();
}

class GetFaqUseCase {
  final TentangRepository repository;
  GetFaqUseCase(this.repository);

  List<Faq> execute() => repository.getFaqList();
}

class GetFasilitasPengunjungUseCase {
  final TentangRepository repository;
  GetFasilitasPengunjungUseCase(this.repository);

  List<FasilitasPengunjung> execute() => repository.getFasilitasPengunjungList();
}
