import '../../domain/entities/user.dart';

/// Base class for all User-related states
///
/// WHAT ARE STATES?
/// States represent the current condition of data and UI.
/// The BLoC emits states, and the UI rebuilds based on state changes.
///
/// WHY SEALED CLASS?
/// - Enables exhaustive pattern matching in UI with switch expressions
/// - Compiler ensures all states are handled
/// - No risk of forgetting to handle a state
///
/// STATE NAMING CONVENTION:
/// - Use nouns or adjectives: UserLoadingState, UserLoadedState
/// - End with "State" suffix
/// - Be descriptive: UserLoadingState > LoadingState
///
/// USAGE IN UI:
/// BlocBuilder<UserBloc, UserState>(
///   builder: (context, state) {
///     return switch (state) {
///       UserInitialState() => InitialWidget(),
///       UserLoadingState() => CircularProgressIndicator(),
///       UserLoadedState() => ListView(...),
///       UserErrorState() => ErrorWidget(),
///     };
///   },
/// )
sealed class UserState {}

/// Initial state before any data loading has occurred
///
/// WHEN EMITTED:
/// - BLoC constructor (super(UserInitialState()))
/// - After clearing/resetting data
/// - Before any events are processed
///
/// UI BEHAVIOR:
/// - Show empty state or welcome message
/// - Display action buttons to trigger data loading
/// - No loading indicator (nothing is loading yet)
final class UserInitialState extends UserState {}

/// State when data is being loaded from the API
///
/// WHEN EMITTED:
/// - Immediately after receiving a LoadUsersEvent
/// - Before calling the use case
/// - Gives instant feedback to the user
///
/// UI BEHAVIOR:
/// - Show CircularProgressIndicator
/// - Display "Loading..." message
/// - Disable action buttons to prevent duplicate requests
///
/// DURATION:
/// - Short-lived (only while async operation is in progress)
/// - Typically 1-5 seconds for API calls
final class UserLoadingState extends UserState {}

/// State when data has been successfully loaded
///
/// WHEN EMITTED:
/// - After successful use case execution
/// - Contains the fetched data (List<User>)
///
/// UI BEHAVIOR:
/// - Display data in ListView or other widgets
/// - Hide loading indicators
/// - Enable refresh/reload actions
///
/// DATA HANDLING:
/// - State is immutable (final List<User> users)
/// - To update data, emit a new UserLoadedState with new list
final class UserLoadedState extends UserState {
  final List<User> users;

  UserLoadedState(this.users);
}

/// State when an error occurred while loading data
///
/// WHEN EMITTED:
/// - Use case throws an exception
/// - Network error, server error, parsing error, etc.
/// - Contains error message for display
///
/// UI BEHAVIOR:
/// - Display error message to user
/// - Show retry button
/// - Use error icon/color for better UX
///
/// ERROR RECOVERY:
/// - User can dispatch RetryLoadUsersEvent
/// - Or navigate back/refresh manually
///
/// BEST PRACTICES:
/// - Don't expose technical errors to users
/// - Provide actionable error messages
/// - Log detailed errors for debugging
final class UserErrorState extends UserState {
  final String errorMessage;

  UserErrorState(this.errorMessage);
}
