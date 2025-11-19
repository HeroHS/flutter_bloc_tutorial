/*
 * ============================================================================
 * FLUTTER BLOC TUTORIAL - BEGINNER'S GUIDE
 * ============================================================================
 * 
 * This file provides a step-by-step explanation of how BLoC works in this app.
 * Follow along with the actual code files while reading this guide.
 * 
 * ============================================================================
 */

/*
 * ----------------------------------------------------------------------------
 * STEP 1: Understanding the User Model (lib/models/user.dart)
 * ----------------------------------------------------------------------------
 * 
 * The User model represents the data structure we get from our API.
 * 
 * Think of it as a blueprint for user data:
 * - id: Unique identifier for each user
 * - name: User's full name
 * - email: User's email address
 * - role: User's job role
 * 
 * Why we need this:
 * - Type safety: Dart knows what fields exist
 * - Easy to work with: Use user.name instead of user['name']
 * - Reusable: Can use this model across the entire app
 */

/*
 * ----------------------------------------------------------------------------
 * STEP 2: Understanding Events (lib/bloc/user_event.dart)
 * ----------------------------------------------------------------------------
 * 
 * Events are like "messages" that tell the BLoC what the user wants to do.
 * 
 * Think of events as buttons being pressed:
 * - LoadUsersEvent: "Hey BLoC, load the users for me!"
 * - LoadUsersWithErrorEvent: "Hey BLoC, try loading but simulate an error!"
 * - RetryLoadUsersEvent: "Hey BLoC, try loading again after that error!"
 * 
 * Flow:
 * User taps button → UI dispatches event → BLoC receives event → BLoC processes
 * 
 * Why sealed classes?
 * - Dart can check we handle ALL possible events
 * - Prevents bugs from forgetting to handle an event type
 * - Modern Dart feature for better type safety
 */

/*
 * ----------------------------------------------------------------------------
 * STEP 3: Understanding States (lib/bloc/user_state.dart)
 * ----------------------------------------------------------------------------
 * 
 * States represent the CURRENT CONDITION of the app.
 * 
 * Think of states as different "screens" or "modes":
 * - UserInitialState: App just started, nothing happened yet
 * - UserLoadingState: Currently loading data, show spinner
 * - UserLoadedState: Data loaded successfully, show the list
 * - UserErrorState: Something went wrong, show error message
 * 
 * State Flow Example:
 * Initial → (user clicks button) → Loading → (API responds) → Loaded
 *                                           ↘ (API fails) → Error
 * 
 * Why sealed classes?
 * - Same reason as events - exhaustive checking
 * - UI MUST handle every possible state
 * - No "oops I forgot to handle the error state"
 */

/*
 * ----------------------------------------------------------------------------
 * STEP 4: Understanding the API Service (lib/services/user_api_service.dart)
 * ----------------------------------------------------------------------------
 * 
 * The API service simulates talking to a real server.
 * 
 * In a real app:
 * - This would use http package to call REST APIs
 * - Would handle actual network requests
 * - Would parse JSON responses
 * 
 * In this tutorial:
 * - We use Future.delayed to simulate network delay
 * - We return hardcoded mock data
 * - We can simulate both success and failure
 * 
 * Why separate this from BLoC?
 * - BLoC focuses on business logic
 * - Service focuses on data fetching
 * - Easy to swap with real API later
 * - Easy to test each part separately
 */

