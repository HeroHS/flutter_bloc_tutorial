# Flutter BLoC Tutorial - Clean Architecture + Three State Management Patterns

A comprehensive tutorial application demonstrating **Clean Architecture** with **three state management patterns**: BLoC (event-driven), Cubit (method-driven), and BlocConsumer (builder + listener) using `flutter_bloc` to manage state when loading data from an API.

## 📚 What You'll Learn

This tutorial demonstrates:
- ✅ **Clean Architecture**: Separation of concerns with Domain, Data, and Presentation layers
- ✅ **BLoC Pattern**: Event-driven architecture with events and states (User demo)
- ✅ **Cubit Pattern**: Simplified approach with direct method calls - no events (Post demo)
- ✅ **BlocConsumer Pattern**: Combined builder and listener for side effects (Product demo)
- ✅ **Use Cases**: Business logic isolation from presentation and data layers
- ✅ **Repository Pattern**: Abstract data access with concrete implementations
- ✅ **Entities vs Models**: Pure domain objects vs data transfer objects
- ✅ Managing different UI states (Initial, Loading, Success, Error, Refreshing)
- ✅ Dual state emission pattern for repeated actions (BlocConsumer)
- ✅ Side effects: Snackbars, navigation, haptic feedback
- ✅ Simulating API calls with `Future.delayed`
- ✅ Handling errors gracefully with retry logic and Failure classes
- ✅ Using `BlocProvider`, `BlocBuilder`, `BlocListener`, and `BlocConsumer`
- ✅ Modern Dart 3+ features: sealed classes, switch expressions, record patterns
- ✅ **When to use BLoC vs Cubit vs BlocConsumer** for your projects
- ✅ **Dependency flow**: Presentation → Domain ← Data

## 🏗️ Project Structure (Clean Architecture)

```
lib/
├── core/                           # Shared across features
│   ├── error/
│   │   └── failures.dart          # Failure classes for error handling
│   └── usecases/
│       └── usecase.dart           # Base use case interface
│
├── features/                       # Feature-based organization
│   ├── user/                      # BLoC pattern example
│   │   ├── domain/                # Business logic layer
│   │   │   ├── entities/
│   │   │   │   └── user.dart     # Pure domain entity
│   │   │   ├── repositories/
│   │   │   │   └── user_repository.dart # Repository interface
│   │   │   └── usecases/
│   │   │       ├── get_users.dart # Use case: Get users
│   │   │       └── get_users_with_error.dart # Use case: Trigger error
│   │   ├── data/                  # Data access layer
│   │   │   ├── datasources/
│   │   │   │   └── user_remote_datasource.dart # API service
│   │   │   ├── models/
│   │   │   │   └── user_model.dart # DTO with JSON serialization
│   │   │   └── repositories/
│   │   │       └── user_repository_impl.dart # Repository implementation
│   │   └── presentation/          # UI layer
│   │       ├── bloc/
│   │       │   ├── user_bloc.dart    # BLoC implementation
│   │       │   ├── user_event.dart   # Event definitions
│   │       │   └── user_state.dart   # State definitions
│   │       └── screens/
│   │           └── user_list_screen.dart # BLoC pattern UI
│   │
│   ├── post/                      # Cubit pattern example
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── post.dart
│   │   │   ├── repositories/
│   │   │   │   └── post_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_posts.dart
│   │   │       └── get_posts_with_error.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── post_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── post_model.dart
│   │   │   └── repositories/
│   │   │       └── post_repository_impl.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── post_cubit.dart   # Cubit implementation (no events!)
│   │       │   └── post_state.dart   # State definitions
│   │       └── screens/
│   │           └── post_list_screen.dart # Cubit pattern UI
│   │
│   ├── product/                   # BlocConsumer pattern example
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── product.dart # with copyWith for cart updates
│   │   │   ├── repositories/
│   │   │   │   └── product_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_products.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── product_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── product_model.dart
│   │   │   └── repositories/
│   │   │       └── product_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── product_bloc.dart    # BLoC for BlocConsumer
│   │       │   ├── product_event.dart   # 7 events including cart actions
│   │       │   └── product_state.dart   # 8 states including action states
│   │       └── screens/
│   │           └── product_list_screen.dart # BlocConsumer demo
│   │
│   └── home/
│       └── home_screen.dart       # Home screen with pattern selection
│
└── main.dart                      # App entry point
```

