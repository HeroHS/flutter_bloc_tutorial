import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Use Case for getting users with error
///
/// This use case demonstrates error handling in Clean Architecture.
/// It intentionally calls a method that will throw an error.
class GetUsersWithError implements UseCase<List<User>, NoParams> {
  final UserRepository repository;

  GetUsersWithError(this.repository);

  @override
  Future<List<User>> call(NoParams params) async {
    return await repository.getUsersWithError();
  }
}
