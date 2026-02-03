package com.turkcell.aimobile.web.mapper;

import com.turkcell.aimobile.dto.v2.CreateProductV2Request;
import com.turkcell.aimobile.dto.v2.PagedProductV2Response;
import com.turkcell.aimobile.dto.v2.ProductV2Response;
import com.turkcell.aimobile.dto.v2.UpdateProductV2Request;
import com.turkcell.aimobile.model.Product;

import java.util.List;
import java.util.stream.Collectors;

public class ProductV2WebMapper {

    public Product toDomain(CreateProductV2Request req) {
        Product p = new Product();
        p.setName(req.getName());
        p.setSku(req.getSku());
        p.setDescription(req.getDescription());
        p.setPrice(req.getPrice());
        p.setCurrency(req.getCurrency());
        p.setIsActive(req.getIsActive());
        p.setCategoryId(req.getCategoryId());
        p.setImageUrl(req.getImageUrl());
        return p;
    }

    public Product toDomain(UpdateProductV2Request req) {
        Product p = new Product();
        p.setName(req.getName());
        p.setSku(req.getSku());
        p.setDescription(req.getDescription());
        p.setPrice(req.getPrice());
        p.setCurrency(req.getCurrency());
        p.setIsActive(req.getIsActive());
        p.setCategoryId(req.getCategoryId());
        p.setImageUrl(req.getImageUrl());
        return p;
    }

    public ProductV2Response toResponse(Product p) {
        ProductV2Response r = new ProductV2Response();
        r.setId(p.getId());
        r.setName(p.getName());
        r.setSku(p.getSku());
        r.setDescription(p.getDescription());
        r.setPrice(p.getPrice());
        r.setCurrency(p.getCurrency());
        r.setIsActive(p.getIsActive());
        r.setCategoryId(p.getCategoryId());
        r.setImageUrl(p.getImageUrl());
        r.setCreatedAt(p.getCreatedAt());
        r.setUpdatedAt(p.getUpdatedAt());
        return r;
    }

    public PagedProductV2Response toPagedResponse(List<Product> domainItems, int page, int size, long totalItems) {
        PagedProductV2Response resp = new PagedProductV2Response();
        List<ProductV2Response> items = domainItems.stream()
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
