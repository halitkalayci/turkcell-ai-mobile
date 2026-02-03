package com.turkcell.aimobile.web.mapper;

import com.turkcell.aimobile.dto.category.CreateCategoryRequest;
import com.turkcell.aimobile.dto.category.PagedCategoryResponse;
import com.turkcell.aimobile.dto.category.CategoryResponse;
import com.turkcell.aimobile.dto.category.UpdateCategoryRequest;
import com.turkcell.aimobile.model.Category;

import java.util.List;
import java.util.stream.Collectors;

public class CategoryWebMapper {

    public Category toDomain(CreateCategoryRequest req) {
        Category c = new Category();
        c.setName(req.getName());
        c.setDescription(req.getDescription());
        c.setParentId(req.getParentId());
        c.setOrdering(req.getOrdering());
        c.setIsActive(req.getIsActive());
        return c;
    }

    public Category toDomain(UpdateCategoryRequest req) {
        Category c = new Category();
        c.setName(req.getName());
        c.setDescription(req.getDescription());
        c.setParentId(req.getParentId());
        c.setOrdering(req.getOrdering());
        c.setIsActive(req.getIsActive());
        return c;
    }

    public CategoryResponse toResponse(Category c) {
        CategoryResponse r = new CategoryResponse();
        r.setId(c.getId());
        r.setName(c.getName());
        r.setDescription(c.getDescription());
        r.setParentId(c.getParentId());
        r.setOrdering(c.getOrdering());
        r.setIsActive(c.getIsActive());
        r.setCreatedAt(c.getCreatedAt());
        r.setUpdatedAt(c.getUpdatedAt());
        return r;
    }

    public PagedCategoryResponse toPagedResponse(List<Category> domainItems, int page, int size, long totalItems) {
        PagedCategoryResponse resp = new PagedCategoryResponse();
        List<CategoryResponse> items = domainItems.stream()
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
