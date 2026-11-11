import 'package:flutter/foundation.dart';

import '../../domain/entities/post_forum.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/toggle_like_usecase.dart';

class ForumViewModel extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final ToggleLikeUseCase toggleLikeUseCase;

  late final List<PostForum> _posts;

  ForumViewModel({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.toggleLikeUseCase,
  }) {
    _posts = getPostsUseCase.execute();
  }

  List<PostForum> get posts => _posts;

  void buatPost({
    required String nama,
    required String isi,
    String avatar = 'assets/images/avatar_saya.png',
  }) {
    final post = PostForum(
      nama: nama,
      waktu: 'Baru saja',
      avatar: avatar,
      isi: isi.trim(),
    );
    createPostUseCase.execute(post);
    notifyListeners();
  }

  void toggleLike(PostForum p) {
    toggleLikeUseCase.execute(p);
    notifyListeners();
  }
}
