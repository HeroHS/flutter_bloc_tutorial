import '../../domain/entities/product.dart';

/// Base class for all Product-related states
sealed class ProductState {}

/// Initial state
final class ProductInitialState extends ProductState {}

/// Loading state
final class ProductLoadingState extends ProductState {}

/// Loaded state
final class ProductLoadedState extends ProductState {
  final List<Product> products;

  ProductLoadedState(this.products);
}

/// Error state
final class ProductErrorState extends ProductState {
  final String errorMessage;

  ProductErrorState(this.errorMessage);
}
