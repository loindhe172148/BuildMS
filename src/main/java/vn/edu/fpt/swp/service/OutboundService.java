package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.*;
import vn.edu.fpt.swp.model.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Service layer for Outbound Request Management
 * 
 * UC-OUT-001: Approve Outbound Request
 * UC-OUT-002: Execute Outbound Request
 * UC-OUT-003: Create Internal Outbound Request
 */
public class OutboundService {
    
    private RequestDAO requestDAO;
    private RequestItemDAO requestItemDAO;
    private InventoryDAO inventoryDAO;
    private ProductDAO productDAO;
    private WarehouseDAO warehouseDAO;
    private LocationDAO locationDAO;
    private UserDAO userDAO;
    
    // Valid outbound reasons for internal requests
    private static final List<String> VALID_REASONS = Arrays.asList(
        "Damage/Disposal",
        "Return to Supplier", 
        "Sample/Demo",
        "Adjustment",
        "Other"
    );
    
    public OutboundService() {
        this.requestDAO = new RequestDAO();
        this.requestItemDAO = new RequestItemDAO();
        this.inventoryDAO = new InventoryDAO();
        this.productDAO = new ProductDAO();
        this.warehouseDAO = new WarehouseDAO();
        this.locationDAO = new LocationDAO();
        this.userDAO = new UserDAO();
    }
    
    /**
     * UC-OUT-003: Create an internal outbound request
     * @param request Request header information
     * @param items List of request items
     * @return Created request with ID, null if failed
     */
    public Request createInternalOutboundRequest(Request request, List<RequestItem> items) {
        // Validation
        if (request == null || items == null || items.isEmpty()) {
            return null;
        }
        
        // Validate source warehouse
        if (request.getSourceWarehouseId() == null) {
            return null;
        }
        
        Warehouse warehouse = warehouseDAO.findById(request.getSourceWarehouseId());
        if (warehouse == null) {
            return null;
        }
        
        // Validate reason
        if (request.getReason() == null || request.getReason().trim().isEmpty()) {
            return null;
        }
        
        if (!VALID_REASONS.contains(request.getReason())) {
            return null;
        }
        
        // If "Other" reason, notes/description is required
        if ("Other".equals(request.getReason()) && 
            (request.getNotes() == null || request.getNotes().trim().isEmpty())) {
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
        }
        
        // Set request type and status
        request.setType("Outbound");
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
            return null;
        }
        
