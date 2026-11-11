class Kios {
  final String kode;
  final String nama;
  final String pemilik;
  final String tutup;
  final bool buka;
  final List<String> spesialisasi;
  final String jumlahArsip;

  const Kios({
    required this.kode,
    required this.nama,
    required this.pemilik,
    required this.spesialisasi,
    required this.jumlahArsip,
    this.buka = true,
    this.tutup = '18.00',
  });

  String get label => nama.replaceFirst('Toko Buku ', '');
}
