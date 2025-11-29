# Flutter BLoC Tutorial - Practice Exercises

Complete these exercises to deepen your understanding of BLoC, Cubit, and BlocConsumer patterns across all four features!

## 🎯 BLoC Pattern Exercises (User Feature)

## 🎯 Exercise 1: Add a Refresh Button to User Screen (Easy - BLoC)

**Goal**: Add a refresh button to the app bar that reloads the user list.

**Steps**:
1. Open `lib/features/user/presentation/screens/user_list_screen.dart`
2. Add a refresh icon button to the `AppBar` actions
3. When clicked, dispatch a `LoadUsersEvent`
4. Test that it works in both success and error states

**Hint**:
```dart
IconButton(
  icon: const Icon(Icons.refresh),
  onPressed: () {
    // Add your code here
  },
)
```

**Learning Objective**: Practice dispatching events from UI

---

## 🎯 Exercise 2: Add User Count Display (Easy - BLoC)

**Goal**: Show the total number of users in the loaded state.

**Steps**:
1. Modify the success banner in `_buildLoadedView`
2. Display "Successfully loaded X users" where X is the actual count
3. Make the count more prominent with styling

**Learning Objective**: Access state data in UI components

---

## 🎯 Exercise 3: Customize Loading Message (Easy - Data Layer)

**Goal**: Change the loading delay and update the message.

**Steps**:
1. Open `lib/features/user/data/datasources/user_remote_datasource.dart`
2. Change the delay from 2 seconds to 3 seconds
3. Update the loading message in the UI to reflect the new delay
4. Run the app and verify the change

**Learning Objective**: Understand how services affect UI state

---

## 🎯 Exercise 4: Add More User Fields (Medium)

**Goal**: Extend the User model with additional fields.

**Steps**:
1. Add `phone` and `department` fields to the `User` model
2. Update mock data in `UserApiService` to include these fields
3. Display these fields in the user list UI
4. Maintain proper styling

**Requirements**:
- Phone number should be displayed with a phone icon
- Department should be displayed with a building icon

**Learning Objective**: Work with data models and UI integration

---

## 🎯 Exercise 5: Implement Search Feature (Medium)

**Goal**: Add the ability to search/filter users by name.

**Steps**:
1. Create a new event `SearchUsersEvent` with a `query` parameter
2. Create a new state `UserFilteredState` to hold filtered results
3. Add event handler in `UserBloc` to filter users
4. Add a search TextField in the UI
5. Dispatch search event as user types

**Hint**: Store the full user list and filter it based on query

**Learning Objective**: Handle user input with BLoC

---

## 🎯 Exercise 6: Add Pull-to-Refresh (Medium)

**Goal**: Implement pull-to-refresh functionality.

**Steps**:
1. Wrap the user list in a `RefreshIndicator`
2. On refresh, dispatch `LoadUsersEvent`
3. Wait for state to change from loading before completing refresh
4. Test in both success and error scenarios

**Hint**:
```dart
RefreshIndicator(
  onRefresh: () async {
    // Your code here
  },
  child: ListView(...),
)
```

**Learning Objective**: Handle async UI interactions with BLoC

---

## 🎯 Exercise 7: Add a Detail Screen (Medium-Hard)

**Goal**: Create a user detail screen that shows when tapping a user.

**Steps**:
1. Create `lib/screens/user_detail_screen.dart`
2. Pass selected user to detail screen via constructor
3. Display all user information with nice formatting
4. Add a back button
5. (Bonus) Create a `UserDetailBloc` if you want to load additional data

**Learning Objective**: Navigate between screens with BLoC

---

## 🎯 Exercise 8: Implement Timeout (Hard)

**Goal**: Add a timeout to API calls with proper error handling.

**Steps**:
1. Modify `UserApiService.fetchUsers()` to support timeout
2. Create a specific `TimeoutState` or error message
3. Handle timeout in BLoC
4. Display timeout-specific message in UI with retry option

**Hint**: Use `Future.timeout()` or `Future.any()`

**Learning Objective**: Advanced error handling patterns

---

## 🎯 Exercise 9: Add Favorites Feature (Hard)

**Goal**: Allow users to mark favorites and persist them.

**Steps**:
1. Create a `FavoritesBloc` to manage favorite user IDs
2. Add events: `AddFavoriteEvent`, `RemoveFavoriteEvent`
3. Add states to track favorites list
4. Add a favorite button to each user card
5. Filter view to show only favorites
6. (Bonus) Use shared_preferences to persist favorites

