class KategoriRingkas {
  final String nama;
  final String contoh;
  final String eksemplar;
  final int ikon; // indeks ikon
  final List<String> kategoriApi;

  const KategoriRingkas(
    this.nama,
    this.contoh,
    this.eksemplar,
    this.ikon, {
    this.kategoriApi = const [],
  });
}

class KategoriTematik {
  final String label;
  final String jumlah;
  final String nama;
  final String deskripsi;
  final String lorong;
  final String gambar;
  final List<String> kategoriApi;
  final String satuan;

  const KategoriTematik({
    required this.label,
    required this.jumlah,
    required this.nama,
    required this.deskripsi,
    required this.lorong,
    required this.gambar,
    this.kategoriApi = const [],
    this.satuan = 'Buku',
  });
}
