# State Management Architecture - BLoC & Cubit

## Overview

This tutorial demonstrates **two state management patterns**: BLoC (Business Logic Component) and Cubit. Both patterns use the same foundational concepts but differ in how they trigger state changes.

---

## BLoC Pattern Flow (User Example)

### The Complete Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                               │
│                      (user_list_screen.dart)                        │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ User taps button
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        DISPATCH EVENT                                │
│  context.read<UserBloc>().add(LoadUsersEvent())                     │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           USER BLOC                                  │
│                        (user_bloc.dart)                             │
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
│                       EMIT NEW STATE                                 │
│  Stream<UserState> → BlocBuilder receives new state                 │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    UI REBUILDS (BlocBuilder)                         │
│                                                                      │
│  switch (state) {                                                   │
│    UserInitialState() => Show welcome screen                        │
│    UserLoadingState() => Show loading spinner                       │
│    UserLoadedState()  => Show user list                             │
│    UserErrorState()   => Show error message                         │
│  }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Cubit Pattern Flow (Post Example)

### The Complete Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                               │
│                      (post_list_screen.dart)                        │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ User taps button
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    CALL METHOD DIRECTLY                              │
│  context.read<PostCubit>().loadPosts()                              │
│  NO EVENTS! Direct method call!                                     │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          POST CUBIT                                  │
│                        (post_cubit.dart)                            │
│                                                                      │
│  Method: loadPosts()                                                │
│  1. emit(PostLoadingState())                                        │
│  2. Call API service                                                │
│  3. emit(PostLoadedState(posts)) OR emit(PostErrorState(error))    │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Calls API
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        API SERVICE                                   │
│                    (post_api_service.dart)                          │
│                                                                      │
│  Future.delayed(Duration(seconds: 2))                               │
│  Returns mock post data                                             │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Returns data
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       EMIT NEW STATE                                 │
│  Stream<PostState> → BlocBuilder receives new state                 │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    UI REBUILDS (BlocBuilder)                         │
│                                                                      │
│  switch (state) {                                                   │
│    PostInitialState() => Show welcome screen                        │
│    PostLoadingState() => Show loading spinner                       │
│    PostLoadedState() => Show post list                              │
│    PostRefreshingState() => Show list + refresh indicator           │
│    PostErrorState() => Show error message                           │
│  }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## State Transitions

### BLoC Pattern (User)
```
Success Flow:
Initial → Loading → Loaded
   ↑                   │
   └───────────────────┘ (User can trigger reload)

Error Flow:
Initial → Loading → Error
   ↑                   │
   └───────────────────┘ (Retry button)
```

### Cubit Pattern (Post)
```
Success Flow:
Initial → Loading → Loaded → Refreshing → Loaded
   ↑                   │         ↑           │
   └───────────────────┘         └───────────┘

Error Flow:
Initial → Loading → Error
   ↑                   │
   └───────────────────┘ (Retry button)

Advanced Refresh Flow:
Loaded → Refreshing (keeps showing old data) → Loaded (new data)
   ↑           ↓ (on error)                            │
   └─────────── (restore old data) ────────────────────┘
```

---

## Key Components Comparison

### BLoC Pattern Components

#### 1. Events (user_event.dart)
- **LoadUsersEvent**: Request to load users successfully
- **LoadUsersWithErrorEvent**: Request to trigger error scenario
- **RetryLoadUsersEvent**: Request to retry after error

#### 2. States (user_state.dart)
- **UserInitialState**: Starting state
- **UserLoadingState**: Data is being fetched
- **UserLoadedState**: Data fetched successfully (contains user list)
- **UserErrorState**: Error occurred (contains error message)

#### 3. BLoC (user_bloc.dart)
- Listens for events
- Processes business logic
- Emits states
- Maintains separation of concerns

#### 4. BlocProvider (main.dart → screen)
```dart
BlocProvider(
  create: (_) => UserBloc(userApiService: UserApiService()),
  child: UserListScreen(),
)
```

