import 'package:flutter/material.dart';
import '../../../application/product/product_state.dart';

/// Renders product list items from state; no business logic.
class ProductListView extends StatelessWidget {
  final ProductState state;
  const ProductListView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = state.list?.items ?? const [];
    if (items.isEmpty) {
      return const Center(child: Text('No products'));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final p = items[index];
        return ListTile(
          title: Text(p.name),
          subtitle: Text(p.sku ?? ''),
          trailing: Text('${p.price.toStringAsFixed(2)} ${p.currency ?? ''}'),
        );
      },
    );
  }
}
