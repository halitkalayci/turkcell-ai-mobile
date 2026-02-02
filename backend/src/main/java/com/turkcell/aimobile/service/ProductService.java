package com.turkcell.aimobile.service;

import com.turkcell.aimobile.dto.CreateProductRequest;
import com.turkcell.aimobile.dto.PagedProductResponse;
import com.turkcell.aimobile.dto.ProductResponse;
import com.turkcell.aimobile.dto.UpdateProductRequest;
import com.turkcell.aimobile.exception.ConflictException;
import com.turkcell.aimobile.exception.ProductNotFoundException;
import com.turkcell.aimobile.mapper.ProductMapper;
import com.turkcell.aimobile.model.Product;
import com.turkcell.aimobile.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductService {
    private final ProductRepository repository;
    private final ProductMapper mapper;

    public ProductService(ProductRepository repository, ProductMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    public PagedProductResponse listProducts(Integer page, Integer size, String query, String sort) {
        List<Product> allProducts = query != null && !query.isBlank()
                ? repository.search(query)
                : repository.findAll();

        allProducts = applySorting(allProducts, sort);

        int totalItems = allProducts.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);

        int start = page * size;
        int end = Math.min(start + size, totalItems);

        List<ProductResponse> items = allProducts.subList(start, end).stream()
                .map(mapper::toResponse)
                .collect(Collectors.toList());

        PagedProductResponse response = new PagedProductResponse();
        response.setItems(items);
        response.setPage(page);
        response.setSize(size);
        response.setTotalItems((long) totalItems);
        response.setTotalPages((int) totalPages);

        return response;
    }

    public ProductResponse getProductById(String id) {
        Product product = repository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException("Product not found."));
        return mapper.toResponse(product);
    }

    public ProductResponse createProduct(CreateProductRequest request) {
        if (repository.existsByName(request.getName())) {
            throw new ConflictException("PRODUCT_NAME_ALREADY_EXISTS");
        }

        if (request.getSku() != null && !request.getSku().isBlank()) {
            if (repository.existsBySku(request.getSku())) {
                throw new ConflictException("CONFLICT");
            }
        }

        Product product = mapper.toEntity(request);
        Product saved = repository.save(product);
        return mapper.toResponse(saved);
    }

    public ProductResponse updateProduct(String id, UpdateProductRequest request) {
        Product product = repository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException("Product not found."));

        if (!product.getName().equalsIgnoreCase(request.getName())) {
            if (repository.existsByNameExcludingId(request.getName(), id)) {
                throw new ConflictException("PRODUCT_NAME_ALREADY_EXISTS");
            }
        }

        if (request.getSku() != null && !request.getSku().isBlank()) {
            if (!request.getSku().equalsIgnoreCase(product.getSku())) {
                if (repository.existsBySkuExcludingId(request.getSku(), id)) {
                    throw new ConflictException("CONFLICT");
                }
            }
        }

        mapper.updateEntity(product, request);
        Product updated = repository.save(product);
        return mapper.toResponse(updated);
    }

    private List<Product> applySorting(List<Product> products, String sort) {
        if (sort == null || sort.isBlank()) {
            return products;
        }

        String[] parts = sort.split(",");
        if (parts.length != 2) {
            return products;
        }

        String field = parts[0].trim();
        String direction = parts[1].trim();

        Comparator<Product> comparator = null;

        switch (field) {
            case "name":
                comparator = Comparator.comparing(Product::getName, String.CASE_INSENSITIVE_ORDER);
                break;
            case "price":
                comparator = Comparator.comparing(Product::getPrice);
                break;
            case "createdAt":
                comparator = Comparator.comparing(Product::getCreatedAt);
                break;
            default:
                return products;
        }

        if ("desc".equalsIgnoreCase(direction)) {
            comparator = comparator.reversed();
        }

        return products.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }
}