#### 5. BlocBuilder (user_list_screen.dart)
- Listens to state changes
- Rebuilds UI when state changes
- Provides current state to builder function

---

### Cubit Pattern Components

#### 1. No Events!
Cubit doesn't use events - methods are called directly

#### 2. States (post_state.dart)
- **PostInitialState**: Starting state
- **PostLoadingState**: Data is being fetched
- **PostLoadedState**: Data fetched successfully (contains post list)
- **PostRefreshingState**: Refreshing while showing current data
- **PostErrorState**: Error occurred (contains error message)

#### 3. Cubit (post_cubit.dart)
- Provides public methods (no event handlers)
- Processes business logic
- Emits states directly from methods

Methods:
- `loadPosts()` - Load posts from API
- `loadPostsWithError()` - Simulate error
- `retry()` - Retry after error
- `refreshPosts()` - Advanced refresh with optimistic update
- `clear()` - Reset to initial state

#### 4. BlocProvider (main.dart → screen)
```dart
BlocProvider(
  create: (_) => PostCubit(postApiService: PostApiService()),
  child: PostListScreen(),
)
```

#### 5. BlocBuilder (post_list_screen.dart)
- Same as BLoC! Works with both patterns
- Listens to state changes
- Rebuilds UI when state changes

---

## Data Flow Examples

### BLoC: When User Taps "Load Users" Button

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

---

### Cubit: When User Taps "Load Posts" Button

1. **UI**: Button tap calls method directly
   ```dart
   context.read<PostCubit>().loadPosts()
   ```

2. **Cubit**: Method starts processing
   ```dart
   emit(PostLoadingState()) // UI shows loading spinner
   ```

3. **API**: Simulates network delay
   ```dart
   await Future.delayed(const Duration(seconds: 2))
   ```

4. **API**: Returns mock data
   ```dart
   return [Post(...), Post(...), ...]
   ```

5. **Cubit**: Emits success state
   ```dart
   emit(PostLoadedState(posts)) // UI shows post list
   ```

6. **UI**: BlocBuilder rebuilds with new state
   ```dart
   PostLoadedState() => _buildLoadedView(state.posts, false)
   ```

---

## Advanced Pattern: Optimistic Refresh (Cubit)

The `refreshPosts()` method demonstrates an advanced pattern:

```
User Pulls to Refresh
        ↓
Currently in PostLoadedState with old data
        ↓
Emit PostRefreshingState(oldPosts) ← Keep showing old data!
        ↓
Show list with loading overlay
        ↓
Call API to fetch new data
        ↓
   ┌────────────┬────────────┐
   ↓ SUCCESS    ↓ FAILURE    │
   │            │            │
Emit           Emit          │
PostLoadedState PostLoadedState
(new posts)    (old posts) ←─┘ Restore previous data!
```

**Code**:
```dart
Future<void> refreshPosts() async {
  if (state is PostLoadedState) {
    final currentPosts = (state as PostLoadedState).posts;
    emit(PostRefreshingState(currentPosts)); // Keep showing data
  } else {
    emit(PostLoadingState());
  }

  try {
    final posts = await postApiService.fetchPosts();
    emit(PostLoadedState(posts));
  } catch (error) {
    if (state is PostRefreshingState) {
      // Restore old data on error
      final previousPosts = (state as PostRefreshingState).currentPosts;
      emit(PostLoadedState(previousPosts));
    } else {
      emit(PostErrorState(error.toString()));
    }
  }
}
```

---

## Pattern Comparison Side-by-Side

