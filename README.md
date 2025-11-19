# Flutter BLoC & Cubit Tutorial App

A comprehensive tutorial application demonstrating **two state management patterns**: BLoC (event-driven) and Cubit (method-driven) using `flutter_bloc` to manage state when loading data from an API.

## 📚 What You'll Learn

This tutorial demonstrates:
- ✅ **BLoC Pattern**: Event-driven architecture with events and states
- ✅ **Cubit Pattern**: Simplified approach with direct method calls (no events)
- ✅ Managing different UI states (Initial, Loading, Success, Error, Refreshing)
- ✅ Simulating API calls with `Future.delayed`
- ✅ Handling errors gracefully with retry logic
- ✅ Using `BlocProvider` and `BlocBuilder` for both patterns
- ✅ **When to use BLoC vs Cubit** for your projects

## 🏗️ Project Structure

```
lib/
├── bloc/                    # BLoC pattern example (User)
│   ├── user_bloc.dart      # BLoC implementation
│   ├── user_event.dart     # Event definitions
│   └── user_state.dart     # State definitions
├── cubit/                   # Cubit pattern example (Post)
│   ├── post_cubit.dart     # Cubit implementation (no events!)
│   └── post_state.dart     # State definitions
├── models/
│   ├── user.dart           # User data model
│   └── post.dart           # Post data model
├── screens/
│   ├── home_screen.dart    # Home screen with pattern selection
│   ├── user_list_screen.dart # BLoC pattern UI
│   └── post_list_screen.dart # Cubit pattern UI
├── services/
│   ├── user_api_service.dart # Simulated User API
│   └── post_api_service.dart # Simulated Post API
└── main.dart               # App entry point
```

## 🎯 Key Concepts

### BLoC Pattern (User Example)

#### 1. Events
Events represent user actions or system events:
- `LoadUsersEvent` - Triggered to load users successfully
- `LoadUsersWithErrorEvent` - Triggered to simulate an error
- `RetryLoadUsersEvent` - Triggered to retry after an error

#### 2. States
States represent the current condition of the UI:
- `UserInitialState` - Initial state before any action
- `UserLoadingState` - Data is being loaded (shows loading indicator)
- `UserLoadedState` - Data loaded successfully (shows user list)
- `UserErrorState` - An error occurred (shows error message)

#### 3. BLoC
The `UserBloc` class:
- Receives events from the UI
- Calls the API service
- Emits appropriate states based on the result
- Keeps business logic separate from UI

### Cubit Pattern (Post Example)

#### 1. No Events!
Cubit doesn't use events - you call methods directly:
```dart
// BLoC way
context.read<UserBloc>().add(LoadUsersEvent());

// Cubit way
context.read<PostCubit>().loadPosts();
```

#### 2. States (Same Pattern as BLoC)
- `PostInitialState` - Initial state
- `PostLoadingState` - Data is being loaded
- `PostLoadedState` - Data loaded successfully
- `PostErrorState` - An error occurred
- `PostRefreshingState` - Refreshing while showing old data

#### 3. Cubit Methods
The `PostCubit` class provides direct methods:
- `loadPosts()` - Load posts from API
- `loadPostsWithError()` - Simulate error
- `retry()` - Retry after error
- `refreshPosts()` - Refresh with optimistic update
- `clear()` - Reset to initial state

## 🔍 BLoC vs Cubit Comparison

| Feature | BLoC | Cubit |
|---------|------|-------|
| **Events** | Required | Not needed |
| **How to trigger** | `bloc.add(Event())` | `cubit.method()` |
| **Boilerplate** | More (events + states) | Less (only states) |
| **Use case** | Complex logic, event tracking | Simple state changes |
| **Files needed** | 3 (bloc, events, states) | 2 (cubit, states) |
| **Learning curve** | Steeper | Gentler |
| **Code reduction** | - | ~40% less code |

## 🚀 How to Run

1. Make sure you have Flutter installed
2. Navigate to the project directory
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 🎮 Using the App

### Home Screen
When you launch, you'll see two options:
1. **BLoC Pattern** - Event-driven architecture (User example)
2. **Cubit Pattern** - Direct method calls (Post example)

### BLoC Pattern Tutorial (User List)
1. **Initial State**: Welcome screen with two buttons
2. **Load Users (Success)**: Click to simulate successful API call
   - Watch the loading indicator appear
   - After 2 seconds, see the user list displayed
3. **Load Users (Error)**: Click to simulate a failed API call
   - Watch the loading indicator appear
   - After 2 seconds, see an error message
   - Click "Retry" to try loading again
4. **Info Button**: Tap for BLoC pattern information

### Cubit Pattern Tutorial (Post List)
1. **Initial State**: Welcome screen with comparison info
2. **Load Posts (Success)**: Click to see direct method call in action
   - Observe the same loading → success flow
   - No events needed!
3. **Load Posts (Error)**: Test error handling
   - Same user experience, simpler code
4. **Refresh Button**: In app bar - demonstrates advanced refresh pattern
5. **Info Button**: Tap for Cubit pattern information

## 🔍 Code Walkthrough

### BLoC Pattern: API Service (`user_api_service.dart`)
```dart
Future<List<User>> fetchUsers() async {
  await Future.delayed(const Duration(seconds: 2)); // Simulates network delay
  return [/* mock users */];
}
```

