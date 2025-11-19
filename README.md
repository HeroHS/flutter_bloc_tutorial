# Flutter BLoC Tutorial App

A comprehensive tutorial application demonstrating how to use the BLoC (Business Logic Component) pattern with `flutter_bloc` to manage state when loading data from an API.

## 📚 What You'll Learn

This tutorial demonstrates:
- ✅ Setting up BLoC architecture (Events, States, BLoC)
- ✅ Managing different UI states (Initial, Loading, Success, Error)
- ✅ Simulating API calls with `Future.delayed`
- ✅ Handling errors gracefully
- ✅ Implementing retry logic
- ✅ Using `BlocProvider` and `BlocBuilder`

## 🏗️ Project Structure

```
lib/
├── bloc/
│   ├── user_bloc.dart       # BLoC implementation
│   ├── user_event.dart      # Event definitions
│   └── user_state.dart      # State definitions
├── models/
│   └── user.dart            # User data model
├── screens/
│   └── user_list_screen.dart # Main UI screen
├── services/
│   └── user_api_service.dart # Simulated API service
└── main.dart                # App entry point
```

## 🎯 Key Concepts

### 1. Events
Events represent user actions or system events:
- `LoadUsersEvent` - Triggered to load users successfully
- `LoadUsersWithErrorEvent` - Triggered to simulate an error
- `RetryLoadUsersEvent` - Triggered to retry after an error

### 2. States
States represent the current condition of the UI:
- `UserInitialState` - Initial state before any action
- `UserLoadingState` - Data is being loaded (shows loading indicator)
- `UserLoadedState` - Data loaded successfully (shows user list)
- `UserErrorState` - An error occurred (shows error message)

### 3. BLoC
The `UserBloc` class:
- Receives events from the UI
- Calls the API service
- Emits appropriate states based on the result
- Keeps business logic separate from UI

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

1. **Initial State**: When you launch the app, you'll see a welcome screen with two buttons
2. **Load Users (Success)**: Click this to simulate a successful API call
   - Watch the loading indicator appear
   - After 2 seconds, see the user list displayed
3. **Load Users (Error)**: Click this to simulate a failed API call
   - Watch the loading indicator appear
   - After 2 seconds, see an error message
   - Click "Retry" to try loading again
4. **Info Button**: Tap the info icon in the app bar for a quick reference

## 🔍 Code Walkthrough

### API Service (`user_api_service.dart`)
```dart
Future<List<User>> fetchUsers() async {
  await Future.delayed(const Duration(seconds: 2)); // Simulates network delay
  return [/* mock users */];
}
```

### BLoC Event Handler (`user_bloc.dart`)
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

### UI with BlocBuilder (`user_list_screen.dart`)
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

## 📦 Dependencies

- `flutter_bloc: ^9.1.1` - BLoC state management library
- `bloc: ^9.1.0` - Core BLoC library

## 💡 Best Practices Demonstrated

1. **Separation of Concerns**: Business logic is in BLoC, UI is in widgets
2. **Immutable States**: All states are immutable for predictability
3. **Error Handling**: Proper error handling with user-friendly messages
4. **Loading States**: Clear feedback during async operations
5. **Sealed Classes**: Using sealed classes for type-safe state handling
6. **Dependency Injection**: BLoC receives API service via constructor

## 🧪 Try Modifying

Want to experiment? Try these:
- Change the delay duration in `user_api_service.dart`
- Add more user fields to the `User` model
- Create a new event for searching users
- Add a refresh button that reloads the data
- Implement pagination with more events/states

## 📖 Learn More

- [BLoC Library Documentation](https://bloclibrary.dev)
- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Architecture Pattern](https://www.didierboelens.com/2018/08/reactive-programming-streams-bloc/)

## 🤝 Contributing

This is a tutorial project. Feel free to fork and modify it for your learning!

## 📄 License

This project is open source and available for educational purposes.
