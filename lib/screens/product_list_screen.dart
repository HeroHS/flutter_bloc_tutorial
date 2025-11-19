/// Product List Screen - BlocConsumer Demo
///
/// This screen demonstrates the complete usage of BlocConsumer:
///
/// 1. BUILDER: Updates UI based on state
///    - Initial state → Welcome message
///    - Loading state → Progress indicator
///    - Loaded state → Products list
///    - Error state → Error message
///    - Refreshing state → List with refresh indicator
///
/// 2. LISTENER: Handles side effects
///    - Product added → Show success snackbar
///    - Product removed → Show info snackbar
///    - Error state → Show error snackbar with retry
///    - Checkout state → Navigate to checkout screen
///
/// This demonstrates why BlocConsumer is powerful:
/// - Single widget handles both UI and side effects
/// - Cleaner code than nesting BlocBuilder + BlocListener
/// - Clear separation: listener for actions, builder for UI

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_tutorial/bloc/product_bloc.dart';
import 'package:flutter_bloc_tutorial/bloc/product_event.dart';
import 'package:flutter_bloc_tutorial/bloc/product_state.dart';
import 'package:flutter_bloc_tutorial/models/product.dart';
import 'package:flutter_bloc_tutorial/services/product_api_service.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create ProductBloc with dependency injection
      create: (context) => ProductBloc(productApiService: ProductApiService()),
      child: const ProductListView(),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlocConsumer Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Info button - explains BlocConsumer
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
          // Cart icon with badge
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              final cartCount = _getCartCount(state);
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: cartCount > 0
                        ? () {
                            context.read<ProductBloc>().add(CheckoutEvent());
                          }
                        : null,
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Explanation banner
          _buildExplanationBanner(),

          // Main content with BlocConsumer
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              // Listen when transitioning TO add/remove/error/checkout states
              listenWhen: (previous, current) {
                // Trigger listener on these specific state types
                return current is ProductAddedToCartState ||
                    current is ProductRemovedFromCartState ||
                    current is ProductErrorState ||
                    current is ProductCheckoutState;
              },
              // ═══════════════════════════════════════════════════════
              // LISTENER: Handles SIDE EFFECTS (executes FIRST)
              // ═══════════════════════════════════════════════════════
              listener: (context, state) {
                // Side effect 1: Product added to cart
                if (state is ProductAddedToCartState) {
                  // Clear any existing snackbars first
                  ScaffoldMessenger.of(context).clearSnackBars();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${state.productName} added to cart!',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  // Haptic feedback
                  HapticFeedback.mediumImpact();
                }

                // Side effect 2: Product removed from cart
                if (state is ProductRemovedFromCartState) {
                  // Clear any existing snackbars first
                  ScaffoldMessenger.of(context).clearSnackBars();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.remove_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${state.productName} removed from cart',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                // Side effect 3: Error occurred
                if (state is ProductErrorState) {
                  // Clear any existing snackbars first
                  ScaffoldMessenger.of(context).clearSnackBars();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(child: Text(state.errorMessage)),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () {
                          context.read<ProductBloc>().add(LoadProductsEvent());
                        },
                      ),
                    ),
                  );
                }

                // Side effect 4: Navigate to checkout
                if (state is ProductCheckoutState) {
                  // Show checkout dialog (in real app, navigate to checkout screen)
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(
                            Icons.shopping_cart_checkout,
                            color: Colors.deepPurple,
                          ),
                          SizedBox(width: 8),
                          Text('Checkout'),
                        ],
                      ),
                      content: Text(
                        'Proceeding to checkout with ${state.itemCount} item(s).\n\n'
                        'In a real app, this would navigate to the checkout screen.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            // Reset to initial state
                            context.read<ProductBloc>().add(
                              ResetProductsEvent(),
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );

                  // Haptic feedback
                  HapticFeedback.heavyImpact();
                }
              },

              // ═══════════════════════════════════════════════════════
              // BUILDER: Builds UI based on STATE (executes SECOND)
              // ═══════════════════════════════════════════════════════
              builder: (context, state) {
                return switch (state) {
                  // Initial state: Show welcome message
                  ProductInitialState() => _buildInitialView(context),

                  // Loading state: Show progress indicator
                  ProductLoadingState() => _buildLoadingView(),

                  // Loaded state: Show products list
                  ProductLoadedState() => _buildProductsList(
                    context,
                    state.products,
                  ),

                  // Added to cart state: Show products list (same as loaded)
                  ProductAddedToCartState() => _buildProductsList(
                    context,
                    state.products,
                  ),

                  // Removed from cart state: Show products list (same as loaded)
                  ProductRemovedFromCartState() => _buildProductsList(
                    context,
                    state.products,
                  ),

                  // Error state: Show error message
                  ProductErrorState() => _buildErrorView(
                    context,
                    state.errorMessage,
                  ),

                  // Refreshing state: Show list with refresh indicator
                  ProductRefreshingState() => Stack(
                    children: [
                      _buildProductsList(context, state.products),
                      const Positioned(
                        top: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Refreshing...'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Checkout state: Show loading (navigation happening in listener)
                  ProductCheckoutState() => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Processing checkout...'),
                      ],
                    ),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build explanation banner at the top
  Widget _buildExplanationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        border: Border(bottom: BorderSide(color: Colors.deepPurple.shade200)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.deepPurple.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'BlocConsumer = Builder (UI) + Listener (Side Effects)',
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build initial view with action buttons
  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: Colors.deepPurple.shade400,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Product Store',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Demonstrating BlocConsumer',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Load products button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<ProductBloc>().add(LoadProductsEvent());
                },
                icon: const Icon(Icons.download),
                label: const Text('Load Products (Success)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Load with error button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<ProductBloc>().add(LoadProductsWithErrorEvent());
                },
                icon: const Icon(Icons.error_outline),
                label: const Text('Load Products (Error Demo)'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
            const SizedBox(height: 32),

            // Info card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Try These Features:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem('Add items to cart → See snackbar'),
                    _buildInfoItem('Remove items → See snackbar'),
                    _buildInfoItem('Trigger error → See error + retry'),
                    _buildInfoItem('Checkout → See navigation dialog'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  /// Build loading view
  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading products...', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text(
            '(Builder updates UI)',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Build products list
  Widget _buildProductsList(BuildContext context, List<Product> products) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(RefreshProductsEvent());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  /// Build product card
  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(product.imageUrl, style: const TextStyle(fontSize: 32)),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              product.description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
        trailing: product.inCart
            ? IconButton(
                icon: const Icon(Icons.remove_shopping_cart, color: Colors.red),
                onPressed: () {
                  context.read<ProductBloc>().add(
                    RemoveFromCartEvent(
                      productId: product.id,
                      productName: product.name,
                    ),
                  );
                },
                tooltip: 'Remove from cart',
              )
            : IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                onPressed: () {
                  context.read<ProductBloc>().add(
                    AddToCartEvent(
                      productId: product.id,
                      productName: product.name,
                    ),
                  );
                },
                tooltip: 'Add to cart',
              ),
      ),
    );
  }

  /// Build error view
  Widget _buildErrorView(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductBloc>().add(LoadProductsEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                context.read<ProductBloc>().add(ResetProductsEvent());
              },
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
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
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('BlocConsumer Demo'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This screen demonstrates BlocConsumer:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDialogSection('📱 BUILDER (UI Updates)', [
                'Initial → Welcome screen',
                'Loading → Progress indicator',
                'Loaded → Products list',
                'Error → Error message',
                'Refreshing → List with indicator',
              ]),
              const SizedBox(height: 16),
              _buildDialogSection('⚡ LISTENER (Side Effects)', [
                'Product added → Green snackbar',
                'Product removed → Orange snackbar',
                'Error → Red snackbar + retry',
                'Checkout → Navigation dialog',
              ]),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BlocConsumer = BlocBuilder + BlocListener\n\n'
                  'One widget for both UI updates and side effects!',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(item, style: const TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Helper: Get cart count from any state
  int _getCartCount(ProductState state) {
    if (state is ProductLoadedState) {
      return state.cartItemCount;
    } else if (state is ProductAddedToCartState) {
      return state.cartItemCount;
    } else if (state is ProductRemovedFromCartState) {
      return state.cartItemCount;
    } else if (state is ProductRefreshingState) {
      return state.cartItemCount;
    }
    return 0;
  }
}
