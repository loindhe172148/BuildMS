package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.SalesOrderItem;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for SalesOrderItem entity
 * Handles CRUD operations for sales order line items
 */
public class SalesOrderItemDAO {
    
    /**
     * Create a new sales order item
     * @param item SalesOrderItem to create
     * @return true if successful
     */
    public boolean create(SalesOrderItem item) {
        if (item == null || item.getSalesOrderId() == null || 
            item.getProductId() == null || item.getQuantity() == null) {
            return false;
        }
        
        String sql = "INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, item.getSalesOrderId());
            stmt.setLong(2, item.getProductId());
            stmt.setInt(3, item.getQuantity());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Create multiple sales order items in batch
     * @param items List of items to create
     * @return true if all successful
     */
    public boolean createBatch(List<SalesOrderItem> items) {
        if (items == null || items.isEmpty()) {
            return false;
        }
        
        String sql = "INSERT INTO SalesOrderItems (SalesOrderId, ProductId, Quantity) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false);
            
            for (SalesOrderItem item : items) {
                if (item.getSalesOrderId() == null || item.getProductId() == null || item.getQuantity() == null) {
                    conn.rollback();
                    return false;
                }
                
                stmt.setLong(1, item.getSalesOrderId());
                stmt.setLong(2, item.getProductId());
                stmt.setInt(3, item.getQuantity());
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            conn.commit();
            
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Find items by sales order ID
     * @param salesOrderId Sales Order ID
     * @return List of items for the order
     */
    public List<SalesOrderItem> findBySalesOrderId(Long salesOrderId) {
        List<SalesOrderItem> items = new ArrayList<>();
        
        if (salesOrderId == null) {
            return items;
        }
        
        String sql = "SELECT SalesOrderId, ProductId, Quantity FROM SalesOrderItems WHERE SalesOrderId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, salesOrderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToItem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Find a specific item
     * @param salesOrderId Sales Order ID
     * @param productId Product ID
     * @return SalesOrderItem if found, null otherwise
     */
    public SalesOrderItem findByOrderAndProduct(Long salesOrderId, Long productId) {
        if (salesOrderId == null || productId == null) {
            return null;
        }
        
        String sql = "SELECT SalesOrderId, ProductId, Quantity FROM SalesOrderItems " +
                     "WHERE SalesOrderId = ? AND ProductId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, salesOrderId);
            stmt.setLong(2, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToItem(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update item quantity
     * @param salesOrderId Sales Order ID
     * @param productId Product ID
     * @param quantity New quantity
     * @return true if successful
     */
    public boolean updateQuantity(Long salesOrderId, Long productId, Integer quantity) {
        if (salesOrderId == null || productId == null || quantity == null || quantity <= 0) {
            return false;
        }
        
        String sql = "UPDATE SalesOrderItems SET Quantity = ? WHERE SalesOrderId = ? AND ProductId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setLong(2, salesOrderId);
            stmt.setLong(3, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete an item from order
     * @param salesOrderId Sales Order ID
     * @param productId Product ID
     * @return true if successful
     */
    public boolean delete(Long salesOrderId, Long productId) {
        if (salesOrderId == null || productId == null) {
            return false;
        }
        
        String sql = "DELETE FROM SalesOrderItems WHERE SalesOrderId = ? AND ProductId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, salesOrderId);
            stmt.setLong(2, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete all items for an order
     * @param salesOrderId Sales Order ID
     * @return true if successful
     */
    public boolean deleteByOrderId(Long salesOrderId) {
        if (salesOrderId == null) {
            return false;
        }
        
        String sql = "DELETE FROM SalesOrderItems WHERE SalesOrderId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, salesOrderId);
            
            return stmt.executeUpdate() >= 0; // 0 is okay if no items
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get count of items in an order
     * @param salesOrderId Sales Order ID
     * @return Number of items
     */
    public int getItemCount(Long salesOrderId) {
        if (salesOrderId == null) {
            return 0;
        }
        
        String sql = "SELECT COUNT(*) FROM SalesOrderItems WHERE SalesOrderId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, salesOrderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Map ResultSet to SalesOrderItem object
     */
    private SalesOrderItem mapResultSetToItem(ResultSet rs) throws SQLException {
        SalesOrderItem item = new SalesOrderItem();
        item.setSalesOrderId(rs.getLong("SalesOrderId"));
        item.setProductId(rs.getLong("ProductId"));
        item.setQuantity(rs.getInt("Quantity"));
        return item;
    }
}