## 🏛️ Clean Architecture Layers

### 1. Domain Layer (Innermost - No Dependencies)
**Pure business logic - independent of frameworks**

- **Entities**: Core business objects (User, Post, Product)
  - Pure Dart classes with business rules
  - No JSON serialization
  - No framework dependencies
  
- **Repositories**: Abstract interfaces defining data operations
  - Contracts that data layer must implement
  - Return entities, not models
  
- **Use Cases**: Single-responsibility business operations
  - GetUsers, GetPosts, GetProducts
  - Contains business logic
  - Called by presentation layer

### 2. Data Layer (Depends on Domain)
**Data access implementation**

- **Data Sources**: Remote/local data fetching (API services)
  - `UserRemoteDataSource` - API calls with Future.delayed (2s mock)
  - Returns models, not entities
  
- **Models**: DTOs extending entities with JSON serialization
  - `UserModel extends User` - adds fromJson/toJson
  - Handles data transformation
  
- **Repository Implementations**: Concrete implementations
  - `UserRepositoryImpl implements UserRepository`
  - Calls data sources, returns entities

### 3. Presentation Layer (Depends on Domain)
**UI and state management**

- **BLoC/Cubit**: State management using use cases
  - UserBloc calls GetUsers use case (not repository!)
  - PostCubit calls GetPosts use case
  - ProductBloc calls GetProducts use case
  
- **Screens**: UI components
  - BlocProvider, BlocBuilder, BlocConsumer
  - Dispatches events or calls methods
  
- **States**: UI state representations
  - Initial, Loading, Loaded, Error, Action states

### Dependency Flow
```
Presentation Layer → Domain Layer ← Data Layer
     (UI)              (Logic)        (API)
     
   UserBloc    →    GetUsers    ←   UserRepositoryImpl
                  (Use Case)      (calls UserRemoteDataSource)
```

## 🎯 Key Concepts

### BLoC Pattern (User Example)

#### Clean Architecture Integration
- **UserBloc** (Presentation) → **GetUsers** (Domain) → **UserRepository** (Domain interface) → **UserRepositoryImpl** (Data) → **UserRemoteDataSource** (Data)

#### 1. Events
Events represent user actions or system events:
- `LoadUsersEvent` - Triggered to load users successfully
- `LoadUsersWithErrorEvent` - Triggered to simulate an error
- `RetryLoadUsersEvent` - Triggered to retry after an error

#### 2. States
States represent the current condition of the UI:
- `UserInitialState` - Initial state before any action
- `UserLoadingState` - Data is being loaded (shows loading indicator)
- `UserLoadedState` - Data loaded successfully (shows user list of entities)
- `UserErrorState` - An error occurred (shows error message)

#### 3. BLoC
The `UserBloc` class:
- Receives events from the UI
- Calls **use cases** (not repositories or services directly!)
- Emits appropriate states based on the result
- Keeps business logic separate from UI
- Works with entities from domain layer

### Cubit Pattern (Post Example)

#### Clean Architecture Integration
- **PostCubit** (Presentation) → **GetPosts** (Domain) → **PostRepository** (Domain interface) → **PostRepositoryImpl** (Data) → **PostRemoteDataSource** (Data)

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
- `PostLoadedState` - Data loaded successfully (contains entities)
- `PostErrorState` - An error occurred
- `PostRefreshingState` - Refreshing while showing old data

#### 3. Cubit Methods
The `PostCubit` class provides direct methods:
- `loadPosts()` - Load posts from API via GetPosts use case
- `loadPostsWithError()` - Simulate error via GetPostsWithError use case
- `retry()` - Retry after error
- `refreshPosts()` - Refresh with optimistic update
- `clear()` - Reset to initial state

### BlocConsumer Pattern (Product Example - Shopping Cart)

