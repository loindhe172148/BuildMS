package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.*;
import vn.edu.fpt.swp.model.*;
import vn.edu.fpt.swp.util.DBConnection;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service layer for Internal Movement Management
 * 
 * UC-MOV-001: Create Internal Movement Request
 * UC-MOV-002: Execute Internal Movement
 * UC-MOV-003: Approve Internal Movement Request
 */
public class MovementService {
    
    private RequestDAO requestDAO;
    private RequestItemDAO requestItemDAO;
    private InventoryDAO inventoryDAO;
    private ProductDAO productDAO;
    private WarehouseDAO warehouseDAO;
    private LocationDAO locationDAO;
    private UserDAO userDAO;
    
    public MovementService() {
        this.requestDAO = new RequestDAO();
        this.requestItemDAO = new RequestItemDAO();
        this.inventoryDAO = new InventoryDAO();
        this.productDAO = new ProductDAO();
        this.warehouseDAO = new WarehouseDAO();
        this.locationDAO = new LocationDAO();
        this.userDAO = new UserDAO();
    }
    
    // ==================== UC-MOV-001: Create Internal Movement ====================
    
    /**
     * Create a new internal movement request
     * @param request Request header information (must have sourceWarehouseId set)
     * @param items List of movement items (with sourceLocationId, destinationLocationId, productId, quantity)
     * @return Created request with ID, null if failed
     */
    public Request createMovementRequest(Request request, List<RequestItem> items) {
        // Validation
        if (request == null || items == null || items.isEmpty()) {
            return null;
        }
        
        // Validate warehouse
        Long warehouseId = request.getSourceWarehouseId();
        if (warehouseId == null) {
            return null;
        }
        
        Warehouse warehouse = warehouseDAO.findById(warehouseId);
        if (warehouse == null) {
            return null;
        }
        
        // Validate items
        for (RequestItem item : items) {
            // Validate product
            if (item.getProductId() == null) {
                return null; // Product required
            }
            Product product = productDAO.findById(item.getProductId());
            if (product == null || !product.isActive()) {
                return null; // Invalid or inactive product
            }
            
            // Validate source location
            if (item.getSourceLocationId() == null) {
                return null; // Source location required
            }
            Location sourceLocation = locationDAO.findById(item.getSourceLocationId());
            if (sourceLocation == null || !sourceLocation.isActive() || 
                !sourceLocation.getWarehouseId().equals(warehouseId)) {
                return null; // Invalid source location or not in same warehouse
            }
            
            // Validate destination location
            if (item.getDestinationLocationId() == null) {
                return null; // Destination location required
            }
            Location destLocation = locationDAO.findById(item.getDestinationLocationId());
            if (destLocation == null || !destLocation.isActive() || 
                !destLocation.getWarehouseId().equals(warehouseId)) {
                return null; // Invalid destination location or not in same warehouse
            }
            
            // BR-MOV-007: Destination location must be compatible with product's category
            if (destLocation.getCategoryId() != null) {
                if (product == null || !destLocation.getCategoryId().equals(product.getCategoryId())) {
                    return null; // Destination restricted to different category
                }
            }
            
            // BR-MOV-003: Source and destination must be different
            if (item.getSourceLocationId().equals(item.getDestinationLocationId())) {
                return null;
            }
            
            // Validate quantity
            if (item.getQuantity() == null || item.getQuantity() <= 0) {
                return null; // Quantity must be positive
            }
            
            // BR-MOV-004: Quantity limited by source availability
            Inventory sourceInventory = inventoryDAO.findByProductAndLocation(
                    item.getProductId(), warehouseId, item.getSourceLocationId());
            if (sourceInventory == null || sourceInventory.getQuantity() < item.getQuantity()) {
                return null; // Not enough inventory at source
            }
        }
        
        // Set request type and status
        request.setType("Internal");
        request.setStatus("Created");
        request.setDestinationWarehouseId(warehouseId); // Same as source for internal movement
        
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
            // Clean up orphaned request since items failed
            requestDAO.deleteById(createdRequest.getId());
            return null;
        }
        
