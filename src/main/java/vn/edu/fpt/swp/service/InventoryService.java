package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.*;
import vn.edu.fpt.swp.model.*;

import java.util.*;

/**
 * Service layer for Inventory Management
 * 
 * UC-INV-001: View Inventory by Warehouse
 * UC-INV-002: View Inventory by Product
 * UC-INV-003: Search Inventory
 */
public class InventoryService {
    
    private InventoryDAO inventoryDAO;
    private ProductDAO productDAO;
    private WarehouseDAO warehouseDAO;
    private LocationDAO locationDAO;
    private CategoryDAO categoryDAO;
    
    public InventoryService() {
        this.inventoryDAO = new InventoryDAO();
        this.productDAO = new ProductDAO();
        this.warehouseDAO = new WarehouseDAO();
        this.locationDAO = new LocationDAO();
        this.categoryDAO = new CategoryDAO();
    }
    
    // ==================== UC-INV-001: View Inventory by Warehouse ====================
    
    /**
     * Get inventory for a specific warehouse, grouped by location
     * @param warehouseId Warehouse ID
     * @return Map of locationId -> List of inventory items with product details
     */
    public Map<Location, List<Map<String, Object>>> getInventoryByWarehouse(Long warehouseId) {
        Map<Location, List<Map<String, Object>>> result = new LinkedHashMap<>();
        
        if (warehouseId == null) {
            return result;
        }
        
        // Get all inventory for this warehouse
        List<Inventory> inventories = inventoryDAO.findByWarehouse(warehouseId);
        
        // Group by location
        Map<Long, List<Inventory>> groupedByLocation = new LinkedHashMap<>();
        for (Inventory inv : inventories) {
            groupedByLocation.computeIfAbsent(inv.getLocationId(), k -> new ArrayList<>()).add(inv);
        }
        
        // Build result with location and product details
        for (Map.Entry<Long, List<Inventory>> entry : groupedByLocation.entrySet()) {
            Location location = locationDAO.findById(entry.getKey());
            if (location == null) continue;
            
            List<Map<String, Object>> items = new ArrayList<>();
            for (Inventory inv : entry.getValue()) {
                Product product = productDAO.findById(inv.getProductId());
                if (product == null) continue;
                
                Map<String, Object> item = new HashMap<>();
                item.put("inventory", inv);
                item.put("product", product);
                items.add(item);
            }
            
            if (!items.isEmpty()) {
                result.put(location, items);
            }
        }
        
        return result;
    }
    
    /**
     * Get warehouse summary statistics
     * @param warehouseId Warehouse ID
     * @return Map containing totalProducts, totalQuantity, locationCount
     */
    public Map<String, Integer> getWarehouseSummary(Long warehouseId) {
        Map<String, Integer> summary = new HashMap<>();
        summary.put("totalProducts", 0);
        summary.put("totalQuantity", 0);
        summary.put("locationCount", 0);
        
        if (warehouseId == null) {
            return summary;
        }
        
        List<Inventory> inventories = inventoryDAO.findByWarehouse(warehouseId);
        
        Set<Long> productIds = new HashSet<>();
        Set<Long> locationIds = new HashSet<>();
        int totalQty = 0;
        
        for (Inventory inv : inventories) {
            productIds.add(inv.getProductId());
            locationIds.add(inv.getLocationId());
            totalQty += inv.getQuantity() != null ? inv.getQuantity() : 0;
        }
        
        summary.put("totalProducts", productIds.size());
        summary.put("totalQuantity", totalQty);
        summary.put("locationCount", locationIds.size());
        
        return summary;
    }
    
    // ==================== UC-INV-002: View Inventory by Product ====================
    
    /**
     * Get inventory for a specific product across all warehouses/locations
     * @param productId Product ID
     * @param warehouseId Optional warehouse filter (for Staff)
     * @return List of inventory items with warehouse and location details
     */
    public List<Map<String, Object>> getInventoryByProduct(Long productId, Long warehouseId) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        if (productId == null) {
            return result;
        }
        
        List<Inventory> inventories = inventoryDAO.findByProduct(productId);
        
        for (Inventory inv : inventories) {
            // Filter by warehouse if specified
            if (warehouseId != null && !warehouseId.equals(inv.getWarehouseId())) {
                continue;
            }
            
            Warehouse warehouse = warehouseDAO.findById(inv.getWarehouseId());
            Location location = locationDAO.findById(inv.getLocationId());
            
            if (warehouse == null || location == null) continue;
            
            Map<String, Object> item = new HashMap<>();
            item.put("inventory", inv);
            item.put("warehouse", warehouse);
            item.put("location", location);
            result.add(item);
        }
        
