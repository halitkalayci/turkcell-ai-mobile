package com.turkcell.aimobile.web.controller.v2;

import com.turkcell.aimobile.application.ProductApplicationService;
import com.turkcell.aimobile.dto.v2.CreateProductV2Request;
import com.turkcell.aimobile.dto.v2.PagedProductV2Response;
import com.turkcell.aimobile.dto.v2.ProductV2Response;
import com.turkcell.aimobile.dto.v2.UpdateProductV2Request;
import com.turkcell.aimobile.model.Product;
import com.turkcell.aimobile.web.mapper.ProductV2WebMapper;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v2/products")
@CrossOrigin(origins = "*")
public class ProductsV2Controller {

    private final ProductApplicationService productService;
    private final ProductV2WebMapper mapper = new ProductV2WebMapper();

    public ProductsV2Controller(ProductApplicationService productService) {
        this.productService = productService;
    }

    @GetMapping
    public ResponseEntity<PagedProductV2Response> listProducts(
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size,
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String categoryId,
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
        var items = productService.listV2(page, size, q, categoryId, sortBy, asc);
        long total = productService.countV2(categoryId);
        return ResponseEntity.ok(mapper.toPagedResponse(items, page, size, total));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductV2Response> getProductById(@PathVariable String id) {
        Product product = productService.getById(id);
        return ResponseEntity.ok(mapper.toResponse(product));
    }

    @PostMapping
    public ResponseEntity<ProductV2Response> createProduct(@Valid @RequestBody CreateProductV2Request request) {
        Product created = productService.create(mapper.toDomain(request));
        return ResponseEntity.status(HttpStatus.CREATED).body(mapper.toResponse(created));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductV2Response> updateProduct(
            @PathVariable String id,
            @Valid @RequestBody UpdateProductV2Request request) {
        Product updated = productService.update(id, mapper.toDomain(request));
        return ResponseEntity.ok(mapper.toResponse(updated));
    }
}
