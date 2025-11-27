import '../entities/post.dart';
import '../repositories/post_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Use Case for getting posts
///
/// This use case is called by the Cubit to fetch posts
class GetPosts implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<List<Post>> call(NoParams params) async {
    return await repository.getPosts();
  }
}
