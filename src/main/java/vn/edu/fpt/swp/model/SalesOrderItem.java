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
    private Integer fulfilledQuantity;
    
    // Default constructor
    public SalesOrderItem() {
        this.fulfilledQuantity = 0;
    }
    
    // Constructor with parameters
    public SalesOrderItem(Long salesOrderId, Long productId, Integer quantity) {
        this.salesOrderId = salesOrderId;
        this.productId = productId;
        this.quantity = quantity;
        this.fulfilledQuantity = 0;
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

    public Integer getFulfilledQuantity() {
        return fulfilledQuantity;
    }

    public void setFulfilledQuantity(Integer fulfilledQuantity) {
        this.fulfilledQuantity = fulfilledQuantity;
    }

    public Integer getRemainingQuantity() {
        int qty = quantity != null ? quantity : 0;
        int fulfilled = fulfilledQuantity != null ? fulfilledQuantity : 0;
        return qty - fulfilled;
    }
    
    @Override
    public String toString() {
        return "SalesOrderItem{" +
                "salesOrderId=" + salesOrderId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", fulfilledQuantity=" + fulfilledQuantity +
                '}';
    }
}
