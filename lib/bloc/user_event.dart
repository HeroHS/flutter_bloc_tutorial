/// Base class for all User-related events
/// Events represent actions/intentions that occur in the UI
sealed class UserEvent {}

/// Event triggered when users should be loaded from the API
/// This is typically called when the screen first loads or on refresh
final class LoadUsersEvent extends UserEvent {}

/// Event triggered when users should be loaded with a simulated error
/// This is useful for testing error handling
final class LoadUsersWithErrorEvent extends UserEvent {}

/// Event triggered when the user wants to retry loading after an error
final class RetryLoadUsersEvent extends UserEvent {}