**Learning Objective**: Multiple BLoCs working together

---

## 🎯 Exercise 10: Add Pagination (Hard)

**Goal**: Implement pagination to load users in batches.

**Steps**:
1. Modify API service to accept `page` and `pageSize` parameters
2. Create mock data for multiple pages
3. Add `LoadMoreUsersEvent` to BLoC
4. Create `LoadingMoreState` that preserves existing data
5. Detect scroll to bottom and load more
6. Show loading indicator at bottom while loading more

**Hint**: Use `ScrollController` to detect bottom reached

**Learning Objective**: Advanced state management with accumulating data

---

## 🎯 Exercise 11: Add Sorting Options (Hard)

**Goal**: Allow users to sort the list by different criteria.

**Steps**:
1. Create `SortUsersEvent` with enum for sort type (name, email, id, role)
2. Implement sorting logic in BLoC
3. Add a sort button in app bar with dropdown menu
4. Persist current sort selection in state
5. Apply sort to newly loaded data automatically

**Learning Objective**: Complex state transformations

---

## 🎯 Exercise 12: Implement Optimistic Updates (Expert)

**Goal**: Show immediate UI updates before API confirmation.

**Steps**:
1. Add ability to edit user name
2. Create `UpdateUserEvent` with user ID and new name
3. Immediately update UI with new name (optimistic)
4. Call API to save changes
5. Revert on error or confirm on success
6. Show loading indicator during save

**Learning Objective**: Advanced UX patterns with BLoC

---

## 🏆 Bonus Challenges

### Challenge A: Add Offline Support
- Cache loaded users locally
- Load from cache if API fails
- Show indicator when viewing cached data

### Challenge B: Add Real-Time Updates
- Simulate periodic data updates from server
- Automatically refresh list when new data available
- Show notification of new users

### Challenge C: Create Dashboard
- Multiple widgets showing different data
- Each widget has its own BLoC
- Coordinate loading states across widgets

### Challenge D: Add Authentication Flow
- Create AuthBloc for login/logout
- Protect user list behind authentication
- Redirect to login if not authenticated

---

## 📝 Self-Assessment Checklist

After completing exercises, you should be able to:

**BLoC Pattern (Users)**
- [ ] Create events, states, and BLoCs from scratch
- [ ] Dispatch events from UI components
- [ ] Build UI based on different states
- [ ] Handle loading, success, and error states
- [ ] Use BlocProvider and BlocBuilder correctly

**Cubit Pattern (Posts)**
- [ ] Create Cubits with direct methods (no events)
- [ ] Call Cubit methods from UI
- [ ] Implement refresh patterns with Cubit
- [ ] Understand when to use Cubit vs BLoC

**Cubit with BlocConsumer (Todos)**
- [ ] Use BlocConsumer for side effects with Cubit
- [ ] Implement dual state emission pattern
- [ ] Show snackbars for user actions
- [ ] Handle CRUD operations with user feedback

**BLoC with BlocConsumer (Products)**
- [ ] Combine BLoC events with BlocConsumer
- [ ] Implement complex interactions with haptic feedback
- [ ] Work with multiple BLoCs in one app
- [ ] Implement side effects with listener
- [ ] Test BLoCs/Cubits in isolation
- [ ] Debug state transitions
- [ ] Apply best practices for BLoC architecture

---

## 🎯 Cubit Pattern Exercises (Post Feature)

### Exercise 13: Add Post Categories (Easy - Cubit)

**Goal**: Add category filtering to posts.

**Steps**:
1. Open `lib/features/post/domain/entities/post.dart`
2. Add a `category` field to Post entity
3. Update PostModel with the new field
4. Add `filterByCategory(String category)` method to PostCubit
5. Create a category dropdown in the UI

**Learning Objective**: Cubit methods with parameters

---

### Exercise 14: Implement Post Search (Medium - Cubit)

**Goal**: Add search functionality to posts.

**Steps**:
1. Add `searchPosts(String query)` method to PostCubit
2. Create PostSearchingState to show search results
3. Add search TextField in UI
4. Filter posts by title and body
5. Show "No results found" message

**Learning Objective**: State management with Cubit methods

---

### Exercise 15: Add Post Detail View (Medium - Cubit)

**Goal**: Create a detail screen for posts.

**Steps**:
1. Create `post_detail_screen.dart`
2. Create PostDetailCubit with `loadPostById(int id)` method
3. Show post details with formatted content
4. Add related posts section
5. Use BlocProvider for the detail screen

**Learning Objective**: Multiple Cubits in navigation

