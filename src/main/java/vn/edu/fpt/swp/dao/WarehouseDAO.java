package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Warehouse;
import vn.edu.fpt.swp.util.DBConnection;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Warehouse entity
 */
public class WarehouseDAO {
    
    /**
     * Create a new warehouse
     * @param warehouse Warehouse to create
     * @return Created warehouse with generated ID, null if failed
     */
    public Warehouse create(Warehouse warehouse) {
        if (warehouse == null || warehouse.getName() == null || warehouse.getName().trim().isEmpty()) {
            return null;
        }
        
        String sql = "INSERT INTO Warehouses (Name, Location, CreatedAt) VALUES (?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, warehouse.getName().trim());
            stmt.setString(2, warehouse.getLocation() != null ? warehouse.getLocation().trim() : null);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        warehouse.setId(generatedKeys.getLong(1));
                        return warehouse;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find warehouse by ID
     * @param id Warehouse ID
     * @return Warehouse if found, null otherwise
     */
    public Warehouse findById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        
        String sql = "SELECT Id, Name, Location, CreatedAt FROM Warehouses WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToWarehouse(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find warehouse by name
     * @param name Warehouse name
     * @return Warehouse if found, null otherwise
     */
    public Warehouse findByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT Id, Name, Location, CreatedAt FROM Warehouses WHERE Name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, name.trim());
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToWarehouse(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all warehouses
     * @return List of all warehouses
     */
    public List<Warehouse> getAll() {
        List<Warehouse> warehouses = new ArrayList<>();
        String sql = "SELECT Id, Name, Location, CreatedAt FROM Warehouses ORDER BY Name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                warehouses.add(mapResultSetToWarehouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return warehouses;
    }
    
    /**
     * Search warehouses by keyword
     * @param keyword Search keyword (searches name and location)
     * @return List of matching warehouses
     */
    public List<Warehouse> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAll();
        }
        
        List<Warehouse> warehouses = new ArrayList<>();
        String sql = "SELECT Id, Name, Location, CreatedAt FROM Warehouses " +
                     "WHERE Name LIKE ? OR Location LIKE ? ORDER BY Name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword.trim() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    warehouses.add(mapResultSetToWarehouse(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return warehouses;
    }

    public PageResult<Warehouse> searchPaginated(String keyword, PageRequest pageRequest) {
        List<Warehouse> warehouses = new ArrayList<>();
        StringBuilder fromClause = new StringBuilder(" FROM Warehouses WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            fromClause.append(" AND (Name LIKE ? OR Location LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        String countSql = "SELECT COUNT(*)" + fromClause;
        String dataSql = "SELECT Id, Name, Location, CreatedAt" + fromClause
            + " ORDER BY Name OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
                        warehouses.add(mapResultSetToWarehouse(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return PageResult.of(warehouses, totalItems, pageRequest);
    }
    
    /**
     * Update a warehouse
     * @param warehouse Warehouse with updated data
     * @return true if update successful, false otherwise
     */
    public boolean update(Warehouse warehouse) {
        if (warehouse == null || warehouse.getId() == null || warehouse.getId() <= 0 ||
            warehouse.getName() == null || warehouse.getName().trim().isEmpty()) {
            return false;
        }
        
        String sql = "UPDATE Warehouses SET Name = ?, Location = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, warehouse.getName().trim());
            stmt.setString(2, warehouse.getLocation() != null ? warehouse.getLocation().trim() : null);
            stmt.setLong(3, warehouse.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a warehouse
     * @param id Warehouse ID
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        String sql = "DELETE FROM Warehouses WHERE Id = ?";
        
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
     * Count locations in a warehouse
     * @param warehouseId Warehouse ID
     * @return Number of locations
     */
    public int countLocations(Long warehouseId) {
        if (warehouseId == null || warehouseId <= 0) {
            return 0;
        }
        
        String sql = "SELECT COUNT(*) as count FROM Locations WHERE WarehouseId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            
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
     * Check if warehouse has any inventory
     * @param warehouseId Warehouse ID
     * @return true if warehouse has inventory, false otherwise
     */
    public boolean hasInventory(Long warehouseId) {
        if (warehouseId == null || warehouseId <= 0) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) as count FROM Inventory i " +
                     "JOIN Locations l ON i.LocationId = l.Id " +
                     "WHERE l.WarehouseId = ? AND i.Quantity > 0";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            
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
     * Get location count per warehouse in one query — avoids N+1 on the list page.
     *
     * @return Map of warehouseId -> location count
     */
    public Map<Long, Integer> getAllLocationCounts() {
        Map<Long, Integer> result = new HashMap<>();
        String sql = "SELECT WarehouseId, COUNT(*) AS cnt FROM Locations GROUP BY WarehouseId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                result.put(rs.getLong("WarehouseId"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Map ResultSet row to Warehouse object
     */
    private Warehouse mapResultSetToWarehouse(ResultSet rs) throws SQLException {
        Warehouse warehouse = new Warehouse();
        warehouse.setId(rs.getLong("Id"));
        warehouse.setName(rs.getString("Name"));
        warehouse.setLocation(rs.getString("Location"));
        
        Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) {
            warehouse.setCreatedAt(ts.toLocalDateTime());
        }
        
        return warehouse;
    }
}
