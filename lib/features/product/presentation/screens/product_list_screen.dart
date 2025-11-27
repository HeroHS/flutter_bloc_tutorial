import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../domain/entities/product.dart';

/// Product List Screen with BLoC and Clean Architecture
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products - BLoC Pattern'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildInstructionBanner(),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return switch (state) {
                  ProductInitialState() => _buildInitialView(context),
                  ProductLoadingState() => _buildLoadingView(),
                  ProductLoadedState() => _buildLoadedView(context, state.products),
                  ProductErrorState() => _buildErrorView(state.errorMessage),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.teal.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.teal.shade700),
              const SizedBox(width: 8),
              Text(
                'Product Catalog',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'BLoC with Clean Architecture - Add/Remove from cart',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            const Text(
              'Product Catalog',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductBloc>().add(LoadProductsEvent());
              },
              icon: const Icon(Icons.download),
              label: const Text('Load Products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.teal),
          SizedBox(height: 24),
          Text('Loading products...', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildLoadedView(BuildContext context, List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: Icon(Icons.shopping_bag, color: Colors.teal.shade700),
            ),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.description),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                product.inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                color: product.inCart ? Colors.red : Colors.teal,
              ),
              onPressed: () {
                if (product.inCart) {
                  context.read<ProductBloc>().add(RemoveFromCartEvent(product.id));
                } else {
                  context.read<ProductBloc>().add(AddToCartEvent(product.id));
                }
              },
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: Colors.red.shade400),
            const SizedBox(height: 24),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
