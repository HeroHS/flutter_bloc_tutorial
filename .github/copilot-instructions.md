# Flutter BLoC Tutorial - AI Coding Agent Instructions

## Project Overview
Educational Flutter app demonstrating **two state management patterns**: BLoC (event-driven) and Cubit (method-driven). Features mock API services, comprehensive documentation, and progressive learning exercises.

## Architecture Patterns

### BLoC Pattern (User Example - `lib/bloc/`)
**Event-driven architecture** with explicit event dispatching:
- **Events** (`user_event.dart`): Sealed classes extending base event (e.g., `LoadUsersEvent`, `RetryLoadUsersEvent`)
- **States** (`user_state.dart`): Sealed classes for exhaustive pattern matching (`UserInitialState`, `UserLoadingState`, `UserLoadedState`, `UserErrorState`)
- **BLoC** (`user_bloc.dart`): Event handlers registered in constructor with `on<EventType>(handler)`
- **UI dispatch**: `context.read<UserBloc>().add(LoadUsersEvent())`

### Cubit Pattern (Post Example - `lib/cubit/`)
**Direct method calls** without events - 40% less boilerplate:
- **States** (`post_state.dart`): Same sealed class pattern as BLoC
- **Cubit** (`post_cubit.dart`): Direct async methods that emit states (e.g., `loadPosts()`, `retry()`)
- **UI dispatch**: `context.read<PostCubit>().loadPosts()` - call methods directly
- **No events**: Skip event file entirely

### State Management Conventions
- Use **sealed classes** for all events/states to enable exhaustive switch statements
- **Immutable states**: All state properties are `final`
- **State transitions**: Always emit loading → success/error sequence
- **UI rebuilding**: Use `BlocBuilder` with pattern matching via `switch (state)`

## Project Structure
```
lib/
├── bloc/           # BLoC pattern example (User)
├── cubit/          # Cubit pattern example (Post)
├── models/         # Data models with fromJson/toJson
├── services/       # Mock API services (2s delay simulation)
└── screens/        # UI with BlocProvider/BlocBuilder
```

## Critical Patterns

### Service Layer
Mock APIs in `services/` simulate network delays with `Future.delayed(Duration(seconds: 2))`. All services have success and error methods (`fetchUsers()` vs `fetchUsersWithError()`).

### Providing State Management
```dart
// main.dart or screen level
BlocProvider(
  create: (context) => UserBloc(userApiService: UserApiService()),
  child: UserListScreen(),
)
```

### UI Pattern (Both BLoC and Cubit)
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

## Development Workflows

### Running the App
```powershell
flutter pub get
flutter run
```

### Project Uses
- `flutter_bloc: ^9.1.1` and `bloc: ^9.1.0` for state management
- Dart 3.9.2+ with sealed class support
- Material Design 3 (`useMaterial3: true`)

### Testing Pattern (from QUICK_REFERENCE.md)
Use `bloc_test` package for testing:
```dart
blocTest<UserBloc, UserState>(
  'emits [loading, loaded] when successful',
  build: () => UserBloc(userApiService: mockService),
  act: (bloc) => bloc.add(LoadUsersEvent()),
  expect: () => [isA<UserLoadingState>(), isA<UserLoadedState>()],
);
```

## Documentation Structure
This project has **extensive documentation** - always reference:
- `ARCHITECTURE.md` - Flow diagrams and component interactions
- `QUICK_REFERENCE.md` - Code patterns and common use cases
- `CUBIT_GUIDE.md` - BLoC vs Cubit comparison with examples
- `EXERCISES.md` - Progressive learning exercises

## When Adding Features

### Choose BLoC When:
- Need event tracking/logging
- Complex business logic with multiple events triggering same state
- Event transformations (debounce, throttle)

### Choose Cubit When:
- Simple, direct state changes
- Prototyping or straightforward flows
- Prefer less boilerplate

### Adding New State Management
1. Create sealed state classes in `*_state.dart`
2. For BLoC: Create sealed event classes in `*_event.dart`
3. Create BLoC/Cubit in `bloc/` or `cubit/` directory
4. Inject dependencies via constructor (service layer)
5. Register event handlers in constructor (BLoC only)

## Code Conventions
- **Sealed classes**: Required for events/states (Dart 3+)
- **Comments**: Extensive inline documentation style - maintain this
- **State fields**: Include data in loaded states (e.g., `LoadedState(this.users)`)
- **Error handling**: Always wrap async calls in try-catch and emit error states
- **UI helpers**: Extract view builders as private methods (`_buildLoadedView`)

## Key Files to Reference
- `lib/screens/user_list_screen.dart` - Complete BLoC UI pattern with all state handling
- `lib/bloc/user_bloc.dart` - Event registration and handler pattern
- `lib/cubit/post_cubit.dart` - Direct method approach with extensive comments
- `lib/main.dart` - App entry point showing dual pattern approach

## Common Gotchas
- Don't mix patterns - file structure separates BLoC and Cubit examples cleanly
- All mock APIs have 2-second delays - don't mistake for bugs
- Sealed classes require Dart 3+ - ensure SDK constraint in pubspec.yaml
- BlocProvider must be ancestor of BlocBuilder in widget tree
