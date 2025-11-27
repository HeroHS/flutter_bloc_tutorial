import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products.dart';
import '../../../../core/usecases/usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

/// Product BLoC with Clean Architecture
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProductsUseCase;

  ProductBloc({required this.getProductsUseCase})
      : super(ProductInitialState()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());

    try {
      final products = await getProductsUseCase(NoParams());
      emit(ProductLoadedState(products));
    } catch (error) {
      emit(ProductErrorState(error.toString()));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;
      final updatedProducts = currentState.products.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(inCart: true);
        }
        return product;
      }).toList();
      emit(ProductLoadedState(updatedProducts));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;
      final updatedProducts = currentState.products.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(inCart: false);
        }
        return product;
      }).toList();
      emit(ProductLoadedState(updatedProducts));
    }
  }
}
