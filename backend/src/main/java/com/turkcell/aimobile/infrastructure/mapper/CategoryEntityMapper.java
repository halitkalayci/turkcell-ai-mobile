package com.turkcell.aimobile.infrastructure.mapper;

import com.turkcell.aimobile.infrastructure.persistence.h2.entity.CategoryEntity;
import com.turkcell.aimobile.model.Category;

public class CategoryEntityMapper {
    public Category toDomain(CategoryEntity e) {
        Category c = new Category();
        c.setId(e.getId());
        c.setName(e.getName());
        c.setDescription(e.getDescription());
        c.setParentId(e.getParentId());
        c.setOrdering(e.getOrdering());
        c.setIsActive(e.getIsActive());
        c.setCreatedAt(e.getCreatedAt());
        c.setUpdatedAt(e.getUpdatedAt());
        return c;
    }

    public CategoryEntity toEntity(Category c) {
        CategoryEntity e = new CategoryEntity();
        e.setId(c.getId());
        e.setName(c.getName());
        e.setDescription(c.getDescription());
        e.setParentId(c.getParentId());
        e.setOrdering(c.getOrdering());
        e.setIsActive(c.getIsActive());
        e.setCreatedAt(c.getCreatedAt());
        e.setUpdatedAt(c.getUpdatedAt());
        return e;
    }
}