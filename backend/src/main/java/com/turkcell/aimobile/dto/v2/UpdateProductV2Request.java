package com.turkcell.aimobile.dto.v2;

import jakarta.validation.constraints.*;

public class UpdateProductV2Request {

    @NotBlank
    @Size(min = 2, max = 120)
    private String name;

    @Size(min = 2, max = 64)
    private String sku;

    @Size(max = 1000)
    private String description;

    @NotNull
    @DecimalMin("0.0")
    private Double price;

    @Size(min = 3, max = 3)
    private String currency;

    @NotNull
    private Boolean isActive;

    @NotBlank
    private String categoryId;

    @Size(max = 1024)
    private String imageUrl;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
    public String getCategoryId() { return categoryId; }
    public void setCategoryId(String categoryId) { this.categoryId = categoryId; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
