import 'package:bloc/bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todo_by_id.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';
import 'todo_state.dart';

/// Cubit for managing todo data state
///
/// WHAT IS CUBIT?
/// Cubit is a simplified version of BLoC that:
/// - Exposes methods instead of accepting events
/// - Directly emits states from methods
/// - Has less boilerplate (no event classes needed)
/// - Still uses the same state pattern as BLoC
///
/// CUBIT vs BLOC - KEY DIFFERENCES:
/// ┌─────────────────┬──────────────────────┬─────────────────────┐
/// │ Feature         │ BLoC                 │ Cubit               │
/// ├─────────────────┼──────────────────────┼─────────────────────┤
/// │ Input           │ Events (add)         │ Methods (call)      │
/// │ Boilerplate     │ More (events file)   │ Less (no events)    │
/// │ Complexity      │ Higher               │ Lower               │
/// │ Transformations │ Yes (debounce, etc.) │ No                  │
/// │ Event Tracking  │ Yes                  │ No                  │
/// │ Use Case        │ Complex logic        │ Simple logic        │
/// └─────────────────┴──────────────────────┴─────────────────────┘
///
/// WHEN TO USE CUBIT:
/// ✓ Simple state changes
/// ✓ Direct method calls feel more natural
/// ✓ Less complex business logic
/// ✓ Don't need event tracking/logging
/// ✓ No need for event transformations
///
/// WHEN TO USE BLOC INSTEAD:
/// ✓ Complex business logic with multiple events
/// ✓ Need to track/log events for debugging
/// ✓ Multiple events trigger same state change
/// ✓ Event transformations (debounce, throttle, distinct)
/// ✓ Advanced features like event buffering
///
/// CLEAN ARCHITECTURE WITH CUBIT:
/// - Still uses Use Cases (not repositories directly)
/// - Follows same dependency rules as BLoC
/// - Belongs to Presentation Layer
/// - Only knows about Domain Layer (use cases, entities)
///
/// UI USAGE:
/// // BLoC: context.read<UserBloc>().add(LoadUsersEvent());
/// // Cubit: context.read<TodoCubit>().loadTodos(); ← Direct method call!
class TodoCubit extends Cubit<TodoState> {
  final GetTodos getTodosUseCase;
  final GetTodoById getTodoByIdUseCase;
  final AddTodo addTodoUseCase;
  final ToggleTodo toggleTodoUseCase;
  final DeleteTodo deleteTodoUseCase;

  /// Constructor initializes with initial state
  ///
  /// KEY DIFFERENCE FROM BLOC:
  /// - No event handlers to register (no on<Event> calls)
  /// - Just set initial state and inject dependencies
  /// - Methods are called directly from UI
  TodoCubit({
    required this.getTodosUseCase,
    required this.getTodoByIdUseCase,
    required this.addTodoUseCase,
    required this.toggleTodoUseCase,
    required this.deleteTodoUseCase,
  }) : super(TodoInitial());

  /// Load todos from the data source
  ///
  /// DIRECT METHOD CALL PATTERN:
  /// - No events needed! Call this method directly from UI
  /// - Example: context.read<TodoCubit>().loadTodos();
  ///
  /// FLOW:
  /// 1. Emit loading state → UI shows CircularProgressIndicator
  /// 2. Call use case → Business logic executes
  /// 3. Emit loaded/error state → UI updates accordingly
  ///
  /// CLEAN ARCHITECTURE FLOW:
  /// Cubit → Use Case → Repository → Data Source
  ///
  /// ASYNC/AWAIT:
  /// - Method is async because use case is async
  /// - emit() is synchronous (emits state immediately)
  /// - State changes trigger UI rebuilds via BlocBuilder
  Future<void> loadTodos() async {
    // Emit loading state - UI will show loading indicator
    emit(TodoLoading());

    try {
      // Call use case to fetch todos
      // NoParams() because this use case doesn't need parameters
      final todos = await getTodosUseCase(NoParams());

      // Emit success state with the fetched todos
      emit(TodoLoaded(todos));
    } catch (error) {
      // Emit error state with error message
      // In production, consider custom error types for better handling
      emit(TodoError(error.toString()));
    }
  }

  /// Filter todos by status
  ///
  /// PARAMETERIZED METHOD PATTERN:
  /// - Cubit methods can accept parameters
  /// - Parameters influence the state emitted
  /// - Maintains loaded state with filtered data
  ///
  /// USAGE:
  /// - context.read<TodoCubit>().filterByStatus(TodoStatus.completed);
  /// - Shows only todos matching the specified status
  void filterByStatus(TodoStatus? status) {
    if (state is TodoLoaded) {
      final allTodos = (state as TodoLoaded).todos;

      if (status == null) {
        // Show all todos
        emit(TodoLoaded(allTodos));
      } else {
        // Filter by status
        final filteredTodos = allTodos
            .where((todo) => todo.status == status)
            .toList();
        emit(TodoLoaded(filteredTodos));
      }
    }
  }

  /// Clear all todos and return to initial state
  ///
  /// SYNCHRONOUS STATE CHANGE:
  /// - Cubit can emit states synchronously (no await needed)
  /// - Useful for simple state changes
  /// - Instant UI update
  ///
  /// USE CASES:
  /// - User logs out
  /// - Clearing cache
  /// - Resetting data
  void clear() {
    emit(TodoInitial());
  }

  // HELPER METHODS (NON-EMITTING):

  /// Check if todos are currently loaded
  ///
  /// NON-EMITTING METHOD:
  /// - Doesn't change state
  /// - Just queries current state
  /// - Useful for conditional UI logic
  bool hasLoadedTodos() {
    return state is TodoLoaded;
  }

