import '../entities/user.dart';

/// User Repository Interface
///
/// WHAT IS A REPOSITORY?
/// - Abstraction that defines data operations
/// - Contract between domain and data layers
/// - Doesn't implement HOW, just defines WHAT
///
/// REPOSITORY PATTERN:
/// - Domain layer defines the interface (this file)
/// - Data layer implements the interface (UserRepositoryImpl)
/// - Presentation layer uses the interface (via use cases)
///
/// WHY USE REPOSITORY PATTERN?
/// ✓ Abstraction: Domain doesn't know about API/Database details
/// ✓ Testability: Easy to mock for testing
/// ✓ Flexibility: Swap implementations without changing domain logic
/// ✓ Single Source of Truth: Centralized data access logic
///
/// DEPENDENCY RULE (CLEAN ARCHITECTURE):
/// Data Layer → Implements → Domain Layer Interface
///     ↓                          ↑
/// Concrete             Abstract (this file)
///
/// IMPLEMENTATION EXAMPLES:
/// - UserRepositoryImpl: Uses API via RemoteDataSource
/// - UserRepositoryLocalImpl: Uses local database
/// - UserRepositoryMockImpl: Returns fake data for testing
///
/// All implement this same interface!
abstract class UserRepository {
  /// Fetches list of users
  ///
  /// RETURN TYPE:
  /// - Returns List<User> (domain entity, not model)
  /// - Implementation converts models to entities
  ///
  /// ERROR HANDLING:
  /// - Throws exceptions on failure
  /// - Implementation decides what exceptions to throw
  /// - Could return Either<Failure, List<User>> for better error handling
  Future<List<User>> getUsers();

  /// Fetches users with simulated error for testing
  ///
  /// DEMO PURPOSE:
  /// - Used to demonstrate error handling
  /// - Real apps would have methods like:
  ///   • getUserById(int id)
  ///   • searchUsers(String query)
  ///   • updateUser(User user)
  ///   • deleteUser(int id)
  Future<List<User>> getUsersWithError();
  
  // Examples of other repository methods:
  // Future<User> getUserById(int id);
  // Future<List<User>> getUsersByRole(String role);
  // Future<void> saveUser(User user);
  // Future<void> deleteUser(int id);
  // Stream<List<User>> watchUsers(); // For real-time updates
}
