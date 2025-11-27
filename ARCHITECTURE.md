# Clean Architecture + State Management - BLoC, Cubit & BlocConsumer

## Overview

This tutorial demonstrates **Clean Architecture** with **three state management patterns**: BLoC (event-driven), Cubit (method-driven), and BlocConsumer (builder + listener). All patterns follow Clean Architecture principles with proper layer separation.

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                               │
│         (BLoC/Cubit + Screens + States + Events)                    │
│  Depends on: Domain Layer only (Use Cases, Entities, Repositories)  │
└─────────────────────────────────────────────────────────────────────┘
                              ↓ depends on ↓
┌─────────────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                                   │
│     (Entities + Repository Interfaces + Use Cases)                  │
│  Depends on: NOTHING! Pure Dart, no framework dependencies          │
└─────────────────────────────────────────────────────────────────────┘
                              ↑ implements ↑
┌─────────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                                    │
│  (Models + Repository Implementations + Data Sources)               │
│  Depends on: Domain Layer (implements repository interfaces)        │
└─────────────────────────────────────────────────────────────────────┘
```

---

## BLoC Pattern Flow (User Example with Clean Architecture)

### The Complete Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER - UI                           │
│                   (user_list_screen.dart)                           │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ User taps button
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER - DISPATCH EVENT               │
│  context.read<UserBloc>().add(LoadUsersEvent())                     │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Event reaches BLoC
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER - USER BLOC                    │
│                        (user_bloc.dart)                             │
│                                                                      │
│  Event Handler: _onLoadUsers()                                      │
│  1. emit(UserLoadingState())                                        │
│  2. Call USE CASE (not repository!)                                 │
│  3. emit(UserLoadedState(users)) OR emit(UserErrorState(error))    │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Calls use case
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER - USE CASE                           │
│                    (get_users.dart)                                 │
│                                                                      │
│  class GetUsers implements UseCase<List<User>, NoParams> {         │
│    Future<List<User>> call(NoParams params) {                      │
│      return repository.getUsers();                                  │
│    }                                                                │
│  }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Calls repository interface
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                 DOMAIN LAYER - REPOSITORY INTERFACE                  │
│                    (user_repository.dart)                           │
│                                                                      │
│  abstract class UserRepository {                                    │
│    Future<List<User>> getUsers();                                   │
│  }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Implemented by
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                 DATA LAYER - REPOSITORY IMPLEMENTATION               │
│                 (user_repository_impl.dart)                         │
│                                                                      │
│  class UserRepositoryImpl implements UserRepository {              │
│    Future<List<User>> getUsers() async {                           │
│      return await remoteDataSource.getUsers();                      │
│    }                                                                │
│  }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Calls data source
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    DATA LAYER - REMOTE DATA SOURCE                   │
│                 (user_remote_datasource.dart)                       │
│                                                                      │
│  Future<List<UserModel>> getUsers() async {                        │
│    await Future.delayed(Duration(seconds: 2));                      │
│    return [UserModel(...), UserModel(...)];                         │
│  }                                                                   │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Returns models (DTOs)
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│               DATA LAYER - MODEL → ENTITY CONVERSION                 │
│  UserModel extends User (entity)                                    │
│  Returns List<User> (entities) to repository                        │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Returns entities up the chain
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    PRESENTATION - EMIT NEW STATE                     │
│  Stream<UserState> → BlocBuilder receives new state                 │
│  State contains List<User> entities (not models!)                   │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ UI rebuilds
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    UI REBUILDS (BlocBuilder)                         │
│                                                                      │
│  switch (state) {                                                   │
│    UserInitialState() => Show welcome screen                        │
│    UserLoadingState() => Show loading spinner                       │
│    UserLoadedState()  => Show user list (entities)                  │
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

## BlocConsumer Pattern Flow (Product Example)

### The Complete Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                               │
│                    (product_list_screen.dart)                       │
│    BlocConsumer: Builder (UI) + Listener (Side Effects)            │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                   User clicks "Add to Cart" button
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        DISPATCH EVENT                                │
│  context.read<ProductBloc>().add(AddToCartEvent(id, name))          │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                      Event reaches BLoC
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        PRODUCT BLOC                                  │
│                       (product_bloc.dart)                           │
│                                                                      │
│  Event Handler: _onAddToCart()                                      │
│  1. Extract current data with switch expression                    │
│  2. Update product list (mark as inCart)                           │
│  3. emit(ProductAddedToCartState(...)) ← Triggers LISTENER        │
│  4. emit(ProductLoadedState(...))      ← Updates BUILDER          │
└─────────────────────────────────────────────────────────────────────┘
                                    │
               Dual state emissions flow
                                    │
          ┌───────────────────────────┴───────────────────────────┐
          │                                                          │
          ▼                                                          ▼
┌──────────────────────────┐                      ┌──────────────────────────┐
│      LISTENER           │                      │       BUILDER          │
│  (Side Effects)        │                      │  (UI Updates)         │
│                        │                      │                      │
│ Show Snackbar:        │                      │ Switch on state:     │
│ "Product added"       │                      │ - LoadedState        │
│                        │                      │ - AddedToCartState   │
│ Haptic Feedback       │                      │ - ErrorState         │
│ (vibration)           │                      │                      │
│                        │                      │ Rebuild product list │
│ listenWhen:           │                      │ with updated cart    │
│ - AddedToCartState    │                      │ badge                │
│ - RemovedState        │                      │                      │
│ - CheckoutState       │                      │                      │
└──────────────────────────┘                      └──────────────────────────┘
```

