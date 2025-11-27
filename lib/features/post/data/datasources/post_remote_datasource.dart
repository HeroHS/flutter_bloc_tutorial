import 'dart:async';
import '../models/post_model.dart';

/// Remote Data Source for Posts
abstract class PostRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
  Future<List<PostModel>> fetchPostsWithError();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  @override
  Future<List<PostModel>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      PostModel(
        id: 1,
        title: 'Getting Started with Cubit',
        body: 'Cubit is a lightweight state management solution that doesn\'t require events. '
            'It\'s simpler than BLoC but still powerful.',
        author: 'Flutter Dev',
        publishedDate: DateTime(2024, 1, 15),
      ),
      PostModel(
        id: 2,
        title: 'Cubit vs BLoC: When to Use What',
        body: 'Use Cubit for simple state changes. Use BLoC when you need event tracking, '
            'complex business logic, or want to separate events from state changes.',
        author: 'State Management Expert',
        publishedDate: DateTime(2024, 2, 20),
      ),
      PostModel(
        id: 3,
        title: 'Building Reactive UIs with Cubit',
        body: 'Cubit makes it easy to build reactive UIs. Just call methods on your Cubit '
            'and emit new states. The UI automatically rebuilds!',
        author: 'UI Specialist',
        publishedDate: DateTime(2024, 3, 10),
      ),
      PostModel(
        id: 4,
        title: 'Testing Cubits Made Easy',
        body: 'Cubits are extremely easy to test. Just call methods and verify the emitted states. '
            'No need to worry about event streams!',
        author: 'Testing Guru',
        publishedDate: DateTime(2024, 4, 5),
      ),
      PostModel(
        id: 5,
        title: 'Clean Architecture with Cubit',
        body: 'Learn how to use Cubit with Clean Architecture patterns like Use Cases and Repositories '
            'for better separation of concerns.',
        author: 'Architecture Architect',
        publishedDate: DateTime(2024, 5, 12),
      ),
    ];
  }

  @override
  Future<List<PostModel>> fetchPostsWithError() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Failed to load posts. Server is unreachable.');
  }
}
