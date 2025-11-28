import '../../domain/entities/todo.dart';

/// Base class for all Todo-related states in Cubit
///
/// CUBIT USES SAME STATE PATTERN AS BLOC:
/// - Sealed class for exhaustive pattern matching
/// - Same state types (Initial, Loading, Loaded, Error)
/// - The ONLY difference is how states are triggered:
///   • BLoC: Events → Event Handlers → emit(state)
///   • Cubit: Methods → emit(state) directly
///
/// STATE MANAGEMENT IS IDENTICAL:
/// - UI uses BlocBuilder<TodoCubit, TodoState>
/// - Same switch expressions for pattern matching
/// - Same immutability principles
///
/// USAGE IN UI:
/// BlocBuilder<TodoCubit, TodoState>(
///   builder: (context, state) {
///     return switch (state) {
///       TodoInitial() => WelcomeView(),
///       TodoLoading() => LoadingSpinner(),
///       TodoLoaded() => TodosList(state.todos),
///       TodoError() => ErrorView(state.errorMessage),
///     };
///   },
/// )

sealed class TodoState {}

/// Initial state before any data loading has occurred
///
/// WHEN EMITTED:
/// - Cubit constructor: super(TodoInitial())
/// - After calling clear() or reset() methods
/// - Before user triggers any data loading
final class TodoInitial extends TodoState {}

/// State when todos are being loaded from the data source
///
/// WHEN EMITTED:
/// - At start of loadTodos() method
/// - Before calling the use case
/// - During initial fetch
///
/// UI BEHAVIOR:
/// - Show CircularProgressIndicator centered
/// - Display "Loading todos..." message
final class TodoLoading extends TodoState {}

/// State when todos have been successfully loaded
///
/// WHEN EMITTED:
/// - After successful getTodosUseCase() call
/// - Contains the fetched todos
/// - After adding, updating, or deleting todos
///
/// UI BEHAVIOR:
/// - Display todos in ListView
/// - Enable add/edit/delete actions
/// - Show todo count and status filters
///
/// IMMUTABILITY:
/// - The List<Todo> is final
/// - To update, emit new TodoLoaded with new list
final class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded(this.todos);
}

/// State when an error occurred while loading or manipulating todos
///
/// WHEN EMITTED:
/// - Use case throws exception
/// - Network/database/parsing errors
/// - After catch block in async methods
///
/// UI BEHAVIOR:
/// - Display error message
/// - Show retry button
/// - Use error color scheme
final class TodoError extends TodoState {
  final String errorMessage;

  TodoError(this.errorMessage);
}

/// State when a todo is being added
///
/// WHEN EMITTED:
/// - During addTodo() method execution
/// - Before persisting to data source
///
/// UI BEHAVIOR:
/// - Keep current todos visible
/// - Disable add/edit/delete actions
/// - Show processing indicator
final class TodoAdding extends TodoState {
  final List<Todo> currentTodos;

  TodoAdding(this.currentTodos);
}

/// State when a todo has been successfully added
///
/// WHEN EMITTED:
/// - After successful addTodoUseCase() call
/// - Contains updated list with new todo
///
/// UI BEHAVIOR:
/// - Show success SnackBar via listener
/// - Update UI with new todo list
final class TodoAdded extends TodoState {
  final String addedTodoTitle;

  TodoAdded(this.addedTodoTitle);
}

/// State when a todo is being toggled
///
/// WHEN EMITTED:
/// - During toggleTodo() method execution
/// - Before persisting to data source
///
/// UI BEHAVIOR:
/// - Keep current todos visible
/// - Disable actions for the specific todo
/// - Show processing indicator
final class TodoToggling extends TodoState {
  final List<Todo> currentTodos;
  final String todoId;

  TodoToggling(this.currentTodos, this.todoId);
}

/// State when a todo has been successfully toggled
///
/// WHEN EMITTED:
/// - After successful toggleTodoUseCase() call
/// - Contains updated list with toggled todo
///
/// UI BEHAVIOR:
/// - Show success SnackBar via listener
/// - Update UI with updated todo list
final class TodoToggled extends TodoState {
  final String toggledTodoTitle;

  TodoToggled(this.toggledTodoTitle);
}

/// State when a todo is being deleted
///
/// WHEN EMITTED:
/// - During deleteTodo() method execution
/// - Before persisting to data source
///
/// UI BEHAVIOR:
/// - Keep current todos visible (or show optimistic delete)
/// - Disable add/edit/delete actions
/// - Show processing indicator
final class TodoDeleting extends TodoState {
  final List<Todo> currentTodos;
  final String todoId;

  TodoDeleting(this.currentTodos, this.todoId);
}

/// State when a todo has been successfully deleted
///
/// WHEN EMITTED:
/// - After successful deleteTodoUseCase() call
/// - Contains updated list without deleted todo
///
/// UI BEHAVIOR:
/// - Show success SnackBar via listener
/// - Update UI with updated todo list
final class TodoDeleted extends TodoState {
  final String deletedTodoTitle;

  TodoDeleted(this.deletedTodoTitle);
}