### Dual State Emission Pattern

**Why it's needed:**
```
Problem: Listener only fires on state TYPE changes

LoadedState → add to cart → AddedToCartState ✓ Fires!
AddedToCartState → add to cart → AddedToCartState ✗ Doesn't fire!

Solution: Emit action state, then base state

LoadedState → add → AddedToCartState → LoadedState ✓ Ready for next!
LoadedState → add → AddedToCartState → LoadedState ✓ Fires again!
```

**Implementation:**
```dart
void _onAddToCart(event, emit) {
  // 1. Get current data using switch expression
  final (products, count) = switch (state) {
    ProductLoadedState() => (state.products, state.cartItemCount),
    ProductAddedToCartState() => (state.products, state.cartItemCount),
    _ => (<Product>[], 0),
  };

  // 2. Update data
  final updatedProducts = products.map((p) => 
    p.id == event.id ? p.copyWith(inCart: true) : p
  ).toList();

  // 3. Emit action state (triggers listener)
  emit(ProductAddedToCartState(
    products: updatedProducts,
    cartItemCount: count + 1,
    productName: event.productName,
    timestamp: DateTime.now(), // Makes each instance unique
  ));

  // 4. Emit base state (prepares for next action)
  emit(ProductLoadedState(
    products: updatedProducts,
    cartItemCount: count + 1,
  ));
}
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

### BlocConsumer Pattern (Product - Shopping Cart)
```
Basic Flow:
Initial → Loading → Loaded

Cart Actions Flow (Dual Emission Pattern):
Loaded → AddEvent → AddedToCart → Loaded ← ready for next action
                        │ Listener fires!
                        └────► Snackbar shown
                        └────► Haptic feedback

Loaded → RemoveEvent → RemovedFromCart → Loaded
                           │ Listener fires!
                           └────► Snackbar shown

Loaded → CheckoutEvent → CheckoutState → Loaded
                            │ Listener fires!
                            └────► Dialog shown
                            └────► Navigation
                            └────► Haptic feedback

Refresh Flow:
Loaded → RefreshEvent → Refreshing → Loaded
                           │ Shows current data
                           └────► + refresh indicator

Error Flow:
Loaded → ErrorEvent → Error
                        │ Listener fires!
                        └────► Error snackbar
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

