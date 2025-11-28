import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

/// Parameters for DeleteTodo use case
///
/// DELETION PARAMETER:
/// - Only needs the ID of the todo to delete
/// - Simple and explicit
class DeleteTodoParams {
  final String id;

  DeleteTodoParams(this.id);
}

/// Use case for deleting a todo
///
/// DESTRUCTIVE OPERATION:
/// - Permanently removes a todo
/// - Returns void (no return value)
/// - Should handle errors (not found, permission denied, etc.)
///
/// BEST PRACTICES:
/// - In production, consider soft delete (marking as deleted)
/// - May want confirmation dialog in UI before calling
/// - Could add undo functionality at presentation layer
///
/// ERROR HANDLING:
/// - Repository may throw exceptions if todo not found
/// - Network errors during deletion
/// - Cubit/BLoC should catch and show error state
///
/// USAGE IN CUBIT/BLOC:
/// await deleteTodoUseCase(DeleteTodoParams(todoId));
/// // Then remove from state or reload todos
class DeleteTodo implements UseCase<void, DeleteTodoParams> {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  @override
  Future<void> call(DeleteTodoParams params) async {
    return await repository.deleteTodo(params.id);
  }
}
