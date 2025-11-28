class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final TodoStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

enum TodoStatus { pending, completed }