/*
 * ----------------------------------------------------------------------------
 * STEP 5: Understanding the BLoC (lib/bloc/user_bloc.dart)
 * ----------------------------------------------------------------------------
 * 
 * The BLoC is the "brain" that:
 * 1. Receives events from the UI
 * 2. Processes them (calls API, handles logic)
 * 3. Emits states back to the UI
 * 
 * Think of BLoC as a translator:
 * UI says: "I want users" (event)
 *    ↓
 * BLoC: "Ok, let me get them..." (emits loading state)
 *    ↓
 * BLoC calls API service
 *    ↓
 * API returns data
 *    ↓
 * BLoC: "Here they are!" (emits loaded state with data)
 *    ↓
 * UI: "Thanks! I'll display them now"
 * 
 * Key Points:
 * - BLoC extends Bloc<Event, State>
 * - Event handlers are registered in the constructor
 * - Each handler receives event and emitter
 * - Use emitter to send states to UI
 * - Try-catch handles errors gracefully
 * 
 * Event Handler Pattern:
 * 1. Emit loading state (UI shows spinner)
 * 2. Try to fetch data
 * 3. On success: emit loaded state (UI shows data)
 * 4. On error: emit error state (UI shows error)
 */

/*
 * ----------------------------------------------------------------------------
 * STEP 6: Understanding BlocProvider (lib/main.dart)
 * ----------------------------------------------------------------------------
 * 
 * BlocProvider is like a "vending machine" for your BLoC.
 * 
 * What it does:
 * - Creates the BLoC instance
 * - Makes it available to all child widgets
 * - Automatically disposes it when no longer needed
 * 
 * Why we need it:
 * - Widgets deep in the tree can access the BLoC
 * - No need to pass BLoC through constructor parameters
 * - Automatic lifecycle management
 * 
 * Think of it like this:
 * BlocProvider (at top of app)
 *    ├── Screen A (can access BLoC)
 *    ├── Screen B (can access BLoC)
 *    └── Screen C
 *          └── Widget D (can access BLoC too!)
 */

/*
 * ----------------------------------------------------------------------------
 * STEP 7: Understanding BlocBuilder (lib/screens/user_list_screen.dart)
 * ----------------------------------------------------------------------------
 * 
 * BlocBuilder is like a "listener" that rebuilds UI when state changes.
 * 
 * How it works:
 * 1. Listens to the BLoC's state stream
 * 2. When state changes, calls builder function
 * 3. Builder returns different UI for different states
 * 4. Flutter rebuilds only that part of the screen
 * 
 * The Switch Pattern:
 * switch (state) {
 *   UserInitialState() => Show welcome screen
 *   UserLoadingState() => Show loading spinner
 *   UserLoadedState() => Show user list
 *   UserErrorState() => Show error message
 * }
 * 
 * Why this is powerful:
 * - UI automatically updates when state changes
 * - No manual setState() calls needed
 * - Code clearly shows what UI appears for each state
 * - Type-safe with sealed classes
 */

/*
 * ----------------------------------------------------------------------------
 * STEP 8: Understanding Event Dispatching
 * ----------------------------------------------------------------------------
 * 
 * How to send events to BLoC from UI:
 * 
 * context.read<UserBloc>().add(LoadUsersEvent());
 *        │        │        │          │
 *        │        │        │          └─ The event to send
 *        │        │        └─ Method to add event to BLoC
 *        │        └─ Which BLoC to use
 *        └─ Get BLoC from context
 * 
 * When button is pressed:
 * 1. User taps button
 * 2. onPressed callback runs
 * 3. We get BLoC from context
 * 4. We add event to BLoC
 * 5. BLoC's event handler processes it
 * 6. BLoC emits new state
 * 7. BlocBuilder rebuilds UI
 * 
 * All of this happens automatically!
 */

