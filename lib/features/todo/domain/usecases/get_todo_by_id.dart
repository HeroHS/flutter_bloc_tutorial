import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Parameters for GetTodoById use case
///
/// PARAMETER CLASSES:
/// - Encapsulate all parameters needed by a use case
/// - Make use case calls type-safe and explicit
/// - Allow multiple parameters without long argument lists
class GetTodoByIdParams {
  final String id;

  GetTodoByIdParams(this.id);
}

/// Use case for fetching a single todo by its ID
///
/// SINGLE RESPONSIBILITY:
/// - Only responsible for getting one todo by ID
/// - Delegates data retrieval to repository
/// - No business logic beyond calling repository
///
/// USAGE IN CUBIT/BLOC:
/// final todo = await getTodoByIdUseCase(GetTodoByIdParams('123'));
class GetTodoById implements UseCase<Todo, GetTodoByIdParams> {
  final TodoRepository repository;

  GetTodoById(this.repository);

  @override
  Future<Todo> call(GetTodoByIdParams params) async {
    return await repository.getTodoById(params.id);
  }
}