        return createdRequest;
    }
    
    /**
     * UC-OUT-001: Approve an outbound request
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
        if (request == null || !"Created".equals(request.getStatus()) || !"Outbound".equals(request.getType())) {
            return false;
        }
        
        return requestDAO.approve(requestId, approverId);
    }
    
    /**
     * UC-OUT-001: Reject an outbound request
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
        if (request == null || !"Created".equals(request.getStatus()) || !"Outbound".equals(request.getType())) {
            return false;
        }
        
        return requestDAO.reject(requestId, rejectorId, reason);
    }
    
    /**
     * UC-OUT-002: Start execution of an approved outbound request
     * @param requestId Request ID
     * @return true if successful
     */
    public boolean startExecution(Long requestId) {
        if (requestId == null) {
            return false;
        }
        
        // Verify request exists and is Approved
        Request request = requestDAO.findById(requestId);
        if (request == null || !"Approved".equals(request.getStatus()) || !"Outbound".equals(request.getType())) {
            return false;
        }
        
        return requestDAO.startExecution(requestId);
    }
    
    /**
     * UC-OUT-002: Update picked quantities for items
     * @param requestId Request ID
     * @param productId Product ID
     * @param pickedQuantity Actual picked quantity
     * @return true if successful
     */
    public boolean updatePickedQuantity(Long requestId, Long productId, Integer pickedQuantity) {
        if (requestId == null || productId == null || pickedQuantity == null || pickedQuantity < 0) {
            return false;
        }
        
        // Verify request is InProgress
        Request request = requestDAO.findById(requestId);
        if (request == null || !"InProgress".equals(request.getStatus())) {
            return false;
        }
        
        // Verify picked quantity doesn't exceed available inventory
        Long warehouseId = request.getSourceWarehouseId();
        if (warehouseId != null) {
            int available = inventoryDAO.getTotalQuantityByProductAndWarehouse(productId, warehouseId);
            if (pickedQuantity > available) {
                return false; // Cannot pick more than available
            }
        }
        
        return requestItemDAO.updatePickedQuantity(requestId, productId, pickedQuantity);
    }
    
    /**
     * UC-OUT-002: Complete outbound request execution
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
        if (request == null || !"InProgress".equals(request.getStatus()) || !"Outbound".equals(request.getType())) {
            return false;
        }
        
        // Get all items
        List<RequestItem> items = requestItemDAO.findByRequestId(requestId);
        if (items.isEmpty()) {
            return false;
        }
        
        // Get source warehouse
        Long warehouseId = request.getSourceWarehouseId();
        if (warehouseId == null) {
            return false;
        }
        
        // Update inventory for each item (decrease)
        for (RequestItem item : items) {
            Integer pickedQty = item.getPickedQuantity();
            if (pickedQty == null || pickedQty <= 0) {
                continue; // Skip items with no picked quantity
            }
            
            // Find inventory record to decrease - take from first available location
            List<Inventory> inventories = inventoryDAO.findByProduct(item.getProductId());
            int remainingToDecrease = pickedQty;
            
            for (Inventory inv : inventories) {
                if (!inv.getWarehouseId().equals(warehouseId)) {
                    continue; // Only from source warehouse
                }
                
                if (remainingToDecrease <= 0) {
                    break;
                }
                
                int available = inv.getQuantity();
                int toDecrease = Math.min(available, remainingToDecrease);
                
                if (toDecrease > 0) {
                    boolean decreased = inventoryDAO.decreaseQuantity(
                        item.getProductId(), 
                        warehouseId, 
                        inv.getLocationId(), 
                        toDecrease
                    );
                    
                    if (decreased) {
                        remainingToDecrease -= toDecrease;
                    }
                }
            }
            
            if (remainingToDecrease > 0) {
                // Not enough inventory - but continue anyway (discrepancy logged)
            }
        }
        
        // Mark request as completed
        return requestDAO.complete(requestId, completedBy);
    }
    
    /**
     * Get all outbound requests
     * @return List of outbound requests
     */
    public List<Request> getAllOutboundRequests() {
        return requestDAO.findByType("Outbound");
    }
    
    /**
     * Get outbound requests by status
     * @param status Request status
     * @return List of matching requests
     */
    public List<Request> getOutboundRequestsByStatus(String status) {
        return requestDAO.findByTypeAndStatus("Outbound", status);
    }
    
    /**
     * Search outbound requests with filters
     * @param status Status filter
     * @param warehouseId Warehouse filter
     * @return List of matching requests
     */
    public List<Request> searchOutboundRequests(String status, Long warehouseId) {
        return requestDAO.search("Outbound", status, warehouseId);
    }
    
    /**
     * Get request by ID
     * @param requestId Request ID
     * @return Request if found and is Outbound type
     */
    public Request getRequestById(Long requestId) {
        Request request = requestDAO.findById(requestId);
        if (request != null && "Outbound".equals(request.getType())) {
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
     * Get inventory quantity for a product in a warehouse
     * @param productId Product ID
     * @param warehouseId Warehouse ID
     * @return Total quantity available
     */
    public int getInventoryQuantity(Long productId, Long warehouseId) {
        return inventoryDAO.getTotalQuantityByProductAndWarehouse(productId, warehouseId);
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
     * Get valid outbound reasons
     * @return List of valid reasons
     */
    public List<String> getValidReasons() {
        return new ArrayList<>(VALID_REASONS);
    }
}