/*
 * ----------------------------------------------------------------------------
 * COMPLETE FLOW EXAMPLE: User Clicks "Load Users"
 * ----------------------------------------------------------------------------
 * 
 * 1. USER ACTION
 *    User taps "Load Users (Success)" button
 * 
 * 2. UI CODE RUNS
 *    onPressed: () {
 *      context.read<UserBloc>().add(LoadUsersEvent());
 *    }
 * 
 * 3. BLOC RECEIVES EVENT
 *    _onLoadUsers method is called
 * 
 * 4. BLOC EMITS LOADING STATE
 *    emit(UserLoadingState());
 * 
 * 5. UI REBUILDS (BlocBuilder reacts)
 *    Shows CircularProgressIndicator
 *    User sees: "Loading users..."
 * 
 * 6. BLOC CALLS API
 *    final users = await userApiService.fetchUsers();
 * 
 * 7. API SIMULATES DELAY
 *    await Future.delayed(Duration(seconds: 2));
 *    (User waits 2 seconds)
 * 
 * 8. API RETURNS DATA
 *    Returns list of 4 mock users
 * 
 * 9. BLOC EMITS SUCCESS STATE
 *    emit(UserLoadedState(users));
 * 
 * 10. UI REBUILDS AGAIN (BlocBuilder reacts)
 *     Shows ListView with user cards
 *     User sees: List of 4 users with all details
 * 
 * DONE! ✅
 */

/*
 * ----------------------------------------------------------------------------
 * BLOCONSUMER FLOW EXAMPLE: User Adds Product to Cart
 * ----------------------------------------------------------------------------
 * 
 * BlocConsumer = BlocBuilder + BlocListener combined!
 * 
 * 1. USER ACTION
 *    User taps "Add to Cart" button on a product
 * 
 * 2. UI DISPATCHES EVENT
 *    onPressed: () {
 *      context.read<ProductBloc>().add(
 *        AddToCartEvent(productId: product.id, productName: product.name)
 *      );
 *    }
 * 
 * 3. BLOC RECEIVES EVENT
 *    _onAddToCart method is called
 * 
 * 4. BLOC EXTRACTS CURRENT STATE DATA (Switch Expression)
 *    final (products, count) = switch (state) {
 *      ProductLoadedState() => (state.products, state.cartItemCount),
 *      ProductAddedToCartState() => (state.products, state.cartItemCount),
 *      _ => (<Product>[], 0),
 *    };
 * 
 * 5. BLOC UPDATES PRODUCTS
 *    Mark selected product as inCart = true
 * 
 * 6. BLOC EMITS ACTION STATE (Triggers Listener)
 *    emit(ProductAddedToCartState(
 *      products: updatedProducts,
 *      cartItemCount: count + 1,
 *      productName: product.name,
 *      timestamp: DateTime.now(),
 *    ));
 * 
 * 7. BLOCONSUMER LISTENER FIRES
 *    listener: (context, state) {
 *      if (state is ProductAddedToCartState) {
 *        // Side Effect 1: Show snackbar
 *        ScaffoldMessenger.of(context).showSnackBar(...);
 *        
 *        // Side Effect 2: Haptic feedback
 *        HapticFeedback.mediumImpact();
 *      }
 *    }
 *    User sees: Green snackbar "Product added to cart!"
 *    User feels: Phone vibrates
 * 
 * 8. BLOC EMITS LOADED STATE (Prepares for Next Action)
 *    emit(ProductLoadedState(
 *      products: updatedProducts,
 *      cartItemCount: count + 1,
 *    ));
 * 
 * 9. BLOCONSUMER BUILDER UPDATES
 *    builder: (context, state) {
 *      return switch (state) {
 *        ProductLoadedState() => ProductList(state.products),
 *        ProductAddedToCartState() => ProductList(state.products),
 *        ...
 *      };
 *    }
 *    User sees: Product icon changes to checkmark, cart badge updates
 * 
 * 10. READY FOR NEXT ACTION
 *     State is now ProductLoadedState, ready for next add/remove
 * 
 * DUAL EMISSION PATTERN EXPLAINED:
 * - Problem: Listener only fires when state TYPE changes
 * - Solution: Emit action state → then emit base state
 * - Result: Can add to cart multiple times, each shows snackbar!
 * 
 * LoadedState → AddedState → LoadedState → AddedState → LoadedState
 *                  ↑ fires!                   ↑ fires again!
 */

