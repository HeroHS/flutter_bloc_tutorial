import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

/// User Repository Implementation
///
/// IMPLEMENTS DOMAIN INTERFACE:
/// - This is the concrete implementation of UserRepository
/// - Lives in the data layer, not domain layer
/// - Domain depends on interface, not this implementation
///
/// RESPONSIBILITIES:
/// 1. Coordinate between data sources (remote, local, cache)
/// 2. Convert models (data layer) to entities (domain layer)
/// 3. Handle data source errors and exceptions
/// 4. Implement caching strategies (if needed)
/// 5. Merge data from multiple sources (if needed)
///
/// DATA FLOW:
/// Use Case → Repository Interface → Repository Impl → Data Source → API
///     ↓            ↓                      ↓                ↓          ↓
///  Domain       Domain                 Data            Data      External
///
/// WHY SEPARATE FROM DATA SOURCE?
/// - Repository can combine multiple data sources (remote + cache + local)
/// - Repository implements business logic for data access
/// - Data sources are "dumb" - just fetch/save data
/// - Can switch data sources without changing repository interface
///
/// EXAMPLE MULTI-SOURCE PATTERN:
/// try {
///   // Try cache first
///   return await localDataSource.getCachedUsers();
/// } catch (e) {
///   // Fetch from API if cache fails
///   final users = await remoteDataSource.fetchUsers();
///   // Save to cache for next time
///   await localDataSource.cacheUsers(users);
///   return users;
/// }
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  // Could inject more data sources:
  // final UserLocalDataSource localDataSource;
  // final UserCacheDataSource cacheDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getUsers() async {
    try {
      // Step 1: Fetch data models from remote data source
      final userModels = await remoteDataSource.fetchUsers();
      
      // Step 2: Convert models to entities
      // This is KEY: Domain works with entities, data layer with models
      return userModels.map((model) => model.toEntity()).toList();
      
      // In a real app, you might also:
      // - Cache the results
      // - Merge with local data
      // - Apply business rules
    } catch (e) {
      // Transform data layer exceptions to domain exceptions
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<List<User>> getUsersWithError() async {
    try {
      // Call data source method that throws error
      final userModels = await remoteDataSource.fetchUsersWithError();
      return userModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Re-throw with context
      // In production, use custom exception types
      throw Exception('Failed to get users: $e');
    }
  }
}
