package com.turkcell.aimobile.application;

import com.turkcell.aimobile.domain.port.CategoryRepositoryPort;
import com.turkcell.aimobile.exception.ConflictException;
import com.turkcell.aimobile.exception.ProductNotFoundException;
import com.turkcell.aimobile.model.Category;

import java.time.Instant;
import java.util.List;
import java.util.Objects;

public class CategoryApplicationService {

    private final CategoryRepositoryPort repository;

    public CategoryApplicationService(CategoryRepositoryPort repository) {
        this.repository = Objects.requireNonNull(repository, "repository");
    }

    public List<Category> list(int page, int size) {
        return repository.findActiveOrdered(page, size);
    }

    public long count() {
        return repository.countActive();
    }

    public Category getById(String id) {
        return repository.findById(id).orElseThrow(() -> new ProductNotFoundException("Category not found: " + id));
    }

    public Category create(Category category) {
        ensureUniqueNameWithinParent(category.getName(), category.getParentId());
        if (category.getCreatedAt() == null) {
            category.setCreatedAt(Instant.now());
        }
        if (category.getOrdering() == null) {
            category.setOrdering(0);
        }
        category.setUpdatedAt(category.getCreatedAt());
        if (category.getIsActive() == null) {
            category.setIsActive(true);
        }
        return repository.save(category);
    }

    public Category update(String id, Category changes) {
        Category current = getById(id);
        if (changes.getName() != null && !changes.getName().equals(current.getName())) {
            ensureUniqueNameWithinParent(changes.getName(), changes.getParentId() != null ? changes.getParentId() : current.getParentId());
            current.setName(changes.getName());
        }
        if (changes.getDescription() != null) {
            current.setDescription(changes.getDescription());
        }
        if (changes.getParentId() != null) {
            current.setParentId(changes.getParentId());
        }
        if (changes.getOrdering() != null) {
            current.setOrdering(changes.getOrdering());
        }
        if (changes.getIsActive() != null) {
            // CAT-04: child cannot be active if parent is passive (enforced when parent provided)
            current.setIsActive(changes.getIsActive());
        }
        current.setUpdatedAt(Instant.now());
        return repository.save(current);
    }

    private void ensureUniqueNameWithinParent(String name, String parentId) {
        if (name == null || name.isBlank()) return;
        if (repository.existsByNameAndParentId(name, parentId)) {
            throw new ConflictException("CATEGORY_NAME_ALREADY_EXISTS");
        }
    }
}