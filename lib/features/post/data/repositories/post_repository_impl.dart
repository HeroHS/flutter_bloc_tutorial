import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';

/// Post Repository Implementation
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Post>> getPosts() async {
    try {
      final postModels = await remoteDataSource.fetchPosts();
      return postModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  @override
  Future<List<Post>> getPostsWithError() async {
    try {
      final postModels = await remoteDataSource.fetchPostsWithError();
      return postModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }
}
