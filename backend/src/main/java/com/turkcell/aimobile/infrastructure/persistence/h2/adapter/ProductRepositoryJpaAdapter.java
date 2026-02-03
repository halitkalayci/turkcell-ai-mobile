package com.turkcell.aimobile.infrastructure.persistence.h2.adapter;

import com.turkcell.aimobile.domain.port.ProductRepositoryPort;
import com.turkcell.aimobile.infrastructure.mapper.ProductEntityMapper;
import com.turkcell.aimobile.infrastructure.persistence.h2.entity.ProductEntity;
import com.turkcell.aimobile.infrastructure.persistence.h2.repository.ProductJpaRepository;
import com.turkcell.aimobile.model.Product;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class ProductRepositoryJpaAdapter implements ProductRepositoryPort {

    private final ProductJpaRepository jpaRepository;
    private final ProductEntityMapper mapper = new ProductEntityMapper();

    public ProductRepositoryJpaAdapter(ProductJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Product save(Product product) {
        ProductEntity saved = jpaRepository.save(mapper.toEntity(product));
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Product> findById(String id) {
        return jpaRepository.findByIdAndIsActiveTrue(id).map(mapper::toDomain);
    }

    @Override
    public boolean existsByName(String name) {
        return jpaRepository.existsByName(name);
    }

    @Override
    public boolean existsBySku(String sku) {
        return jpaRepository.existsBySku(sku);
    }

    @Override
    public List<Product> findAll(int page, int size, String sortBy, boolean asc) {
        Sort sort = Sort.by(asc ? Sort.Direction.ASC : Sort.Direction.DESC, sortBy == null ? "createdAt" : sortBy);
        return jpaRepository.findByIsActiveTrue(PageRequest.of(page, size, sort))
                .map(mapper::toDomain)
                .getContent();
    }

    @Override
    public List<Product> search(String q, int page, int size, String sortBy, boolean asc) {
        Sort sort = Sort.by(asc ? Sort.Direction.ASC : Sort.Direction.DESC, sortBy == null ? "createdAt" : sortBy);
        return jpaRepository.searchActive(q, PageRequest.of(page, size, sort))
                .map(mapper::toDomain)
                .getContent();
    }

    @Override
    public void deleteById(String id) {
        jpaRepository.deleteById(id);
    }

    @Override
    public long count() {
        return jpaRepository.countByIsActiveTrue();
    }

    @Override
    public List<Product> findAllByCategory(String categoryId, int page, int size, String sortBy, boolean asc) {
        Sort sort = Sort.by(asc ? Sort.Direction.ASC : Sort.Direction.DESC, sortBy == null ? "createdAt" : sortBy);
        return jpaRepository.findByIsActiveTrueAndCategoryId(categoryId, PageRequest.of(page, size, sort))
                .map(mapper::toDomain)
                .getContent();
    }

    @Override
    public List<Product> searchByCategory(String categoryId, String q, int page, int size, String sortBy, boolean asc) {
        Sort sort = Sort.by(asc ? Sort.Direction.ASC : Sort.Direction.DESC, sortBy == null ? "createdAt" : sortBy);
        return jpaRepository.searchActiveByCategory(q, categoryId, PageRequest.of(page, size, sort))
                .map(mapper::toDomain)
                .getContent();
    }

    @Override
    public long countByCategory(String categoryId) {
        return jpaRepository.countByIsActiveTrueAndCategoryId(categoryId);
    }
}
