import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'config/app_config.dart';
import 'application/product/product_controller.dart';
import 'application/category/category_controller.dart';
import 'infrastructure/repositories/product_repository_adapter.dart';
import 'infrastructure/repositories/category_repository_adapter.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/product_add_screen.dart';
import 'ui/screens/category_add_screen.dart';

/// Main entry point for Turkcell AI Mobile app.
/// Per AGENTS.md Section 5: Hexagonal architecture with Provider + go_router.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Product controller with repository
        ChangeNotifierProvider(
          create: (_) => ProductController(
            repository: ProductRepositoryAdapter(),
          ),
        ),
        // Category controller with repository
        ChangeNotifierProvider(
          create: (_) => CategoryController(
            repository: CategoryRepositoryAdapter(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.appName,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: AppConfig.isDevelopment,
      ),
    );
  }
}

/// Router configuration using go_router (approved navigation - AGENTS.md).
/// Per user request: App opens with Product List screen by default.
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/products/add',
      builder: (context, state) => const ProductAddScreen(),
    ),
    GoRoute(
      path: '/categories/add',
      builder: (context, state) => const CategoryAddScreen(),
    ),
    // Future routes (when implemented):
    // GoRoute(path: '/categories/:id', builder: (context, state) => CategoryDetailScreen()),
    // GoRoute(path: '/products/:id', builder: (context, state) => ProductDetailScreen()),
  ],
);

/// Placeholder home page until UI layer is implemented.
/// Infrastructure is ready for UI development.
class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch controllers to rebuild on state changes
    final productController = context.watch<ProductController>();
    final categoryController = context.watch<CategoryController>();

    // Use controllers to prevent unused variable warnings
    final isLoading = productController.isLoading || categoryController.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.appName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else
              const Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Colors.green,
              ),
            const SizedBox(height: 16),
            const Text(
              'Infrastructure Ready!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'All layers implemented per AGENTS.md',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Text('✅ Config layer (API + environment)'),
            const Text('✅ Core contracts (Product V2 + Category V1)'),
            const Text('✅ Core infrastructure (errors, pagination, mappers)'),
            const Text('✅ Infrastructure (HTTP client, API clients)'),
            const Text('✅ Domain (entities + ports)'),
            const Text('✅ Application (controllers + state)'),
            const Text('✅ Provider + go_router setup'),
            const SizedBox(height: 32),
            Text(
              'Base URL: ${AppConfig.baseUrl}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Environment: ${AppConfig.currentEnvironment.name}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              '⏳ Ready for UI layer implementation',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