/*
 * ----------------------------------------------------------------------------
 * ERROR FLOW EXAMPLE: User Clicks "Load Users (Error)"
 * ----------------------------------------------------------------------------
 * 
 * 1. USER ACTION
 *    User taps "Load Users (Error)" button
 * 
 * 2. UI DISPATCHES EVENT
 *    context.read<UserBloc>().add(LoadUsersWithErrorEvent());
 * 
 * 3. BLOC EMITS LOADING STATE
 *    emit(UserLoadingState());
 *    UI shows spinner
 * 
 * 4. BLOC CALLS API (error version)
 *    await userApiService.fetchUsersWithError();
 * 
 * 5. API THROWS EXCEPTION
 *    throw Exception('Failed to load users...');
 * 
 * 6. BLOC CATCHES EXCEPTION
 *    catch (error) block runs
 * 
 * 7. BLOC EMITS ERROR STATE
 *    emit(UserErrorState(error.toString()));
 * 
 * 8. UI REBUILDS WITH ERROR VIEW
 *    Shows red error icon
 *    Shows error message
 *    Shows "Retry" button
 * 
 * 9. USER CLICKS RETRY
 *    Dispatches RetryLoadUsersEvent
 *    Whole process starts again!
 */

/*
 * ----------------------------------------------------------------------------
 * KEY CONCEPTS SUMMARY
 * ----------------------------------------------------------------------------
 * 
 * 1. SEPARATION OF CONCERNS
 *    - UI only displays and dispatches events
 *    - BLoC handles all business logic
 *    - Services handle data fetching
 *    - Models define data structure
 * 
 * 2. UNIDIRECTIONAL DATA FLOW
 *    UI → Event → BLoC → State → UI
 *    Data flows in ONE direction
 *    Makes code predictable and easy to debug
 * 
 * 3. STATE AS SINGLE SOURCE OF TRUTH
 *    Current state tells you EVERYTHING about the UI
 *    Want to know what's showing? Check the state
 *    No hidden variables or flags
 * 
 * 4. IMMUTABILITY
 *    States and events are immutable (can't change)
 *    Create new states instead of modifying existing ones
 *    Prevents bugs from unexpected mutations
 * 
 * 5. TESTABILITY
 *    BLoC can be tested without UI
 *    Just send events, check emitted states
 *    No need to render widgets in tests
 */

