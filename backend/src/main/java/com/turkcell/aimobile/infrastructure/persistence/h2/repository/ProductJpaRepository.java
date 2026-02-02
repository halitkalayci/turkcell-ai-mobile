package com.turkcell.aimobile.infrastructure.persistence.h2.repository;

import com.turkcell.aimobile.infrastructure.persistence.h2.entity.ProductEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ProductJpaRepository extends JpaRepository<ProductEntity, String> {
    boolean existsByName(String name);
    boolean existsBySku(String sku);

    @Query("SELECT p FROM ProductEntity p WHERE " +
            "LOWER(p.name) LIKE LOWER(CONCAT('%', :q, '%')) OR " +
            "LOWER(p.sku) LIKE LOWER(CONCAT('%', :q, '%')) OR " +
            "LOWER(p.description) LIKE LOWER(CONCAT('%', :q, '%'))")
    Page<ProductEntity> search(@Param("q") String q, Pageable pageable);
}
