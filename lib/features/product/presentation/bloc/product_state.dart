import '../../domain/entities/product.dart';

/// Base class for all Product-related states
///
/// BLOCCONSUMER STATES:
/// The ProductCartUpdatedState is specifically designed for BlocConsumer:
/// - Listener detects it and shows snackbar
/// - Builder uses it to rebuild the UI
///
/// This demonstrates how to structure states for BlocConsumer pattern.
sealed class ProductState {}

/// Initial state before any data loading
final class ProductInitialState extends ProductState {}

/// State when data is being loaded from the API
///
/// LOADING STATE:
/// - Emitted immediately after LoadProductsEvent
/// - Builder shows CircularProgressIndicator
/// - No listener action needed
final class ProductLoadingState extends ProductState {}

/// State when products are successfully loaded
///
/// LOADED STATE:
/// - Contains list of products
/// - Builder displays the product list
/// - No listener action (products just loaded)
final class ProductLoadedState extends ProductState {
  final List<Product> products;

  ProductLoadedState(this.products);
}

/// State when cart is updated (item added/removed)
///
/// CART UPDATED STATE - Key for BlocConsumer:
/// This state is emitted when cart changes (add/remove item).
///
/// WHY SEPARATE STATE?
/// - Listener needs to know WHAT changed (product name, action)
/// - Builder needs updated products list to rebuild UI
/// - Provides data for both listener (snackbar) and builder (UI)
///
/// PROPERTIES:
/// - products: Updated list to display
/// - productName: For snackbar message
/// - addedToCart: true = added, false = removed
///
/// BLOCCONSUMER USAGE:
/// listener: (context, state) {
///   if (state is ProductCartUpdatedState) {
///     // Show snackbar with state.productName
///   }
/// }
/// builder: (context, state) {
///   if (state is ProductCartUpdatedState) {
///     // Display state.products
///   }
/// }
final class ProductCartUpdatedState extends ProductState {
  final List<Product> products;
  final String productName;
  final bool addedToCart;

  ProductCartUpdatedState({
    required this.products,
    required this.productName,
    required this.addedToCart,
  });
}

/// State when an error occurred
///
/// ERROR STATE:
/// - Contains error message
/// - Builder shows error UI with retry button
/// - Could add listener to log errors
final class ProductErrorState extends ProductState {
  final String errorMessage;

  ProductErrorState(this.errorMessage);
}
