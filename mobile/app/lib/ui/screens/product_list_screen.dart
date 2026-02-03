import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../application/product/product_controller.dart';
import '../../domain/entities/product.dart';
import '../../core/formatters/product_formatter.dart';
import '../theme/app_colors.dart';
import '../widgets/product_card.dart';

/// Product listing screen matching reference design.
/// Per AGENTS.md Section 5.1: UI uses Provider for state, no business logic.
/// Per BR-04: Only active products shown (enforced by API).
/// Per BR-05: Default sort by createdAt:desc (enforced by API).
/// Per styleguide.md Section 3: Uses AppColors design tokens.
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
  final Set<String> _favoriteIds = {};

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
      SnackBar(
        content: Text('Product tapped: ${product.name}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onFavoritePressed(String productId) {
    setState(() {
      if (_favoriteIds.contains(productId)) {
        _favoriteIds.remove(productId);
      } else {
        _favoriteIds.add(productId);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Custom header
            _buildHeader(theme),
            
            // Product grid
            Expanded(
              child: Consumer<ProductController>(
                builder: (context, controller, child) {
                  // Initial loading state
                  if (controller.isLoading && controller.products.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.textPrimary,
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
                            color: AppColors.iconInactive,
                          ),
                          const SizedBox(height: AppColors.spacingStandard),
                          Text(
                            'Error loading products',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _onRefresh,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonBackground,
                              foregroundColor: AppColors.buttonForeground,
                            ),
                            child: const Text('Retry'),
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
                            color: AppColors.iconPlaceholder,
                          ),
                          const SizedBox(height: AppColors.spacingStandard),
                          Text(
                            'No products found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Product grid
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.textPrimary,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppColors.spacingStandard, 
                        vertical: AppColors.spacingSmall,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: AppColors.spacingGrid,
                        mainAxisSpacing: AppColors.spacingGrid,
                      ),
                      itemCount: controller.products.length + (_isLoadingMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        // Loading indicator at bottom
                        if (index >= controller.products.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppColors.spacingStandard),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }

                        final product = controller.products[index];
                        return ProductCard(
                          product: product,
                          isFavorite: _favoriteIds.contains(product.id),
                          onTap: () => _onProductTap(product),
                          onFavoritePressed: () => _onFavoritePressed(product.id),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/products/add'),
        backgroundColor: AppColors.buttonBackground,
        foregroundColor: AppColors.buttonForeground,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final controller = context.watch<ProductController>();
    final productCount = controller.totalItems;

    return Container(
      color: AppColors.pageBackground,
      padding: const EdgeInsets.all(AppColors.spacingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Menu + Search
          Row(
            children: [
              // Hamburger menu
              IconButton(
                icon: const Icon(Icons.menu, color: AppColors.iconDefault),
                onPressed: () {
                  // TODO: Open drawer/menu
                },
              ),
              const SizedBox(width: AppColors.spacingSmall),
              
              // Search bar
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.searchBarBackground,
                    borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search product',
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                                _onSearchSubmitted('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppColors.spacingStandard,
                        vertical: 14,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Title + Icons row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sneakers',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ProductFormatter.formatProductCount(productCount),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.iconInactive,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Sort icon
              IconButton(
                icon: const Icon(Icons.sort, color: AppColors.iconDefault),
                onPressed: () {
                  // TODO: Show sort options
                },
              ),
              
              // Filter icon
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppColors.iconDefault),
                onPressed: () {
                  // TODO: Show filter options
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
