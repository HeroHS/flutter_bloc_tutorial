import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';

/// Todo List Screen using BlocConsumer
///
/// WHAT IS BLOCCONSUMER?
/// BlocConsumer combines BlocListener and BlocBuilder into a single widget.
/// It allows you to:
/// - LISTEN to state changes for side effects (SnackBars, Navigation, Dialogs)
/// - BUILD UI based on current state
///
/// BLOCCONSUMER = BLOCLISTENER + BLOCBUILDER
///
/// WHEN TO USE BLOCCONSUMER:
/// ✓ Need both UI updates AND side effects
/// ✓ Show SnackBars/Toasts on state changes
/// ✓ Navigate based on state changes
/// ✓ Show dialogs on errors
/// ✓ Trigger analytics events
///
/// PARAMETERS:
/// - listener: Called for side effects (SnackBars, navigation)
/// - builder: Called to build UI based on state
/// - listenWhen: Optional - control when listener is called
/// - buildWhen: Optional - control when builder is called
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List - BlocConsumer Cubit Pattern'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TodoCubit>().loadTodos();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInstructionBanner(),
          Expanded(
            child: BlocConsumer<TodoCubit, TodoState>(
              listenWhen: (previous, current) {
                // Only listen for specific states that require side effects
                return current is TodoAdded ||
                    current is TodoToggled ||
                    current is TodoDeleted ||
                    current is TodoError;
              },

              /// LISTENER - For side effects (SnackBars, Navigation, Dialogs)
              ///
              /// IMPORTANT:
              /// - Called BEFORE builder
              /// - Use for actions that shouldn't rebuild UI
              /// - NOT for UI building (use builder instead)
              ///
              /// COMMON USE CASES:
              /// - Show SnackBar on success/error
              /// - Navigate to another screen
              /// - Show Dialog
              /// - Log analytics events
              listener: (context, state) {
                // Show different SnackBars based on specific action states
                switch (state) {
                  case TodoAdded():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✓ Added "${state.addedTodoTitle}"'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  case TodoToggled():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✓ Toggled "${state.toggledTodoTitle}"'),
                        backgroundColor: Colors.blue,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  case TodoDeleted():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✓ Deleted "${state.deletedTodoTitle}"'),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  case TodoError():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✗ Error: ${state.errorMessage}'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  default:
                    // No SnackBar for other states
                    break;
                }
              },

              buildWhen: (previous, state) {
                // Rebuild UI for these states only
                return state is TodoInitial ||
                    state is TodoLoading ||
                    state is TodoLoaded ||
                    state is TodoAdding ||
                    state is TodoToggling ||
                    state is TodoDeleting ||
                    state is TodoError;
              },

              /// BUILDER - For building UI based on state
              ///
              /// CALLED:
              /// - After listener
              /// - Every time state changes
              /// - Returns Widget tree for current state
              ///
              /// PATTERN MATCHING:
              /// - Use switch expression for exhaustive matching
              /// - Sealed classes ensure all states are handled
              builder: (context, state) {
                return switch (state) {
                  TodoInitial() => _buildInitialView(context),
                  TodoLoading() => _buildLoadingView(),
                  TodoLoaded() => _buildLoadedView(context, state.todos, false),
                  TodoAdding() => _buildLoadedView(
                    context,
                    state.currentTodos,
                    true,
                  ),
                  TodoToggling() => _buildLoadedView(
                    context,
                    state.currentTodos,
                    true,
                    processingId: state.todoId,
                  ),
                  TodoDeleting() => _buildLoadedView(
                    context,
                    state.currentTodos,
                    true,
                    processingId: state.todoId,
                  ),
                  TodoError() => _buildErrorView(context, state),
                  _ => Center(),
                };
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          final isProcessing =
              state is TodoAdding ||
              state is TodoToggling ||
              state is TodoDeleting;

          return FloatingActionButton(
            onPressed: isProcessing
                ? null
                : () {
                    _showAddTodoDialog(context);
                  },
            backgroundColor: isProcessing ? Colors.grey : null,
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

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
                'BlocConsumer Cubit Pattern',
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
            'Combines BlocListener + BlocBuilder. Direct method calls: Cubit → Use Case → Repository',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Build initial view - shown before any data is loaded
  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checklist, size: 100, color: Colors.purple.shade500),
          const SizedBox(height: 16),
          const Text(
            'Welcome to Todo List',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the button below to load your todos',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Direct method call - Cubit pattern!
              context.read<TodoCubit>().loadTodos();
            },
            icon: const Icon(Icons.download),
            label: const Text('Load Todos'),
          ),
        ],
      ),
    );
  }

  /// Build loading view - shown while data is being fetched
  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading todos...'),
        ],
      ),
    );
  }

  /// Build loaded view - shown when todos are successfully loaded
  Widget _buildLoadedView(
    BuildContext context,
    List<Todo> todos,
    bool isProcessing, {
    String? processingId,
  }) {
    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No todos yet',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to add your first todo',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            // Statistics card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total', todos.length.toString(), Colors.blue),
                  _buildStatItem(
                    'Pending',
                    todos
                        .where((t) => t.status == TodoStatus.pending)
                        .length
                        .toString(),
                    Colors.orange,
                  ),
                  _buildStatItem(
                    'Completed',
                    todos
                        .where((t) => t.status == TodoStatus.completed)
                        .length
                        .toString(),
                    Colors.green,
                  ),
                ],
              ),
            ),
            // Todo list
            Expanded(
              child: AbsorbPointer(
                absorbing: isProcessing,
                child: Opacity(
                  opacity: isProcessing ? 0.5 : 1.0,
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      final isThisProcessing = processingId == todo.id;
                      return _buildTodoItem(context, todo, isThisProcessing);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        // Processing overlay
        if (isProcessing)
          Container(
            color: Colors.black12,
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Processing...'),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Build error view - shown when an error occurs
  Widget _buildErrorView(BuildContext context, TodoError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 100, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.read<TodoCubit>().loadTodos();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Build stat item for statistics card
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  /// Build individual todo item
  Widget _buildTodoItem(BuildContext context, Todo todo, bool isProcessing) {
    final isCompleted = todo.status == TodoStatus.completed;

    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // Prevent dismiss if processing
        if (isProcessing) return false;
        return true;
      },
      onDismissed: (direction) {
        // The Cubit attempts to delete the todo immediately as required by Dismissible widget
        // If deletion fails, an error SnackBar will be shown by the listener and the UI will reload
        context.read<TodoCubit>().deleteTodo(todo.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: isProcessing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Checkbox(
                  activeColor: Colors.purple.shade500,
                  side: BorderSide(color: Colors.purple.shade500),
                  value: isCompleted,
                  onChanged: (value) {
                    context.read<TodoCubit>().toggleTodo(todo.id);
                  },
                ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Colors.grey : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description.isNotEmpty) Text(todo.description),
              if (todo.dueDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          trailing: Chip(
            side: BorderSide(color: Colors.purple.shade200),
            label: Text(
              isCompleted ? 'Done' : 'Pending',
              style: const TextStyle(fontSize: 10),
            ),
            backgroundColor: isCompleted
                ? Colors.green.shade100
                : Colors.orange.shade100,
          ),
        ),
      ),
    );
  }

  /// Show dialog to add a new todo
  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a title'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final newTodo = Todo(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                dueDate: DateTime.now().add(const Duration(days: 7)),
                status: TodoStatus.pending,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              context.read<TodoCubit>().addTodo(newTodo);
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
