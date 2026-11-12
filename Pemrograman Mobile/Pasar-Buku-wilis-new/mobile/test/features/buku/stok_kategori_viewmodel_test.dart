import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:wilis_mobile/core/utils/api_exception.dart';
import 'package:wilis_mobile/features/buku/domain/entities/buku.dart';
import 'package:wilis_mobile/features/buku/domain/repositories/buku_repository.dart';
import 'package:wilis_mobile/features/buku/domain/usecases/get_buku_list_usecase.dart';
import 'package:wilis_mobile/features/buku/presentation/viewmodels/stok_kategori_viewmodel.dart';

Buku _buku(String judul, String kategori, int jumlah, {int id = 1}) => Buku(
      id: id,
      tanggal: '2026-01-01',
      judul: judul,
      kategori: kategori,
      penulis: 'Penulis',
      jumlah: jumlah,
      pemasok: 'Pemasok',
      harga: 10000,
    );

/// Repository palsu: hanya getBukuList yang dipakai viewmodel ini.
/// Fake dari flutter_test melempar UnimplementedError untuk method lain.
class _RepoPalsu extends Fake implements BukuRepository {
  List<Buku> data = [
    _buku('Bumi Manusia', 'Novel', 5, id: 1),
    _buku('Laskar Pelangi', 'Novel', 3, id: 2),
    _buku('Kamus Jawa', 'Kamus', 7, id: 3),
  ];
  Object? galat;
  Completer<void>? tahan;
  int panggilan = 0;

  @override
  Future<List<Buku>> getBukuList() async {
    panggilan++;
    if (tahan != null) await tahan!.future;
    if (galat != null) throw galat!;
    return data;
  }
}

void main() {
  late _RepoPalsu repo;
  late StokKategoriViewModel vm;
  late int jumlahNotifikasi;

  setUp(() {
    repo = _RepoPalsu();
    vm = StokKategoriViewModel(getBukuListUseCase: GetBukuListUseCase(repo));
    jumlahNotifikasi = 0;
    vm.addListener(() => jumlahNotifikasi++);
  });

  tearDown(() => vm.dispose());

  test('keadaan awal: belum termuat, kosong, jumlah null', () {
    expect(vm.termuat, isFalse);
    expect(vm.error, isNull);
    expect(vm.buku, isEmpty);
    expect(vm.jumlah(['Novel']), isNull);
  });

  test('muat sukses: data terisi dan listener dikabari sekali', () async {
    await vm.muat();

    expect(vm.termuat, isTrue);
    expect(vm.error, isNull);
    expect(vm.buku.length, 3);
    expect(jumlahNotifikasi, 1);
  });

  test('jumlah: menjumlahkan stok per kategori', () async {
    await vm.muat();

    expect(vm.jumlah(['Novel']), 8);
    expect(vm.jumlah(['Novel', 'Kamus']), 15);
    expect(vm.jumlah(['Tidak Ada']), 0);
  });

  test('jumlah: daftar kategori kosong menghasilkan null', () async {
    await vm.muat();

    expect(vm.jumlah([]), isNull);
  });

  test('bukuUntuk: hanya buku dengan kategori yang diminta', () async {
    await vm.muat();

    expect(vm.bukuUntuk(['Kamus']).map((b) => b.judul), ['Kamus Jawa']);
  });

  test('muat gagal: error terisi, belum termuat, listener dikabari', () async {
    repo.galat = const ApiException('Server tidak bisa dihubungi');

    await vm.muat();

    expect(vm.error, 'Server tidak bisa dihubungi');
    expect(vm.termuat, isFalse);
    expect(jumlahNotifikasi, 1);
  });

  test('error yang sama berulang tidak mengabari listener lagi', () async {
    repo.galat = const ApiException('Gagal');

    await vm.muat();
    await vm.muat();

    expect(jumlahNotifikasi, 1);
  });

  test('pulih dari error: error hilang dan listener dikabari', () async {
    repo.galat = const ApiException('Gagal');
    await vm.muat();

    repo.galat = null;
    await vm.muat();

    expect(vm.error, isNull);
    expect(vm.termuat, isTrue);
    expect(jumlahNotifikasi, 2);
  });

  test('data tidak berubah: muat ulang tidak mengabari listener', () async {
    await vm.muat();
    await vm.muat();

    expect(jumlahNotifikasi, 1);
  });

  test('data berubah: muat ulang mengabari listener dan menyimpan data baru', () async {
    await vm.muat();

    repo.data = [_buku('Bumi Manusia', 'Novel', 99, id: 1)];
    await vm.muat();

    expect(vm.jumlah(['Novel']), 99);
    expect(jumlahNotifikasi, 2);
  });

  test('muat saat masih memuat diabaikan: repository hanya dipanggil sekali', () async {
    repo.tahan = Completer<void>();

    final pertama = vm.muat();
    final kedua = vm.muat();
    repo.tahan!.complete();
    await Future.wait([pertama, kedua]);

    expect(repo.panggilan, 1);
  });

  test('mulaiPantau: memuat langsung lalu berkala, berhenti setelah berhenti()', () async {
    vm.mulaiPantau(setiap: const Duration(milliseconds: 20));
    try {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(repo.panggilan, greaterThanOrEqualTo(3));
    } finally {
      vm.berhenti();
    }

    await Future<void>.delayed(const Duration(milliseconds: 40));
    final setelahBerhenti = repo.panggilan;
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(repo.panggilan, setelahBerhenti);
  });

  test('pemantau ganda: timer baru mati setelah semua pemanggil berhenti', () async {
    vm.mulaiPantau(setiap: const Duration(milliseconds: 20));
    vm.mulaiPantau(setiap: const Duration(milliseconds: 20));
    try {
      vm.berhenti();
      final sebelum = repo.panggilan;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(repo.panggilan, greaterThan(sebelum));
    } finally {
      vm.berhenti();
    }

    await Future<void>.delayed(const Duration(milliseconds: 40));
    final setelahBerhenti = repo.panggilan;
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(repo.panggilan, setelahBerhenti);
  });
}
