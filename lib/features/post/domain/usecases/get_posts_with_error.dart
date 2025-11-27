import '../entities/post.dart';
import '../repositories/post_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Use Case for getting posts with error
class GetPostsWithError implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;

  GetPostsWithError(this.repository);

  @override
  Future<List<Post>> call(NoParams params) async {
    return await repository.getPostsWithError();
  }
}
