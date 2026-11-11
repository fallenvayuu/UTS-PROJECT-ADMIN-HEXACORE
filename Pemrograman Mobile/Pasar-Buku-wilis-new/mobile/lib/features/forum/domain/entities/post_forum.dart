class KomentarForum {
  final String nama;
  final String kios;
  final String waktu;
  final String isi;
  final String avatar;

  const KomentarForum({
    required this.nama,
    required this.kios,
    required this.waktu,
    required this.isi,
    required this.avatar,
  });
}

class PostForum {
  final String nama;
  final String kios;
  final String waktu;
  final String isi;
  final String avatar;
  final List<String> gambar;
  final KomentarForum? balasan;
  int suka;
  int komentar;
  bool disukai;

  PostForum({
    required this.nama,
    required this.waktu,
    required this.isi,
    required this.avatar,
    this.kios = '',
    this.gambar = const [],
    this.balasan,
    this.suka = 0,
    this.komentar = 0,
    this.disukai = false,
  });
}
