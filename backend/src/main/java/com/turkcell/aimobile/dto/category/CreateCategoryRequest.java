package com.turkcell.aimobile.dto.category;

import jakarta.validation.constraints.*;

public class CreateCategoryRequest {
    @NotBlank
    @Size(min = 2, max = 120)
    private String name;

    @Size(max = 1000)
    private String description;

    private String parentId;

    private Integer ordering = 0;

    private Boolean isActive = true;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getParentId() { return parentId; }
    public void setParentId(String parentId) { this.parentId = parentId; }
    public Integer getOrdering() { return ordering; }
    public void setOrdering(Integer ordering) { this.ordering = ordering; }
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
}
