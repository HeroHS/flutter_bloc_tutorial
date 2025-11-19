import 'dart:async';
import '../models/user.dart';

/// Simulated API service for fetching users
/// In a real app, this would make HTTP requests to a server
class UserApiService {
  /// Simulates an API call to fetch a list of users
  ///
  /// Uses Future.delayed to simulate network latency
  /// Returns a list of mock users after 2 seconds
  Future<List<User>> fetchUsers() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful response with mock data
    return [
      const User(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        role: 'Developer',
      ),
      const User(
        id: 2,
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        role: 'Designer',
      ),
      const User(
        id: 3,
        name: 'Bob Johnson',
        email: 'bob.johnson@example.com',
        role: 'Manager',
      ),
      const User(
        id: 4,
        name: 'Alice Williams',
        email: 'alice.williams@example.com',
        role: 'Product Owner',
      ),
    ];
  }

  /// Simulates an API call that fails
  ///
  /// Uses Future.delayed to simulate network latency
  /// Throws an exception after 2 seconds to simulate an error
  Future<List<User>> fetchUsersWithError() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate error response
    throw Exception('Failed to load users. Please check your connection.');
  }
}
