import '../entities/post_forum.dart';
import '../repositories/forum_repository.dart';

class GetPostsUseCase {
  final ForumRepository repository;
  GetPostsUseCase(this.repository);

  List<PostForum> execute() => repository.getPosts();
}
