package vn.edu.fpt.swp.model;

import java.io.Serializable;

/**
 * RequestItem entity representing an item in a warehouse request
 */
public class RequestItem implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long requestId;
    private Long productId;
    private Integer quantity;
    private Long locationId; // Target location for Inbound
    private Long sourceLocationId; // For Internal Movement
    private Long destinationLocationId; // For Internal Movement
    private Integer receivedQuantity; // Actual received for Inbound
    private Integer pickedQuantity; // Actual picked for Outbound
    
    // Default constructor
    public RequestItem() {
    }
    
    // Constructor with parameters
    public RequestItem(Long requestId, Long productId, Integer quantity) {
        this.requestId = requestId;
        this.productId = productId;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public Long getRequestId() {
        return requestId;
    }
    
    public void setRequestId(Long requestId) {
        this.requestId = requestId;
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

    public Long getLocationId() {
        return locationId;
    }

    public void setLocationId(Long locationId) {
        this.locationId = locationId;
    }

    public Long getSourceLocationId() {
        return sourceLocationId;
    }

    public void setSourceLocationId(Long sourceLocationId) {
        this.sourceLocationId = sourceLocationId;
    }

    public Long getDestinationLocationId() {
        return destinationLocationId;
    }

    public void setDestinationLocationId(Long destinationLocationId) {
        this.destinationLocationId = destinationLocationId;
    }

    public Integer getReceivedQuantity() {
        return receivedQuantity;
    }

    public void setReceivedQuantity(Integer receivedQuantity) {
        this.receivedQuantity = receivedQuantity;
    }

    public Integer getPickedQuantity() {
        return pickedQuantity;
    }

    public void setPickedQuantity(Integer pickedQuantity) {
        this.pickedQuantity = pickedQuantity;
    }
    
    @Override
    public String toString() {
        return "RequestItem{" +
                "requestId=" + requestId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", locationId=" + locationId +
                ", receivedQuantity=" + receivedQuantity +
                ", pickedQuantity=" + pickedQuantity +
                '}';
    }
}