### BLoC Pattern: Event Handler (`user_bloc.dart`)
```dart
Future<void> _onLoadUsers(LoadUsersEvent event, Emitter<UserState> emit) async {
  emit(UserLoadingState());           // Show loading
  try {
    final users = await userApiService.fetchUsers();
    emit(UserLoadedState(users));     // Show data
  } catch (error) {
    emit(UserErrorState(error.toString())); // Show error
  }
}
```

### BLoC Pattern: UI with BlocBuilder (`user_list_screen.dart`)
```dart
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    return switch (state) {
      UserInitialState() => _buildInitialView(context),
      UserLoadingState() => _buildLoadingView(),
      UserLoadedState() => _buildLoadedView(state.users),
      UserErrorState() => _buildErrorView(context, state.errorMessage),
    };
  },
)
```

### Cubit Pattern: Direct Method (`post_cubit.dart`)
```dart
Future<void> loadPosts() async {
  emit(PostLoadingState());           // Show loading
  try {
    final posts = await postApiService.fetchPosts();
    emit(PostLoadedState(posts));     // Show data
  } catch (error) {
    emit(PostErrorState(error.toString())); // Show error
  }
}
```

### Cubit Pattern: UI Calling Method (`post_list_screen.dart`)
```dart
// Dispatching is simpler - just call the method!
ElevatedButton(
  onPressed: () => context.read<PostCubit>().loadPosts(),
  child: Text('Load Posts'),
)

// BlocBuilder works the same way
BlocBuilder<PostCubit, PostState>(
  builder: (context, state) {
    return switch (state) {
      PostInitialState() => _buildInitialView(context),
      PostLoadingState() => _buildLoadingView(),
      PostLoadedState() => _buildLoadedView(state.posts, false),
      PostRefreshingState() => _buildLoadedView(state.currentPosts, true),
      PostErrorState() => _buildErrorView(context, state.errorMessage),
    };
  },
)
```

## 📦 Dependencies

- `flutter_bloc: ^9.1.1` - BLoC state management library
- `bloc: ^9.1.0` - Core BLoC library
- `intl: ^0.19.0` - Internationalization and date formatting

## 💡 Best Practices Demonstrated

1. **Separation of Concerns**: Business logic is in BLoC/Cubit, UI is in widgets
2. **Immutable States**: All states are immutable for predictability
3. **Error Handling**: Proper error handling with user-friendly messages
4. **Loading States**: Clear feedback during async operations
5. **Sealed Classes**: Using sealed classes for type-safe state handling
6. **Dependency Injection**: BLoC/Cubit receives API service via constructor
7. **Pattern Selection**: Choose the right tool (BLoC vs Cubit) for the job

## 🎨 Advanced Patterns Demonstrated

### Optimistic Updates (Cubit)
The `refreshPosts()` method shows an advanced pattern:
- Keeps showing current data while refreshing
- Shows loading indicator overlay
- Restores previous data if refresh fails
- Great for pull-to-refresh scenarios

```dart
Future<void> refreshPosts() async {
  if (state is PostLoadedState) {
    final currentPosts = (state as PostLoadedState).posts;
    emit(PostRefreshingState(currentPosts));
  } else {
    emit(PostLoadingState());
  }
  
  try {
    final posts = await postApiService.fetchPosts();
    emit(PostLoadedState(posts));
  } catch (error) {
    if (state is PostRefreshingState) {
      final previousPosts = (state as PostRefreshingState).currentPosts;
      emit(PostLoadedState(previousPosts)); // Restore on error
    } else {
      emit(PostErrorState(error.toString()));
    }
  }
}
```

## 🧪 Try Modifying

Want to experiment? Try these:
- Change the delay duration in API services
- Add more fields to User or Post models
- Create a search feature using BLoC events or Cubit methods
- Implement pagination with LoadMoreEvent or loadMore() method
- Add a favorites feature with a separate BLoC/Cubit
- Compare the code size between BLoC and Cubit implementations

## 📖 Learn More

### Documentation Files
- **ARCHITECTURE.md** - Flow diagrams for both patterns
- **QUICK_REFERENCE.md** - Code snippets and common patterns
- **CUBIT_GUIDE.md** - Deep dive into Cubit vs BLoC
- **EXERCISES.md** - Practice exercises for both patterns
- **BEGINNERS_GUIDE.dart** - Step-by-step explanation
- **TUTORIAL_OVERVIEW.md** - Complete package overview

### External Resources
- [BLoC Library Documentation](https://bloclibrary.dev)
- [Flutter Documentation](https://flutter.dev/docs)
- [Cubit vs BLoC](https://bloclibrary.dev/#/coreconcepts?id=cubit-vs-bloc)

## ✅ When to Use Each Pattern

### Use BLoC When:
- ✓ You need event tracking/logging
- ✓ Complex business logic with multiple events triggering same state
- ✓ Event transformations needed (debounce, throttle)
- ✓ Team prefers strict event-driven architecture
- ✓ Large applications with complex flows

### Use Cubit When:
- ✓ Simple, straightforward state changes
- ✓ Prototyping or MVP development
- ✓ Less complex business logic
- ✓ Want to reduce boilerplate (~40% less code)
- ✓ Team prefers simplicity
- ✓ Direct method calls feel more natural

## 🤝 Contributing

This is a tutorial project. Feel free to fork and modify it for your learning!

## 📄 License

This project is open source and available for educational purposes.
