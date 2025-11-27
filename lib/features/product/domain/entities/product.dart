/// Product entity - Pure business object
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
}
