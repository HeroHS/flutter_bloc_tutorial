import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/get_posts_with_error.dart';
import '../../../../core/usecases/usecase.dart';
import 'post_state.dart';

/// Cubit for managing post data state
///
/// WHAT IS CUBIT?
/// Cubit is a simplified version of BLoC that:
/// - Exposes methods instead of accepting events
/// - Directly emits states from methods
/// - Has less boilerplate (no event classes needed)
/// - Still uses the same state pattern as BLoC
///
/// CUBIT vs BLOC - KEY DIFFERENCES:
/// ┌─────────────────┬──────────────────────┬─────────────────────┐
/// │ Feature         │ BLoC                 │ Cubit               │
/// ├─────────────────┼──────────────────────┼─────────────────────┤
/// │ Input           │ Events (add)         │ Methods (call)      │
/// │ Boilerplate     │ More (events file)   │ Less (no events)    │
/// │ Complexity      │ Higher               │ Lower               │
/// │ Transformations │ Yes (debounce, etc.) │ No                  │
/// │ Event Tracking  │ Yes                  │ No                  │
/// │ Use Case        │ Complex logic        │ Simple logic        │
/// └─────────────────┴──────────────────────┴─────────────────────┘
///
/// WHEN TO USE CUBIT:
/// ✓ Simple state changes
/// ✓ Direct method calls feel more natural
/// ✓ Less complex business logic
/// ✓ Don't need event tracking/logging
/// ✓ No need for event transformations
///
/// WHEN TO USE BLOC INSTEAD:
/// ✓ Complex business logic with multiple events
/// ✓ Need to track/log events for debugging
/// ✓ Multiple events trigger same state change
/// ✓ Event transformations (debounce, throttle, distinct)
/// ✓ Advanced features like event buffering
///
/// CLEAN ARCHITECTURE WITH CUBIT:
/// - Still uses Use Cases (not repositories directly)
/// - Follows same dependency rules as BLoC
/// - Belongs to Presentation Layer
/// - Only knows about Domain Layer (use cases, entities)
///
/// UI USAGE:
/// // BLoC: context.read<UserBloc>().add(LoadUsersEvent());
/// // Cubit: context.read<PostCubit>().loadPosts(); ← Direct method call!
class PostCubit extends Cubit<PostState> {
  final GetPosts getPostsUseCase;
  final GetPostsWithError getPostsWithErrorUseCase;

  /// Constructor initializes with initial state
  ///
  /// KEY DIFFERENCE FROM BLOC:
  /// - No event handlers to register (no on<Event> calls)
  /// - Just set initial state and inject dependencies
  /// - Methods are called directly from UI
  PostCubit({
    required this.getPostsUseCase,
    required this.getPostsWithErrorUseCase,
  }) : super(PostInitialState());

  /// Load posts from the API
  ///
  /// DIRECT METHOD CALL PATTERN:
  /// - No events needed! Call this method directly from UI
  /// - Example: context.read<PostCubit>().loadPosts();
  ///
  /// FLOW:
  /// 1. Emit loading state → UI shows CircularProgressIndicator
  /// 2. Call use case → Business logic executes
  /// 3. Emit loaded/error state → UI updates accordingly
  ///
  /// CLEAN ARCHITECTURE FLOW:
  /// Cubit → Use Case → Repository → Data Source → API
  ///
  /// ASYNC/AWAIT:
  /// - Method is async because use case is async
  /// - emit() is synchronous (emits state immediately)
  /// - State changes trigger UI rebuilds via BlocBuilder
  Future<void> loadPosts() async {
    // Emit loading state - UI will show loading indicator
    emit(PostLoadingState());

    try {
      // Call use case to fetch posts
      // NoParams() because this use case doesn't need parameters
      final posts = await getPostsUseCase(NoParams());
      
      // Emit success state with the fetched posts
      emit(PostLoadedState(posts));
    } catch (error) {
      // Emit error state with error message
      // In production, consider custom error types for better handling
      emit(PostErrorState(error.toString()));
    }
  }

