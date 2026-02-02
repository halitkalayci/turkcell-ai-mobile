import 'package:flutter/material.dart';

/// Shows raw error code as per current decision.
class ProductErrorBanner extends StatelessWidget {
  final String? errorCode;
  const ProductErrorBanner({super.key, required this.errorCode});

  @override
  Widget build(BuildContext context) {
    if (errorCode == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red.shade50,
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorCode!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
