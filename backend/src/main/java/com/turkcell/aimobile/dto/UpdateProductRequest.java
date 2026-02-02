package com.turkcell.aimobile.dto;

import jakarta.validation.constraints.*;

public class UpdateProductRequest {

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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}
