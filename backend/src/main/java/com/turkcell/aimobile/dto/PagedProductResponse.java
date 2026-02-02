package com.turkcell.aimobile.dto;

import java.util.List;

public class PagedProductResponse {

    private List<ProductResponse> items;
    private Integer page;
    private Integer size;
    private Long totalItems;
    private Integer totalPages;

    public List<ProductResponse> getItems() {
        return items;
    }

    public void setItems(List<ProductResponse> items) {
        this.items = items;
    }

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public Long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(Long totalItems) {
        this.totalItems = totalItems;
    }

    public Integer getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(Integer totalPages) {
        this.totalPages = totalPages;
    }
}
