import '../entities/post_forum.dart';

abstract class ForumRepository {
  List<PostForum> getPosts();
  void addPost(PostForum post);
  void toggleLike(PostForum post);
}
