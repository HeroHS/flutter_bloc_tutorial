/// Base class for all Product-related events
sealed class ProductEvent {}

/// Event to load products
final class LoadProductsEvent extends ProductEvent {}

/// Event to add product to cart
final class AddToCartEvent extends ProductEvent {
  final String productId;
  AddToCartEvent(this.productId);
}

/// Event to remove product from cart
final class RemoveFromCartEvent extends ProductEvent {
  final String productId;
  RemoveFromCartEvent(this.productId);
}
