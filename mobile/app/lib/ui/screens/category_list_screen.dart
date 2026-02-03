import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../application/category/category_controller.dart';
import '../../domain/entities/category.dart';
import '../theme/app_colors.dart';
import '../widgets/category_card.dart';

/// Category listing screen.
/// Per AGENTS.md Section 5.1: UI uses Provider for state, no business logic.
/// Per CAT-02: Only active categories shown (enforced by API).
/// Per CAT-05: Default sort by ordering field (enforced by API).
/// Per styleguide.md Section 3: Uses AppColors design tokens.
class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryController>().listCategories();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<CategoryController>().listCategories();
  }

  void _onCategoryTap(Category category) {
    // TODO: Navigate to category detail when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category tapped: ${category.name}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onEditPressed(Category category) {
    // TODO: Navigate to category edit when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit category: ${category.name}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Get parent category name by ID
  String? _getParentName(String? parentId, List<Category> categories) {
    if (parentId == null) return null;
    try {
      return categories.firstWhere((c) => c.id == parentId).name;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(theme),
            
            // Category list
            Expanded(
              child: Consumer<CategoryController>(
                builder: (context, controller, child) {
                  // Loading state
                  if (controller.isLoading && controller.categories.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.textPrimary,
                      ),
                    );
                  }

                  // Error state
                  if (controller.hasError && controller.categories.isEmpty) {
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
                            'Error loading categories',
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
                  if (controller.categories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 64,
                            color: AppColors.iconPlaceholder,
                          ),
                          const SizedBox(height: AppColors.spacingStandard),
                          Text(
                            'No categories found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first category',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Category list
                  final categories = controller.categories;
                  
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.textPrimary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppColors.spacingStandard,
                        vertical: AppColors.spacingSmall,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final parentName = _getParentName(
                          category.parentId, 
                          categories,
                        );
                        
                        return CategoryCard(
                          category: category,
                          parentName: parentName,
                          onTap: () => _onCategoryTap(category),
                          onEditPressed: () => _onEditPressed(category),
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
        onPressed: () => context.push('/categories/add'),
        backgroundColor: AppColors.buttonBackground,
        foregroundColor: AppColors.buttonForeground,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Consumer<CategoryController>(
      builder: (context, controller, _) {
        final categoryCount = controller.totalItems;
        
        return Container(
          color: AppColors.pageBackground,
          padding: const EdgeInsets.all(AppColors.spacingStandard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Menu + Title
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
                  
                  // Title + count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (categoryCount > 0)
                          Text(
                            '$categoryCount categories',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
