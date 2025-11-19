import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

/// Entry point of the application
///
/// This tutorial now includes TWO state management patterns:
/// 1. BLoC Pattern - Uses events and states (User example)
/// 2. Cubit Pattern - Direct method calls, no events (Post example)
void main() {
  runApp(const MyApp());
}

/// Root widget of the application
///
/// Now shows a home screen where you can choose between:
/// - BLoC Tutorial (User List)
/// - Cubit Tutorial (Post List)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC & Cubit Tutorial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
