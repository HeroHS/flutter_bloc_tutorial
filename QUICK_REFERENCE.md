# BLoC & Cubit Quick Reference Guide

## 📋 Common Patterns & Snippets for All Four Examples

This guide covers BLoC, Cubit, and BlocConsumer patterns used in:
- **Users** - BLoC Pattern
- **Posts** - Cubit Pattern  
- **Todos** - Cubit with BlocConsumer
- **Products** - BLoC with BlocConsumer

---

## 🎯 BLoC Pattern (Users Example)

### 1. Creating a New Event

```dart
// In your_event.dart
sealed class YourEvent {}

final class LoadDataEvent extends YourEvent {}

final class RefreshDataEvent extends YourEvent {}

final class SearchEvent extends YourEvent {
  final String query;
  SearchEvent(this.query);
}
```

### 2. Creating a New State

```dart
// In your_state.dart
sealed class YourState {}

final class InitialState extends YourState {}

final class LoadingState extends YourState {}

final class LoadedState extends YourState {
  final List<YourModel> data;
  LoadedState(this.data);
}

final class ErrorState extends YourState {
  final String message;
  ErrorState(this.message);
}
```

### 3. Creating a BLoC

```dart
// In your_bloc.dart
class YourBloc extends Bloc<YourEvent, YourState> {
  final YourService service;

  YourBloc({required this.service}) : super(InitialState()) {
    on<LoadDataEvent>(_onLoadData);
    on<RefreshDataEvent>(_onRefresh);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<YourState> emit,
  ) async {
    emit(LoadingState());
    try {
      final data = await service.fetchData();
      emit(LoadedState(data));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshDataEvent event,
    Emitter<YourState> emit,
  ) async {
    // Refresh logic here
  }
}
```

### 4. Providing BLoC to Widget Tree

```dart
// In main.dart or parent widget
BlocProvider(
  create: (context) => YourBloc(service: YourService()),
  child: YourScreen(),
)
```

### 5. Using BLoC in UI with BlocBuilder

```dart
BlocBuilder<YourBloc, YourState>(
  builder: (context, state) {
    return switch (state) {
      InitialState() => Text('Press button to start'),
      LoadingState() => CircularProgressIndicator(),
      LoadedState() => ListView.builder(
        itemCount: state.data.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(state.data[index].toString()),
        ),
      ),
      ErrorState() => Text('Error: ${state.message}'),
    };
  },
)
```

### 6. Dispatching Events

```dart
// Get BLoC instance and add event
context.read<YourBloc>().add(LoadDataEvent());

// Or with a button
ElevatedButton(
  onPressed: () => context.read<YourBloc>().add(RefreshDataEvent()),
  child: Text('Refresh'),
)
```

### 7. Listening to State Changes (Side Effects)

```dart
BlocListener<YourBloc, YourState>(
  listener: (context, state) {
    if (state is ErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: YourWidget(),
)
```

### 8. Combined Builder and Listener (BlocConsumer)

```dart
BlocConsumer<YourBloc, YourState>(
  // Optional: Control when listener fires
  listenWhen: (previous, current) {
    return current is ErrorState || current is SuccessState;
  },
  listener: (context, state) {
    // Side effects: navigation, snackbars, dialogs
    if (state is ErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
    if (state is SuccessState) {
      Navigator.push(context, NextScreen());
    }
  },
  // Optional: Control when builder rebuilds
  buildWhen: (previous, current) {
    return current is! ErrorState; // Don't rebuild for errors
  },
  builder: (context, state) {
    // UI based on state
    return switch (state) {
      LoadingState() => CircularProgressIndicator(),
      LoadedState() => YourDataWidget(state.data),
      _ => Container(),
    };
  },
)
```

### 8a. BlocConsumer with Dual State Emissions (Shopping Cart Pattern)

