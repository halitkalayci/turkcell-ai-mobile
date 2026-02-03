package com.turkcell.aimobile.infrastructure.persistence.h2.repository;

import com.turkcell.aimobile.infrastructure.persistence.h2.entity.ProductEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Optional;

public interface ProductJpaRepository extends JpaRepository<ProductEntity, String> {
    boolean existsByName(String name);
    boolean existsBySku(String sku);

        @Query("SELECT p FROM ProductEntity p WHERE " +
            "LOWER(p.name) LIKE LOWER(CONCAT('%', :q, '%')) OR " +
            "LOWER(p.sku) LIKE LOWER(CONCAT('%', :q, '%')) OR " +
            "LOWER(p.description) LIKE LOWER(CONCAT('%', :q, '%'))")
        Page<ProductEntity> search(@Param("q") String q, Pageable pageable);

        // Active-only variants
        Page<ProductEntity> findByIsActiveTrue(Pageable pageable);
        Page<ProductEntity> findByIsActiveTrueAndCategoryId(String categoryId, Pageable pageable);

        @Query("SELECT p FROM ProductEntity p WHERE (" +
            "LOWER(p.name) LIKE LOWER(CONCAT('%', :q, '%')) OR " +
            "LOWER(p.sku) LIKE LOWER(CONCAT('%', :q, '%')) OR " +
            "LOWER(p.description) LIKE LOWER(CONCAT('%', :q, '%'))" +
            ") AND p.isActive = TRUE")
            Page<ProductEntity> searchActive(@Param("q") String q, Pageable pageable);
            @Query("SELECT p FROM ProductEntity p WHERE (" +
                "LOWER(p.name) LIKE LOWER(CONCAT('%', :q, '%')) OR " +
                "LOWER(p.sku) LIKE LOWER(CONCAT('%', :q, '%')) OR " +
                "LOWER(p.description) LIKE LOWER(CONCAT('%', :q, '%'))" +
                ") AND p.isActive = TRUE AND p.categoryId = :categoryId")
            Page<ProductEntity> searchActiveByCategory(@Param("q") String q, @Param("categoryId") String categoryId, Pageable pageable);

        Optional<ProductEntity> findByIdAndIsActiveTrue(String id);

        long countByIsActiveTrue();
        long countByIsActiveTrueAndCategoryId(String categoryId);
}
