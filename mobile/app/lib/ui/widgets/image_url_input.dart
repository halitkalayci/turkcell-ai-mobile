import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../core/validators/product_validator.dart';

/// Image URL input widget with preview.
/// Per BR-08: Image is recommended but not mandatory.
class ImageUrlInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const ImageUrlInput({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  State<ImageUrlInput> createState() => _ImageUrlInputState();
}

class _ImageUrlInputState extends State<ImageUrlInput> {
  String? _previewUrl;
  bool _isValidUrl = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onUrlChanged);
    _updatePreview();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onUrlChanged);
    super.dispose();
  }

  void _onUrlChanged() {
    _updatePreview();
  }

  void _updatePreview() {
    final url = widget.controller.text.trim();
    final validationResult = ProductValidator.validateImageUrl(url);
    
    setState(() {
      _isValidUrl = url.isNotEmpty && validationResult == null;
      _previewUrl = _isValidUrl ? url : null;
      _hasError = false;
    });
  }

  void _onImageError() {
    setState(() {
      _hasError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Product Image (Optional)',
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Image preview area
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.imagePlaceholder,
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            border: Border.all(
              color: AppColors.textHint.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: _buildPreview(theme),
        ),
        
        const SizedBox(height: 12),
        
        // URL input field
        TextFormField(
          controller: widget.controller,
          style: const TextStyle(color: AppColors.inputTextColor),
          decoration: InputDecoration(
            hintText: 'https://example.com/image.jpg',
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(
              Icons.link,
              color: AppColors.iconInactive,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: AppColors.iconInactive),
                    onPressed: () {
                      widget.controller.clear();
                      _updatePreview();
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
              borderSide: BorderSide(color: AppColors.textHint.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
              borderSide: BorderSide(color: AppColors.textHint.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
              borderSide: const BorderSide(color: AppColors.textPrimary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
          ),
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          validator: widget.validator ?? ProductValidator.validateImageUrl,
        ),
      ],
    );
  }

  Widget _buildPreview(ThemeData theme) {
    // No URL entered
    if (_previewUrl == null || _previewUrl!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: AppColors.iconPlaceholder,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter image URL below',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // URL entered but image failed to load
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load image',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    // Show image preview
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppColors.radiusCard),
      child: Image.network(
        _previewUrl!,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: AppColors.textPrimary,
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _onImageError();
          });
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
