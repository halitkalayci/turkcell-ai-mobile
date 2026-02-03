import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/ports/product_repository.dart';
import '../../core/pagination/pagination_params.dart';
import '../../core/errors/api_exception.dart';

/// Product state management controller using ChangeNotifier.
/// Per AGENTS.md Section 5.2: Application layer orchestrates use-cases.
/// Per AGENTS.md Section 5.1: Provider for state management (approved).
class ProductController extends ChangeNotifier {
  final ProductRepository _repository;

  ProductController({required ProductRepository repository})
      : _repository = repository;

  // State
  bool _isLoading = false;
  String? _error;
  List<Product> _products = [];
  Product? _selectedProduct;
  PaginationParams _currentParams = PaginationParams();
  int _totalPages = 0;
  int _totalItems = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get products => List.unmodifiable(_products);
  Product? get selectedProduct => _selectedProduct;
  PaginationParams get currentParams => _currentParams;
  int get totalPages => _totalPages;
  int get totalItems => _totalItems;
  bool get hasMore => _currentParams.page < _totalPages - 1;
  bool get hasError => _error != null;

  /// List products with pagination and optional category filter
  /// Per BR-04: Only active products returned (enforced by API)
  /// Per BR-05: Default sort by createdAt:desc (enforced by API)
  Future<void> listProducts({
    int page = 0,
    int size = 20,
    String? categoryId,
    String? searchQuery,
    String? sort,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentParams = PaginationParams(
        page: page,
        size: size,
        q: searchQuery,
        sort: sort,
      );

      final pagedResponse = await _repository.listProducts(
        _currentParams,
        categoryId: categoryId,
      );

      _products = pagedResponse.items;
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

  /// Load next page (for infinite scroll)
  Future<void> loadNextPage({String? categoryId}) async {
    if (!hasMore || _isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final nextParams = _currentParams.nextPage();
      final pagedResponse = await _repository.listProducts(
        nextParams,
        categoryId: categoryId,
      );

      _products.addAll(pagedResponse.items);
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

  /// Get product by ID
  /// Per BR-04: Passive products return 404 (enforced by backend)
  Future<void> getProductById(String id) async {
    try {
      _isLoading = true;
      _error = null;
      _selectedProduct = null;
      notifyListeners();

      _selectedProduct = await _repository.getProductById(id);
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
      if (e.isNotFound) {
        _error = 'Product not found or is inactive';
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

  /// Create new product
  /// Per BR-06: categoryId must reference active category (backend validates)
  Future<bool> createProduct(Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final createdProduct = await _repository.createProduct(product);
      _selectedProduct = createdProduct;
      return true;
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
      if (e.isConflict) {
        if (e.errorResponse.details.contains('SKU_ALREADY_EXISTS')) {
          _error = 'SKU already exists';
        } else if (e.errorResponse.details.contains('PRODUCT_NAME_ALREADY_EXISTS')) {
          _error = 'Product name already exists in this category';
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

  /// Update existing product
  /// Per BR-02: SKU conflicts return CONFLICT error
  Future<bool> updateProduct(String id, Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedProduct = await _repository.updateProduct(id, product);
      _selectedProduct = updatedProduct;
      return true;
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
      if (e.isConflict) {
        if (e.errorResponse.details.contains('SKU_ALREADY_EXISTS')) {
          _error = 'SKU already exists';
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

  /// Delete product (soft delete)
  Future<bool> deleteProduct(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.deleteProduct(id);
      return true;
    } on ApiException catch (e) {
      _error = e.errorResponse.message;
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
    _products = [];
    _selectedProduct = null;
    _currentParams = PaginationParams();
    _totalPages = 0;
    _totalItems = 0;
    notifyListeners();
  }
}
