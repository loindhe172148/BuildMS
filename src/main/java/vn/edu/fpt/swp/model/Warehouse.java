package vn.edu.fpt.swp.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Warehouse entity representing a warehouse in the system
 */
public class Warehouse implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private String name;
    private String location;
    private LocalDateTime createdAt;
    
    // Default constructor
    public Warehouse() {
        this.createdAt = LocalDateTime.now();
    }
    
    // Constructor with parameters
    public Warehouse(String name, String location) {
        this();
        this.name = name;
        this.location = location;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "Warehouse{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", location='" + location + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