        return result;
    }
    
    /**
     * Get product summary across all locations
     * @param productId Product ID
     * @param warehouseId Optional warehouse filter
     * @return Map containing totalQuantity, locationCount, warehouseCount
     */
    public Map<String, Integer> getProductInventorySummary(Long productId, Long warehouseId) {
        Map<String, Integer> summary = new HashMap<>();
        summary.put("totalQuantity", 0);
        summary.put("locationCount", 0);
        summary.put("warehouseCount", 0);
        
        if (productId == null) {
            return summary;
        }
        
        List<Inventory> inventories = inventoryDAO.findByProduct(productId);
        
        Set<Long> warehouseIds = new HashSet<>();
        Set<Long> locationIds = new HashSet<>();
        int totalQty = 0;
        
        for (Inventory inv : inventories) {
            // Filter by warehouse if specified
            if (warehouseId != null && !warehouseId.equals(inv.getWarehouseId())) {
                continue;
            }
            
            warehouseIds.add(inv.getWarehouseId());
            locationIds.add(inv.getLocationId());
            totalQty += inv.getQuantity() != null ? inv.getQuantity() : 0;
        }
        
        summary.put("totalQuantity", totalQty);
        summary.put("locationCount", locationIds.size());
        summary.put("warehouseCount", warehouseIds.size());
        
        return summary;
    }
    
    // ==================== UC-INV-003: Search Inventory ====================
    
    /**
     * Search inventory with filters
     * @param searchTerm Search term for SKU or product name
     * @param warehouseId Filter by warehouse
     * @param categoryId Filter by category
     * @param minQuantity Minimum quantity filter
     * @param maxQuantity Maximum quantity filter
     * @return List of inventory items with product, warehouse, and location details
     */
    public List<Map<String, Object>> searchInventory(String searchTerm, Long warehouseId, 
            Long categoryId, Integer minQuantity, Integer maxQuantity) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        // Get all inventory
        List<Inventory> inventories;
        if (warehouseId != null) {
            inventories = inventoryDAO.findByWarehouse(warehouseId);
        } else {
            inventories = inventoryDAO.getAll();
        }
        
        for (Inventory inv : inventories) {
            // Apply quantity filters
            int qty = inv.getQuantity() != null ? inv.getQuantity() : 0;
            if (minQuantity != null && qty < minQuantity) continue;
            if (maxQuantity != null && qty > maxQuantity) continue;
            
            Product product = productDAO.findById(inv.getProductId());
            if (product == null) continue;
            
            // Apply category filter
            if (categoryId != null && !categoryId.equals(product.getCategoryId())) continue;
            
            // Apply search term filter (case-insensitive)
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String term = searchTerm.toLowerCase().trim();
                boolean matches = (product.getSku() != null && product.getSku().toLowerCase().contains(term))
                        || (product.getName() != null && product.getName().toLowerCase().contains(term));
                if (!matches) continue;
            }
            
            Warehouse warehouse = warehouseDAO.findById(inv.getWarehouseId());
            Location location = locationDAO.findById(inv.getLocationId());
            Category category = product.getCategoryId() != null ? categoryDAO.findById(product.getCategoryId()) : null;
            
            if (warehouse == null || location == null) continue;
            
            Map<String, Object> item = new HashMap<>();
            item.put("inventory", inv);
            item.put("product", product);
            item.put("warehouse", warehouse);
            item.put("location", location);
            item.put("category", category);
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
     * Get all products (active)
     */
    public List<Product> getAllActiveProducts() {
        return productDAO.findByStatus(true);
    }
    
    /**
     * Get product by ID
     */
    public Product getProductById(Long productId) {
        return productDAO.findById(productId);
    }
    
    /**
     * Get all categories
     */
    public List<Category> getAllCategories() {
        return categoryDAO.getAll();
    }
    
    /**
     * Search products by term
     */
    public List<Product> searchProducts(String term) {
        if (term == null || term.trim().isEmpty()) {
            return productDAO.findByStatus(true);
        }
        return productDAO.search(term.trim());
    }
    
    /**
     * Get inventory at a specific location for a product
     */
    public int getQuantityAtLocation(Long productId, Long warehouseId, Long locationId) {
        Inventory inv = inventoryDAO.findByProductAndLocation(productId, warehouseId, locationId);
        return inv != null && inv.getQuantity() != null ? inv.getQuantity() : 0;
    }
}
