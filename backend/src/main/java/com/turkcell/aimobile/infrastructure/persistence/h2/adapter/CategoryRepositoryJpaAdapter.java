package com.turkcell.aimobile.infrastructure.persistence.h2.adapter;

import com.turkcell.aimobile.domain.port.CategoryRepositoryPort;
import com.turkcell.aimobile.infrastructure.mapper.CategoryEntityMapper;
import com.turkcell.aimobile.infrastructure.persistence.h2.entity.CategoryEntity;
import com.turkcell.aimobile.infrastructure.persistence.h2.repository.CategoryJpaRepository;
import com.turkcell.aimobile.model.Category;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class CategoryRepositoryJpaAdapter implements CategoryRepositoryPort {

    private final CategoryJpaRepository jpaRepository;
    private final CategoryEntityMapper mapper = new CategoryEntityMapper();

    public CategoryRepositoryJpaAdapter(CategoryJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Category save(Category category) {
        CategoryEntity saved = jpaRepository.save(mapper.toEntity(category));
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Category> findById(String id) {
        return jpaRepository.findById(id).map(mapper::toDomain);
    }

    @Override
    public boolean existsByNameAndParentId(String name, String parentId) {
        return jpaRepository.existsByNameAndParentId(name, parentId);
    }

    @Override
    public List<Category> findActiveOrdered(int page, int size) {
        return jpaRepository.findByIsActiveTrueOrderByOrderingAsc(PageRequest.of(page, size))
                .map(mapper::toDomain)
                .getContent();
    }

    @Override
    public long countActive() {
        return jpaRepository.countByIsActiveTrue();
    }

    @Override
    public List<Category> findChildren(String parentId) {
        return jpaRepository.findByParentId(parentId).stream().map(mapper::toDomain).toList();
    }

    @Override
    public boolean existsByIdAndIsActiveTrue(String id) {
        return jpaRepository.existsByIdAndIsActiveTrue(id);
    }
}