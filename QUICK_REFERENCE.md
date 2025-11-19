# BLoC Quick Reference Guide

## 📋 Common Patterns & Snippets

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

### 8. Combined Builder and Listener

```dart
BlocConsumer<YourBloc, YourState>(
  listener: (context, state) {
    // Side effects (e.g., show snackbar)
    if (state is ErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
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