---

## 🎯 Cubit with BlocConsumer Exercises (Todo Feature)

### Exercise 16: Add Todo Priorities (Easy - BlocConsumer)

**Goal**: Add priority levels to todos.

**Steps**:
1. Add `priority` enum (Low, Medium, High) to Todo entity
2. Update TodoModel and data source
3. Show priority with colored badges
4. Add priority selector when adding todos
5. Show snackbar with priority when added

**Learning Objective**: Enhanced data with BlocConsumer feedback

---

### Exercise 17: Add Todo Categories (Medium - BlocConsumer)

**Goal**: Categorize todos (Work, Personal, Shopping).

**Steps**:
1. Add `category` field to Todo
2. Add `filterByCategory(String category)` to TodoCubit
3. Create category tabs in UI
4. Show category in snackbar messages
5. Emit TodoFiltered state with listenWhen

**Learning Objective**: Complex filtering with action states

---

### Exercise 18: Add Todo Due Dates (Hard - BlocConsumer)

**Goal**: Add due dates with notifications.

**Steps**:
1. Add `dueDate` field to Todo
2. Add date picker when creating todo
3. Emit TodoDueDateSet state with snackbar
4. Highlight overdue todos in red
5. Sort by due date
6. Show haptic feedback for overdue items

**Learning Objective**: Advanced BlocConsumer with complex states

---

## 🎯 BLoC with BlocConsumer Exercises (Product Feature)

### Exercise 19: Add Product Favorites (Easy - BlocConsumer)

**Goal**: Let users favorite products.

**Steps**:
1. Add `isFavorite` to Product entity
2. Create ToggleFavoriteEvent
3. Add ProductFavoritedState with timestamp
4. Show yellow heart icon for favorites
5. Emit snackbar: "Added to favorites!"
6. Add haptic feedback

**Learning Objective**: Additional actions with BlocConsumer

---

### Exercise 20: Add Cart Quantity (Medium - BlocConsumer)

**Goal**: Allow multiple quantities in cart.

**Steps**:
1. Add `quantity` to Product
2. Create IncrementCartEvent and DecrementCartEvent
3. Show quantity badge on products
4. Update ProductCartUpdatedState with quantity change
5. Show snackbar: "Quantity increased to 3"
6. Add strong haptic for max quantity

**Learning Objective**: Complex state with multiple fields

---

### Exercise 21: Add Checkout Flow (Hard - BlocConsumer)

**Goal**: Complete checkout with confirmation.

**Steps**:
1. Create CheckoutConfirmedState after CheckoutState
2. Navigate to checkout screen on CheckoutState
3. Show order summary
4. Add ConfirmOrderEvent
5. Emit ProductOrderCompletedState with timestamp
6. Show success snackbar and haptic
7. Clear cart and return to product list

**Learning Objective**: Multi-step flow with navigation and BlocConsumer

---

## 🏆 Advanced Cross-Feature Challenges

### Challenge E: Unified Search Across Features
- Search across Users, Posts, Todos, and Products
- Create SearchBloc with multiple repositories
- Show results grouped by feature
- Navigate to detail screens

### Challenge F: Shopping List from Todos
- Convert todos to shopping list
- Add products from product list to todos
- Sync cart items with todo completion
- Use multiple BlocConsumers

### Challenge G: User Activity Dashboard
- Show user's posts, todos, and cart
- Real-time updates across features
- Use StreamBuilder with multiple Cubits/BLoCs
- Coordinate state across features

### Challenge H: Export/Import Data
- Export users, posts, todos, products to JSON
- Import from JSON files
- Show progress with BlocConsumer
- Handle errors gracefully

---

## 🎓 Pattern Comparison Exercise

**Exercise 22: Implement Same Feature in All Four Patterns**

**Goal**: Understand the differences by implementing "Comments" feature in four ways:

1. **Comments with BLoC (like Users)**
   - Create CommentEvent, CommentState, CommentBloc
   - Use traditional event-driven approach
   
2. **Comments with Cubit (like Posts)**
   - Create CommentCubit with direct methods
   - No events needed
   
3. **Comments with Cubit + BlocConsumer (like Todos)**
   - Add/edit/delete comments with snackbars
   - Use action states for feedback
   
4. **Comments with BLoC + BlocConsumer (like Products)**
   - Like/unlike comments with haptic feedback
   - Complex interactions with events

**Learning Objective**: Master all four patterns by comparing implementations

---

## 🤔 Reflection Questions

