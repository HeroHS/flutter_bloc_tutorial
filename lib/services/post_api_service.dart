import 'dart:async';
import '../models/post.dart';

/// Simulated API service for fetching blog posts
///
/// This demonstrates how Cubit works with API calls
/// In a real app, this would make HTTP requests to a server
class PostApiService {
  /// Simulates an API call to fetch a list of posts
  ///
  /// Uses Future.delayed to simulate network latency
  /// Returns a list of mock posts after 2 seconds
  Future<List<Post>> fetchPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful response with mock data
    return [
      Post(
        id: 1,
        title: 'Getting Started with Cubit',
        body:
            'Cubit is a lightweight state management solution that doesn\'t require events. '
            'It\'s simpler than BLoC but still powerful.',
        author: 'Flutter Dev',
        publishedDate: DateTime(2024, 1, 15),
      ),
      Post(
        id: 2,
        title: 'Cubit vs BLoC: When to Use What',
        body:
            'Use Cubit for simple state changes. Use BLoC when you need event tracking, '
            'complex business logic, or want to separate events from state changes.',
        author: 'State Management Expert',
        publishedDate: DateTime(2024, 2, 20),
      ),
      Post(
        id: 3,
        title: 'Building Reactive UIs with Cubit',
        body:
            'Cubit makes it easy to build reactive UIs. Just call methods on your Cubit '
            'and emit new states. The UI automatically rebuilds!',
        author: 'UI Specialist',
        publishedDate: DateTime(2024, 3, 10),
      ),
      Post(
        id: 4,
        title: 'Testing Cubits Made Easy',
        body:
            'Cubits are extremely easy to test. Just call methods and verify the emitted states. '
            'No need to worry about event streams!',
        author: 'Testing Guru',
        publishedDate: DateTime(2024, 4, 5),
      ),
      Post(
        id: 5,
        title: 'Advanced Cubit Patterns',
        body:
            'Learn advanced patterns like debouncing, throttling, and composing multiple Cubits '
            'for complex state management scenarios.',
        author: 'Architecture Architect',
        publishedDate: DateTime(2024, 5, 12),
      ),
    ];
  }

  /// Simulates an API call that fails
  ///
  /// Uses Future.delayed to simulate network latency
  /// Throws an exception after 2 seconds to simulate an error
  Future<List<Post>> fetchPostsWithError() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate error response
    throw Exception('Failed to load posts. Server is unreachable.');
  }

  /// Simulates fetching a single post by ID
  Future<Post> fetchPostById(int id) async {
    await Future.delayed(const Duration(seconds: 1));

    final posts = await fetchPosts();
    return posts.firstWhere(
      (post) => post.id == id,
      orElse: () => throw Exception('Post not found'),
    );
  }
}
