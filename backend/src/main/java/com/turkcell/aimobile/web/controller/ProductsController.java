package com.turkcell.aimobile.web.controller;

import com.turkcell.aimobile.application.ProductApplicationService;
import com.turkcell.aimobile.dto.CreateProductRequest;
import com.turkcell.aimobile.dto.PagedProductResponse;
import com.turkcell.aimobile.dto.ProductResponse;
import com.turkcell.aimobile.dto.UpdateProductRequest;
import com.turkcell.aimobile.model.Product;
import com.turkcell.aimobile.web.mapper.ProductWebMapper;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/v1/products")
public class ProductsController {

    private final ProductApplicationService productService;
    private final ProductWebMapper mapper = new ProductWebMapper();

    public ProductsController(ProductApplicationService productService) {
        this.productService = productService;
    }

    @GetMapping
    public ResponseEntity<PagedProductResponse> listProducts(
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size,
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String sort) {
        String sortBy = null;
        boolean asc = false; // default to DESC when sort is absent
        if (sort != null && !sort.isBlank()) {
            String[] parts = sort.contains(",") ? sort.split(",") : sort.split(":");
            sortBy = parts[0].trim();
            if (parts.length > 1) {
                asc = !"desc".equalsIgnoreCase(parts[1].trim());
            }
        } else {
            sortBy = "createdAt"; // default field per BA: latest first
        }
        var items = productService.list(page, size, q, sortBy, asc);
        long total = productService.count();
        return ResponseEntity.ok(mapper.toPagedResponse(items, page, size, total));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductResponse> getProductById(@PathVariable String id) {
        Product product = productService.getById(id);
        return ResponseEntity.ok(mapper.toResponse(product));
    }

    @PostMapping
    public ResponseEntity<ProductResponse> createProduct(@Valid @RequestBody CreateProductRequest request) {
        Product created = productService.create(mapper.toDomain(request));
        return ResponseEntity.status(HttpStatus.CREATED).body(mapper.toResponse(created));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductResponse> updateProduct(
            @PathVariable String id,
            @Valid @RequestBody UpdateProductRequest request) {
        Product updated = productService.update(id, mapper.toDomain(request));
        return ResponseEntity.ok(mapper.toResponse(updated));
    }
}