        return createdRequest;
    }
    
    /**
     * Validate a movement item before adding to request
     * @param warehouseId Warehouse ID
     * @param productId Product ID
     * @param sourceLocationId Source location ID
     * @param destinationLocationId Destination location ID
     * @param quantity Quantity to move
     * @return Error message or null if valid
     */
    public String validateMovementItem(Long warehouseId, Long productId, 
            Long sourceLocationId, Long destinationLocationId, Integer quantity) {
        
        if (productId == null) {
            return "Product is required";
        }
        
        Product product = productDAO.findById(productId);
        if (product == null || !product.isActive()) {
            return "Invalid or inactive product";
        }
        
        if (sourceLocationId == null) {
            return "Source location is required";
        }
        
        Location sourceLocation = locationDAO.findById(sourceLocationId);
        if (sourceLocation == null || !sourceLocation.isActive()) {
            return "Invalid or inactive source location";
        }
        if (!sourceLocation.getWarehouseId().equals(warehouseId)) {
            return "Source location must be in the selected warehouse";
        }
        
        if (destinationLocationId == null) {
            return "Destination location is required";
        }
        
        Location destLocation = locationDAO.findById(destinationLocationId);
        if (destLocation == null || !destLocation.isActive()) {
            return "Invalid or inactive destination location";
        }
        if (!destLocation.getWarehouseId().equals(warehouseId)) {
            return "Destination location must be in the selected warehouse";
        }
        
        if (sourceLocationId.equals(destinationLocationId)) {
            return "Source and destination locations must be different";
        }
        
        if (quantity == null || quantity <= 0) {
            return "Quantity must be greater than 0";
        }
        
        Inventory sourceInventory = inventoryDAO.findByProductAndLocation(
                productId, warehouseId, sourceLocationId);
        int available = sourceInventory != null ? sourceInventory.getQuantity() : 0;
        if (quantity > available) {
            return "Quantity exceeds available at source location (" + available + " available)";
        }
        
        return null; // Valid
    }
    
    // ==================== UC-MOV-003: Approve/Reject Internal Movement ====================
    
    /**
     * Approve an internal movement request (Admin/Manager only)
     * @param requestId Request ID
     * @param approvedBy User ID who approved
     * @return true if successful
     */
    public boolean approveRequest(Long requestId, Long approvedBy) {
        if (requestId == null || approvedBy == null) {
            return false;
        }
        
        Request request = requestDAO.findById(requestId);
        if (request == null || !"Internal".equals(request.getType())) {
            return false;
        }
        
        if (!"Created".equals(request.getStatus())) {
            return false;
        }
        
        return requestDAO.approve(requestId, approvedBy);
    }
    
    /**
     * Reject an internal movement request (Admin/Manager only)
     * @param requestId Request ID
     * @param rejectedBy User ID who rejected
     * @param reason Rejection reason (required)
     * @return true if successful
     */
    public boolean rejectRequest(Long requestId, Long rejectedBy, String reason) {
        if (requestId == null || rejectedBy == null || reason == null || reason.trim().isEmpty()) {
            return false;
        }
        
        Request request = requestDAO.findById(requestId);
        if (request == null || !"Internal".equals(request.getType())) {
            return false;
        }
        
        if (!"Created".equals(request.getStatus())) {
            return false;
        }
        
        return requestDAO.reject(requestId, rejectedBy, reason.trim());
    }
    
    // ==================== UC-MOV-002: Execute Internal Movement ====================
    
    /**
     * Start execution of an internal movement request
     * @param requestId Request ID
     * @return true if successful
     */
    public boolean startExecution(Long requestId) {
        if (requestId == null) {
            return false;
        }
        
        // Verify request exists and is Approved (approval required before execution)
        Request request = requestDAO.findById(requestId);
        if (request == null || !"Internal".equals(request.getType())) {
            return false;
        }
        
        if (!"Approved".equals(request.getStatus())) {
            return false;
        }
        
        return requestDAO.startExecution(requestId);
    }
    
    /**
     * Complete internal movement execution (transactional - all-or-nothing)
     * @param requestId Request ID
     * @param completedBy User ID completing the movement
     * @return true if successful
     */
    public boolean completeMovement(Long requestId, Long completedBy) {
        if (requestId == null || completedBy == null) {
            return false;
        }
        
        Request request = requestDAO.findById(requestId);
        if (request == null || !"Internal".equals(request.getType()) || 
            !"InProgress".equals(request.getStatus())) {
            return false;
        }
        
        Long warehouseId = request.getSourceWarehouseId();
        List<RequestItem> items = requestItemDAO.findByRequestId(requestId);
        
        if (items.isEmpty()) {
            return false;
        }
        
        // Pre-validate all items before starting transaction
        for (RequestItem item : items) {
            Inventory sourceInventory = inventoryDAO.findByProductAndLocation(
                    item.getProductId(), warehouseId, item.getSourceLocationId());
            if (sourceInventory == null || sourceInventory.getQuantity() < item.getQuantity()) {
                return false; // Not enough inventory - reject before any changes
            }
            
            // BR-MXE-005: Defensive re-validation of destination compatibility
            Location destLoc = locationDAO.findById(item.getDestinationLocationId());
            if (destLoc != null && destLoc.getCategoryId() != null) {
                Product product = productDAO.findById(item.getProductId());
                if (product == null || !destLoc.getCategoryId().equals(product.getCategoryId())) {
                    return false; // Category changed since creation — block
                }
            }
        }
        
        // Execute all inventory changes in a single transaction
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            for (RequestItem item : items) {
                int quantityToMove = item.getQuantity();
                
                // Decrease source
                String decreaseSql = "UPDATE Inventory SET Quantity = Quantity - ? " +
                        "WHERE ProductId = ? AND WarehouseId = ? AND LocationId = ? AND Quantity >= ?";
                try (PreparedStatement stmt = conn.prepareStatement(decreaseSql)) {
                    stmt.setInt(1, quantityToMove);
                    stmt.setLong(2, item.getProductId());
                    stmt.setLong(3, warehouseId);
                    stmt.setLong(4, item.getSourceLocationId());
                    stmt.setInt(5, quantityToMove);
                    if (stmt.executeUpdate() == 0) {
                        conn.rollback();
                        return false; // Insufficient inventory (concurrent change)
                    }
                }
                
                // Check if destination record exists
                String checkSql = "SELECT Quantity FROM Inventory " +
                        "WHERE ProductId = ? AND WarehouseId = ? AND LocationId = ?";
                boolean destExists = false;
                try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
                    stmt.setLong(1, item.getProductId());
                    stmt.setLong(2, warehouseId);
                    stmt.setLong(3, item.getDestinationLocationId());
                    try (ResultSet rs = stmt.executeQuery()) {
                        destExists = rs.next();
                    }
                }
                
                if (destExists) {
                    // Increase destination
                    String increaseSql = "UPDATE Inventory SET Quantity = Quantity + ? " +
                            "WHERE ProductId = ? AND WarehouseId = ? AND LocationId = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(increaseSql)) {
                        stmt.setInt(1, quantityToMove);
                        stmt.setLong(2, item.getProductId());
                        stmt.setLong(3, warehouseId);
                        stmt.setLong(4, item.getDestinationLocationId());
                        if (stmt.executeUpdate() == 0) {
                            conn.rollback();
                            return false;
                        }
                    }
                } else {
                    // Create destination inventory record
                    String insertSql = "INSERT INTO Inventory (ProductId, WarehouseId, LocationId, Quantity) " +
                            "VALUES (?, ?, ?, ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                        stmt.setLong(1, item.getProductId());
                        stmt.setLong(2, warehouseId);
                        stmt.setLong(3, item.getDestinationLocationId());
                        stmt.setInt(4, quantityToMove);
                        if (stmt.executeUpdate() == 0) {
                            conn.rollback();
                            return false;
                        }
                    }
                }
            }
            
            // Mark request as completed within the same transaction
            String completeSql = "UPDATE Requests SET Status = 'Completed', CompletedBy = ?, " +
                    "CompletedDate = GETDATE() WHERE Id = ? AND Status = 'InProgress'";
            try (PreparedStatement stmt = conn.prepareStatement(completeSql)) {
                stmt.setLong(1, completedBy);
                stmt.setLong(2, requestId);
                if (stmt.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Execute movement with handling for discrepancies
     * @param requestId Request ID
     * @param productId Product ID
     * @param actualQuantity Actual moved quantity
     * @return true if successful
     */
    public boolean updateMovedQuantity(Long requestId, Long productId, Integer actualQuantity) {
        if (requestId == null || productId == null || actualQuantity == null || actualQuantity < 0) {
            return false;
        }
        
        Request request = requestDAO.findById(requestId);
        if (request == null || !"InProgress".equals(request.getStatus())) {
            return false;
        }
        
        // Update picked quantity (using pickedQuantity field for actual moved)
        return requestItemDAO.updatePickedQuantity(requestId, productId, actualQuantity);
    }
    
    // ==================== Query Methods ====================
    
    /**
     * Get all internal movement requests
     */
    public List<Request> getAllMovementRequests() {
        return requestDAO.findByType("Internal");
    }
    
    /**
     * Search internal movement requests
     * @param status Status filter
     * @param warehouseId Warehouse filter
     * @return List of matching requests
     */
    public List<Request> searchMovementRequests(String status, Long warehouseId) {
        if ((status == null || status.trim().isEmpty()) && warehouseId == null) {
            return getAllMovementRequests();
        }
        return requestDAO.search("Internal", status, warehouseId);
    }
    
    public PageResult<Request> searchMovementRequestsPaginated(String status, Long warehouseId, PageRequest pageRequest) {
        return requestDAO.searchPaginated("Internal", status, warehouseId, pageRequest);
    }
    
    /**
     * Get movement request by ID
     */
    public Request getRequestById(Long requestId) {
        Request request = requestDAO.findById(requestId);
        if (request != null && "Internal".equals(request.getType())) {
            return request;
        }
        return null;
    }
    
    /**
     * Get request items with product and location details
     * @param requestId Request ID
     * @return List of maps with item, product, sourceLocation, destLocation details
     */
    public List<Map<String, Object>> getRequestItemsWithDetails(Long requestId) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        if (requestId == null) {
            return result;
        }
        
        Request request = requestDAO.findById(requestId);
        if (request == null) {
            return result;
        }
        
        Long warehouseId = request.getSourceWarehouseId();
        List<RequestItem> items = requestItemDAO.findByRequestId(requestId);
        
        for (RequestItem item : items) {
            Map<String, Object> itemData = new HashMap<>();
            itemData.put("item", item);
            
            Product product = productDAO.findById(item.getProductId());
            itemData.put("product", product);
            
            Location sourceLocation = locationDAO.findById(item.getSourceLocationId());
            itemData.put("sourceLocation", sourceLocation);
            
            Location destLocation = locationDAO.findById(item.getDestinationLocationId());
            itemData.put("destinationLocation", destLocation);
            
            // Get current quantity at source location
            Inventory sourceInventory = inventoryDAO.findByProductAndLocation(
                    item.getProductId(), warehouseId, item.getSourceLocationId());
            int sourceQty = sourceInventory != null ? sourceInventory.getQuantity() : 0;
            itemData.put("sourceQuantity", sourceQty);
            
            // Get current quantity at destination location
            Inventory destInventory = inventoryDAO.findByProductAndLocation(
                    item.getProductId(), warehouseId, item.getDestinationLocationId());
            int destQty = destInventory != null ? destInventory.getQuantity() : 0;
            itemData.put("destinationQuantity", destQty);
            
            result.add(itemData);
        }
        
        return result;
    }
    
    /**
     * Get inventory at a location for a product
     */
    public int getQuantityAtLocation(Long productId, Long warehouseId, Long locationId) {
        Inventory inv = inventoryDAO.findByProductAndLocation(productId, warehouseId, locationId);
        return inv != null ? inv.getQuantity() : 0;
    }
    
    /**
     * Get products with inventory at warehouse
     */
    public List<Map<String, Object>> getProductsWithInventoryAtWarehouse(Long warehouseId) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        if (warehouseId == null) {
            return result;
        }
        
        List<Inventory> inventories = inventoryDAO.findByWarehouse(warehouseId);
        Map<Long, List<Inventory>> byProduct = new HashMap<>();
        
        for (Inventory inv : inventories) {
            byProduct.computeIfAbsent(inv.getProductId(), k -> new ArrayList<>()).add(inv);
        }
        
        for (Map.Entry<Long, List<Inventory>> entry : byProduct.entrySet()) {
            Product product = productDAO.findById(entry.getKey());
            if (product == null || !product.isActive()) continue;
            
            int totalQty = 0;
            for (Inventory inv : entry.getValue()) {
                totalQty += inv.getQuantity();
            }
            
            Map<String, Object> item = new HashMap<>();
            item.put("product", product);
            item.put("totalQuantity", totalQty);
            item.put("inventories", entry.getValue());
            result.add(item);
        }
        
        return result;
    }
    
    // ==================== Helper Methods ====================
    
    /**
     * Get all warehouses
     */
    public List<Warehouse> getAllWarehouses() {
        return warehouseDAO.getAll();
    }
    
    /**
     * Get warehouse by ID
     */
    public Warehouse getWarehouseById(Long warehouseId) {
        return warehouseDAO.findById(warehouseId);
    }
    
    /**
     * Get locations by warehouse
     */
    public List<Location> getLocationsByWarehouse(Long warehouseId) {
        return locationDAO.findByWarehouse(warehouseId);
    }
    
    /**
     * Get active locations by warehouse
     */
    public List<Location> getActiveLocationsByWarehouse(Long warehouseId) {
        List<Location> all = locationDAO.findByWarehouse(warehouseId);
        List<Location> active = new ArrayList<>();
        for (Location loc : all) {
            if (loc.isActive()) {
                active.add(loc);
            }
        }
        return active;
    }
    
    /**
     * Get user by ID
     */
    public User getUserById(Long userId) {
        return userDAO.findById(userId);
    }

    /**
     * Get all users — used for batch display on the list page.
     * @return List of all users
     */
    public List<User> getAllUsers() {
        return userDAO.getAll();
    }
    
    /**
     * Get all active products
     */
    public List<Product> getAllActiveProducts() {
        return productDAO.findByStatus(true);
    }
}
