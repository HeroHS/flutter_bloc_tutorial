import 'package:flutter_bloc_tutorial/features/todo/domain/entities/todo.dart';

/// Todo Repository Interface
///
/// Defines the contract for todo data operations
abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> getTodoById(String id);
  Future<void> addTodo(Todo todo);
  Future<void> toggleTodo(String id);
  Future<void> deleteTodo(String id);
}
