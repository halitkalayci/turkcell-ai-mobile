package com.turkcell.aimobile.web.controller;

import com.turkcell.aimobile.application.CategoryApplicationService;
import com.turkcell.aimobile.dto.category.CreateCategoryRequest;
import com.turkcell.aimobile.dto.category.PagedCategoryResponse;
import com.turkcell.aimobile.dto.category.CategoryResponse;
import com.turkcell.aimobile.dto.category.UpdateCategoryRequest;
import com.turkcell.aimobile.model.Category;
import com.turkcell.aimobile.web.mapper.CategoryWebMapper;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/categories")
@CrossOrigin(origins = "*")
public class CategoriesController {

    private final CategoryApplicationService service;
    private final CategoryWebMapper mapper = new CategoryWebMapper();

    public CategoriesController(CategoryApplicationService service) {
        this.service = service;
    }

    @GetMapping
    public ResponseEntity<PagedCategoryResponse> list(
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size) {
        var items = service.list(page, size);
        long total = service.count();
        return ResponseEntity.ok(mapper.toPagedResponse(items, page, size, total));
    }

    @GetMapping("/{id}")
    public ResponseEntity<CategoryResponse> getById(@PathVariable String id) {
        Category category = service.getById(id);
        return ResponseEntity.ok(mapper.toResponse(category));
    }

    @PostMapping
    public ResponseEntity<CategoryResponse> create(@Valid @RequestBody CreateCategoryRequest request) {
        Category created = service.create(mapper.toDomain(request));
        return ResponseEntity.status(HttpStatus.CREATED).body(mapper.toResponse(created));
    }

    @PutMapping("/{id}")
    public ResponseEntity<CategoryResponse> update(
            @PathVariable String id,
            @Valid @RequestBody UpdateCategoryRequest request) {
        Category updated = service.update(id, mapper.toDomain(request));
        return ResponseEntity.ok(mapper.toResponse(updated));
    }
}