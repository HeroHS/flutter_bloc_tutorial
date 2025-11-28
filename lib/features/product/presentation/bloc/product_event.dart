/// Base class for all Product-related events
///
/// BLOCCONSUMER EVENTS:
/// Events now include product name to provide context for snackbar messages.
/// The BLoC uses this to emit ProductCartUpdatedState with proper information.
sealed class ProductEvent {}

/// Event to load products from the data source
///
/// LOAD PRODUCTS EVENT:
/// - Triggers initial data fetch
/// - No parameters needed
/// - Emits: Loading → Loaded/Error
final class ProductLoadedEvent extends ProductEvent {}

/// Event to add product to cart
///
/// ADD TO CART EVENT:
/// - Requires productId to identify which product
/// - Requires productName for snackbar message
/// - Emits: ProductCartUpdatedState (addedToCart: true)
///
/// BLOCCONSUMER FLOW:
/// 1. User taps "Add to Cart"
/// 2. Event dispatched: ProductAddedToCart(id, name)
/// 3. BLoC updates product and emits ProductCartUpdatedState
/// 4. Listener shows: "{productName} added to cart!"
/// 5. Builder rebuilds UI with updated cart icon
final class ProductAddedToCartEvent extends ProductEvent {
  final String productId;
  final String productName;

  ProductAddedToCartEvent(this.productId, this.productName);
}

/// Event to remove product from cart
///
/// REMOVE FROM CART EVENT:
/// - Requires productId to identify which product
/// - Requires productName for snackbar message
/// - Emits: ProductCartUpdatedState (addedToCart: false)
///
/// BLOCCONSUMER FLOW:
/// 1. User taps "Remove from Cart"
/// 2. Event dispatched: ProductRemovedFromCart(id, name)
/// 3. BLoC updates product and emits ProductCartUpdatedState
/// 4. Listener shows: "{productName} removed from cart"
/// 5. Builder rebuilds UI with updated cart icon
final class ProductRemovedFromCartEvent extends ProductEvent {
  final String productId;
  final String productName;

  ProductRemovedFromCartEvent(this.productId, this.productName);
}

final class ProductCheckedoutEvent extends ProductEvent {}

final class ProductResetEvent extends ProductEvent {}
