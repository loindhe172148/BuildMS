package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Location;
import vn.edu.fpt.swp.util.DBConnection;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        
        String sql = "INSERT INTO Locations (WarehouseId, Code, Type, IsActive, CategoryId) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, location.getWarehouseId());
            stmt.setString(2, location.getCode().trim());
            stmt.setString(3, location.getType().trim());
            stmt.setBoolean(4, location.isActive());
            if (location.getCategoryId() != null) {
                stmt.setLong(5, location.getCategoryId());
            } else {
                stmt.setNull(5, java.sql.Types.BIGINT);
            }
            
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
        
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations WHERE Id = ?";
        
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
        
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations " +
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
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations ORDER BY WarehouseId, Code";
        
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
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations " +
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
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations " +
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
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations " +
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
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations " +
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
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations " +
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
        
        String sql = "UPDATE Locations SET Code = ?, Type = ?, IsActive = ?, CategoryId = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, location.getCode().trim());
            stmt.setString(2, location.getType().trim());
            stmt.setBoolean(3, location.isActive());
            if (location.getCategoryId() != null) {
                stmt.setLong(4, location.getCategoryId());
            } else {
                stmt.setNull(4, java.sql.Types.BIGINT);
            }
            stmt.setLong(5, location.getId());
            
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
     * Get inventory item counts (distinct product lines with qty > 0) per location
     * in a single query — avoids N+1 calls on the location list page.
     *
     * @return Map of locationId -> inventory item count
     */
    public Map<Long, Integer> getAllLocationInventoryCounts() {
        Map<Long, Integer> result = new HashMap<>();
        String sql = "SELECT LocationId, COUNT(*) AS cnt FROM Inventory WHERE Quantity > 0 GROUP BY LocationId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                result.put(rs.getLong("LocationId"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    public PageResult<Location> searchPaginated(Long warehouseId, String type, Boolean isActive, String keyword,
                                                Long categoryId, PageRequest pageRequest) {
        List<Location> locations = new ArrayList<>();
        StringBuilder fromClause = new StringBuilder(" FROM Locations WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (warehouseId != null && warehouseId > 0) {
            fromClause.append(" AND WarehouseId = ?");
            params.add(warehouseId);
        }

        if (type != null && !type.trim().isEmpty()) {
            fromClause.append(" AND Type = ?");
            params.add(type.trim());
        }

        if (isActive != null) {
            fromClause.append(" AND IsActive = ?");
            params.add(isActive);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            fromClause.append(" AND Code LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        
        if (categoryId != null && categoryId > 0) {
            fromClause.append(" AND CategoryId = ?");
            params.add(categoryId);
        }

        String countSql = "SELECT COUNT(*)" + fromClause;
        String dataSql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId" + fromClause
            + " ORDER BY WarehouseId, Code OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        long totalItems = 0L;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement countStmt = conn.prepareStatement(countSql)) {

            for (int i = 0; i < params.size(); i++) {
                countStmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = countStmt.executeQuery()) {
                if (rs.next()) {
                    totalItems = rs.getLong(1);
                }
            }

            try (PreparedStatement dataStmt = conn.prepareStatement(dataSql)) {
                int index = 1;
                for (Object param : params) {
                    dataStmt.setObject(index++, param);
                }
                dataStmt.setInt(index++, pageRequest.getOffset());
                dataStmt.setInt(index, pageRequest.getSize());

                try (ResultSet rs = dataStmt.executeQuery()) {
                    while (rs.next()) {
                        locations.add(mapResultSetToLocation(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return PageResult.of(locations, totalItems, pageRequest);
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
        
        long catId = rs.getLong("CategoryId");
        location.setCategoryId(rs.wasNull() ? null : catId);
        
        return location;
    }
    
    /**
     * Find active locations compatible with a given category in a warehouse.
     * Returns locations where CategoryId IS NULL (unrestricted) OR CategoryId = given categoryId.
     */
    public List<Location> findActiveByWarehouseAndCategory(Long warehouseId, Long categoryId) {
        if (warehouseId == null || warehouseId <= 0) {
            return new ArrayList<>();
        }
        
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive, CategoryId FROM Locations " +
                     "WHERE WarehouseId = ? AND IsActive = 1 AND (CategoryId IS NULL OR CategoryId = ?) " +
                     "ORDER BY Code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            if (categoryId != null) {
                stmt.setLong(2, categoryId);
            } else {
                stmt.setNull(2, java.sql.Types.BIGINT);
            }
            
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
     * Count locations that reference a specific category (for delete-guard).
     */
    public int countByCategoryId(Long categoryId) {
        if (categoryId == null || categoryId <= 0) return 0;
        
        String sql = "SELECT COUNT(*) FROM Locations WHERE CategoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if location has any inventory from a DIFFERENT category than the given one.
     * Used by BR-LOC-012: block category change if conflicting inventory exists.
     */
    public boolean hasInventoryFromDifferentCategory(Long locationId, Long newCategoryId) {
        if (locationId == null || locationId <= 0) return false;
        if (newCategoryId == null) return false; // Setting to NULL (unrestricted) is always safe
        
        String sql = "SELECT COUNT(*) FROM Inventory i " +
                     "INNER JOIN Products p ON i.ProductId = p.Id " +
                     "WHERE i.LocationId = ? AND i.Quantity > 0 AND p.CategoryId != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, locationId);
            stmt.setLong(2, newCategoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
