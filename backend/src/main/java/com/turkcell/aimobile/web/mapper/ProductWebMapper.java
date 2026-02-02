package com.turkcell.aimobile.web.mapper;

import com.turkcell.aimobile.dto.CreateProductRequest;
import com.turkcell.aimobile.dto.PagedProductResponse;
import com.turkcell.aimobile.dto.ProductResponse;
import com.turkcell.aimobile.dto.UpdateProductRequest;
import com.turkcell.aimobile.model.Product;

import java.util.List;
import java.util.stream.Collectors;

public class ProductWebMapper {

    public Product toDomain(CreateProductRequest req) {
        Product p = new Product();
        p.setName(req.getName());
        p.setSku(req.getSku());
        p.setDescription(req.getDescription());
        p.setPrice(req.getPrice());
        p.setCurrency(req.getCurrency());
        p.setIsActive(req.getIsActive());
        return p;
    }

    public Product toDomain(UpdateProductRequest req) {
        Product p = new Product();
        p.setName(req.getName());
        p.setSku(req.getSku());
        p.setDescription(req.getDescription());
        p.setPrice(req.getPrice());
        p.setCurrency(req.getCurrency());
        p.setIsActive(req.getIsActive());
        return p;
    }

    public ProductResponse toResponse(Product p) {
        ProductResponse r = new ProductResponse();
        r.setId(p.getId());
        r.setName(p.getName());
        r.setSku(p.getSku());
        r.setDescription(p.getDescription());
        r.setPrice(p.getPrice());
        r.setCurrency(p.getCurrency());
        r.setIsActive(p.getIsActive());
        r.setCreatedAt(p.getCreatedAt());
        r.setUpdatedAt(p.getUpdatedAt());
        return r;
    }

    public PagedProductResponse toPagedResponse(List<Product> domainItems, int page, int size, long totalItems) {
        PagedProductResponse resp = new PagedProductResponse();
        List<ProductResponse> items = domainItems.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        resp.setItems(items);
        resp.setPage(page);
        resp.setSize(size);
        resp.setTotalItems(totalItems);
        int totalPages = (int) Math.ceil(totalItems / (double) Math.max(size, 1));
        resp.setTotalPages(totalPages);
        return resp;
    }
}
