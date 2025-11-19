# Cubit Tutorial Guide

## 🎯 What is Cubit?

**Cubit** is a lightweight subset of BLoC that allows you to manage state without events. It's simpler, has less boilerplate, and is perfect for straightforward state management scenarios.

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

Future<void> _onLoadUsers(LoadUsersEvent event, Emitter emit) async {
  emit(UserLoadingState());
  final users = await api.fetchUsers();
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
  final posts = await api.fetchPosts();
  emit(PostLoadedState(posts));
}
```

**Result: 40% less code with Cubit!**

## 🏗️ Project Structure (Cubit Example)

```
lib/
├── cubit/                      # Cubit layer
│   ├── post_cubit.dart        # Cubit implementation
│   └── post_state.dart        # State definitions
├── models/
│   └── post.dart              # Post data model
├── services/
│   └── post_api_service.dart  # API service
└── screens/
    └── post_list_screen.dart  # UI with Cubit
```

**Notice:** No `post_event.dart` file needed!

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
  final ProductService service;

  ProductCubit({required this.service}) : super(ProductInitialState());

  // Method 1: Load products
  Future<void> loadProducts() async {
    emit(ProductLoadingState());
    try {
      final products = await service.fetchProducts();
      emit(ProductLoadedState(products));
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  // Method 2: Search products
  Future<void> searchProducts(String query) async {
    emit(ProductLoadingState());
    try {
      final products = await service.search(query);
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
  create: (context) => ProductCubit(service: ProductService()),
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

## 📚 Summary

**Cubit** simplifies state management by removing the event layer:

- **No Events**: Call methods directly on Cubit
- **Same BlocProvider & BlocBuilder**: Works with existing flutter_bloc infrastructure
- **40% Less Code**: Fewer files and classes
- **Still Reactive**: UI automatically updates on state changes
- **Easy Testing**: Just call methods and verify states
- **Great for Learning**: Simpler mental model

**Try the tutorial app to see both BLoC and Cubit in action!**

---

## 🚀 Quick Start

Run the app and tap "Cubit Pattern" to see:
- Direct method calls (no events)
- Loading states with spinner
- Success state with post list
- Error handling with retry
- Refresh functionality

Compare with the "BLoC Pattern" to understand the differences!
