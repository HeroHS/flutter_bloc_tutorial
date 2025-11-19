/// Product Events for BlocConsumer Demo
///
/// This file demonstrates various events that trigger different states,
/// which will be handled by BlocConsumer's listener and builder.

sealed class ProductEvent {}

/// Event: Load products from API
final class LoadProductsEvent extends ProductEvent {}

/// Event: Load products with simulated error
final class LoadProductsWithErrorEvent extends ProductEvent {}

/// Event: Add a product to cart
final class AddToCartEvent extends ProductEvent {
  final String productId;
  final String productName;

  AddToCartEvent({required this.productId, required this.productName});
}

/// Event: Remove a product from cart
final class RemoveFromCartEvent extends ProductEvent {
  final String productId;
  final String productName;

  RemoveFromCartEvent({required this.productId, required this.productName});
}

/// Event: Checkout (navigate to checkout screen)
final class CheckoutEvent extends ProductEvent {}

/// Event: Refresh products
final class RefreshProductsEvent extends ProductEvent {}

/// Event: Reset to initial state
final class ResetProductsEvent extends ProductEvent {}
