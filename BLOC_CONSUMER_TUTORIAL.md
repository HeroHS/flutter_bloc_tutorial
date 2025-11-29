# 🎯 BlocConsumer Tutorial - Complete Guide (Todo & Product Examples)

This tutorial covers BlocConsumer with two implementations:
- **Todos** - Cubit with BlocConsumer (simpler CRUD operations)
- **Products** - BLoC with BlocConsumer (complex shopping cart with events)

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is BlocConsumer?](#what-is-blocconsumer)
3. [When to Use BlocConsumer](#when-to-use-blocconsumer)
4. [Cubit vs BLoC with BlocConsumer](#cubit-vs-bloc-with-blocconsumer)
5. [BlocBuilder vs BlocListener vs BlocConsumer](#comparison)
6. [Basic Usage](#basic-usage)
7. [Real-World Examples](#real-world-examples)
8. [Advanced Patterns](#advanced-patterns)
9. [Best Practices](#best-practices)
10. [Common Mistakes](#common-mistakes)
11. [Exercises](#exercises)

---

## 🎓 Introduction

**BlocConsumer** is a powerful widget that combines the functionality of **BlocBuilder** and **BlocListener** into a single widget. It allows you to:
- **Rebuild UI** based on state changes (like BlocBuilder)
- **Perform side effects** in response to state changes (like BlocListener)

Think of it as the "best of both worlds" widget!

---

## 🤔 What is BlocConsumer?

### The Problem It Solves

Often you need to:
1. **Update the UI** when state changes (e.g., show a list of items)
2. **Show side effects** when state changes (e.g., show a snackbar for errors)

**Before BlocConsumer**, you had to nest widgets:

```dart
// ❌ Verbose - nesting BlocBuilder and BlocListener
BlocListener<UserBloc, UserState>(
  listener: (context, state) {
    if (state is UserErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage)),
      );
    }
  },
  child: BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      return switch (state) {
        UserLoadingState() => CircularProgressIndicator(),
        UserLoadedState() => UserList(users: state.users),
        _ => Container(),
      };
    },
  ),
)
```

**With BlocConsumer**, it's cleaner:

```dart
// ✅ Clean - single widget does both!
BlocConsumer<UserBloc, UserState>(
  listener: (context, state) {
    // Handle side effects
    if (state is UserErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage)),
      );
    }
  },
  builder: (context, state) {
    // Build UI
    return switch (state) {
      UserLoadingState() => CircularProgressIndicator(),
      UserLoadedState() => UserList(users: state.users),
      _ => Container(),
    };
  },
)
```

### How It Works

```
State Change
     ↓
BlocConsumer
     ↓
     ├──→ listener: (context, state) { }  ← Executes FIRST (side effects)
     │
     └──→ builder: (context, state) { }   ← Executes SECOND (UI rebuild)
```

**Important**: The `listener` **always executes before** the `builder`!

---

## 🎯 When to Use BlocConsumer

### ✅ Use BlocConsumer When:

1. **You need BOTH UI updates AND side effects**
   ```dart
   // Show loading spinner + navigate on success
   BlocConsumer<LoginBloc, LoginState>(
     listener: (context, state) {
       if (state is LoginSuccessState) {
         Navigator.pushReplacement(context, HomeScreen());
       }
     },
     builder: (context, state) => LoginForm(isLoading: state is LoginLoadingState),
   )
   ```

2. **Showing notifications/dialogs/snackbars while updating UI**
   ```dart
   // Show error snackbar + update UI
   BlocConsumer<CartBloc, CartState>(
     listener: (context, state) {
       if (state is CartErrorState) {
         showSnackBar(state.message);
       }
     },
     builder: (context, state) => CartWidget(state),
   )
   ```

3. **Navigation based on state + UI changes**
   ```dart
   // Navigate on completion + show progress
   BlocConsumer<CheckoutBloc, CheckoutState>(
     listener: (context, state) {
       if (state is CheckoutCompleteState) {
         Navigator.push(context, OrderConfirmationScreen());
       }
     },
     builder: (context, state) => CheckoutProgress(state),
   )
   ```

### ❌ DON'T Use BlocConsumer When:

1. **You only need UI updates** → Use `BlocBuilder`
2. **You only need side effects** → Use `BlocListener`
3. **You're nesting multiple consumers** → Consider refactoring

---

## 🔍 Comparison: BlocBuilder vs BlocListener vs BlocConsumer {#comparison}

| Feature | BlocBuilder | BlocListener | BlocConsumer |
|---------|-------------|--------------|--------------|
| **Purpose** | Rebuild UI | Side effects | Both |
| **Has `builder`** | ✅ Yes | ❌ No | ✅ Yes |
| **Has `listener`** | ❌ No | ✅ Yes | ✅ Yes |
| **Returns Widget** | ✅ Yes | ✅ Yes (child) | ✅ Yes |
| **Use Case** | Display data | Show snackbars, navigate | Both together |
| **Performance** | Rebuilds on state | Doesn't rebuild | Rebuilds on state |

### Visual Comparison

```dart
// 1️⃣ BlocBuilder - UI updates only
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('Count: ${state.count}');
  },
)

// 2️⃣ BlocListener - Side effects only
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state.count == 10) {
      showDialog(context, 'You reached 10!');
    }
  },
  child: MyWidget(), // This widget doesn't rebuild
)

// 3️⃣ BlocConsumer - Both!
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    // Side effect
    if (state.count == 10) {
      showDialog(context, 'You reached 10!');
    }
  },
  builder: (context, state) {
    // UI update
    return Text('Count: ${state.count}');
  },
)
```

---

## 🚀 Basic Usage

### Complete Example: User Login

Let's build a login screen that:
- Shows a loading spinner while logging in
- Navigates to home on success (side effect)
- Shows error snackbar on failure (side effect)
- Updates UI based on state

#### Step 1: Define States

```dart
// login_state.dart
sealed class LoginState {}

final class LoginInitialState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {
  final String username;
  LoginSuccessState(this.username);
}

final class LoginErrorState extends LoginState {
  final String errorMessage;
  LoginErrorState(this.errorMessage);
}
```

#### Step 2: Define Events

```dart
// login_event.dart
sealed class LoginEvent {}

final class LoginSubmittedEvent extends LoginEvent {
  final String username;
  final String password;
  LoginSubmittedEvent(this.username, this.password);
}

final class LoginResetEvent extends LoginEvent {}
```

#### Step 3: Create BLoC

```dart
// login_bloc.dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LoginResetEvent>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());
    
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      // Simulate validation
      if (event.username == 'admin' && event.password == 'password') {
        emit(LoginSuccessState(event.username));
      } else {
        emit(LoginErrorState('Invalid username or password'));
      }
    } catch (e) {
      emit(LoginErrorState('Network error: $e'));
    }
  }

  void _onLoginReset(LoginResetEvent event, Emitter<LoginState> emit) {
    emit(LoginInitialState());
  }
}
```

#### Step 4: Build UI with BlocConsumer

```dart
// login_screen.dart
class LoginScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          // 🎯 LISTENER: Side effects (navigation, snackbars)
          listener: (context, state) {
            // Handle successful login
            if (state is LoginSuccessState) {
              // Navigate to home screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen(username: state.username)),
              );
            }
            
            // Handle errors
            if (state is LoginErrorState) {
              // Show error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<LoginBloc>().add(LoginResetEvent());
                    },
                  ),
                ),
              );
            }
          },
          
          // 🎨 BUILDER: UI updates
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Username field
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    enabled: state is! LoginLoadingState,
                  ),
                  SizedBox(height: 16),
                  
                  // Password field
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    enabled: state is! LoginLoadingState,
                  ),
                  SizedBox(height: 24),
                  
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state is LoginLoadingState
                          ? null
                          : () {
                              context.read<LoginBloc>().add(
                                LoginSubmittedEvent(
                                  _usernameController.text,
                                  _passwordController.text,
                                ),
                              );
                            },
                      child: state is LoginLoadingState
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Login'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### What Happens?

```
User clicks "Login"
     ↓
Dispatch LoginSubmittedEvent
     ↓
BLoC emits LoginLoadingState
     ↓
BlocConsumer receives state
     ↓
listener: executes (no side effects for loading)
     ↓
builder: rebuilds → shows loading spinner
     ↓
API call completes
     ↓
BLoC emits LoginSuccessState
     ↓
BlocConsumer receives state
     ↓
listener: executes → NAVIGATES to HomeScreen
     ↓
builder: rebuilds (but navigation already happened)
```

---

## 🌟 Real-World Examples

### Example 1: Shopping Cart

**Requirements:**
- Show cart items (UI update)
- Show snackbar when item added (side effect)
- Navigate to checkout on success (side effect)

```dart
BlocConsumer<CartBloc, CartState>(
  listener: (context, state) {
    // Side effect: Show snackbar when item added
    if (state is CartItemAddedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${state.itemName} added to cart'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    
    // Side effect: Navigate to checkout
    if (state is CartCheckoutReadyState) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CheckoutScreen()),
      );
    }
    
    // Side effect: Show error dialog
    if (state is CartErrorState) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(state.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  },
  builder: (context, state) {
    // UI: Show cart contents
    return switch (state) {
      CartLoadingState() => Center(child: CircularProgressIndicator()),
      CartLoadedState() => CartItemsList(items: state.items, total: state.total),
      CartEmptyState() => EmptyCartMessage(),
      _ => Container(),
    };
  },
)
```

### Example 2: Form Submission

**Requirements:**
- Show validation errors in UI
- Show success message (snackbar)
- Clear form on success (side effect)

```dart
class FormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormBloc, FormState>(
      listener: (context, state) {
        // Side effect: Show success message
        if (state is FormSubmitSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Form submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Side effect: Clear form
          _nameController.clear();
          _emailController.clear();
          _formKey.currentState?.reset();
        }
        
        // Side effect: Show error
        if (state is FormSubmitErrorState) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Submission Failed'),
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              // Name field with validation errors from state
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: state is FormValidationErrorState 
                      ? state.nameError 
                      : null,
                ),
              ),
              
              // Email field with validation errors
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: state is FormValidationErrorState 
                      ? state.emailError 
                      : null,
                ),
              ),
              
              // Submit button
              ElevatedButton(
                onPressed: state is FormSubmittingState
                    ? null
                    : () {
                        context.read<FormBloc>().add(
                          FormSubmitEvent(
                            name: _nameController.text,
                            email: _emailController.text,
                          ),
                        );
                      },
                child: state is FormSubmittingState
                    ? CircularProgressIndicator()
                    : Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Example 3: File Upload with Progress

**Requirements:**
- Show upload progress (UI update)
- Show completion dialog (side effect)
- Vibrate on success (side effect)

```dart
BlocConsumer<UploadBloc, UploadState>(
  listener: (context, state) {
    // Side effect: Show completion dialog
    if (state is UploadCompleteState) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Upload Complete'),
          content: Text('File uploaded successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<UploadBloc>().add(UploadResetEvent());
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      
      // Side effect: Vibrate
      HapticFeedback.mediumImpact();
    }
    
    // Side effect: Show error with retry
    if (state is UploadErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              context.read<UploadBloc>().add(UploadRetryEvent());
            },
          ),
        ),
      );
    }
  },
  builder: (context, state) {
    return Column(
      children: [
        // Show progress indicator
        if (state is UploadProgressState)
          Column(
            children: [
              LinearProgressIndicator(value: state.progress),
              SizedBox(height: 8),
              Text('${(state.progress * 100).toInt()}%'),
            ],
          ),
        
        // Show upload button
        if (state is UploadInitialState || state is UploadErrorState)
          ElevatedButton(
            onPressed: () {
              context.read<UploadBloc>().add(UploadStartEvent());
            },
            child: Text('Upload File'),
          ),
        
        // Show completion message
        if (state is UploadCompleteState)
          Icon(Icons.check_circle, color: Colors.green, size: 64),
      ],
    );
  },
)
```

---

## 🎨 Advanced Patterns

### Pattern 1: Conditional Listening with `listenWhen`

Sometimes you don't want the listener to run on EVERY state change. Use `listenWhen`:

```dart
BlocConsumer<UserBloc, UserState>(
  // Only trigger listener when state actually changes
  listenWhen: (previous, current) {
    // Only listen when transitioning from loading to error
    return previous is UserLoadingState && current is UserErrorState;
  },
  listener: (context, state) {
    if (state is UserErrorState) {
      // This only runs when listenWhen returns true
      showSnackBar(state.errorMessage);
    }
  },
  builder: (context, state) {
    return UserWidget(state);
  },
)
```

### Pattern 2: Conditional Building with `buildWhen`

Similarly, control when the UI rebuilds:

```dart
BlocConsumer<CounterBloc, CounterState>(
  // Only rebuild when count changes
  buildWhen: (previous, current) {
    return previous.count != current.count;
  },
  listener: (context, state) {
    // Always listen for errors
    if (state.hasError) {
      showSnackBar(state.errorMessage);
    }
  },
  builder: (context, state) {
    // This only rebuilds when buildWhen returns true
    return Text('Count: ${state.count}');
  },
)
```

### Pattern 3: Combining Both Conditions

```dart
BlocConsumer<TodoBloc, TodoState>(
  // Listen only for specific state transitions
  listenWhen: (previous, current) {
    // Listen when todo is added or deleted
    return (previous is TodoLoadedState && current is TodoLoadedState) &&
           (previous.todos.length != current.todos.length);
  },
  // Rebuild only when data changes
  buildWhen: (previous, current) {
    // Don't rebuild for error states (handled by listener)
    return current is! TodoErrorState;
  },
  listener: (context, state) {
    if (state is TodoLoadedState) {
      final message = state.todos.length > (previous as TodoLoadedState).todos.length
          ? 'Todo added!'
          : 'Todo deleted!';
      showSnackBar(message);
    }
    
    if (state is TodoErrorState) {
      showErrorDialog(state.errorMessage);
    }
  },
  builder: (context, state) {
    return switch (state) {
      TodoLoadingState() => CircularProgressIndicator(),
      TodoLoadedState() => TodoList(todos: state.todos),
      _ => Container(),
    };
  },
)
```

### Pattern 4: Multiple State Handling

```dart
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    // Handle multiple state types
    switch (state) {
      case AuthenticatedState():
        // Navigate to home
        Navigator.pushReplacementNamed(context, '/home');
        
      case UnauthenticatedState():
        // Navigate to login
        Navigator.pushReplacementNamed(context, '/login');
        
      case AuthErrorState():
        // Show error
        showErrorSnackBar(state.message);
        
      case AuthSessionExpiredState():
        // Show specific message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Session Expired'),
            content: Text('Please login again'),
          ),
        );
        
      default:
        // Do nothing for other states
        break;
    }
  },
  builder: (context, state) {
    return switch (state) {
      AuthLoadingState() => LoadingScreen(),
      AuthenticatedState() => HomeScreen(user: state.user),
      UnauthenticatedState() => LoginScreen(),
      AuthErrorState() => ErrorScreen(message: state.message),
      _ => SplashScreen(),
    };
  },
)
```

---

## ✅ Best Practices

### 1. Keep Listener Logic Simple

```dart
// ❌ BAD: Complex logic in listener
listener: (context, state) {
  if (state is UserLoadedState) {
    final users = state.users;
    final filteredUsers = users.where((u) => u.age > 18).toList();
    final sortedUsers = filteredUsers..sort((a, b) => a.name.compareTo(b.name));
    // ... more logic
  }
},

// ✅ GOOD: Simple side effects only
listener: (context, state) {
  if (state is UserLoadedState) {
    showSnackBar('Users loaded successfully');
  }
},
```

### 2. Use `listenWhen` and `buildWhen` for Performance

```dart
// ❌ BAD: Rebuilds and listens on every state
BlocConsumer<TimerBloc, TimerState>(
  listener: (context, state) {
    // This runs every second!
    print('State changed');
  },
  builder: (context, state) {
    return Text('Time: ${state.seconds}');
  },
)

// ✅ GOOD: Control when to rebuild/listen
BlocConsumer<TimerBloc, TimerState>(
  listenWhen: (previous, current) => current.seconds == 60,
  buildWhen: (previous, current) => current.seconds % 5 == 0,
  listener: (context, state) {
    // Only when 1 minute passes
    showSnackBar('1 minute passed!');
  },
  builder: (context, state) {
    // Only rebuilds every 5 seconds
    return Text('Time: ${state.seconds}');
  },
)
```

### 3. One BlocConsumer Per Concern

```dart
// ❌ BAD: Handling multiple concerns in one consumer
BlocConsumer<AppBloc, AppState>(
  listener: (context, state) {
    // Too many responsibilities!
    if (state.hasAuthError) { /* ... */ }
    if (state.hasNetworkError) { /* ... */ }
    if (state.hasDataUpdate) { /* ... */ }
  },
  builder: (context, state) { /* ... */ },
)

// ✅ GOOD: Separate consumers for separate concerns
Column(
  children: [
    // Auth handling
    BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) { /* handle auth */ },
      builder: (context, state) { /* auth UI */ },
    ),
    // Network handling
    BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) { /* handle network */ },
      child: Container(),
    ),
  ],
)
```

### 4. Avoid State Comparisons in Listener

```dart
// ❌ BAD: Comparing states manually
listener: (context, state) {
  if (state is LoadedState && previous is LoadingState) {
    showSnackBar('Data loaded');
  }
},

// ✅ GOOD: Use listenWhen
listenWhen: (previous, current) {
  return previous is LoadingState && current is LoadedState;
},
listener: (context, state) {
  showSnackBar('Data loaded');
},
```

### 5. Don't Dispatch Events from Listener

```dart
// ❌ BAD: Creating infinite loops
listener: (context, state) {
  if (state is DataLoadedState) {
    // This can cause infinite loop!
    context.read<MyBloc>().add(LoadMoreDataEvent());
  }
},

// ✅ GOOD: Dispatch from user actions or use separate BLoC
ElevatedButton(
  onPressed: () {
    context.read<MyBloc>().add(LoadMoreDataEvent());
  },
  child: Text('Load More'),
)
```

---

## ⚠️ Common Mistakes

### Mistake 1: Using BlocConsumer When Not Needed

```dart
// ❌ BAD: No side effects, use BlocBuilder instead
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    // Empty listener!
  },
  builder: (context, state) {
    return Text('Count: ${state.count}');
  },
)

// ✅ GOOD: Use BlocBuilder
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('Count: ${state.count}');
  },
)
```

### Mistake 2: Building Widgets in Listener

```dart
// ❌ BAD: Don't build widgets in listener
listener: (context, state) {
  if (state is LoadedState) {
    return Container(); // This does nothing!
  }
},

// ✅ GOOD: Build in builder
builder: (context, state) {
  if (state is LoadedState) {
    return Container();
  }
  return SizedBox.shrink();
},
```

### Mistake 3: Not Handling All States

```dart
// ❌ BAD: Missing error state
BlocConsumer<DataBloc, DataState>(
  listener: (context, state) {
    if (state is DataLoadedState) {
      showSnackBar('Success');
    }
    // What about errors?
  },
  builder: (context, state) {
    // What about initial and loading states?
    return DataList(state.data);
  },
)

// ✅ GOOD: Handle all states
BlocConsumer<DataBloc, DataState>(
  listener: (context, state) {
    if (state is DataLoadedState) {
      showSnackBar('Success');
    } else if (state is DataErrorState) {
      showErrorDialog(state.message);
    }
  },
  builder: (context, state) {
    return switch (state) {
      DataInitialState() => WelcomeMessage(),
      DataLoadingState() => CircularProgressIndicator(),
      DataLoadedState() => DataList(state.data),
      DataErrorState() => ErrorWidget(state.message),
    };
  },
)
```

### Mistake 4: Forgetting Context

```dart
// ❌ BAD: Using wrong context
BlocConsumer<MyBloc, MyState>(
  listener: (context, state) {
    // context here is from BlocConsumer, not from Builder
    showDialog(
      context: context,
      builder: (dialogContext) {
        // ❌ This won't have access to MyBloc!
        context.read<MyBloc>().add(SomeEvent());
      },
    );
  },
  builder: (context, state) { /* ... */ },
)

// ✅ GOOD: Pass the right context
BlocConsumer<MyBloc, MyState>(
  listener: (blocContext, state) {
    showDialog(
      context: blocContext,
      builder: (dialogContext) {
        // ✅ Use blocContext, not dialogContext
        blocContext.read<MyBloc>().add(SomeEvent());
      },
    );
  },
  builder: (context, state) { /* ... */ },
)
```

---

## 💪 Exercises

### Exercise 1: Basic BlocConsumer (Easy)

**Task:** Create a counter app that:
- Shows the count (UI)
- Shows a snackbar when count reaches 10 (side effect)

<details>
<summary>Show Solution</summary>

```dart
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state.count == 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You reached 10!')),
      );
    }
  },
  builder: (context, state) {
    return Column(
      children: [
        Text('Count: ${state.count}', style: TextStyle(fontSize: 48)),
        ElevatedButton(
          onPressed: () => context.read<CounterBloc>().add(IncrementEvent()),
          child: Text('Increment'),
        ),
      ],
    );
  },
)
```

</details>

### Exercise 2: Form with Validation (Medium)

**Task:** Create a registration form that:
- Shows validation errors in UI
- Shows success snackbar and navigates on success
- Shows error dialog on failure

<details>
<summary>Show Solution</summary>

```dart
BlocConsumer<RegistrationBloc, RegistrationState>(
  listener: (context, state) {
    if (state is RegistrationSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pushReplacement(context, HomeScreen());
    }
    
    if (state is RegistrationErrorState) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text(state.message),
        ),
      );
    }
  },
  builder: (context, state) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: state is RegistrationValidationState 
                  ? state.emailError 
                  : null,
            ),
          ),
          ElevatedButton(
            onPressed: state is RegistrationLoadingState ? null : () {
              context.read<RegistrationBloc>().add(SubmitRegistrationEvent());
            },
            child: state is RegistrationLoadingState
                ? CircularProgressIndicator()
                : Text('Register'),
          ),
        ],
      ),
    );
  },
)
```

</details>

### Exercise 3: Optimized Consumer (Hard)

**Task:** Create a search screen that:
- Only rebuilds when search results change
- Only shows snackbar when search completes (not while typing)
- Debounces user input

<details>
<summary>Show Solution</summary>

```dart
BlocConsumer<SearchBloc, SearchState>(
  buildWhen: (previous, current) {
    // Only rebuild when results actually change
    return previous.results != current.results;
  },
  listenWhen: (previous, current) {
    // Only listen when transitioning from loading to loaded
    return previous is SearchLoadingState && 
           current is SearchLoadedState;
  },
  listener: (context, state) {
    if (state is SearchLoadedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Found ${state.results.length} results')),
      );
    }
  },
  builder: (context, state) {
    return Column(
      children: [
        TextField(
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
        ),
        if (state is SearchLoadingState)
          CircularProgressIndicator(),
        if (state is SearchLoadedState)
          SearchResultsList(results: state.results),
      ],
    );
  },
)
```

</details>

### Exercise 4: Multi-State Consumer (Expert)

**Task:** Create a payment screen that:
- Shows different UI for each payment state
- Navigates on success
- Shows retry dialog on failure
- Vibrates on completion
- Shows loading with progress percentage

<details>
<summary>Show Solution</summary>

```dart
BlocConsumer<PaymentBloc, PaymentState>(
  listener: (context, state) {
    switch (state) {
      case PaymentSuccessState():
        // Vibrate
        HapticFeedback.heavyImpact();
        
        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OrderConfirmationScreen()),
          );
        });
        
      case PaymentErrorState():
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Payment Failed'),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<PaymentBloc>().add(RetryPaymentEvent());
                },
                child: Text('Retry'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        );
        
      default:
        break;
    }
  },
  builder: (context, state) {
    return switch (state) {
      PaymentInitialState() => PaymentForm(),
      PaymentProcessingState() => Column(
          children: [
            CircularProgressIndicator(),
            Text('Processing payment...'),
            if (state.progress != null)
              LinearProgressIndicator(value: state.progress),
          ],
        ),
      PaymentSuccessState() => Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 100,
        ),
      PaymentErrorState() => ErrorMessage(state.message),
      _ => Container(),
    };
  },
)
```

</details>

---

## 🎯 Summary

### Key Takeaways

1. **BlocConsumer = BlocBuilder + BlocListener**
2. **Listener executes BEFORE builder**
3. **Use for UI updates + side effects together**
4. **Optimize with `listenWhen` and `buildWhen`**
5. **Keep listener logic simple (navigation, snackbars, dialogs)**

### When to Use What?

| Widget | Use Case | Example |
|--------|----------|---------|
| **BlocBuilder** | Only UI updates | Display list of items |
| **BlocListener** | Only side effects | Show snackbar, navigate |
| **BlocConsumer** | Both UI + side effects | Login (show spinner + navigate) |

### Quick Reference

```dart
// Structure
BlocConsumer<MyBloc, MyState>(
  listenWhen: (previous, current) => ...,  // Optional: when to listen
  buildWhen: (previous, current) => ...,   // Optional: when to rebuild
  listener: (context, state) {
    // Side effects: navigation, snackbars, dialogs
  },
  builder: (context, state) {
    // UI: return widgets
  },
)
```

---

## 🚀 Next Steps

1. ✅ Complete all exercises above
2. ✅ Refactor existing BlocBuilder + BlocListener to BlocConsumer
3. ✅ Practice with real-world scenarios
4. ✅ Learn about `MultiBlocConsumer` for multiple BLoCs
5. ✅ Explore BLoC testing with `bloc_test` package

---

**Happy Coding! 🎉**

---

*Created with ❤️ for Flutter developers mastering BLoC pattern*