/*
 * ----------------------------------------------------------------------------
 * THREE PATTERNS COMPARISON (Ordered by Complexity: Simple → Complex)
 * ----------------------------------------------------------------------------
 * 
 * This tutorial demonstrates THREE state management patterns!
 * Start with Cubit (simplest), then BLoC, then BlocConsumer (most advanced).
 * 
 * ===== 1. CUBIT PATTERN (Post Demo) - ⭐ SIMPLEST =====
 * Complexity: LOW | Learning Curve: EASIEST | Files: 2
 * 
 * Use when: Simple CRUD, prototyping, straightforward flows
 * 
 * Flow:
 * UI → Call Method → Cubit → Process → Emit State → UI Rebuilds
 * 
 * Example:
 * context.read<PostCubit>().loadPosts();
 * 
 * Files: cubit.dart, state.dart (2 files)
 * Code: ~350 lines
 * Benefits: 40% LESS CODE than BLoC, no events to manage
 * 
 * 
 * ===== 2. BLOC PATTERN (User Demo) - ⭐⭐ INTERMEDIATE =====
 * Complexity: MEDIUM | Learning Curve: MODERATE | Files: 3
 * 
 * Use when: Need event tracking, complex logic, multiple events → same state
 * 
 * Flow:
 * UI → Dispatch Event → BLoC → Process → Emit State → UI Rebuilds
 * 
 * Example:
 * context.read<UserBloc>().add(LoadUsersEvent());
 * 
 * Files: bloc.dart, event.dart, state.dart (3 files)
 * Code: ~400 lines
 * Benefits: Event tracking, clear event-driven flow, testable
 * 
 * 
 * ===== 3. BLOCONSUMER PATTERN (Product Demo) - ⭐⭐⭐ ADVANCED =====
 * Complexity: HIGH | Learning Curve: STEEP | Files: 3
 * 
 * Use when: Shopping carts, forms, features needing rich user feedback
 * 
 * Flow:
 * UI → Dispatch Event → BLoC → Dual Emission:
 *   1. Action State → Listener (snackbar, haptics, navigation)
 *   2. Loaded State → Builder (UI updates)
 * 
 * Example:
 * context.read<ProductBloc>().add(AddToCartEvent(...));
 * 
 * Files: bloc.dart, event.dart, state.dart (3 files)
 * Code: ~750 lines (more features!)
 * Features: BlocBuilder + BlocListener combined, dual state emission
 * Benefits: Integrated side effects, best UX, professional feel
 * 
 * 
 * QUICK COMPARISON TABLE (Ordered by Complexity):
 * ┌────────────────┬──────────────┬──────────────┬──────────────────┐
 * │ Aspect         │ 1️⃣ Cubit    │ 2️⃣ BLoC     │ 3️⃣ BlocConsumer │
 * ├────────────────┼──────────────┼──────────────┼──────────────────┤
 * │ Complexity     │ ⭐ LOW       │ ⭐⭐ MEDIUM  │ ⭐⭐⭐ HIGH      │
 * │ Learning Curve │ Easiest      │ Moderate     │ Steep            │
 * │ Events         │ None ✅      │ Yes (3)      │ Yes (7)          │
 * │ States         │ 5 states     │ 4 states     │ 8 states         │
 * │ Methods        │ Public       │ Private      │ Private          │
 * │ Trigger        │ method()     │ .add()       │ .add()           │
 * │ Side Effects   │ Separate     │ Separate     │ Built-in ✅      │
 * │ Widget Used    │ BlocBuilder  │ BlocBuilder  │ BlocConsumer     │
 * │ Files Needed   │ 2            │ 3            │ 3                │
 * │ Lines of Code  │ ~350         │ ~400         │ ~750             │
 * │ Code vs BLoC   │ -12% (less)  │ Baseline     │ +88% (richer UX) │
 * │ Best For       │ Simple lists │ CRUD ops     │ Shopping carts   │
 * │ Example        │ Post feed    │ User mgmt    │ Add to cart      │
 * │ Feedback       │ Manual       │ Manual       │ Integrated ✅    │
 * │ Start Here?    │ ✅ YES!      │ After Cubit  │ Advanced users   │
 * └────────────────┴──────────────┴──────────────┴──────────────────┘
 * 
 * 📚 LEARNING PATH:
 * Week 1: Master Cubit (Post demo) - Understand state management basics
 * Week 2: Learn BLoC (User demo) - Add event-driven architecture
 * Week 3: Explore BlocConsumer (Product demo) - Integrate side effects
 * 
 * TIP: Run the app and try demos in order: Cubit → BLoC → BlocConsumer
 */

/*
 * ----------------------------------------------------------------------------
 * COMMON MISTAKES TO AVOID
 * ----------------------------------------------------------------------------
 * 
 * ❌ DON'T: Put business logic in widgets
 *    class MyWidget extends StatelessWidget {
 *      void loadData() {
 *        // Calling API here is BAD!
 *      }
 *    }
 * 
 * ✅ DO: Put business logic in BLoC
 *    Event handler calls API
 *    Widget just dispatches event
 * 
 * ❌ DON'T: Modify state objects
 *    state.users.add(newUser); // NO!
 * 
 * ✅ DO: Create new state objects
 *    emit(UserLoadedState([...oldUsers, newUser]));
 * 
 * ❌ DON'T: Access BLoC directly in StatelessWidget
 *    final bloc = UserBloc(); // Creates new instance
 * 
 * ✅ DO: Get BLoC from context
 *    context.read<UserBloc>() // Uses provided instance
 * 
 * ❌ DON'T: Forget to handle all states
 *    if (state is LoadedState) { ... }
 *    // What if it's ErrorState? App crashes!
 * 
 * ✅ DO: Use switch for exhaustive checking
 *    switch (state) { ... } // Must handle all cases
 */

