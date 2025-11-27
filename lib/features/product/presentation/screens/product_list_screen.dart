import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../domain/entities/product.dart';

/// Product List Screen demonstrating BlocConsumer
///
/// WHAT IS BLOCCONSUMER?
/// BlocConsumer combines BlocBuilder and BlocListener into one widget.
/// It allows you to:
/// - LISTEN to state changes for side effects (showing snackbars, dialogs, navigation)
/// - BUILD UI based on state changes (displaying different widgets)
///
/// WHY USE BLOCCONSUMER?
/// ✓ Eliminates nested BlocBuilder inside BlocListener
/// ✓ More concise code when you need both listening and building
/// ✓ Common pattern for showing feedback while updating UI
///
/// WHEN TO USE BLOCCONSUMER:
/// ✓ Need to show snackbar/dialog when state changes (listener)
/// ✓ Also need to rebuild UI based on state (builder)
/// ✓ Example: Add to cart (show snackbar + update UI)
///
/// BLOCCONSUMER STRUCTURE:
/// BlocConsumer<ProductBloc, ProductState>(
///   listener: (context, state) {
///     // Side effects: Snackbars, Dialogs, Navigation
///     // Does NOT rebuild widget tree
///   },
///   builder: (context, state) {
///     // Build UI based on state
///     // Rebuilds widget tree
///     return Widget();
///   },
/// )
///
/// TUTORIAL FEATURE:
/// This screen demonstrates adding/removing products from cart with:
/// - Listener: Shows snackbar when item added/removed
/// - Builder: Updates UI to reflect cart changes
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger initial load when screen builds
    // This ensures products are loaded when navigating to this screen
    context.read<ProductBloc>().add(LoadProductsEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('BlocConsumer Demo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'BlocConsumer Info',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInstructionBanner(),
          Expanded(
            // 🔑 KEY FEATURE: BlocConsumer combines listener + builder
            child: BlocConsumer<ProductBloc, ProductState>(
              // 📢 LISTENER: For side effects (doesn't rebuild UI)
              // Called when state changes, before builder
              // Use for: Snackbars, Dialogs, Navigation
              listener: (context, state) {
                // Show snackbar when product added/removed from cart
                if (state is ProductCartUpdatedState) {
                  _showCartSnackbar(context, state);
                }
              },
              // 🎨 BUILDER: For UI updates (rebuilds widget tree)
              // Called when state changes
              // Returns widget based on current state
              builder: (context, state) {
                return switch (state) {
                  ProductInitialState() => _buildInitialView(context),
                  ProductLoadingState() => _buildLoadingView(),
                  ProductLoadedState() => _buildLoadedView(context, state.products),
                  ProductCartUpdatedState() => _buildLoadedView(context, state.products),
                  ProductErrorState() => _buildErrorView(context, state.errorMessage),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Show snackbar when cart is updated
  ///
  /// LISTENER SIDE EFFECT:
  /// This is called from the listener callback, not the builder.
  /// Shows temporary feedback to user without rebuilding the entire UI.
  void _showCartSnackbar(BuildContext context, ProductCartUpdatedState state) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            state.addedToCart ? Icons.check_circle : Icons.remove_circle,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              state.addedToCart
                  ? '${state.productName} added to cart!'
                  : '${state.productName} removed from cart',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: state.addedToCart ? Colors.green : Colors.orange,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildInstructionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.orange.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(
                'BlocConsumer Demo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Combines BlocListener + BlocBuilder. Add/remove items to see snackbar (listener) and UI update (builder).',
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
              'Loading Products...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'BlocConsumer will listen for cart changes and update UI',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
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
          CircularProgressIndicator(color: Colors.orange),
          SizedBox(height: 24),
          Text('Loading products...', style: TextStyle(fontSize: 18)),
          SizedBox(height: 12),
          Text(
            'Fetching from data source...',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedView(BuildContext context, List<Product> products) {
    // Calculate cart items for display
    final cartCount = products.where((p) => p.inCart).length;

    return Column(
      children: [
        // Cart summary banner
        if (cartCount > 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.green.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  '$cartCount item${cartCount != 1 ? 's' : ''} in cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                elevation: product.inCart ? 4 : 1,
                color: product.inCart ? Colors.green.shade50 : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: product.inCart 
                        ? Colors.green.shade100 
                        : Colors.orange.shade100,
                    child: Icon(
                      product.inCart ? Icons.check_circle : Icons.shopping_bag,
                      color: product.inCart 
                          ? Colors.green.shade700 
                          : Colors.orange.shade700,
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      product.inCart 
                          ? Icons.remove_shopping_cart 
                          : Icons.add_shopping_cart,
                      color: product.inCart ? Colors.red : Colors.orange,
                    ),
                    onPressed: () {
                      // Dispatch events to toggle cart status
                      // BLoC will emit ProductCartUpdatedState
                      // Listener will show snackbar
                      // Builder will rebuild UI
                      if (product.inCart) {
                        context.read<ProductBloc>().add(
                          RemoveFromCartEvent(product.id, product.name),
                        );
                      } else {
                        context.read<ProductBloc>().add(
                          AddToCartEvent(product.id, product.name),
                        );
                      }
                    },
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 100, color: Colors.red.shade400),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductBloc>().add(LoadProductsEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show info dialog explaining BlocConsumer
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.orange),
            SizedBox(width: 8),
            Text('BlocConsumer Demo'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoSection(
                'What is BlocConsumer?',
                'Combines BlocListener and BlocBuilder into one widget.',
              ),
              _buildInfoSection(
                'Listener (Side Effects):',
                '• Shows snackbar when item added/removed\n'
                    '• Does NOT rebuild widget tree\n'
                    '• Perfect for one-time actions',
              ),
              _buildInfoSection(
                'Builder (UI Updates):',
                '• Rebuilds UI when state changes\n'
                    '• Updates product list display\n'
                    '• Shows cart count and highlights',
              ),
              _buildInfoSection(
                'Try It:',
                '• Tap shopping cart icon to add/remove items\n'
                    '• Watch snackbar appear (listener)\n'
                    '• See UI update immediately (builder)',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
