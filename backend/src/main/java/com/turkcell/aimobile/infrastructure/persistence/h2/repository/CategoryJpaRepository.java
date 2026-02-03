package com.turkcell.aimobile.infrastructure.persistence.h2.repository;

import com.turkcell.aimobile.infrastructure.persistence.h2.entity.CategoryEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategoryJpaRepository extends JpaRepository<CategoryEntity, String> {
    boolean existsByNameAndParentId(String name, String parentId);
    Page<CategoryEntity> findByIsActiveTrueOrderByOrderingAsc(Pageable pageable);
    long countByIsActiveTrue();
    List<CategoryEntity> findByParentId(String parentId);
    boolean existsByIdAndIsActiveTrue(String id);
}