package com.turkcell.aimobile.domain.port;

import com.turkcell.aimobile.model.Category;
import java.util.List;
import java.util.Optional;

public interface CategoryRepositoryPort {
    Category save(Category category);
    Optional<Category> findById(String id);
    boolean existsByNameAndParentId(String name, String parentId);
    List<Category> findActiveOrdered(int page, int size);
    long countActive();
    List<Category> findChildren(String parentId);
    boolean existsByIdAndIsActiveTrue(String id);
}