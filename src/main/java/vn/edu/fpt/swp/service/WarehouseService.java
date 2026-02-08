package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.WarehouseDAO;
import vn.edu.fpt.swp.model.Warehouse;

import java.util.List;

/**
 * Service class for warehouse operations
 */
public class WarehouseService {
    private final WarehouseDAO warehouseDAO;
    
    public WarehouseService() {
        this.warehouseDAO = new WarehouseDAO();
    }
    
    /**
     * Get warehouse by ID
     * @param id Warehouse ID
     * @return Warehouse object if found, null otherwise
     */
    public Warehouse getWarehouseById(Long id) {
        return warehouseDAO.findById(id);
    }
    
    /**
     * Get all warehouses
     * @return List of all warehouses
     */
    public List<Warehouse> getAllWarehouses() {
        return warehouseDAO.getAll();
    }
    
    /**
     * Search warehouses
     * @param keyword Search keyword
     * @return List of matching warehouses
     */
    public List<Warehouse> searchWarehouses(String keyword) {
        return warehouseDAO.search(keyword);
    }
    
    /**
     * Create a new warehouse
     * @param name Warehouse name
     * @param location Warehouse location/address
     * @return Created warehouse with generated ID, null if failed
     */
    public Warehouse createWarehouse(String name, String location) {
        // Validate input
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        
        // Check for duplicate name
        if (warehouseDAO.findByName(name.trim()) != null) {
            return null; // Name already exists
        }
        
        // Create warehouse
        Warehouse warehouse = new Warehouse(name.trim(), location);
        return warehouseDAO.create(warehouse);
    }
    
    /**
     * Update an existing warehouse
     * @param id Warehouse ID
     * @param name New name
     * @param location New location
     * @return true if update successful, false otherwise
     */
    public boolean updateWarehouse(Long id, String name, String location) {
        // Validate input
        if (id == null || id <= 0 || name == null || name.trim().isEmpty()) {
            return false;
        }
        
        // Check if warehouse exists
        Warehouse existing = warehouseDAO.findById(id);
        if (existing == null) {
            return false;
        }
        
        // Check for duplicate name (only if name is different)
        if (!existing.getName().equalsIgnoreCase(name.trim())) {
            Warehouse duplicate = warehouseDAO.findByName(name.trim());
            if (duplicate != null) {
                return false; // Another warehouse with this name exists
            }
        }
        
        // Update warehouse
        Warehouse warehouse = new Warehouse(name.trim(), location);
        warehouse.setId(id);
        warehouse.setCreatedAt(existing.getCreatedAt());
        return warehouseDAO.update(warehouse);
    }
    
    /**
     * Delete a warehouse
     * @param id Warehouse ID
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteWarehouse(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        if (warehouseDAO.findById(id) == null) {
            return false;
        }
        
        // Check if warehouse has locations
        if (warehouseDAO.countLocations(id) > 0) {
            return false; // Cannot delete warehouse with locations
        }
        
        return warehouseDAO.delete(id);
    }
    
    /**
     * Get location count for a warehouse
     * @param warehouseId Warehouse ID
     * @return Number of locations
     */
    public int getLocationCount(Long warehouseId) {
        return warehouseDAO.countLocations(warehouseId);
    }
    
    /**
     * Check if warehouse has inventory
     * @param warehouseId Warehouse ID
     * @return true if has inventory, false otherwise
     */
    public boolean hasInventory(Long warehouseId) {
        return warehouseDAO.hasInventory(warehouseId);
    }
}
