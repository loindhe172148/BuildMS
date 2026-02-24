package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.RequestItemDAO;
import vn.edu.fpt.swp.dao.ProductDAO;
import vn.edu.fpt.swp.dao.InventoryDAO;
import vn.edu.fpt.swp.dao.LocationDAO;
import vn.edu.fpt.swp.dao.WarehouseDAO;
import vn.edu.fpt.swp.dao.UserDAO;
import vn.edu.fpt.swp.dao.RequestDAO;
import vn.edu.fpt.swp.model.Location;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.model.Warehouse;
import vn.edu.fpt.swp.model.Product;
import vn.edu.fpt.swp.model.RequestItem;
import vn.edu.fpt.swp.model.Request;
import vn.edu.fpt.swp.model.Inventory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service layer for Inter-Warehouse Transfer Management
 * 
 * UC-TRF-001: Create Inter-Warehouse Transfer Request
 * UC-TRF-002: Execute Transfer Outbound
 * UC-TRF-003: Execute Transfer Inbound
 */
public class TransferService {
    
    private RequestDAO requestDAO;
    private RequestItemDAO requestItemDAO;
    private InventoryDAO inventoryDAO;
    private ProductDAO productDAO;
    private WarehouseDAO warehouseDAO;
    private LocationDAO locationDAO;
    private UserDAO userDAO;
    
    public TransferService() {
        this.requestDAO = new RequestDAO();
        this.requestItemDAO = new RequestItemDAO();
        this.inventoryDAO = new InventoryDAO();
        this.productDAO = new ProductDAO();
        this.warehouseDAO = new WarehouseDAO();
        this.locationDAO = new LocationDAO();
        this.userDAO = new UserDAO();
    }
    
    // ========== UC-TRF-001: Create Inter-Warehouse Transfer Request ==========
    
    /**
     * Create a new transfer request with linked outbound and inbound requests
     * @param sourceWarehouseId Source warehouse ID
     * @param destinationWarehouseId Destination warehouse ID
     * @param createdBy User creating the request
     * @param items List of items to transfer
     * @param notes Optional notes
     * @return Created transfer request, null if failed
     */
    public Request createTransferRequest(Long sourceWarehouseId, Long destinationWarehouseId,
                                         Long createdBy, List<RequestItem> items, String notes) {
        // Validate inputs
        if (sourceWarehouseId == null || destinationWarehouseId == null || 
            createdBy == null || items == null || items.isEmpty()) {
            return null;
        }
        
        // Source and destination must be different
        if (sourceWarehouseId.equals(destinationWarehouseId)) {
            return null;
        }
        
        // Validate warehouses exist
        Warehouse sourceWarehouse = warehouseDAO.findById(sourceWarehouseId);
        Warehouse destWarehouse = warehouseDAO.findById(destinationWarehouseId);
        if (sourceWarehouse == null || destWarehouse == null) {
            return null;
        }
        
        // Validate items - no duplicates, valid products
        List<Long> productIds = new ArrayList<>();
        for (RequestItem item : items) {
            if (item.getProductId() == null) {
                return null;
            }
            if (item.getQuantity() == null || item.getQuantity() <= 0) {
                return null;
            }
            if (productIds.contains(item.getProductId())) {
                return null; // Duplicate
            }
            productIds.add(item.getProductId());
            
            // Verify product exists and is active
            Product product = productDAO.findById(item.getProductId());
            if (product == null || !product.isActive()) {
                return null;
            }
        }
        
        // Create the main transfer request
        Request transferRequest = new Request();
        transferRequest.setType("Transfer");
        transferRequest.setStatus("Created");
        transferRequest.setSourceWarehouseId(sourceWarehouseId);
        transferRequest.setDestinationWarehouseId(destinationWarehouseId);
        transferRequest.setCreatedBy(createdBy);
        transferRequest.setNotes(notes);
        
        Request createdTransfer = requestDAO.create(transferRequest);
        if (createdTransfer == null) {
            return null;
        }
        
        // Create transfer items
        for (RequestItem item : items) {
            item.setRequestId(createdTransfer.getId());
        }
        
        boolean itemsCreated = requestItemDAO.createBatch(items);
        if (!itemsCreated) {
            return null;
        }
        
        return createdTransfer;
    }
    
    /**
     * Get all transfer requests
     * @return List of all transfer requests
     */
    public List<Request> getAllTransferRequests() {
        return requestDAO.findByType("Transfer");
    }
    
