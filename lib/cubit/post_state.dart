import '../models/post.dart';

/// Base class for all Post-related states in Cubit
///
/// Cubit uses the same state pattern as BLoC, but without events!
/// The Cubit directly emits states through method calls
sealed class PostState {}

/// Initial state before any data loading has occurred
final class PostInitialState extends PostState {}

/// State when data is being loaded from the API
/// UI should show a loading indicator in this state
final class PostLoadingState extends PostState {}

/// State when data has been successfully loaded
/// UI should display the posts list in this state
final class PostLoadedState extends PostState {
  final List<Post> posts;

  PostLoadedState(this.posts);
}

/// State when an error occurred while loading data
/// UI should display an error message and retry option in this state
final class PostErrorState extends PostState {
  final String errorMessage;

  PostErrorState(this.errorMessage);
}

/// Additional state to show we can have more complex states
/// This shows posts being refreshed while still displaying old data
final class PostRefreshingState extends PostState {
  final List<Post> currentPosts; // Keep showing these while refreshing

  PostRefreshingState(this.currentPosts);
}