1. Why is it important to separate business logic from UI?
2. What are the advantages of using sealed classes for states?
3. When would you use BlocListener vs BlocBuilder vs BlocConsumer?
4. How does BLoC make testing easier compared to setState?
5. What are the trade-offs of using BLoC vs other state management solutions?

---

## 📚 Next Steps

Once you've mastered these exercises:

1. **Read the official BLoC documentation**: https://bloclibrary.dev
2. **Explore advanced topics**: 
   - Bloc-to-Bloc communication
   - BLoC composition
   - Hydrated BLoC (state persistence)
3. **Build a real project**: Apply BLoC to a personal project
4. **Learn testing**: Write comprehensive tests for your BLoCs
5. **Explore alternatives**: Compare with Provider, Riverpod, GetX

---

## 💡 Tips for Success

- Start with easier exercises and progress gradually
- Test your code frequently as you make changes
- Use the debugger to understand state transitions
- Refer to the existing code as examples
- Don't hesitate to experiment and break things
- Read error messages carefully—they often point to the solution
- Keep the architecture diagram handy for reference

Happy coding! 🚀

---

##  Cubit Pattern Exercises

### Exercise C1: Add a Clear Button (Easy - Cubit)

**Goal**: Add a clear button to the Post List screen.

**Steps**:
1. Open lib/screens/post_list_screen.dart
2. Add a clear icon button to the AppBar actions
3. When clicked, call context.read<PostCubit>().clear()
4. Test that it resets to initial state

**Learning Objective**: Practice calling Cubit methods directly

---

### Exercise C2: Add Post Count Display (Easy - Cubit)

**Goal**: Show the total number of posts in the loaded state.

**Steps**:
1. Modify the success banner in _buildLoadedView
2. Display "Successfully loaded X posts" with actual count
3. Make it visually distinct

**Learning Objective**: Access state data in Cubit UI

---

### Exercise C3: Implement Search in Cubit (Medium)

**Goal**: Add search functionality using Cubit (no events!).

**Steps**:
1. Add a searchPosts(String query) method to PostCubit
2. Filter posts based on title or body
3. Add a search TextField in the UI
4. Call the search method as user types

**Compare** with Exercise 5 (BLoC search) to see the difference!

**Learning Objective**: Implement features with direct method calls

---

### Exercise C4: Add Favorites (Medium - Both Patterns)

**Goal**: Implement favorites in BOTH BLoC and Cubit to compare.

**BLoC Implementation**:
1. Create FavoritesBloc with AddFavorite and RemoveFavorite events
2. Add event handlers
3. Use BlocBuilder to show favorites

**Cubit Implementation**:
1. Create FavoritesCubit with addFavorite() and removeFavorite() methods
2. Call methods directly from UI
3. Use BlocBuilder (same as BLoC!)

**Learning Objective**: Compare code complexity between patterns

---

### Exercise C5: Convert BLoC to Cubit (Hard)

**Goal**: Convert the User/BLoC example to use Cubit pattern.

**Steps**:
1. Create UserCubit (copy from UserBloc)
2. Remove all events
3. Convert event handlers to public methods
4. Update UI to call methods instead of dispatching events
5. Compare line count: BLoC vs Cubit

**Learning Objective**: Understand the structural differences

---

### Exercise C6: Add Pagination with Cubit (Hard)

**Goal**: Implement pagination using Cubit's direct method approach.

**Steps**:
1. Add loadMore() method to PostCubit
2. Track current page number
3. Create LoadingMoreState
4. Detect scroll to bottom in UI
5. Call loadMore() method

**Learning Objective**: Handle pagination without events

---

##  BlocConsumer Pattern Exercises

### Exercise BC1: Add Remove from Cart (Easy)

**Goal**: Implement remove functionality for the Product demo.

**Steps**:
1. The event already exists: `RemoveFromCartEvent`
2. The state already exists: `ProductRemovedFromCartState`
3. Test removing items from cart
4. Verify snackbar shows "Product removed from cart"
5. Verify cart count decreases

**Learning Objective**: Understand dual emission pattern for repeated actions

---

### Exercise BC2: Customize Snackbar Duration (Easy)

**Goal**: Change snackbar display duration for different actions.

**Steps**:
1. Open `lib/screens/product_list_screen.dart`
2. Find the listener in BlocConsumer
3. Add `duration` parameter to SnackBar widgets
4. Use longer duration for errors (4s), shorter for success (2s)

**Learning Objective**: Control side effect behavior

---

### Exercise BC3: Add Haptic Feedback Patterns (Medium)

