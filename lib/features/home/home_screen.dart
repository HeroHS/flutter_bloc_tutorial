import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../user/presentation/screens/user_list_screen.dart';
import '../user/presentation/bloc/user_bloc.dart';
import '../user/domain/usecases/get_users.dart';
import '../user/domain/usecases/get_users_with_error.dart';
import '../user/data/repositories/user_repository_impl.dart';
import '../user/data/datasources/user_remote_datasource.dart';
import '../post/presentation/screens/post_list_screen.dart';
import '../post/presentation/cubit/post_cubit.dart';
import '../post/domain/usecases/get_posts.dart';
import '../post/domain/usecases/get_posts_with_error.dart';
import '../post/data/repositories/post_repository_impl.dart';
import '../post/data/datasources/post_remote_datasource.dart';
import '../product/presentation/screens/product_list_screen.dart';
import '../product/presentation/bloc/product_bloc.dart';
import '../product/domain/usecases/get_products.dart';
import '../product/data/repositories/product_repository_impl.dart';
import '../product/data/datasources/product_remote_datasource.dart';
import '../todo/presentation/screens/todo_list_screen.dart';
import '../todo/presentation/cubit/todo_cubit.dart';
import '../todo/domain/usecases/get_todos.dart';
import '../todo/domain/usecases/get_todo_by_id.dart';
import '../todo/domain/usecases/add_todo.dart';
import '../todo/domain/usecases/toggle_todo.dart';
import '../todo/domain/usecases/delete_todo.dart';
import '../todo/data/repositories/todo_repository_impl.dart';
import '../todo/data/datasources/todo_remote_datasource.dart';

/// Home Screen - Navigation hub for all features
///
/// CLEAN ARCHITECTURE APP STRUCTURE:
/// This screen serves as the entry point to explore different features,
/// each demonstrating Clean Architecture principles with different state management patterns.
///
/// FEATURES:
/// 1. User Management (BLoC Pattern)
/// 2. Post Management (Cubit Pattern)
/// 3. Todo Management (Cubit Pattern with BlocConsumer)
/// 4. Product Management (BLoC Pattern with BlocConsumer)
///
/// DEPENDENCY INJECTION:
/// Each feature creates its dependencies here before navigation.
/// In production apps, use dependency injection containers (get_it, injectable).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture Tutorial'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildFeatureListCard(
                    context,
                    title: 'Posts',
                    subtitle: 'Cubit Pattern',
                    icon: Icons.article,
                    color: Colors.brown,
                    onTap: () => _navigateToPosts(context),
                    badge: 'Methods',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureListCard(
                    context,
                    title: 'Users',
                    subtitle: 'BLoC Pattern',
                    icon: Icons.people,
                    color: Colors.blue,
                    onTap: () => _navigateToUsers(context),
                    badge: 'Events',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureListCard(
                    context,
                    title: 'Todos',
                    subtitle: 'Cubit with BlocConsumer',
                    icon: Icons.checklist,
                    color: Colors.purple,
                    onTap: () => _navigateToTodos(context),
                    badge: 'Methods',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureListCard(
                    context,
                    title: 'Products',
                    subtitle: 'BLoC with BlocConsumer',
                    icon: Icons.shopping_cart,
                    color: Colors.orange,
                    onTap: () => _navigateToProducts(context),
                    badge: 'Events',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildArchitectureInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.school, size: 48, color: Colors.indigo.shade700),
            const SizedBox(height: 12),
            Text(
              'Welcome to Clean Architecture',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore BLoC and Cubit patterns with Clean Architecture',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureListCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String badge,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArchitectureInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Architecture Layers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Presentation → Domain ← Data',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Navigate to User screen with BLoC dependency injection
  ///
  /// DEPENDENCY INJECTION PATTERN:
  /// 1. Create data source
  /// 2. Create repository with data source
  /// 3. Create use cases with repository
  /// 4. Create BLoC with use cases
  /// 5. Provide BLoC to screen
  void _navigateToUsers(BuildContext context) {
    final dataSource = UserRemoteDataSourceImpl();
    final repository = UserRepositoryImpl(remoteDataSource: dataSource);
    final getUsersUseCase = GetUsers(repository);
    final getUsersWithErrorUseCase = GetUsersWithError(repository);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UserBloc(
            getUsersUseCase: getUsersUseCase,
            getUsersWithErrorUseCase: getUsersWithErrorUseCase,
          ),
          child: const UserListScreen(),
        ),
      ),
    );
  }

  /// Navigate to Post screen with Cubit dependency injection
  void _navigateToPosts(BuildContext context) {
    final dataSource = PostRemoteDataSourceImpl();
    final repository = PostRepositoryImpl(remoteDataSource: dataSource);
    final getPostsUseCase = GetPosts(repository);
    final getPostsWithErrorUseCase = GetPostsWithError(repository);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => PostCubit(
            getPostsUseCase: getPostsUseCase,
            getPostsWithErrorUseCase: getPostsWithErrorUseCase,
          ),
          child: const PostListScreen(),
        ),
      ),
    );
  }

  /// Navigate to Todo screen with Cubit dependency injection
  ///
  /// DEMONSTRATES BLOCCONSUMER PATTERN:
  /// - Shows how to listen to state changes for SnackBars
  /// - Prevents user interaction during processing
  /// - Specific states for add/toggle/delete operations
  void _navigateToTodos(BuildContext context) {
    final dataSource = TodoRemoteDataSourceImpl();
    final repository = TodoRepositoryImpl(remoteDataSource: dataSource);
    final getTodosUseCase = GetTodos(repository);
    final getTodoByIdUseCase = GetTodoById(repository);
    final addTodoUseCase = AddTodo(repository);
    final toggleTodoUseCase = ToggleTodo(repository);
    final deleteTodoUseCase = DeleteTodo(repository);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TodoCubit(
            getTodosUseCase: getTodosUseCase,
            getTodoByIdUseCase: getTodoByIdUseCase,
            addTodoUseCase: addTodoUseCase,
            toggleTodoUseCase: toggleTodoUseCase,
            deleteTodoUseCase: deleteTodoUseCase,
          ),
          child: const TodoListScreen(),
        ),
      ),
    );
  }

  /// Navigate to Product screen with BLoC dependency injection
  void _navigateToProducts(BuildContext context) {
    final dataSource = ProductRemoteDataSourceImpl();
    final repository = ProductRepositoryImpl(remoteDataSource: dataSource);
    final getProductsUseCase = GetProducts(repository);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              ProductBloc(getProductsUseCase: getProductsUseCase),
          child: const ProductListScreen(),
        ),
      ),
    );
  }
}