/*
 * ----------------------------------------------------------------------------
 * WHAT TO EXPLORE NEXT
 * ----------------------------------------------------------------------------
 * 
 * 1. Run the App and Try All Three Demos
 *    - "BLoC Pattern" (Users) - Event-driven architecture
 *    - "Cubit Pattern" (Posts) - Direct method calls
 *    - "BlocConsumer Demo" (Products) - Shopping cart with feedback
 * 
 * 2. Read the Documentation in Order
 *    a) README.md - Project overview
 *    b) ARCHITECTURE.md - Flow diagrams for all 3 patterns
 *    c) CUBIT_GUIDE.md - BLoC vs Cubit deep dive
 *    d) BLOC_CONSUMER_TUTORIAL.md - Complete BlocConsumer guide
 *    e) BLOC_CONSUMER_DEMO.md - Implementation walkthrough
 *    f) QUICK_REFERENCE.md - Code patterns and snippets
 * 
 * 3. Try the Exercises
 *    - EXERCISES.md has 12 BLoC + 6 Cubit + 10 BlocConsumer exercises
 *    - Start with easy ones (Exercise 1-3)
 *    - Progress to pattern comparison challenges
 *    - Compare code complexity across patterns
 * 
 * 4. Experiment with the Code
 *    - Add new events/methods to existing BLoCs/Cubits
 *    - Create new states for different scenarios
 *    - Modify the UI to show different information
 *    - Try breaking things to understand error handling
 * 
 * 5. Study the Implementation Files
 *    Key files to examine:
 *    - lib/bloc/user_bloc.dart - Event registration pattern
 *    - lib/cubit/post_cubit.dart - Direct method approach
 *    - lib/bloc/product_bloc.dart - Dual emission pattern, switch expressions
 *    - lib/screens/user_list_screen.dart - BlocBuilder usage
 *    - lib/screens/post_list_screen.dart - Cubit with BlocBuilder
 *    - lib/screens/product_list_screen.dart - BlocConsumer with listenWhen
 * 
 * 6. Compare Pattern Trade-offs
 *    - Count lines of code for the same feature across patterns
 *    - Notice how events add boilerplate but improve traceability
 *    - See how BlocConsumer integrates side effects elegantly
 *    - Understand when each pattern shines
 * 
 * 7. Build Your Own Feature
 *    Try implementing:
 *    - A favorites system using BLoC pattern
 *    - A search feature using Cubit pattern
 *    - A like/unlike button using BlocConsumer pattern
 * 
 * 8. Learn Testing
 *    - Check QUICK_REFERENCE.md for testing examples
 *    - Write tests for BLoCs and Cubits
 *    - Mock services for unit tests
 *    - Test state transitions
 * 
 * 9. Explore Advanced Topics
 *    - Bloc-to-Bloc communication
 *    - Event transformations (debounce, throttle)
 *    - Hydrated BLoC for persistence
 *    - BlocObserver for logging
 * 
 * 10. Compare with Other Solutions
 *     After mastering BLoC, Cubit, and BlocConsumer, explore:
 *     - Provider
 *     - Riverpod
 *     - GetX
 *     - Redux
 *     
 *     You'll appreciate BLoC's structure and patterns!
 */

/*
 *    - Change the delay time
 *    - Add more users to mock data
 *    - Try different error messages
 * 
 * 3. Add new features
 *    - Search functionality
 *    - Sorting options
 *    - User detail screen
 * 
 * 4. Learn advanced BLoC topics
 *    - BlocListener for side effects
 *    - BlocConsumer (builder + listener)
 *    - Multiple BLoCs in one screen
 *    - Bloc-to-Bloc communication
 * 
 * 5. Explore testing
 *    - Write unit tests for BLoC
 *    - Use bloc_test package
 *    - Mock API service
 * 
 * 6. Build a real app
 *    - Apply these concepts to a personal project
 *    - Use real APIs
 *    - Add local storage
 */

