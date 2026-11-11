class BukuPopuler {
  final String judul;
  final String penulis;
  final String gambar;

  const BukuPopuler(this.judul, this.penulis, this.gambar);
}

class Fasilitas {
  final String nama;
  final String lokasi;
  final String deskripsi;

  const Fasilitas(this.nama, this.lokasi, [this.deskripsi = '']);
}
