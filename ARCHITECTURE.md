# BLoC Architecture Flow Diagram

## Overview

This document explains how data flows through the BLoC pattern in this tutorial app.

## The Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                              USER INTERFACE                          │
│                         (user_list_screen.dart)                     │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ User taps button
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          DISPATCH EVENT                              │
│  context.read<UserBloc>().add(LoadUsersEvent())                     │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                            USER BLOC                                 │
│                         (user_bloc.dart)                            │
│                                                                      │
│  Event Handler: _onLoadUsers()                                      │
│  1. emit(UserLoadingState())                                        │
│  2. Call API service                                                │
│  3. emit(UserLoadedState(users)) OR emit(UserErrorState(error))    │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Calls API
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        API SERVICE                                   │
│                    (user_api_service.dart)                          │
│                                                                      │
│  Future.delayed(Duration(seconds: 2))                               │
│  Returns mock user data                                             │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Returns data
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         EMIT NEW STATE                               │
│  Stream<UserState> → BlocBuilder receives new state                 │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      UI REBUILDS (BlocBuilder)                       │
│                                                                      │
│  switch (state) {                                                   │
│    UserInitialState() => Show welcome screen                        │
│    UserLoadingState() => Show loading spinner                       │
│    UserLoadedState()  => Show user list                             │
│    UserErrorState()   => Show error message                         │
│  }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
```

## State Transitions

### Success Flow
```
Initial → Loading → Loaded
   ↑                   │
   └───────────────────┘ (User can trigger reload)
```

### Error Flow
```
Initial → Loading → Error
   ↑                   │
   └───────────────────┘ (Retry button)
```

## Key Components

### 1. Events (user_event.dart)
- **LoadUsersEvent**: Request to load users successfully
- **LoadUsersWithErrorEvent**: Request to trigger error scenario
- **RetryLoadUsersEvent**: Request to retry after error

### 2. States (user_state.dart)
- **UserInitialState**: Starting state
- **UserLoadingState**: Data is being fetched
- **UserLoadedState**: Data fetched successfully (contains user list)
- **UserErrorState**: Error occurred (contains error message)

### 3. BLoC (user_bloc.dart)
- Listens for events
- Processes business logic
- Emits states
- Maintains separation of concerns

### 4. BlocProvider (main.dart)
- Creates and provides BLoC instance to widget tree
- Manages BLoC lifecycle
- Enables dependency injection

### 5. BlocBuilder (user_list_screen.dart)
- Listens to state changes
- Rebuilds UI when state changes
- Provides current state to builder function

## Data Flow Example

### When user taps "Load Users" button:

1. **UI**: Button tap triggers event dispatch
   ```dart
   context.read<UserBloc>().add(LoadUsersEvent())
   ```

2. **BLoC**: Receives event and starts processing
   ```dart
   emit(UserLoadingState()) // UI shows loading spinner
   ```

3. **API**: Simulates network delay
   ```dart
   await Future.delayed(const Duration(seconds: 2))
   ```

4. **API**: Returns mock data
   ```dart
   return [User(...), User(...), ...]
   ```

5. **BLoC**: Emits success state
   ```dart
   emit(UserLoadedState(users)) // UI shows user list
   ```

6. **UI**: BlocBuilder rebuilds with new state
   ```dart
   UserLoadedState() => _buildLoadedView(state.users)
   ```

## Benefits of This Architecture

✅ **Testability**: Business logic is isolated and easy to test
✅ **Reusability**: BLoC can be reused across multiple screens
✅ **Maintainability**: Clear separation of concerns
✅ **Predictability**: State changes are explicit and traceable
✅ **Scalability**: Easy to add new events and states
