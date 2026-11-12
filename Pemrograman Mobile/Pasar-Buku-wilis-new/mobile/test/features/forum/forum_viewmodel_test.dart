import 'package:flutter_test/flutter_test.dart';
import 'package:wilis_mobile/features/forum/domain/entities/post_forum.dart';
import 'package:wilis_mobile/features/forum/domain/repositories/forum_repository.dart';
import 'package:wilis_mobile/features/forum/domain/usecases/create_post_usecase.dart';
import 'package:wilis_mobile/features/forum/domain/usecases/get_posts_usecase.dart';
import 'package:wilis_mobile/features/forum/domain/usecases/toggle_like_usecase.dart';
import 'package:wilis_mobile/features/forum/presentation/viewmodels/forum_viewmodel.dart';

/// Repository palsu: menyimpan post di memori dan mencatat pemanggilan like.
class _RepoPalsu implements ForumRepository {
  final List<PostForum> posts = [
    PostForum(nama: 'Budi', waktu: '1 jam lalu', isi: 'Halo', avatar: 'a.png'),
    PostForum(nama: 'Sari', waktu: '2 jam lalu', isi: 'Ada buku lama?', avatar: 'b.png'),
  ];
  final List<PostForum> diLike = [];

  @override
  List<PostForum> getPosts() => posts;

  @override
  void addPost(PostForum post) => posts.insert(0, post);

  @override
  void toggleLike(PostForum post) {
    diLike.add(post);
    post.disukai = !post.disukai;
    post.suka += post.disukai ? 1 : -1;
  }
}

void main() {
  late _RepoPalsu repo;
  late ForumViewModel vm;
  late int jumlahNotifikasi;

  setUp(() {
    repo = _RepoPalsu();
    vm = ForumViewModel(
      getPostsUseCase: GetPostsUseCase(repo),
      createPostUseCase: CreatePostUseCase(repo),
      toggleLikeUseCase: ToggleLikeUseCase(repo),
    );
    jumlahNotifikasi = 0;
    vm.addListener(() => jumlahNotifikasi++);
  });

  tearDown(() => vm.dispose());

  test('keadaan awal: post diambil dari repository', () {
    expect(vm.posts.map((p) => p.nama), ['Budi', 'Sari']);
    expect(jumlahNotifikasi, 0);
  });

  test('buatPost: post baru di urutan teratas, isi dirapikan, listener dikabari', () {
    vm.buatPost(nama: 'Andi', isi: '  Cari buku Pramoedya  ');

    expect(vm.posts.length, 3);
    final baru = vm.posts.first;
    expect(baru.nama, 'Andi');
    expect(baru.isi, 'Cari buku Pramoedya');
    expect(baru.waktu, 'Baru saja');
    expect(baru.avatar, 'assets/images/avatar_saya.png');
    expect(jumlahNotifikasi, 1);
  });

  test('buatPost: avatar bisa diganti', () {
    vm.buatPost(nama: 'Andi', isi: 'Halo', avatar: 'lain.png');

    expect(vm.posts.first.avatar, 'lain.png');
  });

  test('toggleLike: menyukai lalu membatalkan, listener dikabari tiap kali', () {
    final post = vm.posts.first;

    vm.toggleLike(post);
    expect(post.disukai, isTrue);
    expect(post.suka, 1);

    vm.toggleLike(post);
    expect(post.disukai, isFalse);
    expect(post.suka, 0);

    expect(repo.diLike, [post, post]);
    expect(jumlahNotifikasi, 2);
  });
}
