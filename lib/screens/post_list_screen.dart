import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/post_cubit.dart';
import '../cubit/post_state.dart';
import '../models/post.dart';

/// Main screen that displays the list of posts using Cubit
///
/// CUBIT DIFFERENCES FROM BLOC:
/// - No events! Call methods directly: cubit.loadPosts()
/// - Same BlocBuilder and BlocProvider
/// - Simpler, less boilerplate
/// - Perfect for straightforward state management
class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubit Tutorial - Post List'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          // Refresh button - directly calls cubit method!
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // No event needed - just call the method!
              context.read<PostCubit>().refreshPosts();
            },
            tooltip: 'Refresh Posts',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'Cubit Info',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tutorial instruction banner
          _buildInstructionBanner(),

          // Main content area with BlocBuilder
          // Same as BLoC - BlocBuilder works with both!
          Expanded(
            child: BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                // Switch on state type to determine what to display
                return switch (state) {
                  PostInitialState() => _buildInitialView(context),
                  PostLoadingState() => _buildLoadingView(),
                  PostLoadedState() => _buildLoadedView(state.posts, false),
                  PostRefreshingState() => _buildLoadedView(
                    state.currentPosts,
                    true,
                  ),
                  PostErrorState() => _buildErrorView(
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
      color: Colors.purple.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.purple.shade700),
              const SizedBox(width: 8),
              Text(
                'Cubit Pattern Tutorial',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Cubit is simpler than BLoC - no events needed! '
            'Just call methods directly on the Cubit.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Initial view - shown when app first loads
  Widget _buildInitialView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(Icons.article_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Cubit Tutorial!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Cubit is a simpler alternative to BLoC.\n'
              'No events - just call methods directly!\n\n'
              'Press a button below to start.',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 20),
            _buildComparisonCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Comparison card showing Cubit vs BLoC
  Widget _buildComparisonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cubit vs BLoC',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
          const SizedBox(height: 12),
          _buildComparisonRow(
            'BLoC:',
            'context.read<UserBloc>().add(LoadEvent())',
          ),
          const SizedBox(height: 8),
          _buildComparisonRow(
            'Cubit:',
            'context.read<PostCubit>().loadPosts()',
            isHighlight: true,
          ),
          const SizedBox(height: 12),
          Text(
            '✓ Simpler  ✓ Less code  ✓ Direct method calls',
            style: TextStyle(
              fontSize: 12,
              color: Colors.purple.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String label,
    String code, {
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isHighlight
                  ? Colors.purple.shade100
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: isHighlight ? Colors.purple.shade900 : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Loading view - shown while data is being fetched
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.purple),
          const SizedBox(height: 24),
          const Text(
            'Loading posts...',
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
  Widget _buildLoadedView(List<Post> posts, bool isRefreshing) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(
                isRefreshing ? Icons.refresh : Icons.check_circle,
                color: Colors.green.shade700,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isRefreshing
                      ? 'Refreshing posts...'
                      : 'Successfully loaded ${posts.length} posts',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isRefreshing)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green.shade700,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Another example of calling Cubit method directly!
              // Note: We need to get the cubit from context
              // But RefreshIndicator needs a BuildContext
              // So we'll handle this in the calling widget
            },
            child: ListView.builder(
              itemCount: posts.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      _showPostDetail(context, post);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  post.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '#${post.id}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.purple.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.body,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post.author,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  'MMM d, y',
                                ).format(post.publishedDate),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
                // Directly call retry method on Cubit - no event needed!
                context.read<PostCubit>().retry();
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

  /// Builds the action buttons for loading posts
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // CUBIT: Direct method call - no event!
              context.read<PostCubit>().loadPosts();
            },
            icon: const Icon(Icons.download),
            label: const Text('Load Posts (Success)'),
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
              // CUBIT: Another direct method call!
              context.read<PostCubit>().loadPostsWithError();
            },
            icon: const Icon(Icons.warning),
            label: const Text('Load Posts (Error)'),
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

  void _showPostDetail(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(post.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                post.body,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 8),
                  Text(post.author),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(DateFormat('MMMM d, y').format(post.publishedDate)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.purple),
            SizedBox(width: 8),
            Text('Cubit Pattern Tutorial'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoSection(
                'What is Cubit?',
                'Cubit is a lightweight subset of BLoC. It manages state '
                    'without events - you call methods directly on the Cubit!',
              ),
              _buildInfoSection(
                'Key Differences from BLoC:',
                '• No Events: Call cubit.loadPosts() directly\n'
                    '• Less Boilerplate: Fewer files and classes\n'
                    '• Simpler: Easier to learn and understand\n'
                    '• Same Power: Still reactive and testable',
              ),
              _buildInfoSection(
                'When to Use Cubit:',
                '• Simple state management\n'
                    '• Direct UI interactions\n'
                    '• Less complex business logic\n'
                    '• When you want simplicity',
              ),
              _buildInfoSection(
                'This Demo Shows:',
                '• Direct method calls (no events)\n'
                    '• Same state pattern as BLoC\n'
                    '• Simulated API with Future.delayed\n'
                    '• Error handling and retry\n'
                    '• Refresh with loading overlay',
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
