package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.*;
import vn.edu.fpt.swp.model.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service layer for Sales Order Management
 * 
 * UC-SO-001: Create Sales Order
 * UC-SO-002: Confirm Sales Order
 * UC-SO-003: Generate Outbound Request from Sales Order
 * UC-SO-004: Cancel Sales Order
 */
public class SalesOrderService {
    
    private SalesOrderDAO salesOrderDAO;
    private SalesOrderItemDAO salesOrderItemDAO;
    private CustomerDAO customerDAO;
    private ProductDAO productDAO;
    private WarehouseDAO warehouseDAO;
    private RequestDAO requestDAO;
    private RequestItemDAO requestItemDAO;
    private InventoryDAO inventoryDAO;
    private UserDAO userDAO;
    
    public SalesOrderService() {
        this.salesOrderDAO = new SalesOrderDAO();
        this.salesOrderItemDAO = new SalesOrderItemDAO();
        this.customerDAO = new CustomerDAO();
        this.productDAO = new ProductDAO();
        this.warehouseDAO = new WarehouseDAO();
        this.requestDAO = new RequestDAO();
        this.requestItemDAO = new RequestItemDAO();
        this.inventoryDAO = new InventoryDAO();
        this.userDAO = new UserDAO();
    }
    
    // ========== UC-SO-001: Create Sales Order ==========
    
