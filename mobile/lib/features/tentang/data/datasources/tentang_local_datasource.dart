import '../../domain/entities/faq.dart';

abstract class TentangLocalDataSource {
  List<Faq> getFaqList();
  List<FasilitasPengunjung> getFasilitasPengunjungList();
}

class TentangLocalDataSourceImpl implements TentangLocalDataSource {
  static const _daftarFaq = [
    Faq(
      'Apakah harga buku di Wilis boleh ditawar?',
      'Tentu saja! Tradisi tawar-menawar secara santun merupakan bagian dari kehangatan berbelanja '
          'di Pasar Wilis. Kios-kios sangat terbuka untuk mendiskusikan harga terbaik.',
    ),
    Faq(
      'Bisakah tukar tambah atau jual buku koleksi pribadi?',
      'Bisa. Banyak kios menerima tukar tambah maupun pembelian koleksi pribadi. Bawa bukumu ke kios '
          'yang sesuai dengan kategorinya, lalu bicarakan harganya langsung dengan pemilik kios.',
    ),
  ];

  static const _fasilitasPengunjung = [
    FasilitasPengunjung('Lahan Parkir', 'Kapasitas motor tertata dan area mobil di bahu jalan depan kios.'),
    FasilitasPengunjung('Musholla Al-Ikhlas', 'Tempat ibadah bersih lengkap sarung, mukena, dan air wudhu.'),
    FasilitasPengunjung('Toilet Umum', 'Tersedia di sisi selatan pasar, terawat dan terjaga kebersihannya.'),
  ];

  @override
  List<Faq> getFaqList() => _daftarFaq;

  @override
  List<FasilitasPengunjung> getFasilitasPengunjungList() => _fasilitasPengunjung;
}
