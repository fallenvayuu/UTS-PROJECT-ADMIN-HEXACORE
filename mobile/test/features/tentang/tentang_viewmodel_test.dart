import 'package:flutter_test/flutter_test.dart';
import 'package:wilis_mobile/features/tentang/domain/entities/faq.dart';
import 'package:wilis_mobile/features/tentang/domain/repositories/tentang_repository.dart';
import 'package:wilis_mobile/features/tentang/presentation/viewmodels/tentang_viewmodel.dart';

/// Repository palsu: data bisa diatur dan kegagalan bisa dipicu dari test.
class _RepoPalsu implements TentangRepository {
  List<Faq> faq = const [Faq('Tanya 1', 'Jawab 1'), Faq('Tanya 2', 'Jawab 2')];
  List<FasilitasPengunjung> fasilitas = const [FasilitasPengunjung('Parkir', 'Luas')];
  Object? galatFaq;
  Object? galatFasilitas;

  @override
  List<Faq> getFaqList() {
    if (galatFaq != null) throw galatFaq!;
    return faq;
  }

  @override
  List<FasilitasPengunjung> getFasilitasPengunjungList() {
    if (galatFasilitas != null) throw galatFasilitas!;
    return fasilitas;
  }
}

void main() {
  late _RepoPalsu repo;
  late TentangViewModel vm;

  setUp(() {
    repo = _RepoPalsu();
    vm = TentangViewModel(
      getFaqUseCase: GetFaqUseCase(repo),
      getFasilitasPengunjungUseCase: GetFasilitasPengunjungUseCase(repo),
    );
  });

  tearDown(() => vm.dispose());

  test('keadaan awal: belum memuat, kosong, tanpa error', () {
    expect(vm.termuat, isFalse);
    expect(vm.sedangMuat, isFalse);
    expect(vm.error, isNull);
    expect(vm.faqList, isEmpty);
    expect(vm.fasilitasList, isEmpty);
  });

  test('muat sukses: data terisi dan error kosong', () {
    vm.muat();

    expect(vm.termuat, isTrue);
    expect(vm.sedangMuat, isFalse);
    expect(vm.error, isNull);
    expect(vm.faqList.map((f) => f.tanya), ['Tanya 1', 'Tanya 2']);
    expect(vm.fasilitasList.single.nama, 'Parkir');
  });

  test('listener dikabari: status memuat menyala lalu mati', () {
    final status = <bool>[];
    vm.addListener(() => status.add(vm.sedangMuat));

    vm.muat();

    expect(status, [true, false]);
  });

  test('muat gagal pada FAQ: error terisi dan belum termuat', () {
    repo.galatFaq = Exception('server mati');

    vm.muat();

    expect(vm.termuat, isFalse);
    expect(vm.sedangMuat, isFalse);
    expect(vm.error, contains('server mati'));
    expect(vm.faqList, isEmpty);
  });

  test('muat gagal pada fasilitas: data tidak setengah terisi', () {
    repo.galatFasilitas = Exception('gagal fasilitas');

    vm.muat();

    expect(vm.error, contains('gagal fasilitas'));
    expect(vm.faqList, isEmpty);
    expect(vm.fasilitasList, isEmpty);
  });

  test('coba lagi setelah gagal: error hilang dan data termuat', () {
    repo.galatFaq = Exception('gagal');
    vm.muat();
    expect(vm.error, isNotNull);

    repo.galatFaq = null;
    vm.muat();

    expect(vm.error, isNull);
    expect(vm.termuat, isTrue);
    expect(vm.faqList, hasLength(2));
  });

  test('muat ulang yang gagal tidak menghapus data lama', () {
    vm.muat();
    expect(vm.termuat, isTrue);

    repo.galatFaq = Exception('putus');
    vm.muat();

    expect(vm.error, contains('putus'));
    expect(vm.termuat, isTrue);
    expect(vm.faqList, hasLength(2));
  });
}
