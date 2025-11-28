import '../../domain/entities/todo.dart' show Todo;
import '../../domain/repositories/todo_repository.dart' show TodoRepository;
import '../datasources/todo_remote_datasource.dart';

/// Todo Repository Interface
///
/// Defines the contract for todo data operations
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final todoModels = await remoteDataSource.getTodos();
      return todoModels;
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  @override
  Future<Todo> getTodoById(String id) async {
    try {
      final todoModel = await remoteDataSource.getTodoById(id);
      return todoModel;
    } catch (e) {
      throw Exception('Failed to fetch todo by id: $e');
    }
  }

  @override
  Future<void> addTodo(Todo todo) async {
    try {
      await remoteDataSource.addTodo(todo);
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  @override
  Future<void> toggleTodo(String id) async {
    try {
      await remoteDataSource.toggleTodo(id);
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await remoteDataSource.deleteTodo(id);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}
