import 'dart:async';
import '../models/user_model.dart';

/// Remote Data Source for Users
///
/// WHAT IS A DATA SOURCE?
/// - Lowest level of data layer
/// - Directly interacts with external systems (API, database, etc.)
/// - Returns models (data layer objects), not entities
/// - "Dumb" component - just fetches/saves data, no business logic
///
/// DATA SOURCE TYPES:
/// - RemoteDataSource: API/Network calls (HTTP, GraphQL, gRPC)
/// - LocalDataSource: Local database (SQLite, Hive, SharedPreferences)
/// - CacheDataSource: In-memory cache (for performance)
///
/// WHY ABSTRACT CLASS?
/// - Defines contract for implementations
/// - Easy to mock for testing
/// - Can have multiple implementations (Real API, Mock API, Test API)
///
/// REAL WORLD EXAMPLE:
/// import 'package:http/http.dart' as http;
/// 
/// Future<List<UserModel>> fetchUsers() async {
///   final response = await http.get(
///     Uri.parse('https://api.example.com/users'),
///   );
///   if (response.statusCode == 200) {
///     final List<dynamic> jsonList = json.decode(response.body);
///     return jsonList.map((json) => UserModel.fromJson(json)).toList();
///   } else {
///     throw ServerException();
///   }
/// }
abstract class UserRemoteDataSource {
  /// Fetches users from the API
  Future<List<UserModel>> fetchUsers();
  
  /// Fetches users with simulated error
  Future<List<UserModel>> fetchUsersWithError();
}

/// Implementation of UserRemoteDataSource
///
/// MOCK IMPLEMENTATION:
/// - Uses Future.delayed to simulate network latency
/// - Returns hardcoded data instead of making real API calls
/// - Perfect for development without backend
///
/// IN PRODUCTION:
/// - Replace with real HTTP client (dio, http package)
/// - Add authentication headers
/// - Handle network errors properly
/// - Implement retry logic
/// - Add request/response logging
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<List<UserModel>> fetchUsers() async {
    // Simulate network delay (2 seconds)
    // Real API calls take time, so we simulate this for realistic UX
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful API response
    // In real app, this would be: final response = await http.get(url);
    // Then: return parseResponse(response.body);
    return [
      const UserModel(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        role: 'Developer',
      ),
      const UserModel(
        id: 2,
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        role: 'Designer',
      ),
      const UserModel(
        id: 3,
        name: 'Bob Johnson',
        email: 'bob.johnson@example.com',
        role: 'Manager',
      ),
      const UserModel(
        id: 4,
        name: 'Alice Williams',
        email: 'alice.williams@example.com',
        role: 'Product Owner',
      ),
    ];
  }

  @override
  Future<List<UserModel>> fetchUsersWithError() async {
    // Simulate network delay before error
    await Future.delayed(const Duration(seconds: 2));

    // Simulate error response (404, 500, network timeout, etc.)
    // In real app, this could be:
    // - Server error (500)
    // - Network error (no internet)
    // - Parsing error (invalid JSON)
    // - Authentication error (401)
    throw Exception('Failed to load users. Please check your connection.');
  }
  
  // Real-world data source methods might look like:
  
  // Future<UserModel> fetchUserById(int id) async {
  //   final response = await http.get(
  //     Uri.parse('https://api.example.com/users/$id'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  //   
  //   if (response.statusCode == 200) {
  //     return UserModel.fromJson(json.decode(response.body));
  //   } else if (response.statusCode == 404) {
  //     throw NotFoundException('User not found');
  //   } else {
  //     throw ServerException('Server error');
  //   }
  // }
  
  // Future<void> createUser(UserModel user) async {
  //   await http.post(
  //     Uri.parse('https://api.example.com/users'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(user.toJson()),
  //   );
  // }
}
