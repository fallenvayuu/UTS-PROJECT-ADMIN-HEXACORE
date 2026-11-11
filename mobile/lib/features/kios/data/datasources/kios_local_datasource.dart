import '../../domain/entities/buku_populer.dart';
import '../../domain/entities/kios.dart';

abstract class KiosLocalDataSource {
  List<Kios> getDaftarKios();
  List<BukuPopuler> getBukuPopuler();
  List<Fasilitas> getFasilitasPublik();
}

class KiosLocalDataSourceImpl implements KiosLocalDataSource {
  static const _daftarKios = [
    Kios(
      kode: 'A-01',
      nama: 'Toko Surya',
      pemilik: 'Pak Surya (Pedagang Generasi Kedua, sejak 2003)',
      spesialisasi: ['Buku Kuliah Teknik', 'Hukum & Politik'],
      jumlahArsip: '60+ Koleksi',
    ),
    Kios(
      kode: 'A-02',
      nama: 'Pustaka Kuno',
      pemilik: 'Bu Lastri (Pedagang Generasi Pertama, sejak 1991)',
      spesialisasi: ['Naskah Jawa Kuno', 'Peta & Arsip Kolonial'],
      jumlahArsip: '80+ Koleksi',
    ),
    Kios(
      kode: 'A-03',
      nama: 'Wilis Book',
      pemilik: 'Mas Hendra (Pedagang Generasi Kedua, sejak 2008)',
      spesialisasi: ['Novel Populer', 'Komik & Manga'],
      jumlahArsip: '120+ Koleksi',
    ),
    Kios(
      kode: 'A-04',
      nama: 'Toko Buku Barokah',
      pemilik: 'H. Ridwan (Pedagang Generasi Pertama, sejak 1994)',
      spesialisasi: ['Sastra Klasik Nusantara', 'Kitab Kuning Pesantren', 'Novel Sejarah Kolonial'],
      jumlahArsip: '100+ Koleksi',
    ),
    Kios(
      kode: 'B-01',
      nama: 'Surya Ilmu',
      pemilik: 'Pak Anwar (Pedagang Generasi Pertama, sejak 1989)',
      spesialisasi: ['Buku Pelajaran Sekolah', 'Kamus Bahasa'],
      jumlahArsip: '90+ Koleksi',
    ),
    Kios(
      kode: 'B-02',
      nama: 'Pustaka Lawas',
      pemilik: 'Pak Bambang (Pedagang Generasi Pertama, sejak 1993)',
      spesialisasi: ['Buku Lawas Terbitan 1950–1970', 'Arsip Kolonial'],
      jumlahArsip: '70+ Koleksi',
    ),
    Kios(
      kode: 'B-03',
      nama: 'Wilis Book II',
      pemilik: 'Mbak Rina (Pedagang Generasi Kedua, sejak 2011)',
      spesialisasi: ['Majalah Antik', 'Kliping Koran'],
      jumlahArsip: '50+ Koleksi',
    ),
    Kios(
      kode: 'B-04',
      nama: 'Wilis Komik',
      pemilik: 'Cak Slamet (Pedagang Generasi Kedua, sejak 2000)',
      spesialisasi: ['Komik Nostalgia', 'Buku Filsafat'],
      jumlahArsip: '110+ Koleksi',
    ),
  ];

  static const _bukuPopuler = [
    BukuPopuler('Bumi Manusia', 'Pramoedya A.T.', 'assets/images/buku_bumi_manusia.png'),
    BukuPopuler('Ronggeng Dukuh Paruk', 'Ahmad Tohari', 'assets/images/buku_ronggeng.png'),
    BukuPopuler('Tafsir Jalalain', 'Cetakan Menara', 'assets/images/buku_tafsir.png'),
  ];

  static const _fasilitasPublik = [
    Fasilitas('Lahan Parkir', 'Depan Jl. Simpang Wilis'),
    Fasilitas('Musholla', 'Ujung Lorong Selatan'),
    Fasilitas('Toilet Umum', 'Ujung Lorong Selatan'),
  ];

  @override
  List<Kios> getDaftarKios() => _daftarKios;

  @override
  List<BukuPopuler> getBukuPopuler() => _bukuPopuler;

  @override
  List<Fasilitas> getFasilitasPublik() => _fasilitasPublik;
}