```dart
// In BLoC: Emit action state, then loaded state
void _onAddToCart(AddToCartEvent event, Emitter emit) {
  // Get current data
  final (products, cartCount) = switch (state) {
    LoadedState() => (state.products, state.cartCount),
    AddedToCartState() => (state.products, state.cartCount),
    _ => (<Product>[], 0),
  };

  // Update data
  final updatedProducts = products.map((p) => 
    p.id == event.id ? p.copyWith(inCart: true) : p
  ).toList();

  // Emit action state (triggers listener for snackbar)
  emit(AddedToCartState(
    products: updatedProducts,
    cartCount: cartCount + 1,
    itemName: event.name,
  ));

  // Then emit loaded state (ready for next action)
  emit(LoadedState(
    products: updatedProducts,
    cartCount: cartCount + 1,
  ));
}

// In UI: listenWhen catches the transition
BlocConsumer<ProductBloc, ProductState>(
  listenWhen: (previous, current) {
    // Trigger on action states
    return current is AddedToCartState ||
        current is RemovedFromCartState;
  },
  listener: (context, state) {
    // Clear existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();
    
    if (state is AddedToCartState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${state.itemName} added to cart!'),
          backgroundColor: Colors.green,
        ),
      );
      HapticFeedback.mediumImpact();
    }
  },
  builder: (context, state) {
    return switch (state) {
      LoadingState() => CircularProgressIndicator(),
      LoadedState() => ProductList(state.products),
      AddedToCartState() => ProductList(state.products),
      _ => Container(),
    };
  },
)
```

### 9. Multiple BLoC Providers

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(create: (context) => UserBloc()),
    BlocProvider(create: (context) => SettingsBloc()),
  ],
  child: MyApp(),
)
```

### 10. Accessing Multiple BLoCs

```dart
// In a widget
ElevatedButton(
  onPressed: () {
    context.read<AuthBloc>().add(LogoutEvent());
    context.read<UserBloc>().add(ClearUserEvent());
  },
  child: Text('Logout'),
)
```

## 🔍 Common Use Cases

### Loading Data on Screen Init

```dart
class YourScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => YourBloc(service: YourService())
        ..add(LoadDataEvent()), // Trigger load immediately
      child: YourScreenView(),
    );
  }
}
```

### Pull-to-Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    context.read<YourBloc>().add(RefreshDataEvent());
    // Wait for the refresh to complete
    await context.read<YourBloc>().stream.firstWhere(
      (state) => state is! LoadingState,
    );
  },
  child: YourListWidget(),
)
```

### Search with Debouncing

```dart
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(Duration(milliseconds: 300)),
    );
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final results = await searchService.search(event.query);
    emit(SearchLoaded(results));
  }
}

// Helper function for debouncing
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
```

### Pagination

```dart
final class LoadMoreEvent extends YourEvent {}

class YourBloc extends Bloc<YourEvent, YourState> {
  int _currentPage = 1;
  List<Item> _allItems = [];

  YourBloc() : super(InitialState()) {
    on<LoadDataEvent>(_onLoadData);
    on<LoadMoreEvent>(_onLoadMore);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<YourState> emit) async {
    emit(LoadingState());
    _currentPage = 1;
    _allItems = await service.fetchPage(_currentPage);
    emit(LoadedState(_allItems));
  }

  Future<void> _onLoadMore(LoadMoreEvent event, Emitter<YourState> emit) async {
    if (state is LoadedState) {
      emit(LoadingMoreState(_allItems)); // Show loading indicator
      _currentPage++;
      final newItems = await service.fetchPage(_currentPage);
      _allItems.addAll(newItems);
      emit(LoadedState(_allItems));
    }
  }
}
```

## 🐛 Debugging Tips

### 1. Log State Changes

```dart
class YourBloc extends Bloc<YourEvent, YourState> {
  YourBloc() : super(InitialState()) {
    on<YourEvent>((event, emit) async {
      print('Event: $event');
      // ... handle event
    });
  }

  @override
  void onChange(Change<YourState> change) {
    super.onChange(change);
    print('State changed: ${change.currentState} → ${change.nextState}');
  }

  @override
  void onTransition(Transition<YourEvent, YourState> transition) {
    super.onTransition(transition);
    print('Transition: ${transition.event} → ${transition.nextState}');
  }
}
```

### 2. Global BLoC Observer

```dart
// In main.dart
class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('BLoC created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} changed: $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('${bloc.runtimeType} error: $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('BLoC closed: ${bloc.runtimeType}');
  }
}

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
```