    /**
     * Get transfer requests by status
     * @param status Request status
     * @return List of matching requests
     */
    public List<Request> getTransferRequestsByStatus(String status) {
        return requestDAO.findByTypeAndStatus("Transfer", status);
    }
    
    /**
     * Get transfer request by ID
     * @param requestId Request ID
     * @return Request if found and is Transfer type
     */
    public Request getTransferRequestById(Long requestId) {
        Request request = requestDAO.findById(requestId);
        if (request != null && "Transfer".equals(request.getType())) {
            return request;
        }
        return null;
    }
    
    /**
     * Get items for a transfer request with product details
     * @param requestId Request ID
     * @return List of items with product info
     */
    public List<Map<String, Object>> getTransferItemsWithDetails(Long requestId) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<RequestItem> items = requestItemDAO.findByRequestId(requestId);
        
        for (RequestItem item : items) {
            Map<String, Object> itemData = new HashMap<>();
            itemData.put("item", item);
            
            Product product = productDAO.findById(item.getProductId());
            if (product != null) {
                itemData.put("product", product);
            }
            
            result.add(itemData);
        }
        
        return result;
    }
    
    /**
     * Check inventory availability at source warehouse
     * @param requestId Transfer request ID
     * @return List of availability info per item
     */
    public List<Map<String, Object>> checkTransferAvailability(Long requestId) {
        Request request = getTransferRequestById(requestId);
        if (request == null) {
            return new ArrayList<>();
        }
        
        List<Map<String, Object>> result = new ArrayList<>();
        List<RequestItem> items = requestItemDAO.findByRequestId(requestId);
        
        for (RequestItem item : items) {
            Map<String, Object> availability = new HashMap<>();
            availability.put("item", item);
            
            Product product = productDAO.findById(item.getProductId());
            availability.put("product", product);
            
            int available = inventoryDAO.getTotalQuantityByProductAndWarehouse(
                item.getProductId(), request.getSourceWarehouseId());
            availability.put("available", available);
            availability.put("requested", item.getQuantity());
            availability.put("sufficient", available >= item.getQuantity());
            
            result.add(availability);
        }
        
        return result;
    }
    
    // ========== Approval ==========
    
    /**
     * Approve a transfer request
     * @param requestId Request ID
     * @param approverId User who approves
     * @return true if successful
     */
    public boolean approveTransfer(Long requestId, Long approverId) {
        if (requestId == null || approverId == null) {
            return false;
        }
        
        Request request = getTransferRequestById(requestId);
        if (request == null || !"Created".equals(request.getStatus())) {
            return false;
        }
        
        return requestDAO.approve(requestId, approverId);
    }
    
    /**
     * Reject a transfer request
     * @param requestId Request ID
     * @param rejectorId User who rejects
     * @param reason Rejection reason
     * @return true if successful
     */
    public boolean rejectTransfer(Long requestId, Long rejectorId, String reason) {
        if (requestId == null || rejectorId == null || reason == null || reason.trim().isEmpty()) {
            return false;
        }
        
        Request request = getTransferRequestById(requestId);
        if (request == null || !"Created".equals(request.getStatus())) {
            return false;
        }
        
        return requestDAO.reject(requestId, rejectorId, reason);
    }
    
    // ========== UC-TRF-002: Execute Transfer Outbound ==========
    
    /**
     * Start outbound execution (picking)
     * @param requestId Request ID
     * @return true if successful
     */
    public boolean startOutboundExecution(Long requestId) {
        if (requestId == null) {
            return false;
        }
        
        Request request = getTransferRequestById(requestId);
        if (request == null || !"Approved".equals(request.getStatus())) {
            return false;
        }
        
        return requestDAO.startExecution(requestId);
    }
    
    /**
     * Complete outbound execution - deduct inventory from source
     * @param requestId Request ID
     * @param completedBy User completing
     * @return true if successful
     */
    public boolean completeOutboundExecution(Long requestId, Long completedBy) {
        if (requestId == null || completedBy == null) {
            return false;
        }
        
        Request request = getTransferRequestById(requestId);
        if (request == null || !"InProgress".equals(request.getStatus())) {
            return false;
        }
        
        // Get items and deduct from source warehouse
        List<RequestItem> items = requestItemDAO.findByRequestId(requestId);
        
        for (RequestItem item : items) {
            // Deduct from source warehouse
            boolean success = inventoryDAO.decreaseQuantity(
                item.getProductId(),
                request.getSourceWarehouseId(),
                item.getLocationId(), // Source location
                item.getQuantity()
            );
            
            if (!success) {
                return false; // Rollback would be needed in real scenario
            }
        }
        
        // Update request to "InTransit" status to indicate outbound complete
        // For simplicity, we'll use "InTransit" to mark outbound done
        return requestDAO.updateStatus(requestId, "InTransit");
    }
    
    // ========== UC-TRF-003: Execute Transfer Inbound ==========
    
    /**
     * Start inbound execution (receiving)
     * @param requestId Request ID
     * @return true if successful
     */
    public boolean startInboundExecution(Long requestId) {
        if (requestId == null) {
            return false;
        }
        
        Request request = getTransferRequestById(requestId);
        // Must be InTransit (outbound completed)
        if (request == null || !"InTransit".equals(request.getStatus())) {
            return false;
        }
        
        return requestDAO.updateStatus(requestId, "Receiving");
    }
    
    /**
     * Complete inbound execution - add inventory to destination
     * @param requestId Request ID
     * @param completedBy User completing
     * @param destinationLocationId Destination location for all items
     * @return true if successful
     */
    public boolean completeInboundExecution(Long requestId, Long completedBy, Long destinationLocationId) {
        if (requestId == null || completedBy == null || destinationLocationId == null) {
            return false;
        }
        
        Request request = getTransferRequestById(requestId);
        if (request == null || !"Receiving".equals(request.getStatus())) {
            return false;
        }
        
        // Verify destination location belongs to destination warehouse
        Location location = locationDAO.findById(destinationLocationId);
        if (location == null || !request.getDestinationWarehouseId().equals(location.getWarehouseId())) {
            return false;
        }
        
        // Get items and add to destination warehouse
        List<RequestItem> items = requestItemDAO.findByRequestId(requestId);
        
        for (RequestItem item : items) {
            // Add to destination warehouse
            boolean success = inventoryDAO.increaseQuantity(
                item.getProductId(),
                request.getDestinationWarehouseId(),
                destinationLocationId,
                item.getQuantity()
            );
            
            if (!success) {
                return false;
            }
        }
        
        // Complete the transfer
        return requestDAO.complete(requestId, completedBy);
    }
    
    // ========== Helper Methods ==========
    
    /**
     * Get all warehouses
     * @return List of warehouses
     */
    public List<Warehouse> getAllWarehouses() {
        return warehouseDAO.getAll();
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
     * Get products with inventory at a warehouse
     * @param warehouseId Warehouse ID
     * @return List of products with inventory info
     */
    public List<Map<String, Object>> getProductsWithInventoryAtWarehouse(Long warehouseId) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<Inventory> inventories = inventoryDAO.findByWarehouse(warehouseId);
        
        // Group by product
        Map<Long, Integer> productQuantities = new HashMap<>();
        for (Inventory inv : inventories) {
            productQuantities.merge(inv.getProductId(), inv.getQuantity(), Integer::sum);
        }
        
        for (Map.Entry<Long, Integer> entry : productQuantities.entrySet()) {
            Product product = productDAO.findById(entry.getKey());
            if (product != null && product.isActive()) {
                Map<String, Object> item = new HashMap<>();
                item.put("product", product);
                item.put("totalQuantity", entry.getValue());
                result.add(item);
            }
        }
        
        return result;
    }
    
    /**
     * Get locations for a warehouse
     * @param warehouseId Warehouse ID
     * @return List of active locations
     */
    public List<Location> getLocationsByWarehouse(Long warehouseId) {
        return locationDAO.findByWarehouse(warehouseId);
    }
    
    /**
     * Get user by ID
     * @param userId User ID
     * @return User if found
     */
    public User getUserById(Long userId) {
        return userDAO.findById(userId);
    }
    
    /**
     * Get transfer requests for a specific warehouse (source or destination)
     * @param warehouseId Warehouse ID
     * @return List of transfer requests
     */
    public List<Request> getTransferRequestsByWarehouse(Long warehouseId) {
        List<Request> all = getAllTransferRequests();
        List<Request> result = new ArrayList<>();
        
        for (Request req : all) {
            if (warehouseId.equals(req.getSourceWarehouseId()) || 
                warehouseId.equals(req.getDestinationWarehouseId())) {
                result.add(req);
            }
        }
        
        return result;
    }
    
    /**
     * Get active products for selection
     * @return List of active products
     */
    public List<Product> getActiveProducts() {
        return productDAO.findByStatus(true);
    }
}
