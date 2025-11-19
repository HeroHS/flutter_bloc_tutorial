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
 * 1. Try the exercises in EXERCISES.md
 *    Start with easy ones, progress to harder
 * 
 * 2. Experiment with the code
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
