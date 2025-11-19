import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/post_api_service.dart';
import 'post_state.dart';

/// Cubit for managing post data state
///
/// KEY DIFFERENCE FROM BLOC:
/// - No events! You call methods directly on the Cubit
/// - Simpler: Just emit states from methods
/// - Less boilerplate: No event classes needed
///
/// WHEN TO USE CUBIT:
/// - Simple state changes
/// - Direct method calls from UI
/// - Less complex business logic
/// - When you don't need event tracking
///
/// WHEN TO USE BLOC INSTEAD:
/// - Complex business logic
/// - Need to track/log events
/// - Multiple events trigger same state
/// - Event transformations (debounce, throttle)
class PostCubit extends Cubit<PostState> {
  final PostApiService postApiService;

  /// Constructor initializes with initial state
  /// No event handlers to register - just methods!
  PostCubit({required this.postApiService}) : super(PostInitialState());

  /// Load posts from the API
  ///
  /// This is called DIRECTLY from the UI, no events needed!
  /// Example: context.read<PostCubit>().loadPosts();
  ///
  /// Flow:
  /// 1. Emit loading state
  /// 2. Call API
  /// 3. Emit loaded or error state
  Future<void> loadPosts() async {
    // Emit loading state - UI will show loading indicator
    emit(PostLoadingState());

    try {
      // Call API service to fetch posts
      final posts = await postApiService.fetchPosts();

      // Emit success state with the fetched posts
      emit(PostLoadedState(posts));
    } catch (error) {
      // Emit error state with error message
      emit(PostErrorState(error.toString()));
    }
  }

  /// Load posts with intentional error (for demo purposes)
  ///
  /// This demonstrates error handling
  Future<void> loadPostsWithError() async {
    emit(PostLoadingState());

    try {
      final posts = await postApiService.fetchPostsWithError();
      emit(PostLoadedState(posts));
    } catch (error) {
      emit(PostErrorState(error.toString()));
    }
  }

  /// Retry loading after an error
  ///
  /// Simple method - just delegates to loadPosts
  Future<void> retry() async {
    await loadPosts();
  }

  /// Refresh posts (shows advanced pattern)
  ///
  /// This demonstrates how to keep old data visible while refreshing
  /// Useful for pull-to-refresh scenarios
  Future<void> refreshPosts() async {
    // If we have data, show refreshing state with current data
    if (state is PostLoadedState) {
      final currentPosts = (state as PostLoadedState).posts;
      emit(PostRefreshingState(currentPosts));
    } else {
      // Otherwise just show loading
      emit(PostLoadingState());
    }

    try {
      final posts = await postApiService.fetchPosts();
      emit(PostLoadedState(posts));
    } catch (error) {
      // If refresh fails, try to restore previous state
      if (state is PostRefreshingState) {
        final previousPosts = (state as PostRefreshingState).currentPosts;
        emit(PostLoadedState(previousPosts));
        // You might want to show a snackbar here
      } else {
        emit(PostErrorState(error.toString()));
      }
    }
  }

  /// Clear all posts and return to initial state
  ///
  /// Example of a simple state change
  void clear() {
    emit(PostInitialState());
  }

  /// Example of a synchronous state change
  ///
  /// Cubit can emit states synchronously too!
  void reset() {
    emit(PostInitialState());
  }

  // Example: Method with parameters
  // void searchPosts(String query) {
  //   emit(PostLoadingState());
  //   // ... search logic
  // }

  // Example: Method that doesn't emit
  // bool hasLoadedPosts() {
  //   return state is PostLoadedState;
  // }
}
