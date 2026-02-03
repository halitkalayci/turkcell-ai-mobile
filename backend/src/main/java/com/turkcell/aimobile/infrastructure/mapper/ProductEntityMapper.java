package com.turkcell.aimobile.infrastructure.mapper;

import com.turkcell.aimobile.infrastructure.persistence.h2.entity.ProductEntity;
import com.turkcell.aimobile.model.Product;

public class ProductEntityMapper {
    public Product toDomain(ProductEntity e) {
        Product p = new Product();
        p.setId(e.getId());
        p.setName(e.getName());
        p.setSku(e.getSku());
        p.setDescription(e.getDescription());
        p.setPrice(e.getPrice());
        p.setCurrency(e.getCurrency());
        p.setIsActive(e.getIsActive());
        p.setCategoryId(e.getCategoryId());
        p.setImageUrl(e.getImageUrl());
        p.setCreatedAt(e.getCreatedAt());
        p.setUpdatedAt(e.getUpdatedAt());
        return p;
    }

    public ProductEntity toEntity(Product p) {
        ProductEntity e = new ProductEntity();
        e.setId(p.getId());
        e.setName(p.getName());
        e.setSku(p.getSku());
        e.setDescription(p.getDescription());
        e.setPrice(p.getPrice());
        e.setCurrency(p.getCurrency());
        e.setIsActive(p.getIsActive());
        e.setCategoryId(p.getCategoryId());
        e.setImageUrl(p.getImageUrl());
        e.setCreatedAt(p.getCreatedAt());
        e.setUpdatedAt(p.getUpdatedAt());
        return e;
    }
}