#### Clean Architecture Integration
- **ProductBloc** (Presentation) → **GetProducts** (Domain) → **ProductRepository** (Domain interface) → **ProductRepositoryImpl** (Data) → **ProductRemoteDataSource** (Data)

#### 1. What is BlocConsumer?
BlocConsumer **combines** `BlocBuilder` and `BlocListener` into one widget:
- **Builder**: Updates UI based on state (like normal BlocBuilder)
- **Listener**: Handles side effects (snackbars, navigation, haptics)

```dart
BlocConsumer<ProductBloc, ProductState>(
  listener: (context, state) {
    // Side effects here (snackbars, navigation)
  },
  builder: (context, state) {
    // UI here (widget tree)
  },
)
```

#### 2. Events (Product Actions)
- `LoadProductsEvent` - Load products successfully
- `LoadProductsWithErrorEvent` - Trigger error scenario
- `AddToCartEvent` - Add product to cart
- `RemoveFromCartEvent` - Remove product from cart
- `CheckoutEvent` - Initiate checkout flow
- `RefreshProductsEvent` - Refresh product list
- `ResetProductsEvent` - Reset to initial state

Note: Product feature only has one use case (GetProducts) since cart operations are UI state only

#### 3. States (Including Action States)
- `ProductInitialState` - Starting state
- `ProductLoadingState` - Products being fetched
- `ProductLoadedState` - Products loaded (contains product entities, cartItemCount)
- **`ProductAddedToCartState`** - Action state with timestamp (triggers listener)
- **`ProductRemovedFromCartState`** - Action state with timestamp (triggers listener)
- `ProductErrorState` - Error occurred
- **`ProductCheckoutState`** - Checkout initiated (triggers listener for navigation)
- `ProductRefreshingState` - Refreshing while showing current products

#### 4. Dual State Emission Pattern
**The key to making BlocConsumer work for repeated actions:**

```dart
// Problem: Listener only fires when state TYPE changes
// Solution: Emit action state → then emit base state

void _onAddToCart(event, emit) {
  // ... update data ...
  
  // Step 1: Emit action state (triggers listener for snackbar)
  emit(ProductAddedToCartState(..., timestamp: DateTime.now()));
  
  // Step 2: Emit loaded state (updates UI, ready for next action)
  emit(ProductLoadedState(...));
}
```

This allows:
- ✅ Snackbar shows every time you add to cart
- ✅ Listener fires for every action (not just first time)
- ✅ State resets to `LoadedState` between actions

#### 5. Side Effects in Listener
The listener handles non-UI logic:
- **Snackbars**: "Product added to cart!" with green/orange colors
- **Navigation**: Navigate to checkout screen
- **Haptic Feedback**: Phone vibration on actions
- **Dialogs**: Show confirmation modals

#### 6. UI Updates in Builder
The builder handles UI rendering:
- Product list with cart badges
- Loading indicators
- Error messages with retry button
- Pull-to-refresh functionality

## 🔍 Pattern Comparison

| Feature | BLoC (User) | Cubit (Post) | BlocConsumer (Product) |
|---------|-------------|--------------|------------------------|
| **Events** | Required (3) | Not needed | Required (7) |
| **States** | 4 states | 5 states | 8 states |
| **How to trigger** | `bloc.add(Event())` | `cubit.method()` | `bloc.add(Event())` |
| **Side Effects** | Separate BlocListener | Separate BlocListener | Built-in listener |
| **UI Updates** | BlocBuilder | BlocBuilder | Built-in builder |
| **Boilerplate** | Medium | Low (-40%) | High (richer UX) |
| **Use case** | CRUD operations | Simple lists | Shopping carts, forms |
| **Files needed** | 3 (bloc, events, states) | 2 (cubit, states) | 3 (bloc, events, states) |
| **Lines of Code** | ~400 | ~350 | ~750 |
| **User Feedback** | Manual | Manual | Integrated (snackbars, haptics) |
| **Learning curve** | Medium | Low | High |
| **When to use** | Standard features | Prototyping | Features needing feedback |

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
When you launch, you'll see three demo options:
1. **BLoC Pattern** - Event-driven architecture (User example)
2. **Cubit Pattern** - Direct method calls (Post example)
3. **BlocConsumer Demo** - Shopping cart with side effects (Product example)

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

