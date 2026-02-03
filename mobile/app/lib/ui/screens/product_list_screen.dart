import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/product/product_controller.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_card.dart';

/// Product listing screen with search and pagination.
/// Per AGENTS.md Section 5.1: UI uses Provider for state, no business logic.
/// Per BR-04: Only active products shown (enforced by API).
/// Per BR-05: Default sort by createdAt:desc (enforced by API).
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().listProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = maxScroll - currentScroll;

    // Load more when within 200px of bottom
    if (delta < 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final controller = context.read<ProductController>();
    if (!controller.hasMore || controller.isLoading) return;

    setState(() => _isLoadingMore = true);
    
    await controller.listProducts(
      page: controller.currentParams.page + 1,
      size: controller.currentParams.size,
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    );
    
    setState(() => _isLoadingMore = false);
  }

  Future<void> _onRefresh() async {
    await context.read<ProductController>().listProducts(
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    );
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  void _onSearchSubmitted(String value) {
    context.read<ProductController>().listProducts(
      searchQuery: value.isEmpty ? null : value,
    );
  }

  void _onProductTap(Product product) {
    // TODO: Navigate to product detail when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product tapped: ${product.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildSearchBar(theme),
          ),
        ),
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          // Initial loading state
          if (controller.isLoading && controller.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading products...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          // Error state
          if (controller.hasError && controller.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading products',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.error ?? 'Unknown error',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (controller.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No products available'
                        : 'Try a different search',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          // Product grid
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.products.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading indicator at bottom
                if (index == controller.products.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    ),
                  );
                }

                final product = controller.products[index];
                return ProductCard(
                  product: product,
                  onTap: () => _onProductTap(product),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                  _onSearchSubmitted('');
                },
              )
            : null,
      ),
      textInputAction: TextInputAction.search,
      onChanged: _onSearchChanged,
      onSubmitted: _onSearchSubmitted,
    );
  }
}
