package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.LocationDAO;
import vn.edu.fpt.swp.model.Location;

import java.util.List;

/**
 * Service class for location operations
 */
public class LocationService {
    private final LocationDAO locationDAO;
    
    public LocationService() {
        this.locationDAO = new LocationDAO();
    }
    
    /**
     * Get location by ID
     * @param id Location ID
     * @return Location object if found, null otherwise
     */
    public Location getLocationById(Long id) {
        return locationDAO.findById(id);
    }
    
    /**
     * Get all locations
     * @return List of all locations
     */
    public List<Location> getAllLocations() {
        return locationDAO.getAll();
    }
    
    /**
     * Get locations by warehouse
     * @param warehouseId Warehouse ID
     * @return List of locations in the warehouse
     */
    public List<Location> getLocationsByWarehouse(Long warehouseId) {
        if (warehouseId == null || warehouseId <= 0) {
            return List.of();
        }
        return locationDAO.findByWarehouse(warehouseId);
    }
    
    /**
     * Get active locations by warehouse
     * @param warehouseId Warehouse ID
     * @return List of active locations in the warehouse
     */
    public List<Location> getActiveLocationsByWarehouse(Long warehouseId) {
        if (warehouseId == null || warehouseId <= 0) {
            return List.of();
        }
        return locationDAO.findActiveByWarehouse(warehouseId);
    }
    
    /**
     * Get locations by type
     * @param type Location type
     * @return List of locations of the specified type
     */
    public List<Location> getLocationsByType(String type) {
        return locationDAO.findByType(type);
    }
    
    /**
     * Get locations by status
     * @param isActive true for active, false for inactive
     * @return List of locations with the specified status
     */
    public List<Location> getLocationsByStatus(boolean isActive) {
        return locationDAO.findByStatus(isActive);
    }
    
    /**
     * Search locations
     * @param keyword Search keyword
     * @return List of matching locations
     */
    public List<Location> searchLocations(String keyword) {
        return locationDAO.search(keyword);
    }
    
    /**
     * Create a new location
     * @param warehouseId Warehouse ID
     * @param code Location code
     * @param type Location type (Storage, Picking, Staging)
     * @return Created location with generated ID, null if failed
     */
    public Location createLocation(Long warehouseId, String code, String type) {
        // Validate input
        if (warehouseId == null || warehouseId <= 0 ||
            code == null || code.trim().isEmpty() ||
            type == null || type.trim().isEmpty()) {
            return null;
        }
        
        // Validate type
        if (!isValidType(type)) {
            return null;
        }
        
        // Check for duplicate code in warehouse
        if (locationDAO.findByCode(warehouseId, code.trim()) != null) {
            return null; // Code already exists in this warehouse
        }
        
        // Create location
        Location location = new Location(warehouseId, code.trim(), type.trim());
        location.setActive(true); // New locations are active by default
        return locationDAO.create(location);
    }
    
    /**
     * Update an existing location
     * @param id Location ID
     * @param code New code
     * @param type New type
     * @return true if update successful, false otherwise
     */
    public boolean updateLocation(Long id, String code, String type) {
        // Validate input
        if (id == null || id <= 0 ||
            code == null || code.trim().isEmpty() ||
            type == null || type.trim().isEmpty()) {
            return false;
        }
        
        // Validate type
        if (!isValidType(type)) {
            return false;
        }
        
        // Check if location exists
        Location existing = locationDAO.findById(id);
        if (existing == null) {
            return false;
        }
        
        // Check for duplicate code in warehouse (only if code is different)
        if (!existing.getCode().equalsIgnoreCase(code.trim())) {
            Location duplicate = locationDAO.findByCode(existing.getWarehouseId(), code.trim());
            if (duplicate != null) {
                return false; // Another location with this code exists in the warehouse
            }
        }
        
        // Update location (preserve warehouseId and status)
        Location location = new Location(existing.getWarehouseId(), code.trim(), type.trim());
        location.setId(id);
        location.setActive(existing.isActive());
        return locationDAO.update(location);
    }
    
    /**
     * Toggle location status
     * @param id Location ID
     * @return true if update successful, false otherwise
     */
    public boolean toggleLocationStatus(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        Location location = locationDAO.findById(id);
        if (location == null) {
            return false;
        }
        
        // If deactivating, check for inventory
        if (location.isActive()) {
            if (locationDAO.hasInventory(id)) {
                return false; // Cannot deactivate location with inventory
            }
        }
        
        return locationDAO.toggleStatus(id, !location.isActive());
    }
    
    /**
     * Check if location can be deactivated
     * @param id Location ID
     * @return true if can be deactivated (no inventory), false otherwise
     */
    public boolean canDeactivate(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        Location location = locationDAO.findById(id);
        if (location == null || !location.isActive()) {
            return false;
        }
        
        return !locationDAO.hasInventory(id);
    }
    
    /**
     * Delete a location
     * @param id Location ID
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteLocation(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        if (locationDAO.findById(id) == null) {
            return false;
        }
        
        // Check if location has inventory
        if (locationDAO.hasInventory(id)) {
            return false; // Cannot delete location with inventory
        }
        
        return locationDAO.delete(id);
    }
    
    /**
     * Check if location has inventory
     * @param locationId Location ID
     * @return true if has inventory, false otherwise
     */
    public boolean hasInventory(Long locationId) {
        return locationDAO.hasInventory(locationId);
    }
    
    /**
     * Get inventory count at a location
     * @param locationId Location ID
     * @return Number of inventory items
     */
    public int getInventoryCount(Long locationId) {
        return locationDAO.getInventoryCount(locationId);
    }
    
    /**
     * Validate location type
     * @param type Type to validate
     * @return true if valid, false otherwise
     */
    private boolean isValidType(String type) {
        if (type == null) return false;
        String t = type.trim();
        return "Storage".equalsIgnoreCase(t) || 
               "Picking".equalsIgnoreCase(t) || 
               "Staging".equalsIgnoreCase(t);
    }
}
