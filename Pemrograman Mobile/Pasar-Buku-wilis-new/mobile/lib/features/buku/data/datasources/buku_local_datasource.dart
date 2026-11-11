import '../../domain/entities/buku_temuan.dart';
import '../../domain/entities/kategori.dart';

abstract class BukuLocalDataSource {
  List<KategoriRingkas> getKategoriRingkas();
  List<KategoriTematik> getKategoriTematik();
  List<BukuTemuan> getBukuTemuan();
}

class BukuLocalDataSourceImpl implements BukuLocalDataSource {
  static const _kategoriRingkas = [
    KategoriRingkas('Buku Pelajaran', 'SD, SMP, SMA &...', '1.820 eks', 0, kategoriApi: ['Pelajaran']),
    KategoriRingkas('Kuliah & Teknik', 'Kedokteran, Hukum,...', '940 eks', 1, kategoriApi: ['Kuliah']),
    KategoriRingkas('Kamus Bahasa', 'Belanda, Jawa Kuno,...', '430 eks', 2, kategoriApi: ['Kamus']),
    KategoriRingkas('Komik & Manga', 'Tatank, Petruk, Kungfu...', '1.150 eks', 3, kategoriApi: ['Komik']),
    KategoriRingkas('Agama & Filsafat', 'Kitab Kuning, Tasawuf,...', '610 eks', 4, kategoriApi: ['Agama']),
    KategoriRingkas('Majalah Antik', 'Tempo 70–an, Star...', '320 eks', 5, kategoriApi: ['Majalah']),
  ];

  static const _bukuTemuan = [
    BukuTemuan(
      gambar: 'assets/images/cover_babad.png',
      info: 'Tahun 1982 • Hardcover',
      judul: 'Babad Tanah Djawi (Jilid I–III)',
      penulis: 'W.L. Olthof',
      harga: 'Rp 120.000',
      kios: 'Kios B–07',
    ),
    BukuTemuan(
      gambar: 'assets/images/cover_bumi.png',
      info: 'Cetakan Ke-1 Hasta Mitra',
      judul: 'Bumi Manusia (Edisi 1980)',
      penulis: 'Pramoedya Ananta Toer',
      harga: 'Rp 250.000',
      kios: 'Kios A–12',
    ),
  ];

  static const _kategoriTematik = [
    KategoriTematik(
      label: 'KLASIK',
      jumlah: '2.410+ Buku',
      nama: 'Novel & Sastra Klasik',
      deskripsi: 'Pramoedya Ananta Toer, Mochtar Lubis, Balai Pustaka, & novel roman...',
      lorong: 'Lorong Blok A & B',
      gambar: 'assets/images/kategori_1.png',
      kategoriApi: ['Novel'],
    ),
    KategoriTematik(
      label: 'STUDI',
      jumlah: '1.820+ Buku',
      nama: 'Buku Pelajaran Sekolah',
      deskripsi: 'SD, SMP, SMA, Kurikulum Merdeka hingga edisi buku paket lawas yang...',
      lorong: 'Lorong Blok B',
      gambar: 'assets/images/kategori_2.png',
      kategoriApi: ['Pelajaran'],
    ),
    KategoriTematik(
      label: 'AKADEMIK',
      jumlah: '940+ Buku',
      nama: 'Buku Kuliah & Teknik',
      deskripsi: 'Kedokteran, Hukum perdata-pidana, Ekonomi makro, Teknik mesin, sipil,...',
      lorong: 'Lorong Blok A',
      gambar: 'assets/images/kategori_3.png',
      kategoriApi: ['Kuliah'],
    ),
    KategoriTematik(
      label: 'LEKSIKON',
      jumlah: '430+ Buku',
      nama: 'Kamus & Bahasa Asing',
      deskripsi: 'Kamus Belanda-Indonesia, Bausastra Jawa Kuna, Oxford lawas, tata bahasa...',
      lorong: 'Lorong Blok C',
      gambar: 'assets/images/kategori_4.png',
      kategoriApi: ['Kamus'],
    ),
    KategoriTematik(
      label: 'POPULER',
      jumlah: '1.150+ Buku',
      nama: 'Komik & Manga Nostalgia',
      deskripsi: 'Karya Tatang S, Petruk Gareng, Kung Fu Boy, Doraemon terbitan jadul,...',
      lorong: 'Lorong Blok B',
      gambar: 'assets/images/kategori_5.png',
      kategoriApi: ['Komik'],
    ),
    KategoriTematik(
      label: 'PESANTREN',
      jumlah: '610+ Buku',
      nama: 'Kitab Kuning & Religi',
      deskripsi: 'Filsafat Islam, Tasawuf Al-Ghazali, Nahwu-Shorof, kitab gandul pegon...',
      lorong: 'Lorong Blok A & C',
      gambar: 'assets/images/kategori_6.png',
      kategoriApi: ['Agama'],
    ),
    KategoriTematik(
      label: 'PERIODIK',
      jumlah: '320+ Koleksi',
      nama: 'Majalah Antik & Kliping',
      deskripsi: 'Majalah Tempo dekade 70–80an, Star Weekly, Intisari edisi perdana, &...',
      lorong: 'Lorong Blok C',
      gambar: 'assets/images/kategori_7.png',
      kategoriApi: ['Majalah'],
      satuan: 'Koleksi',
    ),
    KategoriTematik(
      label: 'LANGKA',
      jumlah: '180+ Koleksi',
      nama: 'Naskah Sejarah Nusantara',
      deskripsi: 'Babad Tanah Jawi, arsip masa kolonial Malang, dokumen peta kuno, &...',
      lorong: 'Lorong Blok C Kolektor',
      gambar: 'assets/images/kategori_8.png',
      kategoriApi: ['Langka'],
      satuan: 'Koleksi',
    ),
  ];

  @override
  List<KategoriRingkas> getKategoriRingkas() => _kategoriRingkas;

  @override
  List<KategoriTematik> getKategoriTematik() => _kategoriTematik;

  @override
  List<BukuTemuan> getBukuTemuan() => _bukuTemuan;
}
