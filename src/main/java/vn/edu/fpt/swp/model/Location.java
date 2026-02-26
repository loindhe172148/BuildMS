package vn.edu.fpt.swp.model;

import java.io.Serializable;

/**
 * Location entity representing a storage location (bin) in the warehouse
 */
public class Location implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private Long warehouseId;
    private String code;
    private String type; // Storage / Picking / Staging
    private boolean isActive;
    
    // Default constructor
    public Location() {
        this.isActive = true;
    }
    
    // Constructor with parameters
    public Location(Long warehouseId, String code, String type) {
        this();
        this.warehouseId = warehouseId;
        this.code = code;
        this.type = type;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getWarehouseId() {
        return warehouseId;
    }
    
    public void setWarehouseId(Long warehouseId) {
        this.warehouseId = warehouseId;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    @Override
    public String toString() {
        return "Location{" +
                "id=" + id +
                ", warehouseId=" + warehouseId +
                ", code='" + code + '\'' +
                ", type='" + type + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}
