import '../entities/post.dart';

/// Post Repository Interface
///
/// Defines the contract for post data operations
abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<List<Post>> getPostsWithError();
}
