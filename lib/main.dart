import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';

/// Entry point of the application
///
/// FLUTTER BLOC CLEAN ARCHITECTURE TUTORIAL
///
/// This application demonstrates FOUR features with different patterns:
/// ┌────────────────────────────┬─────────────────────────────────────┐
/// │ Feature & Pattern          │ Location                            │
/// ├────────────────────────────┼─────────────────────────────────────┤
/// │ Posts (Cubit)              │ lib/features/post/                  │
/// │ Users (BLoC)               │ lib/features/user/                  │
/// │ Todos (Cubit + Consumer)   │ lib/features/todo/                  │
/// │ Products (BLoC + Consumer) │ lib/features/product/               │
/// └────────────────────────────┴─────────────────────────────────────┘
///
/// CLEAN ARCHITECTURE LAYERS (applied to all features):
///
/// 1. PRESENTATION LAYER (UI + State Management)
///    - BLoC/Cubit: State management logic
///    - Screens: UI widgets
///    - Depends on: Domain Layer only
///
/// 2. DOMAIN LAYER (Business Logic)
///    - Entities: Core business objects (User, Post, Product)
///    - Use Cases: Business operations (GetUsers, GetPosts)
///    - Repository Interfaces: Data contracts
///    - Depends on: Nothing! (Pure Dart)
///
/// 3. DATA LAYER (Data Access)
///    - Data Sources: API/Database access
///    - Models: Data transfer objects with JSON serialization
///    - Repository Implementations: Concrete data access
///    - Depends on: Domain Layer interfaces
///
/// DEPENDENCY FLOW:
/// Presentation → Domain ← Data
///     (UI)      (Logic)   (API)
///
/// BENEFITS:
/// ✓ Testable: Mock any layer independently
/// ✓ Maintainable: Changes isolated to specific layers
/// ✓ Scalable: Easy to add new features
/// ✓ Independent: UI, Business Logic, and Data are decoupled
///
/// LEARNING PATH:
/// 1. Start with BLoC example (User) - Understand event-driven pattern
/// 2. Compare with Cubit example (Post) - See simplified approach
/// 3. Study the architecture - Understand layer separation
void main() {
  runApp(const MyApp());
}

/// Root widget of the application
///
/// DEPENDENCY INJECTION:
/// - In production, use dependency injection (get_it, injectable)
/// - BLoC/Cubit instances are provided at appropriate levels
/// - See individual feature screens for BlocProvider usage
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture + BLoC Tutorial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const HomeScreen(),
    );
  }
}