**Goal**: Use different haptic feedback for different actions.

**Steps**:
1. Import `package:flutter/services.dart`
2. In BlocConsumer listener:
   - Use `HapticFeedback.lightImpact()` for add
   - Use `HapticFeedback.mediumImpact()` for remove
   - Use `HapticFeedback.heavyImpact()` for checkout
3. Test on a physical device (emulators may not support)

**Learning Objective**: Enhance UX with tactile feedback

---

### Exercise BC4: Implement listenWhen Optimization (Medium)

**Goal**: Prevent unnecessary listener executions.

**Steps**:
1. The `listenWhen` is already implemented in the product demo
2. Experiment by removing `listenWhen` - observe listener fires for all states
3. Re-add `listenWhen` to filter only action states
4. Add logging to see when listener fires

**Hint**:
```dart
listenWhen: (previous, current) {
  print('Checking: $current');
  return current is ProductAddedToCartState ||
      current is ProductRemovedFromCartState;
}
```

**Learning Objective**: Optimize BlocConsumer performance

---

### Exercise BC5: Add Clear Cart Functionality (Medium)

**Goal**: Add a button to clear all items from cart.

**Steps**:
1. Create `ClearCartEvent` in `product_event.dart`
2. Add event handler `_onClearCart` in `product_bloc.dart`
3. Create `ProductCartClearedState` in `product_state.dart`
4. Implement dual emission: ClearedState → LoadedState
5. Add listener case to show confirmation snackbar
6. Add "Clear Cart" button in app bar

**Learning Objective**: Extend BlocConsumer with new actions

---

### Exercise BC6: Add buildWhen Optimization (Medium-Hard)

**Goal**: Prevent unnecessary UI rebuilds.

**Steps**:
1. Add `buildWhen` parameter to BlocConsumer
2. Configure to rebuild only for states that change UI:
   ```dart
   buildWhen: (previous, current) {
     return current is! ProductAddedToCartState &&
         current is! ProductRemovedFromCartState;
   }
   ```
3. Ensure action states are still handled in builder (they need same UI as LoadedState)
4. Test that snackbars still show (listener) but UI doesn't flicker

**Learning Objective**: Separate side effects from UI updates

---

### Exercise BC7: Navigate to Checkout Screen (Hard)

**Goal**: Create a checkout screen and navigate on CheckoutEvent.

**Steps**:
1. Create `lib/screens/checkout_screen.dart`
2. Pass cart items to checkout screen
3. In BlocConsumer listener, add navigation:
   ```dart
   if (state is ProductCheckoutState) {
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (_) => CheckoutScreen(itemCount: state.itemCount),
       ),
     );
   }
   ```
4. Show success dialog after navigation
5. Add "Back" button to return to products

**Learning Objective**: Navigation as a side effect

---

### Exercise BC8: Add Undo with Snackbar Action (Hard)

**Goal**: Show snackbar with "Undo" button when removing from cart.

**Steps**:
1. In listener for `ProductRemovedFromCartState`:
   ```dart
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text('${state.productName} removed'),
       action: SnackBarAction(
         label: 'UNDO',
         onPressed: () {
           context.read<ProductBloc>().add(
             AddToCartEvent(
               productId: state.productId, // Add this to state
               productName: state.productName,
             ),
           );
         },
       ),
     ),
   );
   ```
2. Add `productId` to `ProductRemovedFromCartState`
3. Test undo functionality

**Learning Objective**: Advanced snackbar interactions

---

### Exercise BC9: Compare BLoC vs BlocConsumer (Expert)

**Goal**: Refactor User demo to use BlocConsumer instead of BlocBuilder.

**Steps**:
1. Create a copy of `user_list_screen.dart` as `user_list_consumer_screen.dart`
2. Replace `BlocBuilder` with `BlocConsumer`
3. Move error snackbar logic to listener
4. Keep UI rendering in builder
5. Compare code clarity and separation of concerns

**Questions to answer**:
- When is BlocConsumer overkill?
- When is it beneficial?
- How does it affect testability?

**Learning Objective**: Know when to use each widget

---

### Exercise BC10: Advanced - Debounced Add to Cart (Expert)

**Goal**: Prevent rapid clicking by debouncing add/remove events.

**Steps**:
1. In `ProductBloc`, add event transformer:
   ```dart
   on<AddToCartEvent>(
     _onAddToCart,
     transformer: debounce(Duration(milliseconds: 300)),
   );
   ```
2. Implement debounce transformer helper
3. Test that rapid clicks are throttled
4. Show loading state during debounce

