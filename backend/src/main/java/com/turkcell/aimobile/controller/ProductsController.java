package com.turkcell.aimobile.controller;

import com.turkcell.aimobile.dto.CreateProductRequest;
import com.turkcell.aimobile.dto.PagedProductResponse;
import com.turkcell.aimobile.dto.ProductResponse;
import com.turkcell.aimobile.dto.UpdateProductRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/products")
public class ProductsController {

    @GetMapping
    public ResponseEntity<PagedProductResponse> listProducts(
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size,
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String sort) {
        // TODO: Implement
        return ResponseEntity.ok(new PagedProductResponse());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductResponse> getProductById(@PathVariable String id) {
        // TODO: Implement
        return ResponseEntity.ok(new ProductResponse());
    }

    @PostMapping
    public ResponseEntity<ProductResponse> createProduct(@Valid @RequestBody CreateProductRequest request) {
        // TODO: Implement
        return ResponseEntity.status(HttpStatus.CREATED).body(new ProductResponse());
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductResponse> updateProduct(
            @PathVariable String id,
            @Valid @RequestBody UpdateProductRequest request) {
        // TODO: Implement
        return ResponseEntity.ok(new ProductResponse());
    }
}
