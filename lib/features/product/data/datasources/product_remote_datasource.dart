import 'dart:async';
import '../models/product_model.dart';

/// Remote Data Source for Products
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      const ProductModel(
        id: '1',
        name: 'Flutter Complete Course',
        description: 'Master Flutter development from beginner to advanced',
        price: 49.99,
        imageUrl: 'https://via.placeholder.com/150',
        inCart: false,
      ),
      const ProductModel(
        id: '2',
        name: 'BLoC Pattern Guide',
        description: 'Learn state management with BLoC pattern',
        price: 29.99,
        imageUrl: 'https://via.placeholder.com/150',
        inCart: false,
      ),
      const ProductModel(
        id: '3',
        name: 'Clean Architecture',
        description: 'Build scalable Flutter apps with Clean Architecture',
        price: 39.99,
        imageUrl: 'https://via.placeholder.com/150',
        inCart: false,
      ),
      const ProductModel(
        id: '4',
        name: 'Testing in Flutter',
        description: 'Comprehensive guide to testing Flutter applications',
        price: 34.99,
        imageUrl: 'https://via.placeholder.com/150',
        inCart: false,
      ),
    ];
  }
}