**Learning Objective**: Event transformations with BLoC

---

##  Pattern Comparison Challenge

### Challenge: Implement the Same Feature in All 3 Patterns

**Feature**: Add a "Favorite" button to each item (User, Post, Product)

**Requirements**:
1. **BLoC Pattern** (User):
   - Create `ToggleFavoriteEvent`
   - Update `User` model with `isFavorite` field
   - Emit updated `UserLoadedState`
   
2. **Cubit Pattern** (Post):
   - Add `toggleFavorite(int postId)` method
   - Update `Post` model with `isFavorite` field
   - Emit updated `PostLoadedState`
   
3. **BlocConsumer Pattern** (Product):
   - Create `ToggleFavoriteEvent`
   - Create `ProductFavoritedState` action state
   - Show snackbar when favorited
   - Update product list

**Compare**:
- Lines of code for each pattern
- Complexity of implementation
- UX differences (Product has snackbar feedback)
- Which felt most natural?

---

## 📝 Self-Assessment Checklist

After completing exercises, you should be able to:

- [ ] Create events, states, and BLoCs from scratch
- [ ] Dispatch events from UI components
- [ ] Build UI based on different states
- [ ] Handle loading, success, and error states
- [ ] Use BlocProvider and BlocBuilder correctly
- [ ] Work with multiple BLoCs in one app
- [ ] Implement side effects with BlocListener
- [ ] **Combine builder and listener with BlocConsumer**
- [ ] **Understand dual state emission pattern**
- [ ] **Optimize with listenWhen and buildWhen**
- [ ] **Implement shopping cart workflows**
- [ ] Call Cubit methods directly (no events)
- [ ] Use switch expressions for state handling
- [ ] Test BLoCs and Cubits in isolation
- [ ] Debug state transitions
- [ ] Apply best practices for all three patterns
- [ ] **Choose the right pattern for the use case**

---

## 🤔 Reflection Questions

1. Why is it important to separate business logic from UI?
2. What are the advantages of using sealed classes for states?
3. When would you use BlocListener vs BlocBuilder vs BlocConsumer?
4. How does BLoC make testing easier compared to setState?
5. What are the trade-offs of using BLoC vs other state management solutions?
6. **When would you choose Cubit over BLoC?**
7. **Why does the dual emission pattern work for repeated actions?**
8. **What is the purpose of listenWhen vs buildWhen?**
9. **How does BlocConsumer improve code organization for features with side effects?**
10. **What are the performance implications of each pattern?**

---

## 📚 Next Steps

Once you've mastered these exercises:

1. **Read the official BLoC documentation**: https://bloclibrary.dev
2. **Explore advanced topics**: 
   - Bloc-to-Bloc communication
   - Event transformations (debounce, throttle)
   - Hydrated BLoC (state persistence)
   - **BlocObserver for global logging**
   - **Replay BLoC for undo/redo**
3. **Build a real project**: Apply all three patterns appropriately
4. **Learn testing**: Write comprehensive tests for BLoCs and Cubits
5. **Explore alternatives**: Compare with Provider, Riverpod, GetX
6. **Study the tutorial docs**:
   - `BLOC_CONSUMER_TUTORIAL.md` for deep dive
   - `CUBIT_GUIDE.md` for pattern comparison
   - `ARCHITECTURE.md` for flow diagrams

---

## 💡 Tips for Success

- Start with easier exercises and progress gradually
- Test your code frequently as you make changes
- Use the debugger to understand state transitions
- Refer to the existing code as examples
- Don't hesitate to experiment and break things
- Read error messages carefully—they often point to the solution
- Keep the architecture diagram handy for reference
- **Compare all three patterns side-by-side to understand trade-offs**
- **Use BlocConsumer for features with side effects**
- **Use Cubit for simple CRUD operations**
- **Use BLoC for complex event-driven logic**

Happy coding! 🚀
4. Detect scroll to bottom
5. Load and append more posts

**Learning Objective**: Advanced state management with Cubit

---

##  Pattern Comparison Challenges

### Challenge PC1: Same Feature, Both Patterns
Implement the same feature (e.g., filtering) in both BLoC and Cubit:
- Measure lines of code
- Compare complexity
- Note developer experience differences

### Challenge PC2: When Would You Choose Each?
For each scenario, decide BLoC or Cubit and explain why:
1. Simple todo list app
2. E-commerce app with complex checkout flow
3. News reader with categories and filters
4. Social media app with real-time updates
5. Weather app with location services

---
