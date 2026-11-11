import '../entities/post_forum.dart';
import '../repositories/forum_repository.dart';

class ToggleLikeUseCase {
  final ForumRepository repository;
  ToggleLikeUseCase(this.repository);

  void execute(PostForum post) => repository.toggleLike(post);
}
