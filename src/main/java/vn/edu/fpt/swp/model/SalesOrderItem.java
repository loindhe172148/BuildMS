package vn.edu.fpt.swp.model;

import java.io.Serializable;

/**
 * SalesOrderItem entity representing an item in a sales order
 */
public class SalesOrderItem implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long salesOrderId;
    private Long productId;
    private Integer quantity;
    
    // Default constructor
    public SalesOrderItem() {
    }
    
    // Constructor with parameters
    public SalesOrderItem(Long salesOrderId, Long productId, Integer quantity) {
        this.salesOrderId = salesOrderId;
        this.productId = productId;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public Long getSalesOrderId() {
        return salesOrderId;
    }
    
    public void setSalesOrderId(Long salesOrderId) {
        this.salesOrderId = salesOrderId;
    }
    
    public Long getProductId() {
        return productId;
    }
    
    public void setProductId(Long productId) {
        this.productId = productId;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    @Override
    public String toString() {
        return "SalesOrderItem{" +
                "salesOrderId=" + salesOrderId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                '}';
    }
}
