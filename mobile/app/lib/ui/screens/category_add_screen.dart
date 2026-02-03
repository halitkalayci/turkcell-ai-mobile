import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../application/category/category_controller.dart';
import '../../domain/entities/category.dart';
import '../../core/validators/category_validator.dart';
import '../theme/app_colors.dart';

/// Category add/create screen.
/// Per AGENTS.md Section 5.1: UI layer has no business logic.
/// Validations per categories-v1.yaml and business-rules/category.rules.md
/// 
/// Business Rules Applied:
/// - CAT-01: Name unique within parent (backend validates)
/// - CAT-04: Child cannot be active if parent passive (backend validates)
/// - CAT-05: Ordering for display order
class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen({super.key});

  @override
  State<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _orderingController = TextEditingController(text: '0');
  
  // Form state
  String? _selectedParentId;
  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Load categories for parent dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryController>().listCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _orderingController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final category = Category(
      id: '', // Will be assigned by backend
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      parentId: _selectedParentId,
      ordering: CategoryValidator.parseOrdering(_orderingController.text),
      isActive: _isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final controller = context.read<CategoryController>();
    final success = await controller.createCategory(category);

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Category created successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.of(context).pop(true);
    } else if (mounted) {
      // Error messages handled by controller based on error codes
      // CAT-01: CATEGORY_NAME_ALREADY_EXISTS
      // CAT-04: PARENT_CATEGORY_PASSIVE
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.error ?? 'Failed to create category'),
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
          'Add Category',
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
              // Category icon placeholder
              _buildCategoryIcon(),
              
              const SizedBox(height: 24),
              
              // Category Name (Required)
              _buildTextField(
                controller: _nameController,
                label: 'Category Name *',
                hint: 'Enter category name',
                validator: CategoryValidator.validateName,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 16),
              
              // Description (Optional)
              _buildTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hint: 'Enter category description',
                validator: CategoryValidator.validateDescription,
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 16),
              
              // Parent Category dropdown
              _buildParentCategoryDropdown(theme),
              
              const SizedBox(height: 16),
              
              // Ordering field
              _buildTextField(
                controller: _orderingController,
                label: 'Display Order',
                hint: '0',
                validator: CategoryValidator.validateOrdering,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.done,
              ),
              
              const SizedBox(height: 8),
              
              // Ordering helper text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Lower numbers appear first in the list',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Active switch
              _buildActiveSwitch(theme),
              
              const SizedBox(height: 8),
              
              // Active helper text (CAT-02, CAT-04)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Inactive categories are hidden from the app',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              
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
                          'Create Category',
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

  Widget _buildCategoryIcon() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppColors.radiusCard),
          border: Border.all(
            color: AppColors.textHint.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.category_outlined,
          size: 48,
          color: AppColors.iconPlaceholder,
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
          style: const TextStyle(color: AppColors.inputTextColor),
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

  Widget _buildParentCategoryDropdown(ThemeData theme) {
    return Consumer<CategoryController>(
      builder: (context, controller, _) {
        final categories = controller.categories;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parent Category (Optional)',
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
                border: Border.all(color: AppColors.textHint.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _selectedParentId,
                  isExpanded: true,
                  dropdownColor: AppColors.cardBackground,
                  hint: Text(
                    'No parent (root category)',
                    style: TextStyle(color: AppColors.textHint),
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.iconInactive),
                  items: [
                    // Null option for root category
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        'No parent (root category)',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    // Active categories as possible parents
                    ...categories.map((category) {
                      return DropdownMenuItem<String?>(
                        value: category.id,
                        child: Text(
                          category.name,
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedParentId = value;
                    });
                  },
                ),
              ),
            ),
            if (controller.isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Loading categories...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildActiveSwitch(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppColors.spacingCard),
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
              const SizedBox(height: 4),
              Text(
                _isActive ? 'Visible in app' : 'Hidden from app',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
            activeColor: AppColors.switchActiveColor,
          ),
        ],
      ),
    );
  }
}
