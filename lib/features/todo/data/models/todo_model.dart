import '../../domain/entities/todo.dart';

/// TodoModel extends Todo entity and adds JSON serialization
///
/// This model handles conversion between JSON data (from API/storage)
/// and the domain Todo entity used throughout the app.
class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Creates a TodoModel from JSON map
  ///
  /// Handles date parsing and status enum conversion from API response
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      status: _statusFromString(json['status'] as String),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts TodoModel to JSON map
  ///
  /// Used when sending data to API or storing locally
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'status': _statusToString(status),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts TodoModel to Todo entity
  ///
  /// Useful when passing data to domain layer
  /// for business logic processing
  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Converts Todo entity to TodoModel
  ///
  /// Useful when you need to convert domain entity back to model
  /// for serialization purposes
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      dueDate: todo.dueDate,
      status: todo.status,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
  }

  /// Helper method to convert string to TodoStatus enum
  static TodoStatus _statusFromString(String status) {
    return switch (status.toLowerCase()) {
      'completed' => TodoStatus.completed,
      'pending' => TodoStatus.pending,
      _ => TodoStatus.pending, // Default to pending for unknown values
    };
  }

  /// Helper method to convert TodoStatus enum to string
  static String _statusToString(TodoStatus status) {
    return switch (status) {
      TodoStatus.completed => 'completed',
      TodoStatus.pending => 'pending',
    };
  }

  /// Creates a copy of this TodoModel with updated fields
  ///
  /// Useful for immutable state updates
  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