/*
 * ============================================================================
 * CONGRATULATIONS!
 * ============================================================================
 * 
 * You now understand how BLoC pattern works!
 * 
 * Key Takeaways:
 * - Events = What users want to do
 * - States = Current condition of UI
 * - BLoC = Processing center
 * - BlocProvider = Makes BLoC available
 * - BlocBuilder = Rebuilds UI on state change
 * 
 * The pattern: UI → Event → BLoC → State → UI
 * 
 * Keep practicing and building!
 * ============================================================================
 */

/*
 * ============================================================================
 * CUBIT PATTERN EXPLANATION
 * ============================================================================
 */

/*
 * ----------------------------------------------------------------------------
 * KEY DIFFERENCE: Cubit vs BLoC
 * ----------------------------------------------------------------------------
 * 
 * BLoC Pattern (User example):
 * UI  Dispatch Event  BLoC receives event  Processes  Emits State  UI rebuilds
 * 
 * Cubit Pattern (Post example):
 * UI  Call Method  Cubit processes  Emits State  UI rebuilds
 * 
 * NO EVENTS IN CUBIT! You call methods directly!
 */

/*
 * ----------------------------------------------------------------------------
 * CUBIT STEP 1: Understanding PostCubit (lib/cubit/post_cubit.dart)
 * ----------------------------------------------------------------------------
 * 
 * Cubit is simpler than BLoC:
 * - No events file needed
 * - No event handlers to register
 * - Just public methods that emit states
 * 
 * Example methods in PostCubit:
 * - loadPosts() - Load posts from API
 * - loadPostsWithError() - Simulate error
 * - retry() - Retry after error
 * - refreshPosts() - Advanced refresh pattern
 * - clear() - Reset to initial
 * 
 * Key Point: These are just regular async methods!
 */

/*
 * ----------------------------------------------------------------------------
 * CUBIT STEP 2: No Events Needed!
 * ----------------------------------------------------------------------------
 * 
 * In BLoC, you have user_event.dart with:
 * - LoadUsersEvent
 * - LoadUsersWithErrorEvent
 * - RetryLoadUsersEvent
 * 
 * In Cubit, you have... NOTHING! No events file!
 * 
 * Why? Because you call methods directly:
 * 
 * BLoC way:
 * context.read<UserBloc>().add(LoadUsersEvent());
 * 
 * Cubit way:
 * context.read<PostCubit>().loadPosts();
 * 
 * Cubit is more like normal OOP - just call the method!
 */

/*
 * ----------------------------------------------------------------------------
 * CUBIT STEP 3: Same States Pattern
 * ----------------------------------------------------------------------------
 * 
 * States work the same way in Cubit!
 * 
 * PostState (sealed class):
 * - PostInitialState: Starting state
 * - PostLoadingState: Loading data
 * - PostLoadedState: Data loaded (has posts list)
 * - PostRefreshingState: Refreshing while showing old data (ADVANCED!)
 * - PostErrorState: Error occurred (has error message)
 * 
 * The difference: In Cubit, methods emit these states directly
 * In BLoC, event handlers emit these states
 */

/*
 * ----------------------------------------------------------------------------
 * CUBIT EXAMPLE: Loading Posts
 * ----------------------------------------------------------------------------
 * 
 * 1. USER ACTION
 *    User taps "Load Posts" button
 * 
 * 2. UI CALLS METHOD DIRECTLY
 *    onPressed: () {
 *      context.read<PostCubit>().loadPosts();
 *    }
 * 
 * 3. CUBIT METHOD RUNS
 *    Future<void> loadPosts() async {
 *      emit(PostLoadingState());  // Show loading
 *      ...
 *    }
 * 
 * 4. UI REBUILDS (BlocBuilder)
 *    Shows CircularProgressIndicator
 * 
 * 5. API CALL
 *    final posts = await postApiService.fetchPosts();
 *    (waits 2 seconds)
 * 
 * 6. CUBIT EMITS SUCCESS
 *    emit(PostLoadedState(posts));
 * 
 * 7. UI REBUILDS AGAIN
 *    Shows ListView with posts
 * 
 * DONE! 
 * 
 * Notice: No events, just method calls!
 */

