/// User entity - Pure business object
///
/// WHAT IS AN ENTITY?
/// - Core business object in the domain layer
/// - Contains business rules and logic
/// - Independent of any external frameworks or libraries
/// - No dependencies on data sources, UI, or external packages
///
/// DOMAIN LAYER PRINCIPLES:
/// - Entities are at the center of Clean Architecture
/// - They define WHAT the data is, not HOW it's stored/fetched
/// - Most stable layer (changes least frequently)
/// - Other layers depend on domain, but domain depends on nothing
///
/// ENTITY vs MODEL:
/// ┌──────────────┬─────────────────────────┬──────────────────────┐
/// │ Aspect       │ Entity (Domain)         │ Model (Data)         │
/// ├──────────────┼─────────────────────────┼──────────────────────┤
/// │ Purpose      │ Business logic          │ Data transfer        │
/// │ Location     │ domain/entities/        │ data/models/         │
/// │ Dependencies │ None (pure Dart)        │ JSON, HTTP, etc.     │
/// │ Methods      │ Business rules          │ fromJson, toJson     │
/// │ Stability    │ Very stable             │ Changes with API     │
/// └──────────────┴─────────────────────────┴──────────────────────┘
///
/// WHY SEPARATE ENTITY AND MODEL?
/// - Entity doesn't change when API response format changes
/// - Can have different JSON structures (v1 API, v2 API) map to same entity
/// - Business logic doesn't depend on external data format
/// - Easier to test (no JSON parsing in business logic)
///
/// CONST CONSTRUCTOR:
/// - Makes instances compile-time constants when possible
/// - Memory efficient (reuses identical instances)
/// - Indicates immutability
class User {
  final int id;
  final String name;
  final String email;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // NOTE: No fromJson/toJson here!
  // Those belong in UserModel (data layer)
  
  // Optional: Business logic methods can go here
  // Examples:
  // bool get isAdmin => role == 'Admin';
  // bool get isPremiumUser => role == 'Premium';
  // String get displayName => name.toUpperCase();
}
