# BLoC Tutorial - Practice Exercises

Complete these exercises to deepen your understanding of the BLoC pattern!

## 🎯 Exercise 1: Add a Refresh Button (Easy)

**Goal**: Add a refresh button to the app bar that reloads the user list.

**Steps**:
1. Open `lib/screens/user_list_screen.dart`
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

## 🎯 Exercise 2: Add User Count Display (Easy)

**Goal**: Show the total number of users in the loaded state.

**Steps**:
1. Modify the success banner in `_buildLoadedView`
2. Display "Successfully loaded X users" where X is the actual count
3. Make the count more prominent with styling

**Learning Objective**: Access state data in UI components

---

## 🎯 Exercise 3: Customize Loading Message (Easy)

**Goal**: Change the loading delay and update the message.

**Steps**:
1. Open `lib/services/user_api_service.dart`
2. Change the delay from 2 seconds to 3 seconds
3. Update the loading message to reflect the new delay
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

- [ ] Create events, states, and BLoCs from scratch
- [ ] Dispatch events from UI components
- [ ] Build UI based on different states
- [ ] Handle loading, success, and error states
- [ ] Use BlocProvider and BlocBuilder correctly
- [ ] Work with multiple BLoCs in one app
- [ ] Implement side effects with BlocListener
- [ ] Test BLoCs in isolation
- [ ] Debug state transitions
- [ ] Apply best practices for BLoC architecture

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
