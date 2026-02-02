package com.turkcell.aimobile.application;

import com.turkcell.aimobile.domain.port.ProductRepositoryPort;
import com.turkcell.aimobile.domain.service.ProductDomainService;
import com.turkcell.aimobile.exception.ProductNotFoundException;
import com.turkcell.aimobile.model.Product;

import java.time.Instant;
import java.util.List;
import java.util.Objects;

/**
 * Application service orchestrating product use-cases.
 * No web DTOs here; accepts/returns domain model.
 */
public class ProductApplicationService {

    private final ProductRepositoryPort repository;
    private final ProductDomainService domainService;

    public ProductApplicationService(ProductRepositoryPort repository,
                                     ProductDomainService domainService) {
        this.repository = Objects.requireNonNull(repository, "repository");
        this.domainService = Objects.requireNonNull(domainService, "domainService");
    }

    public List<Product> list(int page, int size, String sortBy, boolean asc) {
        return repository.findAll(page, size, sortBy, asc);
    }

    public List<Product> list(int page, int size, String q, String sortBy, boolean asc) {
        if (q != null && !q.isBlank()) {
            return repository.search(q, page, size, sortBy, asc);
        }
        return repository.findAll(page, size, sortBy, asc);
    }

    public long count() {
        return repository.count();
    }

    public Product getById(String id) {
        return repository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException("Product not found: " + id));
    }

    public Product create(Product product) {
        // business rules
        domainService.ensureUniqueName(product.getName());
        domainService.ensureUniqueSku(product.getSku());
        // generation responsibilities here to avoid web doing it
        if (product.getCreatedAt() == null) {
            product.setCreatedAt(Instant.now());
        }
        product.setUpdatedAt(product.getCreatedAt());
        return repository.save(product);
    }

    public Product update(String id, Product changes) {
        Product current = getById(id);
        // apply changes and validate rules when name/sku change
        if (changes.getName() != null && !changes.getName().equals(current.getName())) {
            domainService.ensureUniqueName(changes.getName());
            current.setName(changes.getName());
        }
        if (changes.getSku() != null && !changes.getSku().equals(current.getSku())) {
            domainService.ensureUniqueSku(changes.getSku());
            current.setSku(changes.getSku());
        }
        if (changes.getDescription() != null) {
            current.setDescription(changes.getDescription());
        }
        if (changes.getPrice() != null) {
            current.setPrice(changes.getPrice());
        }
        if (changes.getCurrency() != null) {
            current.setCurrency(changes.getCurrency());
        }
        current.setUpdatedAt(Instant.now());
        return repository.save(current);
    }

    public void delete(String id) {
        // ensure exists for consistent semantics
        getById(id);
        repository.deleteById(id);
    }
}
