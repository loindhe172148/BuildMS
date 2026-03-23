package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.SalesOrder;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for SalesOrder entity
 * Handles CRUD operations for sales orders
 */
public class SalesOrderDAO {
    
    /**
     * Create a new sales order
     * @param salesOrder SalesOrder to create
     * @return Created sales order with generated ID, null if failed
     */
    public SalesOrder create(SalesOrder salesOrder) {
        if (salesOrder == null || salesOrder.getCustomerId() == null || salesOrder.getCreatedBy() == null) {
            return null;
        }
        
        String sql = "INSERT INTO SalesOrders (OrderNo, CustomerId, Status, CreatedBy, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, salesOrder.getOrderNo());
            stmt.setLong(2, salesOrder.getCustomerId());
            stmt.setString(3, salesOrder.getStatus() != null ? salesOrder.getStatus() : "Draft");
            stmt.setLong(4, salesOrder.getCreatedBy());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        salesOrder.setId(generatedKeys.getLong(1));
                        return salesOrder;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find sales order by ID
     * @param id Sales Order ID
     * @return SalesOrder if found, null otherwise
     */
    public SalesOrder findById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        
        String sql = "SELECT Id, OrderNo, CustomerId, Status, CreatedBy, CreatedAt, " +
                     "ConfirmedBy, ConfirmedDate, CancelledBy, CancelledDate, CancellationReason " +
                     "FROM SalesOrders WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSalesOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find sales order by order number
     * @param orderNo Order number
     * @return SalesOrder if found, null otherwise
     */
    public SalesOrder findByOrderNo(String orderNo) {
        if (orderNo == null || orderNo.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT Id, OrderNo, CustomerId, Status, CreatedBy, CreatedAt, " +
                     "ConfirmedBy, ConfirmedDate, CancelledBy, CancelledDate, CancellationReason " +
                     "FROM SalesOrders WHERE OrderNo = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, orderNo);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSalesOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all sales orders
     * @return List of all sales orders
     */
    public List<SalesOrder> findAll() {
        List<SalesOrder> orders = new ArrayList<>();
        
        String sql = "SELECT Id, OrderNo, CustomerId, Status, CreatedBy, CreatedAt, " +
                     "ConfirmedBy, ConfirmedDate, CancelledBy, CancelledDate, CancellationReason " +
                     "FROM SalesOrders ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                orders.add(mapResultSetToSalesOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Get sales orders by status
     * @param status Order status
     * @return List of sales orders with the specified status
     */
    public List<SalesOrder> findByStatus(String status) {
        List<SalesOrder> orders = new ArrayList<>();
        
        if (status == null || status.trim().isEmpty()) {
            return orders;
        }
        
        String sql = "SELECT Id, OrderNo, CustomerId, Status, CreatedBy, CreatedAt, " +
                     "ConfirmedBy, ConfirmedDate, CancelledBy, CancelledDate, CancellationReason " +
                     "FROM SalesOrders WHERE Status = ? ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToSalesOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Get sales orders by customer
     * @param customerId Customer ID
     * @return List of sales orders for the customer
     */
    public List<SalesOrder> findByCustomer(Long customerId) {
        List<SalesOrder> orders = new ArrayList<>();
        
        if (customerId == null) {
            return orders;
        }
        
        String sql = "SELECT Id, OrderNo, CustomerId, Status, CreatedBy, CreatedAt, " +
                     "ConfirmedBy, ConfirmedDate, CancelledBy, CancelledDate, CancellationReason " +
                     "FROM SalesOrders WHERE CustomerId = ? ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToSalesOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Update sales order status
     * @param id Sales order ID
     * @param status New status
     * @return true if successful
     */
    public boolean updateStatus(Long id, String status) {
        if (id == null || status == null) {
            return false;
        }
        
        String sql = "UPDATE SalesOrders SET Status = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setLong(2, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Confirm a sales order
     * @param id Sales order ID
     * @param confirmedBy User ID who confirms
     * @return true if successful
     */
    public boolean confirm(Long id, Long confirmedBy) {
        if (id == null || confirmedBy == null) {
            return false;
        }
        
        String sql = "UPDATE SalesOrders SET Status = 'Confirmed', ConfirmedBy = ?, " +
                     "ConfirmedDate = GETDATE() WHERE Id = ? AND Status = 'Draft'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, confirmedBy);
            stmt.setLong(2, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Cancel a sales order
     * @param id Sales order ID
     * @param cancelledBy User ID who cancels
     * @param reason Cancellation reason
     * @return true if successful
     */
    public boolean cancel(Long id, Long cancelledBy, String reason) {
        if (id == null || cancelledBy == null || reason == null) {
            return false;
        }
        
        String sql = "UPDATE SalesOrders SET Status = 'Cancelled', CancelledBy = ?, " +
                     "CancelledDate = GETDATE(), CancellationReason = ? " +
                     "WHERE Id = ? AND Status NOT IN ('Completed', 'Cancelled')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, cancelledBy);
            stmt.setString(2, reason);
            stmt.setLong(3, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update order status to FulfillmentRequested
     * @param id Sales order ID
     * @return true if successful
     */
    public boolean markFulfillmentRequested(Long id) {
        if (id == null) {
            return false;
        }
        
        String sql = "UPDATE SalesOrders SET Status = 'FulfillmentRequested' " +
                     "WHERE Id = ? AND Status = 'Confirmed'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update order status to Completed
     * @param id Sales order ID
     * @return true if successful
     */
    public boolean markCompleted(Long id) {
        if (id == null) {
            return false;
        }
        
        String sql = "UPDATE SalesOrders SET Status = 'Completed' " +
                     "WHERE Id = ? AND Status IN ('FulfillmentRequested', 'Confirmed')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Generate unique order number
     * @return Generated order number (SO-YYYYMMDD-XXXX)
     */
    public String generateOrderNumber() {
        String sql = "SELECT CONCAT('SO-', FORMAT(GETDATE(), 'yyyyMMdd'), '-', " +
                     "RIGHT('0000' + CAST(COALESCE(MAX(CAST(RIGHT(OrderNo, 4) AS INT)), 0) + 1 AS VARCHAR), 4)) " +
                     "FROM SalesOrders WHERE OrderNo LIKE 'SO-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-%'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                String orderNo = rs.getString(1);
                if (orderNo != null) {
                    return orderNo;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Fallback
        return "SO-" + System.currentTimeMillis();
    }
    
    /**
     * Check if order has related outbound requests
     * @param salesOrderId Sales order ID
     * @return true if related requests exist
     */
    public boolean hasRelatedRequests(Long salesOrderId) {
        if (salesOrderId == null) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM Requests WHERE SalesOrderId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, salesOrderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if order has active (non-cancelled, non-completed) outbound requests
     * @param salesOrderId Sales order ID
     * @return true if active requests exist
     */
    public boolean hasActiveRequests(Long salesOrderId) {
        if (salesOrderId == null) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM Requests WHERE SalesOrderId = ? " +
                     "AND Status NOT IN ('Completed', 'Rejected')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, salesOrderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Map ResultSet to SalesOrder object
     */
    private SalesOrder mapResultSetToSalesOrder(ResultSet rs) throws SQLException {
        SalesOrder order = new SalesOrder();
        order.setId(rs.getLong("Id"));
        order.setOrderNo(rs.getString("OrderNo"));
        order.setCustomerId(rs.getLong("CustomerId"));
        order.setStatus(rs.getString("Status"));
        order.setCreatedBy(rs.getLong("CreatedBy"));
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            order.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Long confirmedBy = rs.getLong("ConfirmedBy");
        if (!rs.wasNull()) {
            order.setConfirmedBy(confirmedBy);
        }
        
        Timestamp confirmedDate = rs.getTimestamp("ConfirmedDate");
        if (confirmedDate != null) {
            order.setConfirmedDate(confirmedDate.toLocalDateTime());
        }
        
        Long cancelledBy = rs.getLong("CancelledBy");
        if (!rs.wasNull()) {
            order.setCancelledBy(cancelledBy);
        }
        
        Timestamp cancelledDate = rs.getTimestamp("CancelledDate");
        if (cancelledDate != null) {
            order.setCancelledDate(cancelledDate.toLocalDateTime());
        }
        
        order.setCancellationReason(rs.getString("CancellationReason"));
        
        return order;
    }
}
