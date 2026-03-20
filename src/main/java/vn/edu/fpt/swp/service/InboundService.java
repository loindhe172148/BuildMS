package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.*;
import vn.edu.fpt.swp.model.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Service layer for Inbound Request Management
 * 
 * UC-INB-001: Create Inbound Request
 * UC-INB-002: Approve Inbound Request
 * UC-INB-003: Execute Inbound Request
 */
public class InboundService {
    
    private RequestDAO requestDAO;
    private RequestItemDAO requestItemDAO;
    private InventoryDAO inventoryDAO;
    private ProductDAO productDAO;
    private WarehouseDAO warehouseDAO;
    private LocationDAO locationDAO;
    private UserDAO userDAO;
    
    public InboundService() {
        this.requestDAO = new RequestDAO();
        this.requestItemDAO = new RequestItemDAO();
        this.inventoryDAO = new InventoryDAO();
        this.productDAO = new ProductDAO();
        this.warehouseDAO = new WarehouseDAO();
        this.locationDAO = new LocationDAO();
        this.userDAO = new UserDAO();
    }
    
    /**
     * UC-INB-001: Create a new inbound request
     * @param request Request header information
     * @param items List of request items
     * @return Created request with ID, null if failed
     */
    public Request createInboundRequest(Request request, List<RequestItem> items) {
        // Validation
        if (request == null || items == null || items.isEmpty()) {
            return null;
        }
        
        // Validate destination warehouse
        if (request.getDestinationWarehouseId() == null) {
            return null;
        }
        
        Warehouse warehouse = warehouseDAO.findById(request.getDestinationWarehouseId());
        if (warehouse == null) {
            return null;
        }
        
        // Validate items
        List<Long> productIds = new ArrayList<>();
        for (RequestItem item : items) {
            if (item.getProductId() == null) {
                return null; // Product required
            }
            if (item.getQuantity() == null || item.getQuantity() <= 0) {
                return null; // Quantity must be positive
            }
            if (productIds.contains(item.getProductId())) {
                return null; // Duplicate product
            }
            productIds.add(item.getProductId());
            
            // Verify product is active
            Product product = productDAO.findById(item.getProductId());
            if (product == null || !product.isActive()) {
                return null; // Invalid or inactive product
            }
            
            // Validate location if specified
            if (item.getLocationId() != null) {
                Location location = locationDAO.findById(item.getLocationId());
                if (location == null || !location.isActive() || 
                    !location.getWarehouseId().equals(request.getDestinationWarehouseId())) {
                    return null; // Invalid location
                }
            }
        }
        
        // Set request type and status
        request.setType("Inbound");
        request.setStatus("Created");
        
        // Create request
        Request createdRequest = requestDAO.create(request);
        if (createdRequest == null) {
            return null;
        }
        
        // Create request items
        for (RequestItem item : items) {
            item.setRequestId(createdRequest.getId());
        }
        
        boolean itemsCreated = requestItemDAO.createBatch(items);
        if (!itemsCreated) {
            // TODO: Consider rollback
            return null;
        }
        
        return createdRequest;
    }
    
    /**
     * UC-INB-002: Approve an inbound request
     * @param requestId Request ID to approve
     * @param approverId User ID of approver
     * @return true if successful
     */
    public boolean approveRequest(Long requestId, Long approverId) {
        if (requestId == null || approverId == null) {
            return false;
        }
        
        // Verify request exists and is in Created status
        Request request = requestDAO.findById(requestId);
        if (request == null || !"Created".equals(request.getStatus()) || !"Inbound".equals(request.getType())) {
            return false;
        }
        
        return requestDAO.approve(requestId, approverId);
    }
    
    /**
     * UC-INB-002: Reject an inbound request
     * @param requestId Request ID to reject
     * @param rejectorId User ID of rejector
     * @param reason Rejection reason (required)
     * @return true if successful
     */
    public boolean rejectRequest(Long requestId, Long rejectorId, String reason) {
        if (requestId == null || rejectorId == null || reason == null || reason.trim().isEmpty()) {
            return false;
        }
        
        // Verify request exists and is in Created status
        Request request = requestDAO.findById(requestId);
        if (request == null || !"Created".equals(request.getStatus()) || !"Inbound".equals(request.getType())) {
            return false;
        }
        
        return requestDAO.reject(requestId, rejectorId, reason);
    }
    
    /**
     * UC-INB-003: Start execution of an approved inbound request
     * @param requestId Request ID
     * @return true if successful
     */
    public boolean startExecution(Long requestId) {
        if (requestId == null) {
            return false;
        }
        
        // Verify request exists and is Approved
        Request request = requestDAO.findById(requestId);
        if (request == null || !"Approved".equals(request.getStatus()) || !"Inbound".equals(request.getType())) {
            return false;
        }
        
        return requestDAO.startExecution(requestId);
    }
    
