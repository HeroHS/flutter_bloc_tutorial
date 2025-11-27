/// Product entity - Pure business object
///
/// DOMAIN ENTITY FOR BLOCCONSUMER DEMO:
/// This entity includes an 'inCart' property that changes during user interaction.
/// The copyWith method allows immutable updates, which is essential for BLoC pattern.
///
/// IMMUTABILITY WITH COPYWITH:
/// - All properties are final (immutable)
/// - copyWith creates a new instance with some properties changed
/// - This is how BLoC updates state without mutating existing objects
///
/// BUSINESS PROPERTIES:
/// - id: Unique identifier
/// - name: Product name (used in snackbar messages)
/// - description: Product details
/// - price: Product cost
/// - imageUrl: Product image (for future enhancement)
/// - inCart: Cart status (changes via BLoC events)
///
/// USAGE IN BLOCCONSUMER:
/// When user adds to cart:
/// 1. Event: AddToCartEvent(product.id, product.name)
/// 2. BLoC: product.copyWith(inCart: true)
/// 3. State: ProductCartUpdatedState with updated product
/// 4. Listener: Shows "{product.name} added to cart!"
/// 5. Builder: Rebuilds UI with updated cart icon
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool inCart;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.inCart = false,
  });

  /// Create a copy of this product with some properties changed
  ///
  /// COPYWITH METHOD:
  /// Essential for immutable state updates in BLoC pattern.
  ///
  /// EXAMPLE:
  /// final updated = product.copyWith(inCart: true);
  /// // Creates new Product with inCart=true, all other fields same
  ///
  /// WHY IMMUTABILITY?
  /// - BLoC requires new state objects to trigger rebuilds
  /// - Prevents accidental mutations
  /// - Makes state changes predictable and traceable
  /// - Easier to debug (can compare old vs new state)
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? inCart,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      inCart: inCart ?? this.inCart,
    );
  }

  // Optional: Business logic methods
  // bool get isExpensive => price > 100;
  // bool get isInStock => true; // Could add inventory tracking
  // String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}
