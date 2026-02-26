package vn.edu.fpt.swp.model;

import java.io.Serializable;

/**
 * Inventory entity representing product inventory at a specific location
 */
public class Inventory implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long productId;
    private Long warehouseId;
    private Long locationId;
    private Integer quantity;
    
    // Default constructor
    public Inventory() {
        this.quantity = 0;
    }
    
    // Constructor with parameters
    public Inventory(Long productId, Long warehouseId, Long locationId, Integer quantity) {
        this.productId = productId;
        this.warehouseId = warehouseId;
        this.locationId = locationId;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public Long getProductId() {
        return productId;
    }
    
    public void setProductId(Long productId) {
        this.productId = productId;
    }
    
    public Long getWarehouseId() {
        return warehouseId;
    }
    
    public void setWarehouseId(Long warehouseId) {
        this.warehouseId = warehouseId;
    }
    
    public Long getLocationId() {
        return locationId;
    }
    
    public void setLocationId(Long locationId) {
        this.locationId = locationId;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    @Override
    public String toString() {
        return "Inventory{" +
                "productId=" + productId +
                ", warehouseId=" + warehouseId +
                ", locationId=" + locationId +
                ", quantity=" + quantity +
                '}';
    }
}
