/// Product BLoC for BlocConsumer Demo
///
/// This BLoC demonstrates how different states trigger:
/// 1. UI updates (handled by BlocConsumer's builder)
/// 2. Side effects (handled by BlocConsumer's listener)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_tutorial/bloc/product_event.dart';
import 'package:flutter_bloc_tutorial/bloc/product_state.dart';
import 'package:flutter_bloc_tutorial/models/product.dart';
import 'package:flutter_bloc_tutorial/services/product_api_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductApiService productApiService;

  ProductBloc({required this.productApiService})
    : super(ProductInitialState()) {
    // Register event handlers
    on<LoadProductsEvent>(_onLoadProducts);
    on<LoadProductsWithErrorEvent>(_onLoadProductsWithError);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<CheckoutEvent>(_onCheckout);
    on<RefreshProductsEvent>(_onRefreshProducts);
    on<ResetProductsEvent>(_onReset);
  }

  /// Handle LoadProductsEvent - Load products successfully
  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    // Emit loading state (shows progress indicator)
    emit(ProductLoadingState());

    try {
      // Fetch products from API
      final products = await productApiService.fetchProducts();

      // Emit loaded state (shows products list)
      emit(ProductLoadedState(products: products, cartItemCount: 0));
    } catch (error) {
      // Emit error state (shows error message)
      emit(ProductErrorState('Failed to load products: $error'));
    }
  }

  /// Handle LoadProductsWithErrorEvent - Simulate error
  Future<void> _onLoadProductsWithError(
    LoadProductsWithErrorEvent event,
    Emitter<ProductState> emit,
  ) async {
    // Emit loading state
    emit(ProductLoadingState());

    try {
      // This will throw an error
      await productApiService.fetchProductsWithError();
    } catch (error) {
      // Emit error state (triggers error snackbar in listener)
      emit(ProductErrorState(error.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Handle AddToCartEvent - Add product to cart
  void _onAddToCart(AddToCartEvent event, Emitter<ProductState> emit) {
    final currentState = state;

    // Get products from current state using switch expression
    final (currentProducts, currentCartCount) = switch (currentState) {
      ProductLoadedState() => (
        currentState.products,
        currentState.cartItemCount,
      ),
      ProductAddedToCartState() => (
        currentState.products,
        currentState.cartItemCount,
      ),
      ProductRemovedFromCartState() => (
        currentState.products,
        currentState.cartItemCount,
      ),
      _ => (<Product>[], 0),
    };

    if (currentProducts.isNotEmpty) {
      // Update product list - mark product as in cart
      final updatedProducts = currentProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(inCart: true);
        }
        return product;
      }).toList();

      final newCartCount = currentCartCount + 1;

      // Emit ProductAddedToCartState (triggers snackbar in listener)
      emit(
        ProductAddedToCartState(
          products: updatedProducts,
          cartItemCount: newCartCount,
          productName: event.productName,
        ),
      );

      // Then emit ProductLoadedState so next add will trigger listener again
      emit(
        ProductLoadedState(
          products: updatedProducts,
          cartItemCount: newCartCount,
        ),
      );
    }
  }

  /// Handle RemoveFromCartEvent - Remove product from cart
  void _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<ProductState> emit,
  ) {
    final currentState = state;

    // Get products from current state using switch expression
    final (currentProducts, currentCartCount) = switch (currentState) {
      ProductLoadedState() => (
        currentState.products,
        currentState.cartItemCount,
      ),
      ProductAddedToCartState() => (
        currentState.products,
        currentState.cartItemCount,
      ),
      ProductRemovedFromCartState() => (
        currentState.products,
        currentState.cartItemCount,
      ),
      _ => (<Product>[], 0),
    };

    if (currentProducts.isNotEmpty) {
      // Update product list - remove product from cart
      final updatedProducts = currentProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(inCart: false);
        }
        return product;
      }).toList();

      final newCartCount = currentCartCount > 0 ? currentCartCount - 1 : 0;

      // Emit ProductRemovedFromCartState (triggers snackbar in listener)
      emit(
        ProductRemovedFromCartState(
          products: updatedProducts,
          cartItemCount: newCartCount,
          productName: event.productName,
        ),
      );

      // Then emit ProductLoadedState so next remove will trigger listener again
      emit(
        ProductLoadedState(
          products: updatedProducts,
          cartItemCount: newCartCount,
        ),
      );
    }
  }

  /// Handle CheckoutEvent - Navigate to checkout
  void _onCheckout(CheckoutEvent event, Emitter<ProductState> emit) {
    final currentState = state;

    // Get cart count from current state
    int cartCount = 0;
    if (currentState is ProductLoadedState) {
      cartCount = currentState.cartItemCount;
    } else if (currentState is ProductAddedToCartState) {
      cartCount = currentState.cartItemCount;
    } else if (currentState is ProductRemovedFromCartState) {
      cartCount = currentState.cartItemCount;
    }

    // Only allow checkout if cart has items
    if (cartCount > 0) {
      // Emit checkout state (triggers navigation in listener)
      emit(ProductCheckoutState(cartCount));
    }
  }

  /// Handle RefreshProductsEvent - Refresh product list
  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    // Only refresh from loaded state
    if (currentState is ProductLoadedState ||
        currentState is ProductAddedToCartState ||
        currentState is ProductRemovedFromCartState) {
      final products = _getProductsFromState(currentState);
      final cartCount = _getCartCountFromState(currentState);

      // Emit refreshing state (shows refresh indicator)
      emit(
        ProductRefreshingState(products: products, cartItemCount: cartCount),
      );

      try {
        // Refresh products from API
        final refreshedProducts = await productApiService.refreshProducts();

        // Preserve cart state
        final updatedProducts = refreshedProducts.map((product) {
          final existingProduct = products.firstWhere(
            (p) => p.id == product.id,
            orElse: () => product,
          );
          return product.copyWith(inCart: existingProduct.inCart);
        }).toList();

        // Emit loaded state with refreshed data
        emit(
          ProductLoadedState(
            products: updatedProducts,
            cartItemCount: cartCount,
          ),
        );
      } catch (error) {
        // On error, return to previous state
        emit(ProductErrorState('Failed to refresh: $error'));
      }
    }
  }

  /// Handle ResetProductsEvent - Reset to initial state
  void _onReset(ResetProductsEvent event, Emitter<ProductState> emit) {
    emit(ProductInitialState());
  }

  /// Helper: Get products from different state types
  List<Product> _getProductsFromState(ProductState state) {
    if (state is ProductLoadedState) {
      return state.products;
    } else if (state is ProductAddedToCartState) {
      return state.products;
    } else if (state is ProductRemovedFromCartState) {
      return state.products;
    }
    return [];
  }

  /// Helper: Get cart count from different state types
  int _getCartCountFromState(ProductState state) {
    if (state is ProductLoadedState) {
      return state.cartItemCount;
    } else if (state is ProductAddedToCartState) {
      return state.cartItemCount;
    } else if (state is ProductRemovedFromCartState) {
      return state.cartItemCount;
    }
    return 0;
  }
}
