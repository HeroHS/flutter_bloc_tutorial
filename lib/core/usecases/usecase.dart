/// Base class for all use cases
///
/// WHAT IS A USE CASE?
/// - Represents a single business operation/action
/// - Implements one specific piece of business logic
/// - Follows Single Responsibility Principle
/// - Also called "Interactor" in some architectures
///
/// WHY GENERIC BASE CLASS?
/// - Provides consistent interface for all use cases
/// - Makes use cases easy to test (mock the call method)
/// - Enables dependency injection patterns
/// - Type-safe with compile-time checks
///
/// TYPE PARAMETERS:
/// - [Type]: What the use case returns (e.g., List<User>, User, bool)
/// - [Params]: What parameters it needs (e.g., GetUserByIdParams, NoParams)
///
/// EXAMPLES:
/// - UseCase<List<User>, NoParams> - Returns users, no params needed
/// - UseCase<User, GetUserByIdParams> - Returns one user, needs ID param
/// - UseCase<void, DeleteUserParams> - Deletes user, needs user data
///
/// USAGE:
/// class GetUsers implements UseCase<List<User>, NoParams> {
///   final UserRepository repository;
///   GetUsers(this.repository);
///
///   @override
///   Future<List<User>> call(NoParams params) async {
///     return await repository.getUsers();
///   }
/// }
///
/// CALLING FROM BLOC:
/// final users = await getUsersUseCase(NoParams());
abstract class UseCase<T, Params> {
  /// Execute the use case
  ///
  /// CALLABLE CLASSES:
  /// - call() method makes class instances callable like functions
  /// - getUsersUseCase(NoParams()) instead of getUsersUseCase.execute(NoParams())
  /// - More concise and readable
  ///
  /// ASYNC:
  /// - Returns Future<Type> for async operations
  /// - Most use cases involve I/O (network, database) so they're async
  /// - For sync use cases, just return Future.value(result)
  Future<T> call(Params params);
}

/// Used for use cases that don't need parameters
///
/// EMPTY PARAMETER CLASS:
/// - Some use cases don't need any input (e.g., GetAllUsers, Logout)
/// - Can't use null because it's not type-safe
/// - NoParams provides type safety and explicit intent
///
/// EXAMPLES:
/// - GetUsers - fetches all users (no filter params needed)
/// - GetCurrentUser - returns logged-in user (from token)
/// - ClearCache - clears cache (no params needed)
///
/// USAGE:
/// final users = await getUsersUseCase(NoParams());
///
/// ALTERNATIVE:
/// Some architectures use void or Unit instead, but NoParams is more explicit
class NoParams {}
