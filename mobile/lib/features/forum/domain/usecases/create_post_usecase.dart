import '../entities/post_forum.dart';
import '../repositories/forum_repository.dart';

class CreatePostUseCase {
  final ForumRepository repository;
  CreatePostUseCase(this.repository);

  void execute(PostForum post) => repository.addPost(post);
}
