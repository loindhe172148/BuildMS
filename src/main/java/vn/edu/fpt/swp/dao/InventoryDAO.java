package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Inventory;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Inventory entity
 */
public class InventoryDAO {
    
    /**
     * Get inventory record for a specific product at a specific location
     * @param productId Product ID
     * @param warehouseId Warehouse ID
     * @param locationId Location ID
     * @return Inventory if found, null otherwise
     */
    public Inventory findByProductAndLocation(Long productId, Long warehouseId, Long locationId) {
        if (productId == null || warehouseId == null || locationId == null) {
            return null;
        }
        
        String sql = "SELECT ProductId, WarehouseId, LocationId, Quantity FROM Inventory " +
                     "WHERE ProductId = ? AND WarehouseId = ? AND LocationId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, productId);
            stmt.setLong(2, warehouseId);
            stmt.setLong(3, locationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInventory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get total inventory quantity for a product across all locations in a warehouse
     * @param productId Product ID
     * @param warehouseId Warehouse ID
     * @return Total quantity
     */
    public int getTotalQuantityByProductAndWarehouse(Long productId, Long warehouseId) {
        if (productId == null || warehouseId == null) {
            return 0;
        }
        
        String sql = "SELECT COALESCE(SUM(Quantity), 0) as TotalQty FROM Inventory " +
                     "WHERE ProductId = ? AND WarehouseId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, productId);
            stmt.setLong(2, warehouseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TotalQty");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get total inventory quantity for a product across all warehouses
     * @param productId Product ID
     * @return Total quantity
     */
    public int getTotalQuantityByProduct(Long productId) {
        if (productId == null) {
            return 0;
        }
        
        String sql = "SELECT COALESCE(SUM(Quantity), 0) as TotalQty FROM Inventory WHERE ProductId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TotalQty");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get all inventory records for a warehouse
     * @param warehouseId Warehouse ID
     * @return List of inventory records
     */
    public List<Inventory> findByWarehouse(Long warehouseId) {
        List<Inventory> inventories = new ArrayList<>();
        
        if (warehouseId == null) {
            return inventories;
        }
        
        String sql = "SELECT ProductId, WarehouseId, LocationId, Quantity FROM Inventory " +
                     "WHERE WarehouseId = ? ORDER BY ProductId, LocationId";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    inventories.add(mapResultSetToInventory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return inventories;
    }
    
    /**
     * Get all inventory records for a product
     * @param productId Product ID
     * @return List of inventory records
     */
    public List<Inventory> findByProduct(Long productId) {
        List<Inventory> inventories = new ArrayList<>();
        
        if (productId == null) {
            return inventories;
        }
        
        String sql = "SELECT ProductId, WarehouseId, LocationId, Quantity FROM Inventory " +
                     "WHERE ProductId = ? ORDER BY WarehouseId, LocationId";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    inventories.add(mapResultSetToInventory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return inventories;
    }
    
    /**
     * Get all inventory records
     * @return List of all inventory records
     */
    public List<Inventory> getAll() {
        List<Inventory> inventories = new ArrayList<>();
        
        String sql = "SELECT ProductId, WarehouseId, LocationId, Quantity FROM Inventory " +
                     "ORDER BY WarehouseId, ProductId, LocationId";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return inventories;
    }
    
    /**
     * Create or update inventory record (upsert)
     * @param inventory Inventory to save
     * @return true if successful
     */
    public boolean save(Inventory inventory) {
        if (inventory == null || inventory.getProductId() == null || 
            inventory.getWarehouseId() == null || inventory.getLocationId() == null) {
            return false;
        }
        
        // Check if record exists
        Inventory existing = findByProductAndLocation(
            inventory.getProductId(), 
            inventory.getWarehouseId(), 
            inventory.getLocationId()
        );
        
        if (existing != null) {
            // Update existing record
            return updateQuantity(
                inventory.getProductId(), 
                inventory.getWarehouseId(), 
                inventory.getLocationId(), 
                inventory.getQuantity()
            );
        } else {
            // Create new record
            return create(inventory);
        }
    }
    
    /**
     * Create a new inventory record
     * @param inventory Inventory to create
     * @return true if successful
     */
    public boolean create(Inventory inventory) {
        if (inventory == null || inventory.getProductId() == null || 
            inventory.getWarehouseId() == null || inventory.getLocationId() == null) {
            return false;
        }
        
        String sql = "INSERT INTO Inventory (ProductId, WarehouseId, LocationId, Quantity) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, inventory.getProductId());
            stmt.setLong(2, inventory.getWarehouseId());
            stmt.setLong(3, inventory.getLocationId());
            stmt.setInt(4, inventory.getQuantity() != null ? inventory.getQuantity() : 0);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update inventory quantity
     * @param productId Product ID
     * @param warehouseId Warehouse ID
     * @param locationId Location ID
     * @param quantity New quantity
     * @return true if successful
     */
    public boolean updateQuantity(Long productId, Long warehouseId, Long locationId, Integer quantity) {
        if (productId == null || warehouseId == null || locationId == null || quantity == null) {
            return false;
        }
        
        String sql = "UPDATE Inventory SET Quantity = ? WHERE ProductId = ? AND WarehouseId = ? AND LocationId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setLong(2, productId);
            stmt.setLong(3, warehouseId);
            stmt.setLong(4, locationId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Increase inventory quantity (for inbound)
     * @param productId Product ID
     * @param warehouseId Warehouse ID
     * @param locationId Location ID
     * @param amount Amount to add
     * @return true if successful
     */
    public boolean increaseQuantity(Long productId, Long warehouseId, Long locationId, int amount) {
        if (productId == null || warehouseId == null || locationId == null || amount <= 0) {
            return false;
        }
        
        // Check if record exists
        Inventory existing = findByProductAndLocation(productId, warehouseId, locationId);
        
        if (existing != null) {
            // Update existing
            String sql = "UPDATE Inventory SET Quantity = Quantity + ? " +
                         "WHERE ProductId = ? AND WarehouseId = ? AND LocationId = ?";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setInt(1, amount);
                stmt.setLong(2, productId);
                stmt.setLong(3, warehouseId);
                stmt.setLong(4, locationId);
                
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            // Create new with the amount
            Inventory newInventory = new Inventory(productId, warehouseId, locationId, amount);
            return create(newInventory);
        }
        
        return false;
    }
    
    /**
     * Decrease inventory quantity (for outbound)
     * @param productId Product ID
     * @param warehouseId Warehouse ID
     * @param locationId Location ID
     * @param amount Amount to subtract
     * @return true if successful
     */
    public boolean decreaseQuantity(Long productId, Long warehouseId, Long locationId, int amount) {
        if (productId == null || warehouseId == null || locationId == null || amount <= 0) {
            return false;
        }
        
        // First verify we have enough inventory
        Inventory existing = findByProductAndLocation(productId, warehouseId, locationId);
        if (existing == null || existing.getQuantity() < amount) {
            return false; // Not enough inventory
        }
        
        String sql = "UPDATE Inventory SET Quantity = Quantity - ? " +
                     "WHERE ProductId = ? AND WarehouseId = ? AND LocationId = ? AND Quantity >= ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, amount);
            stmt.setLong(2, productId);
            stmt.setLong(3, warehouseId);
            stmt.setLong(4, locationId);
            stmt.setInt(5, amount);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get inventory at a specific location
     * @param locationId Location ID
     * @return List of inventory records at the location
     */
    public List<Inventory> findByLocation(Long locationId) {
        List<Inventory> inventories = new ArrayList<>();
        
        if (locationId == null) {
            return inventories;
        }
        
        String sql = "SELECT ProductId, WarehouseId, LocationId, Quantity FROM Inventory WHERE LocationId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, locationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    inventories.add(mapResultSetToInventory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return inventories;
    }
    
    /**
     * Map ResultSet to Inventory object
     */
    private Inventory mapResultSetToInventory(ResultSet rs) throws SQLException {
        Inventory inventory = new Inventory();
        inventory.setProductId(rs.getLong("ProductId"));
        inventory.setWarehouseId(rs.getLong("WarehouseId"));
        inventory.setLocationId(rs.getLong("LocationId"));
        inventory.setQuantity(rs.getInt("Quantity"));
        return inventory;
    }
}
