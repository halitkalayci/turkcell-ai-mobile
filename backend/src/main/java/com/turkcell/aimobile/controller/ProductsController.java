package com.turkcell.aimobile.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
public class ProductsController {

    @GetMapping
    public ResponseEntity<?> getAllProducts() {
        // TODO: Implement
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getProductById(@PathVariable Long id) {
        // TODO: Implement
        return ResponseEntity.ok().build();
    }

    @PostMapping
    public ResponseEntity<?> createProduct(@RequestBody Object request) {
        // TODO: Implement
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateProduct(@PathVariable Long id, @RequestBody Object request) {
        // TODO: Implement
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProduct(@PathVariable Long id) {
        // TODO: Implement
        return ResponseEntity.ok().build();
    }
}