### BlocConsumer Demo (Product List - Shopping Cart)
1. **Initial Load**: Products load automatically on screen open
2. **Add to Cart**: Tap the cart icon on any product
   - ✅ Green snackbar appears: "Product added to cart!"
   - ✅ Phone vibrates (haptic feedback)
   - ✅ Icon changes to checkmark
   - ✅ Cart badge updates
3. **Remove from Cart**: Tap the checkmark icon
   - ✅ Orange snackbar appears: "Product removed from cart"
   - ✅ Icon changes back to cart
   - ✅ Cart badge decrements
4. **Checkout**: Tap the checkout button in app bar
   - ✅ Dialog appears with item count
   - ✅ Strong haptic feedback
5. **Pull to Refresh**: Drag down to refresh product list
6. **Error Handling**: Use app bar menu to trigger error scenario
7. **Info Button**: Tap for BlocConsumer pattern explanation

## 🔍 Code Walkthrough

### Clean Architecture Flow: User Feature

#### 1. Domain Layer - Entity
```dart
// lib/features/user/domain/entities/user.dart
class User {
  final int id;
  final String name;
  final String email;
  final String role;

  User({required this.id, required this.name, required this.email, required this.role});
  // Pure domain object - no JSON, no dependencies
}
```

#### 2. Data Layer - Model (extends Entity)
```dart
// lib/features/user/data/models/user_model.dart
class UserModel extends User {
  UserModel({required super.id, required super.name, required super.email, required super.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
  // Model adds JSON serialization
}
```

#### 3. Data Layer - Remote Data Source
```dart
// lib/features/user/data/datasources/user_remote_datasource.dart
class UserRemoteDataSource {
  Future<List<UserModel>> getUsers() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulates network delay
    return [/* mock user models */];
  }

  Future<List<UserModel>> getUsersWithError() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Failed to load users');
  }
}
```

#### 4. Domain Layer - Repository Interface
```dart
// lib/features/user/domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<List<User>> getUsersWithError();
}
```

#### 5. Data Layer - Repository Implementation
```dart
// lib/features/user/data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getUsers() async {
    // Calls data source, returns entities
    return await remoteDataSource.getUsers();
  }
}
```

#### 6. Domain Layer - Use Case
```dart
// lib/features/user/domain/usecases/get_users.dart
class GetUsers implements UseCase<List<User>, NoParams> {
  final UserRepository repository;

  GetUsers(this.repository);

  @override
  Future<List<User>> call(NoParams params) async {
    return await repository.getUsers();
  }
}
```

#### 7. Presentation Layer - BLoC
```dart
// lib/features/user/presentation/bloc/user_bloc.dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsersUseCase;
  final GetUsersWithError getUsersWithErrorUseCase;

  UserBloc({required this.getUsersUseCase, required this.getUsersWithErrorUseCase}) 
      : super(UserInitialState()) {
    on<LoadUsersEvent>(_onLoadUsers);
  }

  Future<void> _onLoadUsers(LoadUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final users = await getUsersUseCase(NoParams()); // Calls use case!
      emit(UserLoadedState(users));
    } catch (error) {
      emit(UserErrorState(error.toString()));
    }
  }
}
```

#### 8. Presentation Layer - UI
```dart
// lib/features/user/presentation/screens/user_list_screen.dart
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    return switch (state) {
      UserInitialState() => _buildInitialView(context),
      UserLoadingState() => _buildLoadingView(),
      UserLoadedState() => _buildLoadedView(state.users), // Uses entities
      UserErrorState() => _buildErrorView(context, state.errorMessage),
    };
  },
)
```

### Cubit Pattern: Post Feature (Same Architecture)

```dart
// Post Cubit calls use case directly
Future<void> loadPosts() async {
  emit(PostLoadingState());
  try {
    final posts = await getPostsUseCase(NoParams()); // Calls GetPosts use case
    emit(PostLoadedState(posts));
  } catch (error) {
    emit(PostErrorState(error.toString()));
  }
}
```

