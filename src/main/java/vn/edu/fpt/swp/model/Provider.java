package vn.edu.fpt.swp.model;

import java.io.Serializable;

/**
 * Provider entity representing a provider/supplier in the system
 */
public class Provider implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private String code;
    private String name;
    private String contactInfo;
    private String status;
    
    // Default constructor
    public Provider() {
        this.status = "Active";
    }
    
    // Constructor with parameters
    public Provider(String code, String name, String contactInfo) {
        this();
        this.code = code;
        this.name = name;
        this.contactInfo = contactInfo;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getContactInfo() {
        return contactInfo;
    }
    
    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    @Override
    public String toString() {
        return "Provider{" +
                "id=" + id +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", contactInfo='" + contactInfo + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
