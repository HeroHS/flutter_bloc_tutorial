import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Parameters for AddTodo use case
///
/// PARAMETER CLASSES:
/// - Wraps the Todo entity to be added
/// - Follows UseCase<Type, Params> pattern
/// - Makes the use case call explicit and type-safe
class AddTodoParams {
  final Todo todo;

  AddTodoParams(this.todo);
}

/// Use case for adding a new todo
///
/// WRITE OPERATION:
/// - Returns void (no return value needed)
/// - Modifies data through repository
/// - Can throw exceptions on failure (network, validation, etc.)
///
/// CLEAN ARCHITECTURE:
/// - Domain layer use case
/// - Depends on repository interface (not implementation)
/// - Can add validation logic here if needed
///
/// USAGE IN CUBIT/BLOC:
/// await addTodoUseCase(AddTodoParams(newTodo));
/// // Then reload todos or optimistically update state
class AddTodo implements UseCase<void, AddTodoParams> {
  final TodoRepository repository;

  AddTodo(this.repository);

  @override
  Future<void> call(AddTodoParams params) async {
    // Could add validation here:
    // if (params.todo.title.isEmpty) throw ValidationException();

    return await repository.addTodo(params.todo);
  }
}
