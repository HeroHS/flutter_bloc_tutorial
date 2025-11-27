import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Use Case for getting users
///
/// WHAT IS A USE CASE?
/// - Represents a single business action/operation
/// - Encapsulates business logic for one specific task
/// - Orchestrates data flow between presentation and data layers
/// - Also called "Interactor" in some architectures
///
/// WHY USE CASES?
/// - Single Responsibility: Each use case does ONE thing
/// - Testable: Easy to unit test business logic in isolation
/// - Reusable: Can be used by multiple BLoCs/Cubits/Controllers
/// - Maintainable: Business logic changes in one place
/// - Decoupled: BLoC doesn't know about repository implementation
///
/// CLEAN ARCHITECTURE LAYERS:
/// Presentation (BLoC/Cubit) → Domain (Use Case) → Data (Repository)
///                         ↓
///                   Uses entities (User)
///
/// USE CASE NAMING:
/// - Use verbs: Get, Create, Update, Delete, Fetch, Load, Save
/// - Be specific: GetUsers, GetUserById, GetActiveUsers
/// - NOT: UserUseCase, HandleUsers (too vague)
///
/// IMPLEMENTS UseCase<Output, Input>:
/// - Output: What the use case returns (List<User>)
/// - Input: What parameters it needs (NoParams if none)
/// - call() method: Executes the use case
class GetUsers implements UseCase<List<User>, NoParams> {
  final UserRepository repository;

  GetUsers(this.repository);

  /// Execute the use case
  ///
  /// FLOW:
  /// 1. BLoC calls: getUsersUseCase(NoParams())
  /// 2. This call() method executes
  /// 3. Delegates to repository
  /// 4. Repository coordinates data sources
  /// 5. Returns domain entities to BLoC
  ///
  /// PARAMETERS:
  /// - NoParams: This use case doesn't need parameters
  /// - Other use cases might use: GetUserByIdParams(id: 5)
  ///
  /// BUSINESS LOGIC:
  /// - This example is simple (just delegates)
  /// - Real use cases might:
  ///   • Validate input
  ///   • Combine multiple repository calls
  ///   • Apply business rules
  ///   • Transform data
  ///   • Cache results
  @override
  Future<List<User>> call(NoParams params) async {
    // Delegate to repository
    // Repository handles data source coordination
    return await repository.getUsers();
    
    // Examples of additional logic you could add:
    // - Sort users: users.sort((a, b) => a.name.compareTo(b.name));
    // - Filter: users.where((u) => u.role == 'Active').toList();
    // - Validate: if (users.isEmpty) throw NoUsersException();
    // - Cache: _cache.save(users); return users;
  }
}