### BlocConsumer Pattern Components (Product Demo)

#### 1. Events (product_event.dart)
- **LoadProductsEvent**: Load products successfully
- **LoadProductsWithErrorEvent**: Trigger error scenario
- **AddToCartEvent**: Add product to cart (includes productId, productName)
- **RemoveFromCartEvent**: Remove product from cart
- **CheckoutEvent**: Initiate checkout flow
- **RefreshProductsEvent**: Refresh product list
- **ResetProductsEvent**: Reset to initial state

#### 2. States (product_state.dart)
- **ProductInitialState**: Starting state
- **ProductLoadingState**: Products being fetched
- **ProductLoadedState**: Products loaded (contains products, cartItemCount)
- **ProductAddedToCartState**: Product added (contains products, cartItemCount, productName, timestamp)
- **ProductRemovedFromCartState**: Product removed (contains products, cartItemCount, productName, timestamp)
- **ProductErrorState**: Error occurred (contains errorMessage)
- **ProductCheckoutState**: Checkout initiated (contains itemCount)
- **ProductRefreshingState**: Refreshing while showing current products

**Note**: Action states (Added, Removed, Checkout) include timestamps to ensure each instance is unique, allowing repeated listener firing.

#### 3. BLoC (product_bloc.dart)
- Uses **switch expressions** with record patterns for clean state extraction
- Implements **dual state emission** pattern:
  - Emits action state (triggers listener)
  - Then emits loaded state (prepares for next action)
- Handles 7 different event types
- Manages shopping cart logic

**Switch Expression Pattern**:
```dart
final (currentProducts, currentCartCount) = switch (state) {
  ProductLoadedState() => (state.products, state.cartItemCount),
  ProductAddedToCartState() => (state.products, state.cartItemCount),
  ProductRemovedFromCartState() => (state.products, state.cartItemCount),
  _ => (<Product>[], 0),
};
```

#### 4. BlocConsumer (product_list_screen.dart)
- **Listener**: Handles side effects
  - Snackbars for add/remove actions
  - Navigation on checkout
  - Haptic feedback for user actions
  - Uses `clearSnackBars()` to prevent queue issues
- **Builder**: Handles UI rendering
  - Product list with cart badges
  - Loading states
  - Error states with retry
- **listenWhen**: Optimizes when listener fires
  ```dart
  listenWhen: (previous, current) {
    return current is ProductAddedToCartState ||
        current is ProductRemovedFromCartState ||
        current is ProductErrorState ||
        current is ProductCheckoutState;
  }
  ```

#### 5. BlocProvider (home_screen.dart → product_list_screen.dart)
```dart
BlocProvider(
  create: (_) => ProductBloc(productApiService: ProductApiService())
    ..add(LoadProductsEvent()),
  child: ProductListScreen(),
)
```

---

## Data Flow Examples

### BLoC: When User Taps "Load Users" Button

1. **UI**: Button tap triggers event dispatch
   ```dart
   context.read<UserBloc>().add(LoadUsersEvent());
   ```

2. **Event Stream**: Event enters BLoC's event stream

3. **Event Handler**: `_onLoadUsers` is called
   ```dart
   Future<void> _onLoadUsers(LoadUsersEvent event, Emitter<UserState> emit) async {
     emit(UserLoadingState());
     final users = await userApiService.fetchUsers();
     emit(UserLoadedState(users));
   }
   ```

4. **State Stream**: New states flow to UI
   - First: `UserLoadingState` (UI shows spinner)
   - Then: `UserLoadedState(users)` (UI shows list)

5. **BlocBuilder Reacts**: Widget rebuilds for each state

---

### Cubit: When User Taps "Load Posts" Button

1. **UI**: Button tap calls method directly
   ```dart
   context.read<PostCubit>().loadPosts();
   ```

