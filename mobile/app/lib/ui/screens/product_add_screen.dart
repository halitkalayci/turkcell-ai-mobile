import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../application/product/product_controller.dart';
import '../../application/category/category_controller.dart';
import '../../domain/entities/product.dart';
import '../../core/validators/product_validator.dart';
import '../theme/app_colors.dart';
import '../widgets/image_url_input.dart';

/// Product add/create screen.
/// Per AGENTS.md Section 5.1: UI layer has no business logic.
/// Validations per products-v2.yaml and business-rules/product.rules.md
class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  // Form state
  String _selectedCurrency = 'TRY';
  String? _selectedCategoryId;
  bool _isActive = true;
  bool _isSubmitting = false;

  // Currency options
  final List<String> _currencies = ['TRY', 'USD', 'EUR', 'GBP'];

  @override
  void initState() {
    super.initState();
    // Load categories for dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryController>().listCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final product = Product(
      id: '', // Will be assigned by backend
      name: _nameController.text.trim(),
      sku: _skuController.text.trim(),
      description: _descriptionController.text.trim(),
      price: ProductValidator.parsePrice(_priceController.text) ?? 0,
      currency: _selectedCurrency,
      isActive: _isActive,
      categoryId: _selectedCategoryId!,
      imageUrl: _imageUrlController.text.trim().isEmpty 
          ? null 
          : _imageUrlController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final controller = context.read<ProductController>();
    final success = await controller.createProduct(product);

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Product created successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.of(context).pop(true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.error ?? 'Failed to create product'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.iconDefault),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add Product',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppColors.spacingStandard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image URL input with preview
              ImageUrlInput(controller: _imageUrlController),
              
              const SizedBox(height: 24),
              
              // Product Name (Required)
              _buildTextField(
                controller: _nameController,
                label: 'Product Name *',
                hint: 'Enter product name',
                validator: ProductValidator.validateName,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 16),
              
              // SKU (Optional)
              _buildTextField(
                controller: _skuController,
                label: 'SKU (Optional)',
                hint: 'e.g., PROD-001',
                validator: ProductValidator.validateSku,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 16),
              
              // Description (Optional)
              _buildTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hint: 'Enter product description',
                validator: ProductValidator.validateDescription,
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 16),
              
              // Price and Currency row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price *',
                      hint: '0.00',
                      validator: ProductValidator.validatePrice,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Currency dropdown
                  Expanded(
                    flex: 1,
                    child: _buildCurrencyDropdown(theme),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Category dropdown
              _buildCategoryDropdown(theme),
              
              const SizedBox(height: 16),
              
              // Active switch
              _buildActiveSwitch(theme),
              
              const SizedBox(height: 32),
              
              // Submit button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    foregroundColor: AppColors.buttonForeground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppColors.radiusCard),
                    ),
                    disabledBackgroundColor: AppColors.textHint,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.buttonForeground,
                          ),
                        )
                      : const Text(
                          'Create Product',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textHint),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency *',
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
            border: Border.all(color: AppColors.textHint.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCurrency,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.iconInactive),
              items: _currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCurrency = value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Consumer<CategoryController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
                  border: Border.all(color: AppColors.textHint.withOpacity(0.3)),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            final categories = controller.categories;
            
            return Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
                border: Border.all(color: AppColors.textHint.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategoryId,
                  isExpanded: true,
                  hint: Text(
                    'Select a category',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.iconInactive),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategoryId = value);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActiveSwitch(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
        border: Border.all(color: AppColors.textHint.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Product will be visible to customers',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() => _isActive = value);
            },
            activeColor: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
