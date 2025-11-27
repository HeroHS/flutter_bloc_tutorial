import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/get_users_with_error.dart';
import '../../../../core/usecases/usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

/// BLoC (Business Logic Component) that manages user data state
///
/// WHAT IS BLOC?
/// BLoC is an event-driven state management pattern where:
/// - UI dispatches Events (user actions/intentions)
/// - BLoC handles events and emits States
/// - UI rebuilds based on state changes
///
/// CLEAN ARCHITECTURE INTEGRATION:
/// - BLoC belongs to the Presentation Layer
/// - Uses Use Cases from Domain Layer (not repositories directly)
/// - Depends only on domain abstractions (Use Cases, Entities)
/// - No knowledge of data sources or implementation details
///
/// BENEFITS:
/// - Separation of concerns: UI logic separate from business logic
/// - Testable: Mock use cases for testing
/// - Reusable: Same BLoC can be used across multiple screens
/// - Predictable: State changes follow event → handler → state flow
///
/// WHEN TO USE BLOC (vs Cubit):
/// - Complex business logic with multiple events
/// - Need to track/log events for debugging
/// - Event transformations (debounce, throttle, distinct)
/// - Multiple events can trigger the same state
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsersUseCase;
  final GetUsersWithError getUsersWithErrorUseCase;

  /// Constructor initializes BLoC with initial state and registers event handlers
  ///
  /// DEPENDENCY INJECTION:
  /// - Use cases are injected via constructor (not created internally)
  /// - Makes BLoC testable and follows Dependency Inversion Principle
  /// - In tests, you can inject mock use cases
  UserBloc({
    required this.getUsersUseCase,
    required this.getUsersWithErrorUseCase,
  }) : super(UserInitialState()) {
    // Register event handlers
    // Each event type maps to a specific handler method
    on<LoadUsersEvent>(_onLoadUsers);
    on<LoadUsersWithErrorEvent>(_onLoadUsersWithError);
    on<RetryLoadUsersEvent>(_onRetryLoadUsers);
  }

  /// Handles the LoadUsersEvent
  ///
  /// EVENT HANDLER FLOW:
  /// 1. Emit UserLoadingState - UI shows loading indicator
  /// 2. Call Use Case - Business logic execution
  /// 3. Emit UserLoadedState with data - UI displays users list
  /// 4. Emit UserErrorState on failure - UI shows error message
  ///
  /// CLEAN ARCHITECTURE FLOW:
  /// BLoC → Use Case → Repository → Data Source → API
  ///
  /// KEY POINTS:
  /// - Event handlers are always async (even if use case is sync)
  /// - Use Emitter to emit multiple states during one event
  /// - Always emit loading state first for better UX
  /// - Handle errors gracefully with try-catch
  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    // Step 1: Emit loading state - UI will show CircularProgressIndicator
    emit(UserLoadingState());

    try {
      // Step 2: Call use case (not repository/service directly!)
      // NoParams() because this use case doesn't need parameters
      // Use cases encapsulate business logic and return domain entities
      final users = await getUsersUseCase(NoParams());
      
      // Step 3: Emit success state with fetched data
      emit(UserLoadedState(users));
    } catch (error) {
      // Step 4: Emit error state with error message
      // In production, you might want to use custom error types
      emit(UserErrorState(error.toString()));
    }
  }

  /// Handles the LoadUsersWithErrorEvent
  ///
  /// DEMONSTRATES ERROR HANDLING:
  /// - This use case intentionally throws an error
  /// - Useful for testing error states in UI
  /// - In real apps, errors come from network issues, server errors, etc.
  Future<void> _onLoadUsersWithError(
    LoadUsersWithErrorEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());

    try {
      // This use case will throw an exception (for demo purposes)
      final users = await getUsersWithErrorUseCase(NoParams());
      // This line won't be reached
      emit(UserLoadedState(users));
    } catch (error) {
      // Error is caught and emitted as ErrorState
      emit(UserErrorState(error.toString()));
    }
  }

  /// Handles the RetryLoadUsersEvent
  ///
  /// EVENT HANDLER REUSE:
  /// - Delegates to _onLoadUsers handler
  /// - Avoids code duplication
  /// - Ensures retry uses the same logic as initial load
  Future<void> _onRetryLoadUsers(
    RetryLoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    // Reuse the load users logic by calling its handler directly
    await _onLoadUsers(LoadUsersEvent(), emit);
  }
}
