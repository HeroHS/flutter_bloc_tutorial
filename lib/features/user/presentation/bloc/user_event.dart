/// Base class for all User-related events
///
/// WHAT ARE EVENTS?
/// Events represent user actions or intentions that trigger business logic.
/// They are dispatched from the UI to the BLoC.
///
/// WHY SEALED CLASS?
/// - Enables exhaustive pattern matching (compiler checks all cases)
/// - Cannot be extended outside this file
/// - Perfect for state machines and event systems
///
/// EVENT NAMING CONVENTION:
/// - Use descriptive names: LoadUsersEvent, DeleteUserEvent, UpdateUserEvent
/// - End with "Event" suffix
/// - Use present tense imperative: Load, Update, Delete (not Loading, Updating)
///
/// DISPATCHING FROM UI:
/// context.read<UserBloc>().add(LoadUsersEvent());
sealed class UserEvent {}

/// Event triggered when users should be loaded from the API
///
/// WHEN TO DISPATCH:
/// - Screen first loads (in initState or when BlocBuilder builds)
/// - User pulls to refresh
/// - User clicks a refresh button
///
/// EXAMPLE:
/// ElevatedButton(
///   onPressed: () => context.read<UserBloc>().add(LoadUsersEvent()),
///   child: Text('Load Users'),
/// )
final class LoadUsersEvent extends UserEvent {}

/// Event triggered to demonstrate error handling
///
/// LEARNING PURPOSE:
/// - This event intentionally calls a use case that fails
/// - Helps understand how BLoC handles errors
/// - In real apps, errors occur naturally from network/server issues
///
/// USE CASE:
/// - Testing error UI states
/// - Demonstrating error recovery with retry
final class LoadUsersWithErrorEvent extends UserEvent {}

/// Event triggered when the user wants to retry loading after an error
///
/// ERROR RECOVERY PATTERN:
/// - Dispatched when user clicks "Retry" button in error state
/// - Reuses the same logic as LoadUsersEvent
/// - Provides better UX than just showing an error permanently
///
/// EXAMPLE:
/// ElevatedButton(
///   onPressed: () => context.read<UserBloc>().add(RetryLoadUsersEvent()),
///   child: Text('Retry'),
/// )
final class RetryLoadUsersEvent extends UserEvent {}
