import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/user_api_service.dart';
import 'user_event.dart';
import 'user_state.dart';

/// BLoC (Business Logic Component) that manages user data state
///
/// This class handles:
/// - Receiving events from the UI
/// - Calling the API service
/// - Emitting appropriate states based on the API response
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApiService userApiService;

  /// Constructor initializes the BLoC with the initial state
  /// and registers event handlers
  UserBloc({required this.userApiService}) : super(UserInitialState()) {
    // Register handler for LoadUsersEvent
    on<LoadUsersEvent>(_onLoadUsers);

    // Register handler for LoadUsersWithErrorEvent
    on<LoadUsersWithErrorEvent>(_onLoadUsersWithError);

    // Register handler for RetryLoadUsersEvent
    on<RetryLoadUsersEvent>(_onRetryLoadUsers);
  }

  /// Handles the LoadUsersEvent
  ///
  /// 1. Emits UserLoadingState to show loading indicator
  /// 2. Calls API to fetch users
  /// 3. Emits UserLoadedState with data on success
  /// 4. Emits UserErrorState on failure
  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    // Emit loading state
    emit(UserLoadingState());

    try {
      // Call API service to fetch users
      final users = await userApiService.fetchUsers();

      // Emit success state with the fetched users
      emit(UserLoadedState(users));
    } catch (error) {
      // Emit error state with error message
      emit(UserErrorState(error.toString()));
    }
  }

  /// Handles the LoadUsersWithErrorEvent
  ///
  /// This demonstrates error handling by calling an API that will fail
  Future<void> _onLoadUsersWithError(
    LoadUsersWithErrorEvent event,
    Emitter<UserState> emit,
  ) async {
    // Emit loading state
    emit(UserLoadingState());

    try {
      // Call API service that will throw an error
      final users = await userApiService.fetchUsersWithError();

      // This line won't be reached due to the error
      emit(UserLoadedState(users));
    } catch (error) {
      // Emit error state with error message
      emit(UserErrorState(error.toString()));
    }
  }

  /// Handles the RetryLoadUsersEvent
  ///
  /// Simply delegates to the standard load users logic
  Future<void> _onRetryLoadUsers(
    RetryLoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    // Re-use the same logic as LoadUsersEvent
    await _onLoadUsers(LoadUsersEvent(), emit);
  }
}
