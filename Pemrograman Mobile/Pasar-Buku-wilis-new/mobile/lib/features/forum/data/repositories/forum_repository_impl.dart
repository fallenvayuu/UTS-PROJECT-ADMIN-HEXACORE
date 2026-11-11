import '../../domain/entities/post_forum.dart';
import '../../domain/repositories/forum_repository.dart';
import '../datasources/forum_local_datasource.dart';

class ForumRepositoryImpl implements ForumRepository {
  final ForumLocalDataSource localDataSource;

  ForumRepositoryImpl(this.localDataSource);

  @override
  List<PostForum> getPosts() => localDataSource.getPosts();

  @override
  void addPost(PostForum post) => localDataSource.addPost(post);

  @override
  void toggleLike(PostForum post) => localDataSource.toggleLike(post);
}
