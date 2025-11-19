/// Product States for BlocConsumer Demo
///
/// This file demonstrates different states that will be handled by:
/// - BlocConsumer's builder (for UI updates)
/// - BlocConsumer's listener (for side effects)

import 'package:flutter_bloc_tutorial/models/product.dart';

sealed class ProductState {}

/// Initial state - shows welcome message
final class ProductInitialState extends ProductState {}

/// Loading state - shows progress indicator
final class ProductLoadingState extends ProductState {}

/// Loaded state - shows products list
final class ProductLoadedState extends ProductState {
  final List<Product> products;
  final int cartItemCount;

  ProductLoadedState({required this.products, this.cartItemCount = 0});
}

/// Error state - shows error message
final class ProductErrorState extends ProductState {
  final String errorMessage;

  ProductErrorState(this.errorMessage);
}

/// Product added to cart state - triggers snackbar (side effect)
final class ProductAddedToCartState extends ProductState {
  final List<Product> products;
  final int cartItemCount;
  final String productName;
  final DateTime timestamp; // Add timestamp to make each state unique

  ProductAddedToCartState({
    required this.products,
    required this.cartItemCount,
    required this.productName,
  }) : timestamp = DateTime.now();
}

/// Product removed from cart state - triggers snackbar (side effect)
final class ProductRemovedFromCartState extends ProductState {
  final List<Product> products;
  final int cartItemCount;
  final String productName;
  final DateTime timestamp; // Add timestamp to make each state unique

  ProductRemovedFromCartState({
    required this.products,
    required this.cartItemCount,
    required this.productName,
  }) : timestamp = DateTime.now();
}

/// Checkout state - triggers navigation (side effect)
final class ProductCheckoutState extends ProductState {
  final int itemCount;

  ProductCheckoutState(this.itemCount);
}

/// Refreshing state - shows refresh indicator while keeping data visible
final class ProductRefreshingState extends ProductState {
  final List<Product> products;
  final int cartItemCount;

  ProductRefreshingState({required this.products, required this.cartItemCount});
}