    /**
     * UC-INB-003: Update received quantities for items
     * @param requestId Request ID
     * @param productId Product ID
     * @param receivedQuantity Actual received quantity
     * @param locationId Location where received (optional update)
     * @return true if successful
     */
    public boolean updateReceivedQuantity(Long requestId, Long productId, Integer receivedQuantity, Long locationId) {
        if (requestId == null || productId == null || receivedQuantity == null || receivedQuantity < 0) {
            return false;
        }
        
        // Verify request is InProgress
        Request request = requestDAO.findById(requestId);
        if (request == null || !"InProgress".equals(request.getStatus())) {
            return false;
        }
        
        // Update received quantity
        boolean updated = requestItemDAO.updateReceivedQuantity(requestId, productId, receivedQuantity);
        
        // Optionally update location
        if (updated && locationId != null) {
            requestItemDAO.updateLocation(requestId, productId, locationId);
        }
        
        return updated;
    }
    
    /**
     * UC-INB-003: Complete inbound request execution
     * @param requestId Request ID
     * @param completedBy User ID who completed
     * @return true if successful
     */
    public boolean completeExecution(Long requestId, Long completedBy) {
        if (requestId == null || completedBy == null) {
            return false;
        }
        
        // Verify request is InProgress
        Request request = requestDAO.findById(requestId);
        if (request == null || !"InProgress".equals(request.getStatus()) || !"Inbound".equals(request.getType())) {
            return false;
        }
        
        // Get all items
        List<RequestItem> items = requestItemDAO.findByRequestId(requestId);
        if (items.isEmpty()) {
            return false;
        }
        
        // Get destination warehouse
        Long warehouseId = request.getDestinationWarehouseId();
        if (warehouseId == null) {
            return false;
        }
        
        // Update inventory for each item
        for (RequestItem item : items) {
            Integer receivedQty = item.getReceivedQuantity();
            if (receivedQty == null || receivedQty <= 0) {
                continue; // Skip items with no received quantity
            }
            
            Long locationId = item.getLocationId();
            if (locationId == null) {
                // Need a default location - get first active location in warehouse
                List<Location> locations = locationDAO.findByWarehouse(warehouseId);
                for (Location loc : locations) {
                    if (loc.isActive()) {
                        locationId = loc.getId();
                        break;
                    }
                }
                if (locationId == null) {
                    return false; // No valid location
                }
            }
            
            // Increase inventory
            boolean inventoryUpdated = inventoryDAO.increaseQuantity(
                item.getProductId(), 
                warehouseId, 
                locationId, 
                receivedQty
            );
            
            if (!inventoryUpdated) {
                // TODO: Consider rollback
                return false;
            }
        }
        
        // Mark request as completed
        return requestDAO.complete(requestId, completedBy);
    }
    
    /**
     * Get all inbound requests
     * @return List of inbound requests
     */
    public List<Request> getAllInboundRequests() {
        return requestDAO.findByType("Inbound");
    }
    
    /**
     * Get inbound requests by status
     * @param status Request status
     * @return List of matching requests
     */
    public List<Request> getInboundRequestsByStatus(String status) {
        return requestDAO.findByTypeAndStatus("Inbound", status);
    }
    
    /**
     * Search inbound requests with filters
     * @param status Status filter
     * @param warehouseId Warehouse filter
     * @return List of matching requests
     */
    public List<Request> searchInboundRequests(String status, Long warehouseId) {
        return requestDAO.search("Inbound", status, warehouseId);
    }
    
    /**
     * Get request by ID
     * @param requestId Request ID
     * @return Request if found and is Inbound type
     */
    public Request getRequestById(Long requestId) {
        Request request = requestDAO.findById(requestId);
        if (request != null && "Inbound".equals(request.getType())) {
            return request;
        }
        return null;
    }
    
    /**
     * Get items for a request
     * @param requestId Request ID
     * @return List of request items
     */
    public List<RequestItem> getRequestItems(Long requestId) {
        return requestItemDAO.findByRequestId(requestId);
    }
    
    /**
     * Get user by ID (for display)
     * @param userId User ID
     * @return User if found
     */
    public User getUserById(Long userId) {
        return userDAO.findById(userId);
    }
    
    /**
     * Get warehouse by ID
     * @param warehouseId Warehouse ID
     * @return Warehouse if found
     */
    public Warehouse getWarehouseById(Long warehouseId) {
        return warehouseDAO.findById(warehouseId);
    }
    
    /**
     * Get product by ID
     * @param productId Product ID
     * @return Product if found
     */
    public Product getProductById(Long productId) {
        return productDAO.findById(productId);
    }
    
    /**
     * Get all warehouses
     * @return List of all warehouses
     */
    public List<Warehouse> getAllWarehouses() {
        return warehouseDAO.getAll();
    }
    
    /**
     * Get all active products
     * @return List of active products
     */
    public List<Product> getActiveProducts() {
        return productDAO.getActive();
    }
    
    /**
     * Get locations for a warehouse
     * @param warehouseId Warehouse ID
     * @return List of locations
     */
    public List<Location> getWarehouseLocations(Long warehouseId) {
        return locationDAO.findByWarehouse(warehouseId);
    }
    
    /**
     * Get location by ID
     * @param locationId Location ID
     * @return Location if found
     */
    public Location getLocationById(Long locationId) {
        return locationDAO.findById(locationId);
    }
}