  /// Get the count of loaded todos
  ///
  /// NON-EMITTING QUERY:
  /// - Returns data without changing state
  /// - Type-safe state checking with 'is' operator
  /// - Returns 0 if no todos are loaded
  int getTodoCount() {
    if (state is TodoLoaded) {
      return (state as TodoLoaded).todos.length;
    }
    return 0;
  }

  /// Get count of completed todos
  ///
  /// DEMONSTRATES DATA QUERIES:
  /// - Cubit can have helper methods for data access
  /// - Doesn't emit state, just returns calculated value
  /// - Useful for displaying statistics in UI
  int getCompletedCount() {
    if (state is TodoLoaded) {
      final todos = (state as TodoLoaded).todos;
      return todos.where((todo) => todo.status == TodoStatus.completed).length;
    }
    return 0;
  }

  /// Get count of pending todos
  int getPendingCount() {
    if (state is TodoLoaded) {
      final todos = (state as TodoLoaded).todos;
      return todos.where((todo) => todo.status == TodoStatus.pending).length;
    }
    return 0;
  }

  /// Get a single todo by ID
  ///
  /// PARAMETERIZED USE CASE:
  /// - Accepts an ID parameter
  /// - Calls use case with GetTodoByIdParams
  /// - Returns the todo directly (doesn't emit state)
  ///
  /// USAGE:
  /// final todo = await context.read<TodoCubit>().getTodoById('123');
  ///
  /// NOTE:
  /// - This is a query method, not a state change
  /// - For navigation to detail screen with specific todo
  /// - Could also emit a TodoDetailLoaded state if needed
  Future<Todo> getTodoById(String id) async {
    return await getTodoByIdUseCase(GetTodoByIdParams(id));
  }

  /// Add a new todo
  ///
  /// FLOW:
  /// 1. Emit TodoAdding state with current todos
  /// 2. Call use case to persist the new todo
  /// 3. Emit TodoAdded state with todo title for SnackBar
  /// 4. Reload todos to get updated list
  /// 5. On error, show error state
  ///
  /// USAGE:
  /// await context.read<TodoCubit>().addTodo(newTodo);
  Future<void> addTodo(Todo todo) async {
    // Get current todos if loaded
    final currentTodos = state is TodoLoaded
        ? (state as TodoLoaded).todos
        : <Todo>[];

    // Emit adding state to prevent user interactions
    emit(TodoAdding(currentTodos));

    try {
      // Persist the new todo
      await addTodoUseCase(AddTodoParams(todo));

      // Emit success state with todo title for SnackBar
      emit(TodoAdded(todo.title));

      // Reload to ensure consistency with backend
      await loadTodos();
    } catch (error) {
      // On error, show error state
      emit(TodoError(error.toString()));
    }
  }

  /// Toggle a todo's completion status
  ///
  /// FLOW:
  /// 1. Emit TodoToggling state with current todos and todo id
  /// 2. Call use case to persist the toggle
  /// 3. Emit TodoToggled state with todo title for SnackBar
  /// 4. Reload todos to get updated list
  /// 5. On error, show error state
  ///
  /// USAGE:
  /// await context.read<TodoCubit>().toggleTodo(todoId);
  Future<void> toggleTodo(String id) async {
    // Get current todos
    if (state is! TodoLoaded) return;

    final currentTodos = (state as TodoLoaded).todos;
    final todoToToggle = currentTodos.firstWhere((t) => t.id == id);

    // Emit toggling state to prevent user interactions
    emit(TodoToggling(currentTodos, id));

    try {
      // Persist the toggle
      await toggleTodoUseCase(ToggleTodoParams(id));

      // Emit success state with todo title for SnackBar
      emit(TodoToggled(todoToToggle.title));

      // Reload to ensure consistency with backend
      await loadTodos();
    } catch (error) {
      // On error, show error state
      emit(TodoError(error.toString()));
    }
  }

  /// Delete a todo
  ///
  /// FLOW:
  /// 1. Get current todos and the todo to delete
  /// 2. Optimistically remove from current todos to avoid UI errors
  /// 3. Emit TodoDeleting state with current todos and todo id
  /// 4. Call use case to delete from backend
  /// 5. Emit TodoDeleted state with todo title for SnackBar
  /// 6. Reload todos to get updated list
  /// 7. On error, show error state
  ///
  /// USAGE:
  /// await context.read<TodoCubit>().deleteTodo(todoId);
  ///
  /// PRODUCTION CONSIDERATION:
  /// - Could add undo functionality with a timer
  /// - Could show SnackBar with undo button
  /// - Could use soft delete instead of hard delete
  Future<void> deleteTodo(String id) async {
    // Get current todos
    if (state is! TodoLoaded) return;

    final currentTodos = (state as TodoLoaded).todos;
    final todoToDelete = currentTodos.where((t) => t.id == id).firstOrNull;
    if (todoToDelete == null) {
      throw Exception('Todo not found with id: $id');
    }
    // Optimistically remove from current todos to avoid UI errors
    currentTodos.remove(todoToDelete);

    // Emit deleting state to prevent user interactions
    emit(TodoDeleting(currentTodos, id));

    try {
      // Persist the deletion
      await deleteTodoUseCase(DeleteTodoParams(id));

      // Emit success state with todo title for SnackBar
      emit(TodoDeleted(todoToDelete.title));

      // Reload to ensure consistency with backend
      await loadTodos();
    } catch (error) {
      // On error, show error state
      emit(TodoError(error.toString()));
    }
  }
}