## ✅ Best Practices

1. **Keep States Immutable**: Use `final` fields in state classes
2. **Use Sealed Classes**: For exhaustive pattern matching
3. **Separate Concerns**: Keep business logic in BLoC, not in widgets
4. **Close Resources**: BLoC automatically closes when disposed
5. **Test BLoCs**: They're easy to test in isolation
6. **Avoid Logic in Events**: Events should just carry data
7. **Use Meaningful Names**: Event and state names should be descriptive
8. **Handle All States**: Always handle every possible state in your UI

## 🧪 Testing Example

```dart
void main() {
  group('UserBloc', () {
    late UserBloc userBloc;
    late MockUserApiService mockService;

    setUp(() {
      mockService = MockUserApiService();
      userBloc = UserBloc(userApiService: mockService);
    });

    tearDown(() {
      userBloc.close();
    });

    test('initial state is UserInitialState', () {
      expect(userBloc.state, isA<UserInitialState>());
    });

    blocTest<UserBloc, UserState>(
      'emits [LoadingState, LoadedState] when LoadUsersEvent succeeds',
      build: () {
        when(() => mockService.fetchUsers())
            .thenAnswer((_) async => [User(id: 1, name: 'Test')]);
        return userBloc;
      },
      act: (bloc) => bloc.add(LoadUsersEvent()),
      expect: () => [
        isA<UserLoadingState>(),
        isA<UserLoadedState>(),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [LoadingState, ErrorState] when LoadUsersEvent fails',
      build: () {
        when(() => mockService.fetchUsers())
            .thenThrow(Exception('Network error'));
        return userBloc;
      },
      act: (bloc) => bloc.add(LoadUsersEvent()),
      expect: () => [
        isA<UserLoadingState>(),
        isA<UserErrorState>(),
      ],
    );
  });
}
```

## 📚 Additional Resources

