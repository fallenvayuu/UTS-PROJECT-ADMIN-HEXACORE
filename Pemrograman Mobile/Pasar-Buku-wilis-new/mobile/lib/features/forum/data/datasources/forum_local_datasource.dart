import '../../domain/entities/post_forum.dart';

abstract class ForumLocalDataSource {
  List<PostForum> getPosts();
  void addPost(PostForum post);
  void toggleLike(PostForum post);
}

class ForumLocalDataSourceImpl implements ForumLocalDataSource {
  final List<PostForum> _posts = [
    PostForum(
      nama: 'Dimas Suryo Wicaksono',
      waktu: '15 Mei 2024 • 14:32 WIB',
      avatar: 'assets/images/avatar_dimas.png',
      isi: 'Sampurasun sedulur Wilis, barangkali ada pedagang lapak yang menyimpan naskah '
          '"Sedjarah Djawa Timoer" terbitan Balai Poestaka tahun 1952? Sedang riset tesis sejarah '
          'kolonial di sekitaran Klojen. Kondisi jilidan lepas tidak apa-apa, yang penting halaman teks komplet.',
      gambar: ['assets/images/forum_djawa_timoer.png'],
      suka: 128,
      komentar: 24,
      balasan: const KomentarForum(
        nama: 'Pak Bambang',
        kios: 'Kios B-13 Buku Lawas',
        waktu: '2 jam yang lalu',
        avatar: 'assets/images/avatar_bambang.png',
        isi: '"Mas Dimas, di kardus arsip kolonial stan saya masih ada 1 eksemplar terbitan 1952 '
            'tapi sampul depan agak gerepes pojoknya. Teks dalam komplet. Monggo mampir."',
      ),
    ),
    PostForum(
      nama: 'Anindya Putri',
      waktu: 'Kemarin • 09:15 WIB',
      avatar: 'assets/images/avatar_anindya.png',
      isi: 'Tadi pagi hunting di lorong barat Pasar Wilis dan dapet harta karun tak terduga! '
          'Cetakan perdana cerpen "Robohnya Surau Kami" karya A.A. Navis (NV Nusantara Bukittinggi, 1956). '
          'Kertasnya wangi kayu manis tua khas simpanan lemari jati puluhan tahun.',
      gambar: ['assets/images/forum_navis_1.png', 'assets/images/forum_navis_2.png'],
      suka: 84,
      komentar: 18,
    ),
    PostForum(
      nama: 'Cak Slamet Riadi',
      kios: 'Kios B-12 Buku Lawas',
      waktu: '2 jam yang lalu',
      avatar: 'assets/images/avatar_slamet.png',
      isi: 'Masuk kiriman 3 peti dari pensiunan dosen UB & UM: Buku-buku filsafat, hukum perdata lama, '
          'serta kamus bahasa Belanda-Indonesia jilid tebal. Kondisi 85% mulus tanpa coretan.',
      gambar: ['assets/images/forum_lorong.png'],
      suka: 56,
      komentar: 9,
    ),
  ];

  @override
  List<PostForum> getPosts() => _posts;

  @override
  void addPost(PostForum post) {
    _posts.insert(0, post);
  }

  @override
  void toggleLike(PostForum post) {
    post.disukai = !post.disukai;
    post.suka += post.disukai ? 1 : -1;
  }
}
