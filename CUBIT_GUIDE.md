# Cubit Tutorial Guide - Posts and Todos Examples

## 🎯 What is Cubit?

**Cubit** is a lightweight subset of BLoC that allows you to manage state without events. It's simpler, has less boilerplate, and is perfect for straightforward state management scenarios. **Works seamlessly with Clean Architecture** - still uses use cases instead of calling repositories or data sources directly!

This guide covers two Cubit examples:
- **Posts** - Basic Cubit with BlocBuilder
- **Todos** - Cubit with BlocConsumer (CRUD operations with side effects)

## 🏛️ Clean Architecture with Cubit

```
PostCubit (Presentation) → GetPosts (Domain Use Case) → PostRepository Interface (Domain)
                                                                ↑
                                                    PostRepositoryImpl (Data)
                                                                ↑
                                                    PostRemoteDataSource (Data)
```

**Key Point**: Cubit calls **use cases**, not services directly!

## 🔑 Key Differences: Cubit vs BLoC

| Aspect | BLoC | Cubit |
|--------|------|-------|
| **Events** | Required | Not needed |
| **Usage** | `bloc.add(LoadEvent())` | `cubit.loadData()` |
| **Boilerplate** | More (events + states) | Less (only states) |
| **Complexity** | Higher | Lower |
| **Use Case** | Complex logic, event tracking | Simple state changes |
| **Learning Curve** | Steeper | Gentler |

## 📊 Code Comparison

### BLoC Pattern (User Example)
```dart
// 1. Define Event
final class LoadUsersEvent extends UserEvent {}

// 2. Dispatch Event
context.read<UserBloc>().add(LoadUsersEvent());

// 3. Handle Event in BLoC
on<LoadUsersEvent>(_onLoadUsers);

Future<void> _onLoadUsers(LoadUsersEvent event, Emitter<UserState> emit) async {
  emit(UserLoadingState());
  // Calls use case (Clean Architecture)
  final users = await getUsersUseCase(NoParams());
  emit(UserLoadedState(users));
}
```

### Cubit Pattern (Post Example)
```dart
// 1. No event needed!

// 2. Call method directly
context.read<PostCubit>().loadPosts();

// 3. Method in Cubit
Future<void> loadPosts() async {
  emit(PostLoadingState());
  // Calls use case (Clean Architecture)
  final posts = await getPostsUseCase(NoParams());
  emit(PostLoadedState(posts));
}
```

**Result: 40% less code with Cubit!**

## 🏗️ Project Structure (Cubit Example with Clean Architecture)

```
lib/features/post/
├── domain/                         # Business logic layer
│   ├── entities/
│   │   └── post.dart              # Pure domain entity
│   ├── repositories/
│   │   └── post_repository.dart   # Repository interface
│   └── usecases/
│       ├── get_posts.dart         # Use case: Get posts
│       └── get_posts_with_error.dart # Use case: Trigger error
├── data/                           # Data access layer
│   ├── datasources/
│   │   └── post_remote_datasource.dart # API service
│   ├── models/
│   │   └── post_model.dart        # DTO with JSON
│   └── repositories/
│       └── post_repository_impl.dart # Repository implementation
└── presentation/                   # UI layer
    ├── cubit/
    │   ├── post_cubit.dart        # Cubit implementation
    │   └── post_state.dart        # State definitions
    └── screens/
        └── post_list_screen.dart  # UI with Cubit
```

**Notice:** No `post_event.dart` file needed! But still has full Clean Architecture!

## 📖 Complete Flow Example

### User Action: Load Posts

```
1. UI INTERACTION
   User taps "Load Posts" button
   ↓

2. DIRECT METHOD CALL (No event!)
   onPressed: () {
     context.read<PostCubit>().loadPosts();
   }
   ↓

3. CUBIT PROCESSES REQUEST
   Future<void> loadPosts() async {
     emit(PostLoadingState());  // UI shows spinner
     final posts = await api.fetchPosts();
     emit(PostLoadedState(posts)); // UI shows data
   }
   ↓

4. UI REBUILDS (BlocBuilder)
   BlocBuilder<PostCubit, PostState>(
     builder: (context, state) {
       return switch (state) {
         PostLoadingState() => CircularProgressIndicator(),
         PostLoadedState() => PostList(state.posts),
         // ... other states
       };
     },
   )
```

## 💻 Creating Your Own Cubit