/*
 * ----------------------------------------------------------------------------
 * ADVANCED: Optimistic Refresh Pattern
 * ----------------------------------------------------------------------------
 * 
 * PostCubit has a special refreshPosts() method that demonstrates
 * an advanced pattern:
 * 
 * Normal Refresh:
 * Loaded  Loading (blank screen!)  Loaded
 * 
 * Optimistic Refresh (Better UX):
 * Loaded  Refreshing (keep showing old data!)  Loaded (new data)
 * 
 * How it works:
 * 
 * 1. User pulls to refresh
 * 2. Check if we have data:
 *    if (state is PostLoadedState) {
 *      emit(PostRefreshingState(currentPosts)); // Keep showing!
 *    }
 * 3. Call API for new data
 * 4. On success: emit(PostLoadedState(newPosts))
 * 5. On error: emit(PostLoadedState(oldPosts)) // Restore!
 * 
 * This is why Cubit has PostRefreshingState!
 */

/*
 * ----------------------------------------------------------------------------
 * WHEN TO USE BLoC VS CUBIT?
 * ----------------------------------------------------------------------------
 * 
 * Use BLoC (User example) when:
 *  You need event tracking/logging
 *  Multiple events can trigger same state
 *  Complex business logic
 *  Event transformations (debounce, throttle)
 *  Large team prefers strict architecture
 * 
 * Use Cubit (Post example) when:
 *  Simple state management
 *  Straightforward operations
 *  Want less boilerplate (~40% less code!)
 *  Direct method calls feel natural
 *  Prototyping or MVP
 * 
 * Both are good! Choose based on your needs.
 */

/*
 * ----------------------------------------------------------------------------
 * COMPARING BLOC AND CUBIT SIDE BY SIDE
 * ----------------------------------------------------------------------------
 * 
 * Same Feature: Loading Data
 * 
 * === BLOC WAY (User) ===
 * 
 * Files needed:
 * 1. user_event.dart (define events)
 * 2. user_state.dart (define states)
 * 3. user_bloc.dart (event handlers)
 * 
 * Steps:
 * 1. Create event: final class LoadUsersEvent extends UserEvent {}
 * 2. Dispatch: context.read<UserBloc>().add(LoadUsersEvent())
 * 3. Register: on<LoadUsersEvent>(_onLoadUsers)
 * 4. Handle: Future<void> _onLoadUsers(...) { emit(...) }
 * 
 * === CUBIT WAY (Post) ===
 * 
 * Files needed:
 * 1. post_state.dart (define states)
 * 2. post_cubit.dart (methods)
 * 
 * Steps:
 * 1. No event needed!
 * 2. Call method: context.read<PostCubit>().loadPosts()
 * 3. No registration needed!
 * 4. Method: Future<void> loadPosts() { emit(...) }
 * 
 * Result: Cubit needs 1 less file and fewer steps!
 */

/*
 * ============================================================================
 * TRY BOTH PATTERNS IN THE APP!
 * ============================================================================
 * 
 * This app lets you try both:
 * 
 * Home Screen  Choose:
 * - BLoC Pattern (Blue) - Event-driven with User list
 * - Cubit Pattern (Purple) - Direct methods with Post list
 * 
 * Compare them yourself:
 * - Which feels more natural to you?
 * - Which is easier to understand?
 * - Which has less code?
 * - Which fits your project better?
 * 
 * There''s no wrong choice - both are excellent!
 * ============================================================================
 */
