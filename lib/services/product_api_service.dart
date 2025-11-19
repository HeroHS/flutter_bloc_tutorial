/// Product API Service
///
/// Simulates API calls for products in the BlocConsumer demo

import 'package:flutter_bloc_tutorial/models/product.dart';

class ProductApiService {
  /// Simulates fetching products from an API (success scenario)
  ///
  /// Returns a list of mock products after a 2-second delay
  Future<List<Product>> fetchProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return mock products
    return [
      Product(
        id: '1',
        name: 'Wireless Headphones',
        description: 'High-quality wireless headphones with noise cancellation',
        price: 99.99,
        imageUrl: '🎧',
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        description: 'Fitness tracker with heart rate monitor',
        price: 199.99,
        imageUrl: '⌚',
      ),
      Product(
        id: '3',
        name: 'Laptop Stand',
        description: 'Ergonomic aluminum laptop stand',
        price: 49.99,
        imageUrl: '💻',
      ),
      Product(
        id: '4',
        name: 'USB-C Cable',
        description: 'Durable braided USB-C charging cable',
        price: 14.99,
        imageUrl: '🔌',
      ),
      Product(
        id: '5',
        name: 'Wireless Mouse',
        description: 'Ergonomic wireless mouse with precision tracking',
        price: 29.99,
        imageUrl: '🖱️',
      ),
      Product(
        id: '6',
        name: 'Mechanical Keyboard',
        description: 'RGB backlit mechanical keyboard',
        price: 129.99,
        imageUrl: '⌨️',
      ),
    ];
  }

  /// Simulates fetching products from an API (error scenario)
  ///
  /// Throws an exception after a 2-second delay to simulate network error
  Future<List<Product>> fetchProductsWithError() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate error
    throw Exception('Failed to load products. Please check your connection.');
  }

  /// Simulates refreshing products (faster than initial load)
  Future<List<Product>> refreshProducts() async {
    // Simulate faster refresh
    await Future.delayed(const Duration(seconds: 1));

    // Return same mock products
    return fetchProducts();
  }
}
