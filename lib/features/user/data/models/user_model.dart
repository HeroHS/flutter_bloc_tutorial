import '../../domain/entities/user.dart';

/// User Model - Data layer representation
///
/// WHAT IS A MODEL?
/// - Data transfer object used in the data layer
/// - Handles serialization/deserialization (JSON ↔ Dart object)
/// - Extends or maps to domain entity
/// - Can have different structure than entity (API changes don't affect domain)
///
/// MODEL vs ENTITY:
/// ┌──────────────┬──────────────────────────┬─────────────────────────┐
/// │ Aspect       │ Model (Data Layer)       │ Entity (Domain Layer)   │
/// ├──────────────┼──────────────────────────┼─────────────────────────┤
/// │ Purpose      │ Data transfer            │ Business logic          │
/// │ Location     │ data/models/             │ domain/entities/        │
/// │ Methods      │ fromJson, toJson         │ Business rules          │
/// │ Dependencies │ JSON, API structure      │ None (pure Dart)        │
/// │ Stability    │ Changes with API         │ Very stable             │
/// └──────────────┴──────────────────────────┴─────────────────────────┘
///
/// WHY SEPARATE FROM ENTITY?
/// ✓ API changes don't affect business logic
/// ✓ Can support multiple API versions (v1, v2) → same entity
/// ✓ Domain layer stays pure and testable
/// ✓ Clear separation of concerns
///
/// CONVERSION FLOW:
/// API JSON → fromJson() → UserModel → toEntity() → User Entity → BLoC → UI
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  /// Factory constructor to create a UserModel from JSON
  ///
  /// DESERIALIZATION (JSON → Dart Object):
  /// - Converts API response to Dart object
  /// - Handles type casting (JSON is dynamic)
  /// - In production, consider json_serializable or freezed for code generation
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  /// Convert UserModel to JSON
  ///
  /// SERIALIZATION (Dart Object → JSON):
  /// - Used when sending data to API (POST, PUT requests)
  /// - Returns Map<String, dynamic> for json.encode()
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  /// Convert UserModel to domain entity
  ///
  /// MODEL → ENTITY CONVERSION:
  /// - Bridges data layer and domain layer
  /// - Repository calls this after fetching from data source
  /// - Ensures domain layer only works with entities, not models
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      role: role,
    );
  }
}
