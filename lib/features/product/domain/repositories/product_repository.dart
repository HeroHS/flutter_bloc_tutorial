import '../entities/product.dart';

/// Product Repository Interface
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
