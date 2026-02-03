import 'package:flutter/foundation.dart' hide Category;
import '../../domain/entities/category.dart';
import '../../domain/ports/category_repository.dart';
import '../../core/pagination/pagination_params.dart';
import '../../core/errors/api_exception.dart';

/// Category state management controller using ChangeNotifier.
/// Per AGENTS.md Section 5.2: Application layer orchestrates use-cases.
/// Per AGENTS.md Section 5.1: Provider for state management (approved).
class CategoryController extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryController({required CategoryRepository repository})
      : _repository = repository;

  // State
  bool _isLoading = false;
  String? _error;
  List<Category> _categories = [];
  Category? _selectedCategory;
  PaginationParams _currentParams = PaginationParams();
  int _totalPages = 0;
  int _totalItems = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Category> get categories => List.unmodifiable(_categories);
  Category? get selectedCategory => _selectedCategory;
  PaginationParams get currentParams => _currentParams;
  int get totalPages => _totalPages;
  int get totalItems => _totalItems;
  bool get hasMore => _currentParams.page < _totalPages - 1;
  bool get hasError => _error != null;

  /// Get root categories (no parent)
  List<Category> get rootCategories =>
      _categories.where((c) => c.isRootCategory).toList();

  /// Get child categories for a specific parent
  List<Category> getChildCategories(String parentId) =>
      _categories.where((c) => c.parentId == parentId).toList();

  /// List categories with pagination
  /// Per CAT-02: Only active categories returned (enforced by API)
  /// Per CAT-05: Default sort by ordering field (enforced by API)
  Future<void> listCategories({
    int page = 0,
    int size = 20,
    String? searchQuery,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentParams = PaginationParams(
        page: page,
        size: size,
        q: searchQuery,
      );

      final pagedResponse = await _repository.listCategories(_currentParams);

      _categories = pagedResponse.items;
      _totalPages = pagedResponse.totalPages;
      _totalItems = pagedResponse.totalItems;
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
    } on NetworkException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unknown error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (!hasMore || _isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final nextParams = _currentParams.nextPage();
      final pagedResponse = await _repository.listCategories(nextParams);

      _categories.addAll(pagedResponse.items);
      _currentParams = nextParams;
      _totalPages = pagedResponse.totalPages;
      _totalItems = pagedResponse.totalItems;
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
    } on NetworkException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unknown error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get category by ID
  /// Per CAT-02: Passive categories return 404 (enforced by backend)
  Future<void> getCategoryById(String id) async {
    try {
      _isLoading = true;
      _error = null;
      _selectedCategory = null;
      notifyListeners();

      _selectedCategory = await _repository.getCategoryById(id);
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
      if (e.isNotFound) {
        _error = 'Category not found or is inactive';
      }
    } on NetworkException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unknown error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new category
  /// Per CAT-01: Name must be unique within parent (backend validates)
  /// Per CAT-04: Child cannot be active if parent passive (backend validates)
  Future<bool> createCategory(Category category) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final createdCategory = await _repository.createCategory(category);
      _selectedCategory = createdCategory;
      return true;
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
      if (e.isConflict) {
        if (e.errorResponse.details.contains('CATEGORY_NAME_ALREADY_EXISTS')) {
          _error = 'Category name already exists in this parent';
        }
      }
      return false;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unknown error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update existing category
  /// Per CAT-01: Name uniqueness within parent (backend validates)
  /// Per CAT-04: Parent-child activation constraint (backend validates)
  Future<bool> updateCategory(String id, Category category) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedCategory = await _repository.updateCategory(id, category);
      _selectedCategory = updatedCategory;
      return true;
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
      if (e.isConflict) {
        if (e.errorResponse.details.contains('CATEGORY_NAME_ALREADY_EXISTS')) {
          _error = 'Category name already exists in this parent';
        }
      }
      return false;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unknown error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete category (soft delete)
  /// Per CAT-03: Cannot delete if has products (backend validates)
  Future<bool> deleteCategory(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.deleteCategory(id);
      return true;
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
      if (e.errorResponse.details.contains('CATEGORY_HAS_PRODUCTS')) {
        _error = 'Cannot delete category that has products';
      }
      return false;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unknown error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _isLoading = false;
    _error = null;
    _categories = [];
    _selectedCategory = null;
    _currentParams = PaginationParams();
    _totalPages = 0;
    _totalItems = 0;
    notifyListeners();
  }
}
