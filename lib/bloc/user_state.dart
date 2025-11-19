import '../models/user.dart';

/// Base class for all User-related states
/// States represent the current condition of the data/UI
sealed class UserState {}

/// Initial state before any data loading has occurred
final class UserInitialState extends UserState {}

/// State when data is being loaded from the API
/// UI should show a loading indicator in this state
final class UserLoadingState extends UserState {}

/// State when data has been successfully loaded
/// UI should display the users list in this state
final class UserLoadedState extends UserState {
  final List<User> users;

  UserLoadedState(this.users);
}

/// State when an error occurred while loading data
/// UI should display an error message and retry button in this state
final class UserErrorState extends UserState {
  final String errorMessage;

  UserErrorState(this.errorMessage);
}
