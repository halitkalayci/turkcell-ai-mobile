package com.turkcell.aimobile.repository;

import com.turkcell.aimobile.model.Product;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Repository
public class ProductRepository {
    private final Map<String, Product> products = new ConcurrentHashMap<>();

    public Product save(Product product) {
        products.put(product.getId(), product);
        return product;
    }

    public Optional<Product> findById(String id) {
        return Optional.ofNullable(products.get(id));
    }

    public List<Product> findAll() {
        return new ArrayList<>(products.values());
    }

    public boolean existsByName(String name) {
        return products.values().stream()
                .anyMatch(p -> p.getName().equalsIgnoreCase(name));
    }

    public boolean existsByNameExcludingId(String name, String excludeId) {
        return products.values().stream()
                .anyMatch(p -> p.getName().equalsIgnoreCase(name) && !p.getId().equals(excludeId));
    }

    public boolean existsBySku(String sku) {
        if (sku == null || sku.isBlank()) {
            return false;
        }
        return products.values().stream()
                .anyMatch(p -> sku.equalsIgnoreCase(p.getSku()));
    }

    public boolean existsBySkuExcludingId(String sku, String excludeId) {
        if (sku == null || sku.isBlank()) {
            return false;
        }
        return products.values().stream()
                .anyMatch(p -> sku.equalsIgnoreCase(p.getSku()) && !p.getId().equals(excludeId));
    }

    public List<Product> search(String query) {
        if (query == null || query.isBlank()) {
            return findAll();
        }
        String lowerQuery = query.toLowerCase();
        return products.values().stream()
                .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(lowerQuery)) ||
                             (p.getSku() != null && p.getSku().toLowerCase().contains(lowerQuery)))
                .collect(Collectors.toList());
    }
}