### Step 1: Define States

```dart
// product_state.dart
sealed class ProductState {}

final class ProductInitialState extends ProductState {}
final class ProductLoadingState extends ProductState {}
final class ProductLoadedState extends ProductState {
  final List<Product> products;
  ProductLoadedState(this.products);
}
final class ProductErrorState extends ProductState {
  final String message;
  ProductErrorState(this.message);
}
```

### Step 2: Create Cubit

```dart
// product_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProductsUseCase; // Use case, not service!

  ProductCubit({required this.getProductsUseCase}) : super(ProductInitialState());

  // Method 1: Load products
  Future<void> loadProducts() async {
    emit(ProductLoadingState());
    try {
      final products = await getProductsUseCase(NoParams()); // Call use case
      emit(ProductLoadedState(products));
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  // Method 2: Search products (if you had a SearchProducts use case)
  Future<void> searchProducts(String query) async {
    emit(ProductLoadingState());
    try {
      final products = await searchProductsUseCase(SearchParams(query));
      emit(ProductLoadedState(products));
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  // Method 3: Clear (synchronous)
  void clear() {
    emit(ProductInitialState());
  }
}
```

### Step 3: Provide Cubit

```dart
// In your app
BlocProvider(
  create: (context) => ProductCubit(
    getProductsUseCase: GetProducts(
      ProductRepositoryImpl(
        remoteDataSource: ProductRemoteDataSource(),
      ),
    ),
  ),
  child: ProductScreen(),
)

// Or with dependency injection (recommended)
BlocProvider(
  create: (context) => getIt<ProductCubit>(),
  child: ProductScreen(),
)
```

### Step 4: Use in UI

```dart
// Call methods
ElevatedButton(
  onPressed: () => context.read<ProductCubit>().loadProducts(),
  child: Text('Load'),
)

// Build UI based on state
BlocBuilder<ProductCubit, ProductState>(
  builder: (context, state) {
    return switch (state) {
      ProductInitialState() => Text('Press Load'),
      ProductLoadingState() => CircularProgressIndicator(),
      ProductLoadedState() => ProductList(state.products),
      ProductErrorState() => ErrorWidget(state.message),
    };
  },
)
```

## 🎨 Advanced Cubit Patterns

### 1. Optimistic Updates

```dart
Future<void> likePost(int postId) async {
  // Update UI immediately
  if (state is PostLoadedState) {
    final posts = (state as PostLoadedState).posts;
    final updated = posts.map((p) => 
      p.id == postId ? p.copyWith(liked: true) : p
    ).toList();
    emit(PostLoadedState(updated));
  }

  // Then call API
  try {
    await api.likePost(postId);
  } catch (e) {
    // Revert on error
    // ... revert logic
  }
}
```

### 2. Refresh with Current Data

```dart
Future<void> refresh() async {
  // Keep showing current data while refreshing
  if (state is PostLoadedState) {
    final currentPosts = (state as PostLoadedState).posts;
    emit(PostRefreshingState(currentPosts));
  } else {
    emit(PostLoadingState());
  }

  try {
    final posts = await api.fetchPosts();
    emit(PostLoadedState(posts));
  } catch (e) {
    // Restore previous state on error
    if (state is PostRefreshingState) {
      emit(PostLoadedState((state as PostRefreshingState).currentPosts));
    }
  }
}
```

### 3. Pagination

```dart
int _currentPage = 1;
List<Post> _allPosts = [];

Future<void> loadMore() async {
  if (state is! PostLoadedState) return;

  emit(PostLoadingMoreState(_allPosts));
  
  try {
    _currentPage++;
    final newPosts = await api.fetchPage(_currentPage);
    _allPosts.addAll(newPosts);
    emit(PostLoadedState(_allPosts));
  } catch (e) {
    emit(PostErrorState(e.toString()));
  }
}
```

### 4. Debouncing Search

```dart
Timer? _debounce;

void search(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 500), () async {
    emit(PostLoadingState());
    try {
      final results = await api.search(query);
      emit(PostLoadedState(results));
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  });
}

@override
Future<void> close() {
  _debounce?.cancel();
  return super.close();
}
```

## 🧪 Testing Cubit

