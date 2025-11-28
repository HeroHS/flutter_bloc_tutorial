import 'dart:async';
import '../../domain/entities/todo.dart';

/// Remote data source for Todo operations
///
/// Simulates API calls with 2-second delays to mimic network behavior.
/// Provides both success and error scenarios for testing state management.
abstract class TodoRemoteDataSource {
  /// Fetches all todos from the remote API
  Future<List<Todo>> getTodos();

  /// Adds a new todo to the remote API
  Future<Todo> addTodo(Todo todo);

  /// Toggles the completion status of a todo
  Future<Todo> toggleTodo(String id);

  /// Deletes a todo by ID
  Future<void> deleteTodo(String id);

  Future<Todo> getTodoById(String id);
}

/// Implementation of TodoRemoteDataSource with mock data
///
/// Simulates a REST API with in-memory storage and network delays.
/// All operations include 2-second delays to simulate real network conditions.
class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  // Mock in-memory storage simulating backend database
  final List<Todo> _mockTodos = [
    Todo(
      id: '1',
      title: 'Learn Flutter BLoC',
      status: TodoStatus.pending,
      description: 'Understand state management using BLoC pattern',
      dueDate: DateTime.now().add(const Duration(days: 10)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: null,
    ),
    Todo(
      id: '2',
      title: 'Build Todo App',
      status: TodoStatus.completed,
      description: 'Create a todo app with Flutter',
      dueDate: DateTime(2025, 3, 5),
      createdAt: DateTime(2025, 2, 23),
      updatedAt: DateTime(2025, 3, 1),
    ),
    Todo(
      id: '3',
      title: 'Master State Management',
      status: TodoStatus.completed,
      description: 'Deep dive into state management techniques',
      dueDate: DateTime(2025, 4, 10),
      createdAt: DateTime(2025, 3, 10),
      updatedAt: DateTime(2025, 4, 7),
    ),
  ];

  int _idCounter = 4; // For generating new IDs

  @override
  Future<List<Todo>> getTodos() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return copy to prevent external modifications
    return List.from(_mockTodos);
  }

  @override
  Future<Todo> addTodo(Todo todo) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (todo.title.trim().isEmpty) {
      throw Exception('Todo title cannot be empty');
    }

    final newTodo = Todo(
      id: (_idCounter++).toString(),
      title: todo.title,
      description: todo.description,
      dueDate: todo.dueDate,
      status: TodoStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: null,
    );

    _mockTodos.add(newTodo);
    return newTodo;
  }

  @override
  Future<Todo> toggleTodo(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final index = _mockTodos.indexWhere((todo) => todo.id == id);

    if (index == -1) {
      throw Exception('Todo not found with id: $id');
    }

    final todo = _mockTodos[index];
    final updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      dueDate: todo.dueDate,
      status: todo.status == TodoStatus.pending
          ? TodoStatus.completed
          : TodoStatus.pending,
      createdAt: todo.createdAt,
      updatedAt: DateTime.now(),
    );

    _mockTodos[index] = updatedTodo;
    return updatedTodo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final index = _mockTodos.indexWhere((todo) => todo.id == id);

    if (index == -1) {
      throw Exception('Todo not found with id: $id');
    }

    _mockTodos.removeAt(index);
  }

  @override
  Future<Todo> getTodoById(String id) {
    // Simulate network delay
    return Future.delayed(const Duration(seconds: 2), () {
      final todo = _mockTodos.firstWhere(
        (todo) => todo.id == id,
        orElse: () => throw Exception('Todo not found with id: $id'),
      );
      return todo;
    });
  }
}
