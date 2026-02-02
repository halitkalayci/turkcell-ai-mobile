import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'config/env.dart';

void main() {
  // Basic bootstrap; no business logic.
  runApp(const AiMobileApp());
}

class AiMobileApp extends StatelessWidget {
  const AiMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = _createRouter();

    return MaterialApp.router(
      title: 'AI Mobile',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _HomeRedirect(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductsListScreen(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return ProductDetailScreen(productId: id ?? '');
          },
        ),
      ],
    );
  }
}

class _HomeRedirect extends StatelessWidget {
  const _HomeRedirect();
  @override
  Widget build(BuildContext context) {
    // Redirect to products list on startup.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/products');
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Base API: ${Env.baseUrl}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Products list will appear here'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product: $productId')),
      body: const Center(
        child: Text('Product details will appear here'),
      ),
    );
  }
}