  /// Load posts with intentional error (for demo purposes)
  ///
  /// DEMONSTRATES ERROR HANDLING:
  /// - Shows how Cubit handles exceptions
  /// - Useful for testing error states in UI
  /// - Same pattern as loadPosts() but calls error use case
  Future<void> loadPostsWithError() async {
    emit(PostLoadingState());

    try {
      // This use case will throw an exception
      final posts = await getPostsWithErrorUseCase(NoParams());
      emit(PostLoadedState(posts));
    } catch (error) {
      emit(PostErrorState(error.toString()));
    }
  }

  /// Retry loading after an error
  ///
  /// ERROR RECOVERY PATTERN:
  /// - Simple method that delegates to loadPosts()
  /// - Reuses logic instead of duplicating code
  /// - Called when user clicks "Retry" button
  Future<void> retry() async {
    await loadPosts();
  }

  /// Refresh posts (advanced pattern)
  ///
  /// OPTIMISTIC UI PATTERN:
  /// - Keeps old data visible while refreshing
  /// - Better UX than showing loading spinner
  /// - Common in pull-to-refresh scenarios
  ///
  /// FLOW:
  /// 1. If we have data, emit PostRefreshingState (keeps showing old posts)
  /// 2. Otherwise, emit PostLoadingState (show spinner)
  /// 3. Fetch new data
  /// 4. On success: emit PostLoadedState with new data
  /// 5. On failure: restore old data (if available) or show error
  ///
  /// STATE CHECKING:
  /// - Use 'state is PostLoadedState' to check current state
  /// - Cast with 'state as PostLoadedState' to access data
  /// - This is type-safe because of the is check
  Future<void> refreshPosts() async {
    // Check if we already have data
    if (state is PostLoadedState) {
      // Keep showing current posts while refreshing
      final currentPosts = (state as PostLoadedState).posts;
      emit(PostRefreshingState(currentPosts));
    } else {
      // No existing data, show loading spinner
      emit(PostLoadingState());
    }

    try {
      // Fetch fresh data
      final posts = await getPostsUseCase(NoParams());
      emit(PostLoadedState(posts));
    } catch (error) {
      // If refresh fails and we had previous data, restore it
      if (state is PostRefreshingState) {
        final previousPosts = (state as PostRefreshingState).currentPosts;
        emit(PostLoadedState(previousPosts));
        // In production, you might show a SnackBar here
      } else {
        // No previous data, show error
        emit(PostErrorState(error.toString()));
      }
    }
  }

  /// Clear all posts and return to initial state
  ///
  /// SYNCHRONOUS STATE CHANGE:
  /// - Cubit can emit states synchronously (no await needed)
  /// - Useful for simple state changes
  /// - Instant UI update
  ///
  /// USE CASES:
  /// - User logs out
  /// - Clearing cache
  /// - Resetting form
  void clear() {
    emit(PostInitialState());
  }

  /// Reset to initial state (alias for clear)
  ///
  /// DEMONSTRATES MULTIPLE METHODS FOR SAME STATE:
  /// - Sometimes multiple methods emit the same state
  /// - Provides semantic clarity (clear vs reset)
  /// - Both do the same thing here
  void reset() {
    emit(PostInitialState());
  }

  // ADDITIONAL PATTERNS YOU CAN IMPLEMENT:
  
  /// Example: Method with parameters
  /// 
  /// PARAMETERIZED METHODS:
  /// - Cubit methods can accept parameters
  /// - Parameters influence the state emitted
  /// - More flexible than events in some cases
  ///
  // void searchPosts(String query) {
  //   emit(PostLoadingState());
  //   // Filter posts by query
  //   final filteredPosts = posts.where((p) => 
  //     p.title.toLowerCase().contains(query.toLowerCase())
  //   ).toList();
  //   emit(PostLoadedState(filteredPosts));
  // }

  /// Example: Method that doesn't emit (getter/query)
  ///
  /// NON-EMITTING METHODS:
  /// - Not all methods need to emit states
  /// - Can have helper methods that just return data
  /// - Useful for queries without state changes
  ///
  // bool hasLoadedPosts() {
  //   return state is PostLoadedState;
  // }
  //
  // int getPostCount() {
  //   if (state is PostLoadedState) {
  //     return (state as PostLoadedState).posts.length;
  //   }
  //   return 0;
  // }
}
