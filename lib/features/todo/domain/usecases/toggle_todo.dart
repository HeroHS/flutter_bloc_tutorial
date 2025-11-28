import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

/// Parameters for ToggleTodo use case
///
/// SIMPLE PARAMETER:
/// - Only needs the todo ID to toggle
/// - Repository handles the status change logic
class ToggleTodoParams {
  final String id;

  ToggleTodoParams(this.id);
}

/// Use case for toggling a todo's completion status
///
/// BUSINESS LOGIC:
/// - Toggles todo between pending ↔ completed
/// - Common operation in todo apps
/// - Repository handles actual status flip
///
/// ALTERNATIVE APPROACHES:
/// - Could accept new status explicitly: UpdateTodoStatusParams(id, status)
/// - Could accept full Todo entity: UpdateTodoParams(todo)
/// - Toggle is simpler for common checkbox interaction
///
/// USAGE IN CUBIT/BLOC:
/// await toggleTodoUseCase(ToggleTodoParams(todoId));
/// // Then update UI state with modified todo
class ToggleTodo implements UseCase<void, ToggleTodoParams> {
  final TodoRepository repository;

  ToggleTodo(this.repository);

  @override
  Future<void> call(ToggleTodoParams params) async {
    return await repository.toggleTodo(params.id);
  }
}
