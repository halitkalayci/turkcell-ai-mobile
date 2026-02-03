package com.turkcell.aimobile.domain.port;

import com.turkcell.aimobile.model.Product;

import java.util.List;
import java.util.Optional;

/**
 * Port exposing persistence operations needed by application/domain.
 * Framework-agnostic signatures to keep domain clean.
 */
public interface ProductRepositoryPort {
    Product save(Product product);

    Optional<Product> findById(String id);

    boolean existsByName(String name);

    boolean existsBySku(String sku);

    /**
     * Retrieve a page of products with simple offset-based pagination.
     * @param page zero-based page index
     * @param size page size
     * @param sortBy field name to sort by
     * @param asc true for ascending, false for descending
     */
    List<Product> findAll(int page, int size, String sortBy, boolean asc);

    /**
     * Search by query in name/sku/description (case-insensitive).
     */
    List<Product> search(String q, int page, int size, String sortBy, boolean asc);

    void deleteById(String id);

    long count();

    // v2: category-aware active-only operations
    List<Product> findAllByCategory(String categoryId, int page, int size, String sortBy, boolean asc);
    List<Product> searchByCategory(String categoryId, String q, int page, int size, String sortBy, boolean asc);
    long countByCategory(String categoryId);
}
