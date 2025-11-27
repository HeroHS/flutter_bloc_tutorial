import '../../domain/entities/post.dart';

/// Base class for all Post-related states in Cubit
///
/// CUBIT USES SAME STATE PATTERN AS BLOC:
/// - Sealed class for exhaustive pattern matching
/// - Same state types (Initial, Loading, Loaded, Error)
/// - The ONLY difference is how states are triggered:
///   • BLoC: Events → Event Handlers → emit(state)
///   • Cubit: Methods → emit(state) directly
///
/// STATE MANAGEMENT IS IDENTICAL:
/// - UI uses BlocBuilder<PostCubit, PostState>
/// - Same switch expressions for pattern matching
/// - Same immutability principles
///
/// USAGE IN UI:
/// BlocBuilder<PostCubit, PostState>(
///   builder: (context, state) {
///     return switch (state) {
///       PostInitialState() => WelcomeView(),
///       PostLoadingState() => LoadingSpinner(),
///       PostLoadedState() => PostsList(state.posts),
///       PostErrorState() => ErrorView(state.errorMessage),
///       PostRefreshingState() => PostsList(state.currentPosts), // Shows old data
///     };
///   },
/// )
sealed class PostState {}

/// Initial state before any data loading has occurred
///
/// WHEN EMITTED:
/// - Cubit constructor: super(PostInitialState())
/// - After calling clear() or reset() methods
/// - Before user triggers any data loading
final class PostInitialState extends PostState {}

/// State when data is being loaded from the API
///
/// WHEN EMITTED:
/// - At start of loadPosts() method
/// - Before calling the use case
/// - In refreshPosts() if no previous data exists
///
/// UI BEHAVIOR:
/// - Show CircularProgressIndicator centered
/// - Display "Loading posts..." message
final class PostLoadingState extends PostState {}

/// State when data has been successfully loaded
///
/// WHEN EMITTED:
/// - After successful getPostsUseCase() call
/// - Contains the fetched posts
/// - After successful refresh
///
/// UI BEHAVIOR:
/// - Display posts in ListView
/// - Enable pull-to-refresh
/// - Show post count
///
/// IMMUTABILITY:
/// - The List<Post> is final
/// - To update, emit new PostLoadedState with new list
final class PostLoadedState extends PostState {
  final List<Post> posts;

  PostLoadedState(this.posts);
}

/// State when an error occurred while loading data
///
/// WHEN EMITTED:
/// - Use case throws exception
/// - Network/server/parsing errors
/// - After catch block in async methods
///
/// UI BEHAVIOR:
/// - Display error message
/// - Show retry button
/// - Use error color scheme
final class PostErrorState extends PostState {
  final String errorMessage;

  PostErrorState(this.errorMessage);
}

/// State when refreshing while displaying old data
///
/// ADVANCED STATE - OPTIMISTIC UI:
/// - Unique to this example (not required for basic Cubit)
/// - Keeps old posts visible during refresh
/// - Better UX than showing loading spinner
///
/// WHEN EMITTED:
/// - In refreshPosts() when state is already PostLoadedState
/// - Shows user something while fetching fresh data
///
/// UI BEHAVIOR:
/// - Display currentPosts (old data)
/// - Show small refresh indicator (e.g., in AppBar)
/// - Don't block entire screen with loading spinner
///
/// TRANSITION:
/// PostLoadedState → PostRefreshingState → PostLoadedState (new data)
///                                       → PostLoadedState (old data on error)
///
/// PATTERN USAGE:
/// This demonstrates you can have as many states as needed!
/// Don't limit yourself to just Initial/Loading/Loaded/Error.
final class PostRefreshingState extends PostState {
  final List<Post> currentPosts; // Keep showing these while refreshing

  PostRefreshingState(this.currentPosts);
}
