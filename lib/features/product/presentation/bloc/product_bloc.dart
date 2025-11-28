import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/entities/product.dart';
import '../../../../core/usecases/usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

/// Product BLoC demonstrating BlocConsumer pattern
///
/// BLOCCONSUMER IMPLEMENTATION:
/// This BLoC is designed to work with BlocConsumer by:
/// 1. Emitting ProductCartUpdatedState when cart changes
/// 2. Including product name and action in the state
/// 3. Allowing listener to show appropriate feedback
///
/// KEY DIFFERENCE FROM STANDARD BLOC:
/// - Emits ProductCartUpdatedState (not ProductLoadedState) for cart changes
/// - Includes metadata (productName, addedToCart) for listener
/// - Enables rich user feedback through snackbars
///
/// CLEAN ARCHITECTURE:
/// - Depends on GetProducts use case (domain layer)
/// - Works with Product entities (domain layer)
/// - No knowledge of data sources or repositories
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProductsUseCase;

  ProductBloc({required this.getProductsUseCase}) : super(ProductInitial()) {
    on<ProductLoadedEvent>(_onLoadProducts);
    on<ProductAddedToCartEvent>(_onAddToCart);
    on<ProductRemovedFromCartEvent>(_onRemoveFromCart);
  }

  /// Handle LoadProductsEvent
  ///
  /// STANDARD LOADING PATTERN:
  /// 1. Emit loading state
  /// 2. Call use case
  /// 3. Emit loaded/error state
  Future<void> _onLoadProducts(
    ProductLoadedEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final products = await getProductsUseCase(NoParams());
      emit(ProductLoaded(products));
    } catch (error) {
      emit(ProductError(error.toString()));
    }
  }

  /// Handle AddToCartEvent
  ///
  /// BLOCCONSUMER PATTERN:
  /// Emits ProductCartUpdatedState instead of ProductLoadedState.
  /// This allows the listener to detect the change and show a snackbar.
  ///
  /// FLOW:
  /// 1. Check if we have loaded products (ProductLoadedState or ProductCartUpdatedState)
  /// 2. Find the product by ID and update inCart to true
  /// 3. Emit ProductCartUpdatedState with:
  ///    - Updated products list (for builder to display)
  ///    - Product name (for listener snackbar message)
  ///    - addedToCart: true (for listener to show "added" message)
  Future<void> _onAddToCart(
    ProductAddedToCartEvent event,
    Emitter<ProductState> emit,
  ) async {
    // Get current products from state
    List<Product> products = [];
    if (state is ProductLoaded) {
      products = (state as ProductLoaded).products;
    } else if (state is ProductCartUpdated) {
      products = (state as ProductCartUpdated).products;
    }

    if (products.isNotEmpty) {
      // Update the specific product's cart status
      final updatedProducts = products.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(inCart: true);
        }
        return product;
      }).toList();

      // Emit ProductCartUpdatedState for BlocConsumer
      // Listener will show snackbar
      // Builder will update UI
      emit(
        ProductCartUpdated(
          products: updatedProducts,
          productName: event.productName,
          addedToCart: true,
        ),
      );
    }
  }

  /// Handle RemoveFromCartEvent
  ///
  /// BLOCCONSUMER PATTERN:
  /// Similar to add, but sets inCart to false and addedToCart to false.
  ///
  /// FLOW:
  /// 1. Get current products from state
  /// 2. Find the product by ID and update inCart to false
  /// 3. Emit ProductCartUpdatedState with:
  ///    - Updated products list
  ///    - Product name
  ///    - addedToCart: false (for "removed" message)
  Future<void> _onRemoveFromCart(
    ProductRemovedFromCartEvent event,
    Emitter<ProductState> emit,
  ) async {
    // Get current products from state
    List<Product> products = [];
    if (state is ProductLoaded) {
      products = (state as ProductLoaded).products;
    } else if (state is ProductCartUpdated) {
      products = (state as ProductCartUpdated).products;
    }

    if (products.isNotEmpty) {
      // Update the specific product's cart status
      final updatedProducts = products.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(inCart: false);
        }
        return product;
      }).toList();

      // Emit ProductCartUpdatedState for BlocConsumer
      // Listener will show snackbar
      // Builder will update UI
      emit(
        ProductCartUpdated(
          products: updatedProducts,
          productName: event.productName,
          addedToCart: false,
        ),
      );
    }
  }
}