- [BLoC Library Documentation](https://bloclibrary.dev)
- [BLoC Architecture Guidelines](https://bloclibrary.dev/architecture)
- [Testing BLoCs](https://bloclibrary.dev/testing)
- [VS Code BLoC Extension](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc)

---

##  Cubit Pattern Quick Reference

### 1. Creating a Cubit (No Events Needed!)

```dart
// In post_cubit.dart
class PostCubit extends Cubit<PostState> {
  final PostApiService service;

  PostCubit({required this.service}) : super(PostInitialState());

  // Direct method calls - no events!
  Future<void> loadPosts() async {
    emit(PostLoadingState());
    try {
      final posts = await service.fetchPosts();
      emit(PostLoadedState(posts));
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  // Advanced: Refresh with optimistic update
  Future<void> refreshPosts() async {
    // Keep showing current data while refreshing
    if (state is PostLoadedState) {
      final currentPosts = (state as PostLoadedState).posts;
      emit(PostRefreshingState(currentPosts));
    } else {
      emit(PostLoadingState());
    }

    try {
      final posts = await service.refreshPosts();
      emit(PostLoadedState(posts));
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  Future<void> retry() async {
    await loadPosts();
  }

  void clear() {
    emit(PostInitialState());
  }
}
```

### 2. Calling Cubit Methods from UI

```dart
// No events! Just call methods directly
ElevatedButton(
  onPressed: () => context.read<PostCubit>().loadPosts(),
  child: Text('Load Posts'),
)
```

### 3. Testing Cubit

```dart
blocTest<PostCubit, PostState>(
  'emits [loading, loaded] when loadPosts succeeds',
  build: () => cubit,
  act: (cubit) => cubit.loadPosts(), // Direct method call!
  expect: () => [isA<PostLoadingState>(), isA<PostLoadedState>()],
);
```

##  BLoC vs Cubit Comparison

| Feature | BLoC | Cubit |
|---------|------|-------|
| **Trigger** | bloc.add(Event()) | cubit.method() |
| **Events** | Required | Not needed |
| **Files** | 3 (bloc, events, states) | 2 (cubit, states) |
| **Boilerplate** | More | ~40% less |
| **Use Case** | Complex logic, event tracking | Simple state changes |
| **Example** | UserBloc, ProductBloc | PostCubit |
| **State Access** | Switch on event types | Switch on state types |
| **Dual Emissions** | Emit multiple states per event | Emit multiple states per method |

---

## 🎯 BlocConsumer Pattern (Product Demo)

### When to Use BlocConsumer
- Need both UI updates AND side effects
- Show snackbars/dialogs while updating UI
- Navigate based on state + update display
- Trigger haptic feedback on actions

### Pattern: Dual State Emission
**Problem**: Listener only fires when state TYPE changes
**Solution**: Emit action state → then emit base state

```dart
// State Flow
LoadedState → AddToCartEvent → AddedToCartState → LoadedState
                                 ↑ Listener fires!

LoadedState → AddToCartEvent → AddedToCartState → LoadedState  
                                 ↑ Fires again!
```

### Complete Example: Shopping Cart

```dart
// States
sealed class ProductState {}
final class ProductLoadedState extends ProductState {
  final List<Product> products;
  final int cartCount;
  ProductLoadedState({required this.products, required this.cartCount});
}

final class ProductAddedToCartState extends ProductState {
  final List<Product> products;
  final int cartCount;
  final String productName;
  final DateTime timestamp; // Makes each instance unique
  ProductAddedToCartState({
    required this.products,
    required this.cartCount,
    required this.productName,
  }) : timestamp = DateTime.now();
}

// BLoC Event Handler
void _onAddToCart(AddToCartEvent event, Emitter emit) {
  // Get current state data using switch expression
  final (currentProducts, currentCartCount) = switch (state) {
    ProductLoadedState() => (state.products, state.cartCount),
    ProductAddedToCartState() => (state.products, state.cartCount),
    ProductRemovedFromCartState() => (state.products, state.cartCount),
    _ => (<Product>[], 0),
  };

  if (currentProducts.isNotEmpty) {
    // Update products
    final updatedProducts = currentProducts.map((product) {
      if (product.id == event.productId) {
        return product.copyWith(inCart: true);
      }
      return product;
    }).toList();

    // Emit action state (triggers listener)
    emit(ProductAddedToCartState(
      products: updatedProducts,
      cartCount: currentCartCount + 1,
      productName: event.productName,
    ));

    // Emit loaded state (ready for next action)
    emit(ProductLoadedState(
      products: updatedProducts,
      cartCount: currentCartCount + 1,
    ));
  }
}

// UI with BlocConsumer
BlocConsumer<ProductBloc, ProductState>(
  listenWhen: (previous, current) {
    // Trigger listener on action states
    return current is ProductAddedToCartState ||
        current is ProductRemovedFromCartState ||
        current is ProductErrorState ||
        current is ProductCheckoutState;
  },
  listener: (context, state) {
    // Clear existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    if (state is ProductAddedToCartState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${state.productName} added to cart!'),
          backgroundColor: Colors.green,
        ),
      );
      HapticFeedback.mediumImpact();
    }

    if (state is ProductRemovedFromCartState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${state.productName} removed from cart'),
          backgroundColor: Colors.orange,
        ),
      );
    }

    if (state is ProductCheckoutState) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Checkout'),
          content: Text('Proceeding with ${state.itemCount} items'),
        ),
      );
      HapticFeedback.heavyImpact();
    }
  },
  builder: (context, state) {
    return switch (state) {
      ProductInitialState() => WelcomeScreen(),
      ProductLoadingState() => LoadingIndicator(),
      ProductLoadedState() => ProductList(state.products),
      ProductAddedToCartState() => ProductList(state.products),
      ProductRemovedFromCartState() => ProductList(state.products),
      ProductErrorState() => ErrorView(state.message),
      ProductRefreshingState() => Stack(
          children: [
            ProductList(state.products),
            RefreshIndicator(),
          ],
        ),
      _ => Container(),
    };
  },
)
```

### Key Takeaways
1. **listenWhen**: Controls when listener fires (optimization)
2. **buildWhen**: Controls when builder rebuilds (optimization)
3. **Dual Emission**: Action state → Base state pattern
4. **Switch Expressions**: Clean state data extraction
5. **clearSnackBars()**: Prevents queue issues