    /**
     * Create a new sales order
     * @param salesOrder SalesOrder header
     * @param items List of order items
     * @return Created sales order with ID, null if failed
     */
    public SalesOrder createSalesOrder(SalesOrder salesOrder, List<SalesOrderItem> items) {
        // Validate inputs
        if (salesOrder == null || items == null || items.isEmpty()) {
            return null;
        }
        
        // Validate customer
        if (salesOrder.getCustomerId() == null) {
            return null;
        }
        
        Customer customer = customerDAO.findById(salesOrder.getCustomerId());
        if (customer == null || !"Active".equals(customer.getStatus())) {
            return null;
        }
        
        // Validate items - no duplicate products
        List<Long> productIds = new ArrayList<>();
        for (SalesOrderItem item : items) {
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
        
        // Generate order number
        salesOrder.setOrderNo(salesOrderDAO.generateOrderNumber());
        salesOrder.setStatus("Draft");
        
        // Create order
        SalesOrder createdOrder = salesOrderDAO.create(salesOrder);
        if (createdOrder == null) {
            return null;
        }
        
        // Create order items
        for (SalesOrderItem item : items) {
            item.setSalesOrderId(createdOrder.getId());
        }
        
        boolean itemsCreated = salesOrderItemDAO.createBatch(items);
        if (!itemsCreated) {
            return null;
        }
        
        return createdOrder;
    }
    
    /**
     * Get all sales orders
     * @return List of all sales orders
     */
    public List<SalesOrder> getAllSalesOrders() {
        return salesOrderDAO.findAll();
    }
    
    /**
     * Get sales orders by status
     * @param status Order status
     * @return List of orders with the status
     */
    public List<SalesOrder> getSalesOrdersByStatus(String status) {
        return salesOrderDAO.findByStatus(status);
    }
    
    /**
     * Get sales order by ID with details
     * @param orderId Order ID
     * @return Order if found, null otherwise
     */
    public SalesOrder getSalesOrderById(Long orderId) {
        return salesOrderDAO.findById(orderId);
    }
    
    /**
     * Get items for a sales order
     * @param salesOrderId Sales Order ID
     * @return List of order items
     */
    public List<SalesOrderItem> getOrderItems(Long salesOrderId) {
        return salesOrderItemDAO.findBySalesOrderId(salesOrderId);
    }
    
    /**
     * Get items with product details
     * @param salesOrderId Sales Order ID
     * @return List of maps with item and product info
     */
    public List<Map<String, Object>> getOrderItemsWithDetails(Long salesOrderId) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<SalesOrderItem> items = salesOrderItemDAO.findBySalesOrderId(salesOrderId);
        
        for (SalesOrderItem item : items) {
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
     * Get active customers for order creation
     * @return List of active customers
     */
    public List<Customer> getActiveCustomers() {
        return customerDAO.getActiveCustomers();
    }
    
    /**
     * Get active products for order items
     * @return List of active products
     */
    public List<Product> getActiveProducts() {
        return productDAO.findByStatus(true);
    }
    
    // ========== UC-SO-002: Confirm Sales Order ==========
    
    /**
     * Confirm a draft sales order
     * @param orderId Sales order ID
     * @param confirmedBy User ID who confirms
     * @return true if successful
     */
    public boolean confirmOrder(Long orderId, Long confirmedBy) {
        if (orderId == null || confirmedBy == null) {
            return false;
        }
        
        // Verify order exists and is Draft
        SalesOrder order = salesOrderDAO.findById(orderId);
        if (order == null || !"Draft".equals(order.getStatus())) {
            return false;
        }
        
        // Verify order has items
        int itemCount = salesOrderItemDAO.getItemCount(orderId);
        if (itemCount == 0) {
            return false;
        }
        
        return salesOrderDAO.confirm(orderId, confirmedBy);
    }
    
    // ========== UC-SO-003: Generate Outbound from Sales Order ==========
    
    /**
     * Check inventory availability for order items at a warehouse
     * @param salesOrderId Sales Order ID
     * @param warehouseId Warehouse ID
     * @return List of maps with product and availability info
     */
    public List<Map<String, Object>> checkInventoryAvailability(Long salesOrderId, Long warehouseId) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<SalesOrderItem> items = salesOrderItemDAO.findBySalesOrderId(salesOrderId);
        
        for (SalesOrderItem item : items) {
            Map<String, Object> availability = new HashMap<>();
            availability.put("item", item);
            
            Product product = productDAO.findById(item.getProductId());
            availability.put("product", product);
            
            // Get total available quantity at warehouse
            int available = inventoryDAO.getTotalQuantityByProductAndWarehouse(
                item.getProductId(), warehouseId);
            availability.put("available", available);
            availability.put("requested", item.getQuantity());
            availability.put("sufficient", available >= item.getQuantity());
            
            result.add(availability);
        }
        
        return result;
    }
    
    /**
     * Generate outbound request from sales order
     * @param salesOrderId Sales Order ID
     * @param warehouseId Source warehouse ID
     * @param createdBy User who generates the request
     * @param quantities Map of productId -> quantity to fulfill
     * @return Created Request, null if failed
     */
    public Request generateOutboundRequest(Long salesOrderId, Long warehouseId, 
                                           Long createdBy, Map<Long, Integer> quantities) {
        if (salesOrderId == null || warehouseId == null || createdBy == null) {
            return null;
        }
        
        // Verify sales order exists and is Confirmed
        SalesOrder order = salesOrderDAO.findById(salesOrderId);
        if (order == null || !"Confirmed".equals(order.getStatus())) {
            return null;
        }
        
        // Verify warehouse exists
        Warehouse warehouse = warehouseDAO.findById(warehouseId);
        if (warehouse == null) {
            return null;
        }
        
        // Get order items
        List<SalesOrderItem> orderItems = salesOrderItemDAO.findBySalesOrderId(salesOrderId);
        if (orderItems.isEmpty()) {
            return null;
        }
        
        // Build request items
        List<RequestItem> requestItems = new ArrayList<>();
        for (SalesOrderItem orderItem : orderItems) {
            Integer qtyToFulfill = quantities != null ? 
                quantities.get(orderItem.getProductId()) : orderItem.getQuantity();
            
            if (qtyToFulfill != null && qtyToFulfill > 0) {
                // Validate quantity doesn't exceed order quantity
                if (qtyToFulfill > orderItem.getQuantity()) {
                    return null;
                }
                
                RequestItem requestItem = new RequestItem();
                requestItem.setProductId(orderItem.getProductId());
                requestItem.setQuantity(qtyToFulfill);
                requestItems.add(requestItem);
            }
        }
        
        if (requestItems.isEmpty()) {
            return null; // At least one item required
        }
        
        // Create outbound request
        Request request = new Request();
        request.setType("Outbound");
        request.setStatus("Created");
        request.setSourceWarehouseId(warehouseId);
        request.setSalesOrderId(salesOrderId);
        request.setCreatedBy(createdBy);
        request.setNotes("Generated from Sales Order " + order.getOrderNo());
        
        Request createdRequest = requestDAO.create(request);
        if (createdRequest == null) {
            return null;
        }
        
        // Create request items
        for (RequestItem item : requestItems) {
            item.setRequestId(createdRequest.getId());
        }
        
        boolean itemsCreated = requestItemDAO.createBatch(requestItems);
        if (!itemsCreated) {
            return null;
        }
        
        // Update sales order status
        salesOrderDAO.markFulfillmentRequested(salesOrderId);
        
        return createdRequest;
    }
    
    /**
     * Get all warehouses for selection
     * @return List of all warehouses
     */
    public List<Warehouse> getAllWarehouses() {
        return warehouseDAO.getAll();
    }
    
    // ========== UC-SO-004: Cancel Sales Order ==========
    
    /**
     * Cancel a sales order
     * @param orderId Sales order ID
     * @param cancelledBy User who cancels
     * @param reason Cancellation reason
     * @return true if successful
     */
    public boolean cancelOrder(Long orderId, Long cancelledBy, String reason) {
        if (orderId == null || cancelledBy == null || reason == null || reason.trim().isEmpty()) {
            return false;
        }
        
        // Verify order exists and is not Completed
        SalesOrder order = salesOrderDAO.findById(orderId);
        if (order == null || "Completed".equals(order.getStatus()) || 
            "Cancelled".equals(order.getStatus())) {
            return false;
        }
        
        // Check for active outbound requests
        boolean hasActiveRequests = salesOrderDAO.hasActiveRequests(orderId);
        if (hasActiveRequests) {
            // Cancel related Created requests
            cancelCreatedRequestsForOrder(orderId);
        }
        
        return salesOrderDAO.cancel(orderId, cancelledBy, reason);
    }
    
    /**
     * Cancel all Created status outbound requests for a sales order
     * @param salesOrderId Sales order ID
     */
    private void cancelCreatedRequestsForOrder(Long salesOrderId) {
        List<Request> requests = requestDAO.findBySalesOrderId(salesOrderId);
        for (Request request : requests) {
            if ("Created".equals(request.getStatus())) {
                requestDAO.reject(request.getId(), request.getCreatedBy(), "Sales order cancelled");
            }
        }
    }
    
    /**
     * Check if order can be cancelled
     * @param orderId Order ID
     * @return Map with canCancel flag and warnings
     */
    public Map<String, Object> checkCancellationStatus(Long orderId) {
        Map<String, Object> result = new HashMap<>();
        
        SalesOrder order = salesOrderDAO.findById(orderId);
        if (order == null) {
            result.put("canCancel", false);
            result.put("reason", "Order not found");
            return result;
        }
        
        if ("Completed".equals(order.getStatus())) {
            result.put("canCancel", false);
            result.put("reason", "Completed orders cannot be cancelled");
            return result;
        }
        
        if ("Cancelled".equals(order.getStatus())) {
            result.put("canCancel", false);
            result.put("reason", "Order is already cancelled");
            return result;
        }
        
        result.put("canCancel", true);
        
        // Check for warnings
        List<String> warnings = new ArrayList<>();
        List<Request> requests = requestDAO.findBySalesOrderId(orderId);
        
        int createdCount = 0;
        int activeCount = 0;
        
        for (Request request : requests) {
            if ("Created".equals(request.getStatus())) {
                createdCount++;
            } else if (!"Completed".equals(request.getStatus()) && !"Rejected".equals(request.getStatus())) {
                activeCount++;
            }
        }
        
        if (createdCount > 0) {
            warnings.add(createdCount + " pending outbound request(s) will be auto-cancelled");
        }
        
        if (activeCount > 0) {
            warnings.add(activeCount + " active outbound request(s) need manual handling");
            result.put("requiresConfirmation", true);
        }
        
        result.put("warnings", warnings);
        
        return result;
    }
    
    // ========== Helper Methods ==========
    
    /**
     * Get customer details for an order
     * @param customerId Customer ID
     * @return Customer if found
     */
    public Customer getCustomerById(Long customerId) {
        return customerDAO.findById(customerId);
    }
    
    /**
     * Get user details
     * @param userId User ID
     * @return User if found
     */
    public User getUserById(Long userId) {
        return userDAO.findById(userId);
    }
    
    /**
     * Get outbound requests for a sales order
     * @param salesOrderId Sales Order ID
     * @return List of related requests
     */
    public List<Request> getRelatedRequests(Long salesOrderId) {
        return requestDAO.findBySalesOrderId(salesOrderId);
    }
}