| Aspect | BLoC (User Example) | Cubit (Post Example) |
|--------|---------------------|----------------------|
| **Trigger** | Dispatch event | Call method directly |
| **Code** | `bloc.add(Event())` | `cubit.method()` |
| **Event file** | ✅ Required | ❌ Not needed |
| **Event handlers** | Register in constructor | N/A |
| **State emission** | In event handler | In public method |
| **Boilerplate** | Higher | Lower (~40% less) |
| **Example files** | 3 files (bloc, events, states) | 2 files (cubit, states) |
| **UI usage** | Same! BlocBuilder works for both | Same! BlocBuilder works for both |

---

## Benefits of This Architecture

### BLoC Benefits
✅ **Event Tracking**: Can log all events for debugging  
✅ **Event Transformation**: Debounce, throttle, etc.  
✅ **Strict Architecture**: Clear separation of concerns  
✅ **Complex Logic**: Multiple events can trigger same state  
✅ **Testability**: Easy to test event → state mappings  

### Cubit Benefits
✅ **Simplicity**: Less boilerplate, easier to learn  
✅ **Direct**: Call methods like normal OOP  
✅ **Quick Development**: Faster to implement  
✅ **Less Code**: ~40% reduction in code  
✅ **Same Power**: Still reactive and testable  

### Shared Benefits
✅ **Testability**: Business logic isolated from UI  
✅ **Reusability**: BLoC/Cubit can be shared across screens  
✅ **Maintainability**: Clear structure and patterns  
✅ **Predictability**: State changes are explicit  
✅ **Scalability**: Easy to add new features  

---

## Architecture Principles

Both patterns follow these principles:

1. **Unidirectional Data Flow**
   - Data flows in one direction
   - Makes code predictable and debuggable
   - UI → Event/Method → BLoC/Cubit → State → UI

2. **Separation of Concerns**
   - UI only displays and triggers actions
   - BLoC/Cubit handles business logic
   - Services handle data fetching
   - Models define data structure

3. **Immutability**
   - States are immutable
   - New states created instead of modifying existing
   - Prevents bugs from unexpected mutations

4. **Single Source of Truth**
   - Current state represents entire UI condition
   - No hidden state variables
   - Easy to understand app state at any time

5. **Reactive Programming**
   - UI reacts to state changes automatically
   - No manual UI updates needed
   - Declarative instead of imperative

---

## When to Use Each Pattern

### Choose BLoC When:
- ✓ Need event tracking/logging
- ✓ Complex business logic
- ✓ Multiple events trigger same state
- ✓ Event transformations needed (debounce, throttle)
- ✓ Large team prefers strict architecture
- ✓ App has complex state flows

### Choose Cubit When:
- ✓ Simple state management
- ✓ Prototyping or MVP
- ✓ Want less boilerplate
- ✓ Direct method calls preferred
- ✓ Straightforward state changes
- ✓ Smaller team or solo developer

### Both Work Great For:
- ✓ Async operations (API calls)
- ✓ Error handling
- ✓ Loading states
- ✓ Testing business logic
- ✓ Reusable state management

---

## Project File Structure

```
lib/
├── bloc/                          # BLoC Pattern Example
│   ├── user_bloc.dart            # BLoC with event handlers
│   ├── user_event.dart           # Event definitions
│   └── user_state.dart           # State definitions
│
├── cubit/                         # Cubit Pattern Example
│   ├── post_cubit.dart           # Cubit with public methods
│   └── post_state.dart           # State definitions (no events!)
│
├── models/                        # Data Models
│   ├── user.dart                 # User model for BLoC example
│   └── post.dart                 # Post model for Cubit example
│
├── screens/                       # UI Layer
│   ├── home_screen.dart          # Pattern selection screen
│   ├── user_list_screen.dart     # BLoC pattern UI
│   └── post_list_screen.dart     # Cubit pattern UI
│
├── services/                      # Data Layer
│   ├── user_api_service.dart     # Mock API for users
│   └── post_api_service.dart     # Mock API for posts
│
└── main.dart                      # App entry point
```

---

**Compare both patterns in the app to understand their differences and choose the right one for your needs!**