2. **Method Executes**: No event handling needed
   ```dart
   Future<void> loadPosts() async {
     emit(PostLoadingState());
     final posts = await postApiService.fetchPosts();
     emit(PostLoadedState(posts));
   }
   ```

3. **State Stream**: New states flow to UI
   - First: `PostLoadingState`
   - Then: `PostLoadedState(posts)`

4. **BlocBuilder Reacts**: Same as BLoC pattern!

---

### BlocConsumer: When User Adds Product to Cart

1. **UI**: User taps "Add to Cart" icon button
   ```dart
   IconButton(
     icon: Icon(product.inCart ? Icons.check_circle : Icons.add_shopping_cart),
     onPressed: () {
       context.read<ProductBloc>().add(
         AddToCartEvent(
           productId: product.id,
           productName: product.name,
         ),
       );
     },
   )
   ```

2. **Event Handler**: `_onAddToCart` processes event
   ```dart
   void _onAddToCart(AddToCartEvent event, Emitter<ProductState> emit) {
     // Extract current data using switch expression
     final (currentProducts, currentCartCount) = switch (state) {
       ProductLoadedState() => (state.products, state.cartItemCount),
       ProductAddedToCartState() => (state.products, state.cartItemCount),
       ProductRemovedFromCartState() => (state.products, state.cartItemCount),
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

       // DUAL EMISSION PATTERN
       // 1. Emit action state (triggers listener)
       emit(ProductAddedToCartState(
         products: updatedProducts,
         cartItemCount: currentCartCount + 1,
         productName: event.productName,
         timestamp: DateTime.now(),
       ));

       // 2. Emit loaded state (updates builder, ready for next)
       emit(ProductLoadedState(
         products: updatedProducts,
         cartItemCount: currentCartCount + 1,
       ));
     }
   }
   ```

3. **BlocConsumer Listener Fires**: Side effects execute
   ```dart
   listener: (context, state) {
     ScaffoldMessenger.of(context).clearSnackBars();
     
     if (state is ProductAddedToCartState) {
       // Show snackbar
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('${state.productName} added to cart!'),
           backgroundColor: Colors.green,
         ),
       );
       // Haptic feedback
       HapticFeedback.mediumImpact();
     }
   }
   ```

4. **BlocConsumer Builder Updates**: UI rebuilds
   ```dart
   builder: (context, state) {
     return switch (state) {
       ProductLoadedState() => _buildProductsList(
         state.products,
         state.cartItemCount,
       ),
       ProductAddedToCartState() => _buildProductsList(
         state.products,
         state.cartItemCount,
       ),
       // ... other states
     };
   }
   ```

5. **Result**: 
   - Cart badge updates (builder)
   - Green snackbar appears (listener)
   - Phone vibrates (listener)
   - Product icon changes to checkmark (builder)
   - State resets to `ProductLoadedState` (ready for next add)

---

## Why Dual Emission Pattern?

**Problem**: BlocConsumer listener only fires when state **type** changes.

```dart
// Scenario without dual emission:
ProductAddedToCartState  (first add - listener fires ✓)
  ↓
ProductAddedToCartState  (second add - listener doesn't fire ✗)
  ↓
ProductAddedToCartState  (third add - listener doesn't fire ✗)
```

**Solution**: Emit action state, then base state.

```dart
// With dual emission:
ProductLoadedState
  ↓ add to cart
ProductAddedToCartState  (listener fires - show snackbar ✓)
  ↓ immediate
ProductLoadedState       (ready for next action)
  ↓ add to cart again
ProductAddedToCartState  (listener fires again - show snackbar ✓)
  ↓ immediate
ProductLoadedState       (ready for next action)
```

**Key Points**:
1. Always transitions between different state types
2. Listener fires every time
3. Builder handles both state types (shows same UI)
4. `listenWhen` optimizes by filtering which states trigger listener
5. `clearSnackBars()` prevents snackbar queue buildup

---

## Component Interaction Summary
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
