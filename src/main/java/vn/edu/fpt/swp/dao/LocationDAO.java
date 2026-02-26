package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Location;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Location entity
 */
public class LocationDAO {
    
    /**
     * Create a new location
     * @param location Location to create
     * @return Created location with generated ID, null if failed
     */
    public Location create(Location location) {
        if (location == null || location.getWarehouseId() == null || 
            location.getCode() == null || location.getCode().trim().isEmpty() ||
            location.getType() == null || location.getType().trim().isEmpty()) {
            return null;
        }
        
        String sql = "INSERT INTO Locations (WarehouseId, Code, Type, IsActive) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, location.getWarehouseId());
            stmt.setString(2, location.getCode().trim());
            stmt.setString(3, location.getType().trim());
            stmt.setBoolean(4, location.isActive());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        location.setId(generatedKeys.getLong(1));
                        return location;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find location by ID
     * @param id Location ID
     * @return Location if found, null otherwise
     */
    public Location findById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLocation(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find location by code within a warehouse
     * @param warehouseId Warehouse ID
     * @param code Location code
     * @return Location if found, null otherwise
     */
    public Location findByCode(Long warehouseId, String code) {
        if (warehouseId == null || warehouseId <= 0 || code == null || code.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations " +
                     "WHERE WarehouseId = ? AND Code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            stmt.setString(2, code.trim());
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLocation(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all locations
     * @return List of all locations
     */
    public List<Location> getAll() {
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations ORDER BY WarehouseId, Code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                locations.add(mapResultSetToLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return locations;
    }
    
    /**
     * Get locations by warehouse
     * @param warehouseId Warehouse ID
     * @return List of locations in the warehouse
     */
    public List<Location> findByWarehouse(Long warehouseId) {
        if (warehouseId == null || warehouseId <= 0) {
            return new ArrayList<>();
        }
        
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations " +
                     "WHERE WarehouseId = ? ORDER BY Code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    locations.add(mapResultSetToLocation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return locations;
    }
    
    /**
     * Get locations by type
     * @param type Location type
     * @return List of locations of the specified type
     */
    public List<Location> findByType(String type) {
        if (type == null || type.trim().isEmpty()) {
            return new ArrayList<>();
        }
        
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations " +
                     "WHERE Type = ? ORDER BY WarehouseId, Code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, type.trim());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    locations.add(mapResultSetToLocation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return locations;
    }
    
    /**
     * Get locations by status
     * @param isActive true for active, false for inactive
     * @return List of locations with the specified status
     */
    public List<Location> findByStatus(boolean isActive) {
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations " +
                     "WHERE IsActive = ? ORDER BY WarehouseId, Code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, isActive);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    locations.add(mapResultSetToLocation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return locations;
    }
    
    /**
     * Get active locations in a warehouse
     * @param warehouseId Warehouse ID
     * @return List of active locations in the warehouse
     */
    public List<Location> findActiveByWarehouse(Long warehouseId) {
        if (warehouseId == null || warehouseId <= 0) {
            return new ArrayList<>();
        }
        
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations " +
                     "WHERE WarehouseId = ? AND IsActive = 1 ORDER BY Code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    locations.add(mapResultSetToLocation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return locations;
    }
    
    /**
     * Search locations by code
     * @param keyword Search keyword
     * @return List of matching locations
     */
    public List<Location> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAll();
        }
        
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations " +
                     "WHERE Code LIKE ? ORDER BY WarehouseId, Code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword.trim() + "%";
            stmt.setString(1, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    locations.add(mapResultSetToLocation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return locations;
    }
    
    /**
     * Update a location
     * @param location Location with updated data
     * @return true if update successful, false otherwise
     */
    public boolean update(Location location) {
        if (location == null || location.getId() == null || location.getId() <= 0 ||
            location.getCode() == null || location.getCode().trim().isEmpty() ||
            location.getType() == null || location.getType().trim().isEmpty()) {
            return false;
        }
        
        String sql = "UPDATE Locations SET Code = ?, Type = ?, IsActive = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, location.getCode().trim());
            stmt.setString(2, location.getType().trim());
            stmt.setBoolean(3, location.isActive());
            stmt.setLong(4, location.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Toggle location status
     * @param id Location ID
     * @param isActive New status
     * @return true if update successful, false otherwise
     */
    public boolean toggleStatus(Long id, boolean isActive) {
        if (id == null || id <= 0) {
            return false;
        }
        
        String sql = "UPDATE Locations SET IsActive = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, isActive);
            stmt.setLong(2, id);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a location
     * @param id Location ID
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        String sql = "DELETE FROM Locations WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if location has inventory
     * @param locationId Location ID
     * @return true if has inventory, false otherwise
     */
    public boolean hasInventory(Long locationId) {
        if (locationId == null || locationId <= 0) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) as count FROM Inventory WHERE LocationId = ? AND Quantity > 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, locationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get inventory count at a location
     * @param locationId Location ID
     * @return Number of inventory items (product types)
     */
    public int getInventoryCount(Long locationId) {
        if (locationId == null || locationId <= 0) {
            return 0;
        }
        
        String sql = "SELECT COUNT(*) as count FROM Inventory WHERE LocationId = ? AND Quantity > 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, locationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Map ResultSet row to Location object
     */
    private Location mapResultSetToLocation(ResultSet rs) throws SQLException {
        Location location = new Location();
        location.setId(rs.getLong("Id"));
        location.setWarehouseId(rs.getLong("WarehouseId"));
        location.setCode(rs.getString("Code"));
        location.setType(rs.getString("Type"));
        location.setActive(rs.getBoolean("IsActive"));
        return location;
    }
}