```dart
void main() {
  group('PostCubit', () {
    late PostCubit cubit;
    late MockPostService mockService;

    setUp(() {
      mockService = MockPostService();
      cubit = PostCubit(postApiService: mockService);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is PostInitialState', () {
      expect(cubit.state, isA<PostInitialState>());
    });

    blocTest<PostCubit, PostState>(
      'emits [loading, loaded] when loadPosts succeeds',
      build: () {
        when(() => mockService.fetchPosts())
            .thenAnswer((_) async => [Post(...)]);
        return cubit;
      },
      act: (cubit) => cubit.loadPosts(), // Direct method call!
      expect: () => [
        isA<PostLoadingState>(),
        isA<PostLoadedState>(),
      ],
    );
  });
}
```

## ✅ When to Use Cubit

Use Cubit when:
- ✓ State changes are straightforward
- ✓ You want less boilerplate
- ✓ You're building a prototype quickly
- ✓ Team prefers simplicity
- ✓ You don't need event tracking
- ✓ Business logic is not complex

Use BLoC when:
- ✓ You need to track/log events
- ✓ Multiple events can trigger same state
- ✓ Complex business logic
- ✓ Event transformations needed (debounce, throttle)
- ✓ You want strict event-driven architecture
- ✓ Large team needs clear separation

## 🎯 Best Practices

### 1. **Keep Methods Focused**
```dart
// Good
Future<void> loadPosts() async { ... }
Future<void> refreshPosts() async { ... }
Future<void> searchPosts(String query) async { ... }

// Avoid
Future<void> handleEverything(String? action, String? query) async { ... }
```

### 2. **Use Descriptive Method Names**
```dart
// Good
cubit.loadPosts()
cubit.searchPosts(query)
cubit.markAsRead(id)

// Avoid
cubit.doAction1()
cubit.process(data)
```

### 3. **Emit States, Not Side Effects**
```dart
// Good - State represents data
emit(PostLoadedState(posts));

// Avoid - Don't trigger navigation from Cubit
Navigator.push(...); // Do this in UI layer
```

### 4. **Handle Errors Gracefully**
```dart
Future<void> loadPosts() async {
  emit(PostLoadingState());
  try {
    final posts = await api.fetchPosts();
    emit(PostLoadedState(posts));
  } catch (e) {
    emit(PostErrorState(e.toString())); // Always handle errors
  }
}
```

### 5. **Use Switch Expressions for State Handling**
```dart
// Modern Dart pattern - clean and exhaustive
return switch (state) {
  PostInitialState() => WelcomeView(),
  PostLoadingState() => LoadingIndicator(),
  PostLoadedState() => PostList(state.posts),
  PostRefreshingState() => Stack(
      children: [
        PostList(state.currentPosts),
        RefreshIndicator(),
      ],
    ),
  PostErrorState() => ErrorView(state.message),
};
```

### 6. **Consider BlocConsumer for Side Effects**
```dart
// When you need BOTH UI updates AND side effects (snackbars, navigation)
// Consider using BLoC with BlocConsumer instead of Cubit
BlocConsumer<ProductBloc, ProductState>(
  listener: (context, state) {
    if (state is ProductAddedToCartState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart!')),
      );
    }
  },
  builder: (context, state) {
    return ProductList(state.products);
  },
)
```

## 📚 Summary

**Cubit** simplifies state management by removing the event layer:

- **No Events**: Call methods directly on Cubit
- **Same BlocProvider & BlocBuilder**: Works with existing flutter_bloc infrastructure
- **40% Less Code**: Fewer files and classes
- **Still Reactive**: UI automatically updates on state changes
- **Easy Testing**: Just call methods and verify states
- **Great for Learning**: Simpler mental model
- **Use Switch Expressions**: Modern Dart 3+ patterns for clean code

**When to Choose**:
- **Cubit**: Simple CRUD, prototyping, direct state changes
- **BLoC**: Complex logic, event tracking, multiple events → same state
- **BlocConsumer**: Shopping carts, forms, features with side effects

**Try the tutorial app to see all three patterns in action!**

---

## 🚀 Quick Start

Run the app and explore all three demos:

1. **"BLoC Pattern"** (Users): Event-driven with explicit events
2. **"Cubit Pattern"** (Posts): Direct method calls, no events, optimistic refresh
3. **"BlocConsumer Demo"** (Products): Shopping cart with snackbars, navigation, haptics

Compare the code to understand:
- BLoC: More boilerplate, event tracking
- Cubit: Less code, simpler flow
- BlocConsumer: Best UX with side effects