## 📦 Dependencies

- `flutter_bloc: ^9.1.1` - BLoC state management library
- `bloc: ^9.1.0` - Core BLoC library
- `intl: ^0.19.0` - Internationalization and date formatting

## 💡 Best Practices Demonstrated

1. **Clean Architecture**: Domain, data, and presentation layers properly separated
2. **Dependency Inversion**: BLoC/Cubit depends on use cases (abstractions), not concrete implementations
3. **Use Cases**: Single Responsibility Principle - one use case per operation
4. **Repository Pattern**: Abstract interfaces in domain, implementations in data layer
5. **Entities vs Models**: Pure domain objects vs DTOs with serialization
6. **Separation of Concerns**: Business logic is in domain layer, not in BLoC/Cubit or UI
7. **Immutable States**: All states are immutable for predictability
8. **Error Handling**: Proper error handling with user-friendly messages and Failure classes
9. **Loading States**: Clear feedback during async operations
10. **Sealed Classes**: Using sealed classes for type-safe state handling
11. **Dependency Injection**: BLoC/Cubit receives use cases via constructor
12. **Pattern Selection**: Choose the right tool (BLoC vs Cubit vs BlocConsumer) for the job
13. **Testability**: Each layer can be tested independently with mocks

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
- **CLEAN_ARCHITECTURE_GUIDE.md** - Clean Architecture restructuring guide
- **CLEAN_ARCHITECTURE_COMPLETE.md** - Complete Clean Architecture implementation
- **ARCHITECTURE.md** - Flow diagrams for all three patterns
- **QUICK_REFERENCE.md** - Code snippets and common patterns
- **CUBIT_GUIDE.md** - Deep dive into Cubit vs BLoC
- **BLOC_CONSUMER_TUTORIAL.md** - Complete guide to BlocConsumer widget
- **BLOCCONSUMER_IMPLEMENTATION_COMPLETE.md** - BlocConsumer implementation details
- **EXERCISES.md** - Practice exercises for all three patterns
- **BEGINNERS_GUIDE.dart** - Step-by-step explanation
- **TUTORIAL_OVERVIEW.md** - Complete package overview

### External Resources
- [BLoC Library Documentation](https://bloclibrary.dev)
- [Flutter Documentation](https://flutter.dev/docs)
- [Cubit vs BLoC](https://bloclibrary.dev/#/coreconcepts?id=cubit-vs-bloc)

## ✅ When to Use Each Pattern

### Use BLoC Pattern When:
- ✓ You need event tracking/logging
- ✓ Complex business logic with multiple events triggering same state
- ✓ Event transformations needed (debounce, throttle)
- ✓ Team prefers strict event-driven architecture
- ✓ Large applications with complex flows
- ✓ Standard CRUD operations

**Example**: User management, data loading, traditional list views

### Use Cubit Pattern When:
- ✓ Simple, straightforward state changes
- ✓ Prototyping or MVP development
- ✓ Less complex business logic
- ✓ Want to reduce boilerplate (~40% less code)
- ✓ Team prefers simplicity
- ✓ Direct method calls feel more natural

**Example**: Simple lists, settings screens, basic forms

### Use BlocConsumer Pattern When:
- ✓ Need BOTH UI updates AND side effects
- ✓ Show user feedback (snackbars, toasts, dialogs)
- ✓ Navigate based on state changes
- ✓ Trigger animations or haptic feedback
- ✓ Shopping cart or checkout workflows
- ✓ Form submissions with confirmation
- ✓ Optimistic updates with rollback

**Example**: Shopping carts, like/unlike buttons, add to favorites, complex forms

### Quick Decision Tree:
```
Need side effects (snackbars, navigation)?
├─ Yes → Use BlocConsumer
└─ No
   ├─ Need event tracking or complex logic?
   │  ├─ Yes → Use BLoC
   │  └─ No → Use Cubit
   └─ Simple CRUD?
      └─ Use Cubit
```

## 🤝 Contributing

This is a tutorial project. Feel free to fork and modify it for your learning!

## 📄 License

This project is open source and available for educational purposes.
