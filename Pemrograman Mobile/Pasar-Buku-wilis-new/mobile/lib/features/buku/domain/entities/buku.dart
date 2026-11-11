class Buku {
  final int? id;
  final String tanggal;
  final String judul;
  final String kategori;
  final String penulis;
  final String pemasok;
  final int jumlah;
  final int harga;

  const Buku({
    this.id,
    required this.tanggal,
    required this.judul,
    required this.kategori,
    required this.penulis,
    required this.jumlah,
    required this.pemasok,
    required this.harga,
  });
}
