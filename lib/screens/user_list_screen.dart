import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../models/user.dart';

/// Main screen that displays the list of users
///
/// This screen demonstrates how to:
/// - Use BlocBuilder to rebuild UI based on state changes
/// - Display different UI for different states (loading, success, error)
/// - Dispatch events to the BLoC
class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Tutorial - User List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'Tutorial Info',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tutorial instruction banner
          _buildInstructionBanner(),

          // Main content area with BlocBuilder
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                // Switch on state type to determine what to display
                return switch (state) {
                  UserInitialState() => _buildInitialView(context),
                  UserLoadingState() => _buildLoadingView(),
                  UserLoadedState() => _buildLoadedView(state.users),
                  UserErrorState() => _buildErrorView(
                    context,
                    state.errorMessage,
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the instruction banner at the top
  Widget _buildInstructionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'BLoC Pattern Tutorial',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'This app demonstrates state management using BLoC pattern. '
            'Press the buttons below to see different states!',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Initial view - shown when app first loads
  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 100, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            const Text(
              'Welcome to BLoC Tutorial!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Press a button below to start loading users.\n'
              'Watch how the UI updates based on state changes.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// Loading view - shown while data is being fetched
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          const Text(
            'Loading users...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Text(
            'Simulating API call with 2 second delay',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Loaded view - shown when data is successfully fetched
  Widget _buildLoadedView(List<User> users) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                'Successfully loaded ${users.length} users',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(user.email),
                      const SizedBox(height: 2),
                      Text(
                        user.role,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      'ID: ${user.id}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Error view - shown when an error occurs
  Widget _buildErrorView(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: Colors.red.shade400),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                errorMessage,
                style: TextStyle(fontSize: 16, color: Colors.red.shade900),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Dispatch RetryLoadUsersEvent to the BLoC
                context.read<UserBloc>().add(RetryLoadUsersEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the action buttons for loading users
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Dispatch LoadUsersEvent to the BLoC
              context.read<UserBloc>().add(LoadUsersEvent());
            },
            icon: const Icon(Icons.download),
            label: const Text('Load Users (Success)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Dispatch LoadUsersWithErrorEvent to the BLoC
              context.read<UserBloc>().add(LoadUsersWithErrorEvent());
            },
            icon: const Icon(Icons.warning),
            label: const Text('Load Users (Error)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  /// Shows a dialog with tutorial information
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('BLoC Pattern Tutorial'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoSection(
                'What is BLoC?',
                'BLoC (Business Logic Component) is a state management pattern '
                    'that separates business logic from UI, making code more testable '
                    'and maintainable.',
              ),
              _buildInfoSection(
                'Key Concepts:',
                '• Events: Actions from the UI (e.g., LoadUsersEvent)\n'
                    '• States: UI conditions (Loading, Loaded, Error)\n'
                    '• BLoC: Processes events and emits states',
              ),
              _buildInfoSection(
                'This Demo Shows:',
                '• Loading state with progress indicator\n'
                    '• Success state with user list\n'
                    '• Error state with retry button\n'
                    '• Simulated API calls using Future.delayed',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
