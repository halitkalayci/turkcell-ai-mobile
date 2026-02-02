package com.turkcell.aimobile.domain.service;

import com.turkcell.aimobile.domain.port.ProductRepositoryPort;
import com.turkcell.aimobile.exception.ConflictException;

import java.util.Objects;

/**
 * Encapsulates product business rules as defined in docs/business-rules.
 * - Product name must be unique.
 * - If SKU is provided (non-null/non-blank), it must be unique.
 */
public class ProductDomainService {

    private final ProductRepositoryPort repository;

    public ProductDomainService(ProductRepositoryPort repository) {
        this.repository = Objects.requireNonNull(repository, "repository");
    }

    public void ensureUniqueName(String name) {
        if (name == null || name.isBlank()) {
            return; // Bean validation should handle requiredness/length; domain enforces uniqueness.
        }
        if (repository.existsByName(name)) {
            throw new ConflictException("PRODUCT_NAME_ALREADY_EXISTS");
        }
    }

    public void ensureUniqueSku(String sku) {
        if (sku == null || sku.isBlank()) {
            return; // rule applies only when SKU is provided
        }
        if (repository.existsBySku(sku)) {
            throw new ConflictException("SKU_ALREADY_EXISTS");
        }
    }
}
