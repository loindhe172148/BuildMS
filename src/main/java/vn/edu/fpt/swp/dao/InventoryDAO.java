/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.swp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import vn.edu.fpt.swp.model.Inventory;
import vn.edu.fpt.swp.util.DBConnection;

/**
 *
 * @author dotri
 */
public class InventoryDAO {
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
    
    private Inventory mapResultSetToInventory(ResultSet rs) throws SQLException {
        Inventory inventory = new Inventory();
        inventory.setProductId(rs.getLong("ProductId"));
        inventory.setWarehouseId(rs.getLong("WarehouseId"));
        inventory.setLocationId(rs.getLong("LocationId"));
        inventory.setQuantity(rs.getInt("Quantity"));
        return inventory;
    }
}
