import '../../domain/entities/buku.dart';

class BukuModel extends Buku {
  const BukuModel({
    super.id,
    required super.tanggal,
    required super.judul,
    required super.kategori,
    required super.penulis,
    required super.jumlah,
    required super.pemasok,
    required super.harga,
  });

  factory BukuModel.fromJson(Map<String, dynamic> j) => BukuModel(
        id: (j['id'] as num?)?.toInt(),
        tanggal: j['tanggal'] as String? ?? '',
        judul: j['judul'] as String? ?? '',
        kategori: j['kategori'] as String? ?? '',
        penulis: j['penulis'] as String? ?? '',
        jumlah: (j['jumlah'] as num?)?.toInt() ?? 0,
        pemasok: (j['pemasok'] ?? '') as String,
        harga: (j['harga'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'tanggal': tanggal,
        'judul': judul,
        'kategori': kategori,
        'penulis': penulis,
        'jumlah': jumlah,
        'pemasok': pemasok,
        'harga': harga,
      };

  factory BukuModel.fromEntity(Buku b) => BukuModel(
        id: b.id,
        tanggal: b.tanggal,
        judul: b.judul,
        kategori: b.kategori,
        penulis: b.penulis,
        jumlah: b.jumlah,
        pemasok: b.pemasok,
        harga: b.harga,
      );
}
