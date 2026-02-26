package vn.edu.fpt.swp.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Product entity representing a product in the system
 */
public class Product implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private String sku;
    private String name;
    private String unit;
    private Long categoryId;
    private boolean isActive;
    private LocalDateTime createdAt;
    
    
    // Default constructor
    public Product() {
        this.isActive = true;
        this.createdAt = LocalDateTime.now();
    }
    
    // Constructor with parameters
    public Product(String sku, String name, String unit, Long categoryId) {
        this();
        this.sku = sku;
        this.name = name;
        this.unit = unit;
        this.categoryId = categoryId;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", sku='" + sku + '\'' +
                ", name='" + name + '\'' +
                ", unit='" + unit + '\'' +
                ", categoryId=" + categoryId +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}
