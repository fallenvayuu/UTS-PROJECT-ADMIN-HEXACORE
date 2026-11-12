import 'package:flutter_test/flutter_test.dart';
import 'package:wilis_mobile/features/kios/domain/entities/buku_populer.dart';
import 'package:wilis_mobile/features/kios/domain/entities/kios.dart';
import 'package:wilis_mobile/features/kios/domain/repositories/kios_repository.dart';
import 'package:wilis_mobile/features/kios/domain/usecases/get_buku_populer_usecase.dart';
import 'package:wilis_mobile/features/kios/domain/usecases/get_daftar_kios_usecase.dart';
import 'package:wilis_mobile/features/kios/domain/usecases/get_fasilitas_usecase.dart';
import 'package:wilis_mobile/features/kios/presentation/viewmodels/denah_viewmodel.dart';

Kios _kios(String kode, String nama) => Kios(
      kode: kode,
      nama: nama,
      pemilik: 'Pak Dar',
      spesialisasi: const ['Novel'],
      jumlahArsip: '100',
    );

/// Repository palsu dengan 5 kios, supaya indeks bawaan (3) valid.
class _RepoPalsu implements KiosRepository {
  @override
  List<Kios> getDaftarKios() => [
        _kios('A-01', 'Toko Buku Mawar'),
        _kios('A-02', 'Toko Buku Melati'),
        _kios('A-03', 'Toko Buku Anggrek'),
        _kios('A-04', 'Toko Buku Cempaka'),
        _kios('A-05', 'Toko Buku Dahlia'),
      ];

  @override
  List<BukuPopuler> getBukuPopuler() => const [BukuPopuler('Bumi Manusia', 'Pramoedya', 'x.png')];

  @override
  List<Fasilitas> getFasilitasPublik() => const [Fasilitas('Musala', 'Lantai 1')];
}

void main() {
  late DenahViewModel vm;
  late int jumlahNotifikasi;

  setUp(() {
    final repo = _RepoPalsu();
    vm = DenahViewModel(
      getDaftarKiosUseCase: GetDaftarKiosUseCase(repo),
      getBukuPopulerUseCase: GetBukuPopulerUseCase(repo),
      getFasilitasPublikUseCase: GetFasilitasPublikUseCase(repo),
    );
    jumlahNotifikasi = 0;
    vm.addListener(() => jumlahNotifikasi++);
  });

  tearDown(() => vm.dispose());

  test('keadaan awal: data dimuat, kios A-04 terpilih, zoom 1, tidak ada pencarian gagal', () {
    expect(vm.daftarKios.length, 5);
    expect(vm.bukuPopuler.single.judul, 'Bumi Manusia');
    expect(vm.fasilitasPublik.single.nama, 'Musala');
    expect(vm.terpilih, 3);
    expect(vm.kiosTerpilih.kode, 'A-04');
    expect(vm.zoom, 1.0);
    expect(vm.tidakDitemukan, isFalse);
  });

  test('setTerpilih: indeks valid mengganti pilihan dan mengabari listener', () {
    vm.setTerpilih(1);

    expect(vm.terpilih, 1);
    expect(vm.kiosTerpilih.kode, 'A-02');
    expect(jumlahNotifikasi, 1);
  });

  test('setTerpilih: indeks di luar rentang diabaikan', () {
    vm.setTerpilih(-1);
    vm.setTerpilih(5);

    expect(vm.terpilih, 3);
    expect(jumlahNotifikasi, 0);
  });

  test('cariKios: cocok berdasarkan kode, tanpa peduli huruf besar-kecil', () {
    vm.cariKios('a-02');

    expect(vm.terpilih, 1);
    expect(vm.tidakDitemukan, isFalse);
  });

  test('cariKios: kata "kios" di depan diabaikan', () {
    vm.cariKios('Kios A-05');

    expect(vm.terpilih, 4);
  });

  test('cariKios: cocok berdasarkan nama', () {
    vm.cariKios('anggrek');

    expect(vm.terpilih, 2);
  });

  test('cariKios: tidak ketemu menandai tidakDitemukan dan pilihan tidak berubah', () {
    vm.cariKios('zzz');

    expect(vm.tidakDitemukan, isTrue);
    expect(vm.terpilih, 3);
    expect(jumlahNotifikasi, 1);
  });

  test('cariKios: teks kosong mengembalikan tidakDitemukan ke false', () {
    vm.cariKios('zzz');
    vm.cariKios('   ');

    expect(vm.tidakDitemukan, isFalse);
    expect(jumlahNotifikasi, 2);
  });

  test('setTerpilih setelah pencarian gagal menghapus tanda tidakDitemukan', () {
    vm.cariKios('zzz');
    vm.setTerpilih(0);

    expect(vm.tidakDitemukan, isFalse);
    expect(vm.terpilih, 0);
  });

  test('ubahZoom: nilai dibatasi antara 1.0 dan 1.8', () {
    vm.ubahZoom(5);
    expect(vm.zoom, 1.8);

    vm.ubahZoom(0.2);
    expect(vm.zoom, 1.0);

    vm.ubahZoom(1.4);
    expect(vm.zoom, 1.4);
  });

  test('toggleSimpan: menyimpan lalu membatalkan, listener dikabari', () {
    expect(vm.isDisimpan('A-04'), isFalse);

    vm.toggleSimpan('A-04');
    expect(vm.isDisimpan('A-04'), isTrue);

    vm.toggleSimpan('A-04');
    expect(vm.isDisimpan('A-04'), isFalse);
    expect(jumlahNotifikasi, 2);
  });
}
