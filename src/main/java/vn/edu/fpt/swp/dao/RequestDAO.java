package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Request;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Request entity
 * Handles Inbound, Outbound, Transfer, and Internal requests
 */
public class RequestDAO {
    
    /**
     * Create a new request
     * @param request Request to create
     * @return Created request with generated ID, null if failed
     */
    public Request create(Request request) {
        if (request == null || request.getType() == null || request.getCreatedBy() == null) {
            return null;
        }
        
        String sql = "INSERT INTO Requests (Type, Status, CreatedBy, SalesOrderId, SourceWarehouseId, " +
                     "DestinationWarehouseId, ExpectedDate, Notes, Reason, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, request.getType());
            stmt.setString(2, request.getStatus() != null ? request.getStatus() : "Created");
            stmt.setLong(3, request.getCreatedBy());
            
            if (request.getSalesOrderId() != null) {
                stmt.setLong(4, request.getSalesOrderId());
            } else {
                stmt.setNull(4, Types.BIGINT);
            }
            
            if (request.getSourceWarehouseId() != null) {
                stmt.setLong(5, request.getSourceWarehouseId());
            } else {
                stmt.setNull(5, Types.BIGINT);
            }
            
            if (request.getDestinationWarehouseId() != null) {
                stmt.setLong(6, request.getDestinationWarehouseId());
            } else {
                stmt.setNull(6, Types.BIGINT);
            }
            
            if (request.getExpectedDate() != null) {
                stmt.setTimestamp(7, Timestamp.valueOf(request.getExpectedDate()));
            } else {
                stmt.setNull(7, Types.TIMESTAMP);
            }
            
            stmt.setString(8, request.getNotes());
            stmt.setString(9, request.getReason());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        request.setId(generatedKeys.getLong(1));
                        return request;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find request by ID
     * @param id Request ID
     * @return Request if found, null otherwise
     */
    public Request findById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        
        String sql = "SELECT Id, Type, Status, CreatedBy, ApprovedBy, ApprovedDate, " +
                     "RejectedBy, RejectedDate, RejectionReason, CompletedBy, CompletedDate, " +
                     "SalesOrderId, SourceWarehouseId, DestinationWarehouseId, ExpectedDate, " +
                     "Notes, Reason, CreatedAt FROM Requests WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRequest(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all requests of a specific type
     * @param type Request type (Inbound, Outbound, Transfer, Internal)
     * @return List of requests
     */
    public List<Request> findByType(String type) {
        List<Request> requests = new ArrayList<>();
        
        if (type == null || type.trim().isEmpty()) {
            return requests;
        }
        
        String sql = "SELECT Id, Type, Status, CreatedBy, ApprovedBy, ApprovedDate, " +
                     "RejectedBy, RejectedDate, RejectionReason, CompletedBy, CompletedDate, " +
                     "SalesOrderId, SourceWarehouseId, DestinationWarehouseId, ExpectedDate, " +
                     "Notes, Reason, CreatedAt FROM Requests WHERE Type = ? ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, type);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToRequest(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    /**
     * Get requests by type and status
     * @param type Request type
     * @param status Request status
     * @return List of matching requests
     */
    public List<Request> findByTypeAndStatus(String type, String status) {
        List<Request> requests = new ArrayList<>();
        
        if (type == null || status == null) {
            return requests;
        }
        
        String sql = "SELECT Id, Type, Status, CreatedBy, ApprovedBy, ApprovedDate, " +
                     "RejectedBy, RejectedDate, RejectionReason, CompletedBy, CompletedDate, " +
                     "SalesOrderId, SourceWarehouseId, DestinationWarehouseId, ExpectedDate, " +
                     "Notes, Reason, CreatedAt FROM Requests WHERE Type = ? AND Status = ? " +
                     "ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, type);
            stmt.setString(2, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToRequest(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    /**
     * Get requests by warehouse (source or destination)
     * @param warehouseId Warehouse ID
     * @return List of requests related to the warehouse
     */
    public List<Request> findByWarehouse(Long warehouseId) {
        List<Request> requests = new ArrayList<>();
        
        if (warehouseId == null) {
            return requests;
        }
        
        String sql = "SELECT Id, Type, Status, CreatedBy, ApprovedBy, ApprovedDate, " +
                     "RejectedBy, RejectedDate, RejectionReason, CompletedBy, CompletedDate, " +
                     "SalesOrderId, SourceWarehouseId, DestinationWarehouseId, ExpectedDate, " +
                     "Notes, Reason, CreatedAt FROM Requests " +
                     "WHERE SourceWarehouseId = ? OR DestinationWarehouseId = ? " +
                     "ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            stmt.setLong(2, warehouseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToRequest(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    /**
     * Search requests with filters
     * @param type Request type (optional)
     * @param status Request status (optional)
     * @param warehouseId Warehouse ID (optional)
     * @return List of matching requests
     */
    public List<Request> search(String type, String status, Long warehouseId) {
        List<Request> requests = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT Id, Type, Status, CreatedBy, ApprovedBy, ApprovedDate, ");
        sql.append("RejectedBy, RejectedDate, RejectionReason, CompletedBy, CompletedDate, ");
        sql.append("SalesOrderId, SourceWarehouseId, DestinationWarehouseId, ExpectedDate, ");
        sql.append("Notes, Reason, CreatedAt FROM Requests WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND Type = ? ");
            params.add(type);
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND Status = ? ");
            params.add(status);
        }
        
        if (warehouseId != null) {
            sql.append("AND (SourceWarehouseId = ? OR DestinationWarehouseId = ?) ");
            params.add(warehouseId);
            params.add(warehouseId);
        }
        
        sql.append("ORDER BY CreatedAt DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToRequest(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    /**
     * Update request status to Approved
     * @param requestId Request ID
     * @param approvedBy User ID who approved
     * @return true if successful
     */
    public boolean approve(Long requestId, Long approvedBy) {
        if (requestId == null || approvedBy == null) {
            return false;
        }
        
        String sql = "UPDATE Requests SET Status = 'Approved', ApprovedBy = ?, ApprovedDate = GETDATE() " +
                     "WHERE Id = ? AND Status = 'Created'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, approvedBy);
            stmt.setLong(2, requestId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update request status to Rejected
     * @param requestId Request ID
     * @param rejectedBy User ID who rejected
     * @param reason Rejection reason
     * @return true if successful
     */
    public boolean reject(Long requestId, Long rejectedBy, String reason) {
        if (requestId == null || rejectedBy == null || reason == null || reason.trim().isEmpty()) {
            return false;
        }
        
        String sql = "UPDATE Requests SET Status = 'Rejected', RejectedBy = ?, RejectedDate = GETDATE(), " +
                     "RejectionReason = ? WHERE Id = ? AND Status = 'Created'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, rejectedBy);
            stmt.setString(2, reason.trim());
            stmt.setLong(3, requestId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update request status to InProgress
     * @param requestId Request ID
     * @return true if successful
     */
    public boolean startExecution(Long requestId) {
        if (requestId == null) {
            return false;
        }
        
        String sql = "UPDATE Requests SET Status = 'InProgress' WHERE Id = ? AND Status = 'Approved'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, requestId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update request status to Completed
     * @param requestId Request ID
     * @param completedBy User ID who completed
     * @return true if successful
     */
    public boolean complete(Long requestId, Long completedBy) {
        if (requestId == null || completedBy == null) {
            return false;
        }
        
        String sql = "UPDATE Requests SET Status = 'Completed', CompletedBy = ?, CompletedDate = GETDATE() " +
                     "WHERE Id = ? AND Status = 'InProgress'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, completedBy);
            stmt.setLong(2, requestId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update request status to a specific value
     * @param requestId Request ID
     * @param newStatus New status value
     * @return true if successful
     */
    public boolean updateStatus(Long requestId, String newStatus) {
        if (requestId == null || newStatus == null) {
            return false;
        }
        
        String sql = "UPDATE Requests SET Status = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newStatus);
            stmt.setLong(2, requestId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update request fields
     * @param request Request with updated values
     * @return true if successful
     */
    public boolean update(Request request) {
        if (request == null || request.getId() == null) {
            return false;
        }
        
        String sql = "UPDATE Requests SET SourceWarehouseId = ?, DestinationWarehouseId = ?, " +
                     "ExpectedDate = ?, Notes = ?, Reason = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (request.getSourceWarehouseId() != null) {
                stmt.setLong(1, request.getSourceWarehouseId());
            } else {
                stmt.setNull(1, Types.BIGINT);
            }
            
            if (request.getDestinationWarehouseId() != null) {
                stmt.setLong(2, request.getDestinationWarehouseId());
            } else {
                stmt.setNull(2, Types.BIGINT);
            }
            
            if (request.getExpectedDate() != null) {
                stmt.setTimestamp(3, Timestamp.valueOf(request.getExpectedDate()));
            } else {
                stmt.setNull(3, Types.TIMESTAMP);
            }
            
            stmt.setString(4, request.getNotes());
            stmt.setString(5, request.getReason());
            stmt.setLong(6, request.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get requests by sales order ID
     * @param salesOrderId Sales Order ID
     * @return List of requests linked to the sales order
     */
    public List<Request> findBySalesOrderId(Long salesOrderId) {
        List<Request> requests = new ArrayList<>();
        
        if (salesOrderId == null) {
            return requests;
        }
        
        String sql = "SELECT Id, Type, Status, CreatedBy, ApprovedBy, ApprovedDate, " +
                     "RejectedBy, RejectedDate, RejectionReason, CompletedBy, CompletedDate, " +
                     "SalesOrderId, SourceWarehouseId, DestinationWarehouseId, ExpectedDate, " +
                     "Notes, Reason, CreatedAt FROM Requests WHERE SalesOrderId = ? " +
                     "ORDER BY CreatedAt DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, salesOrderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToRequest(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    /**
     * Map ResultSet to Request object
     */
    private Request mapResultSetToRequest(ResultSet rs) throws SQLException {
        Request request = new Request();
        request.setId(rs.getLong("Id"));
        request.setType(rs.getString("Type"));
        request.setStatus(rs.getString("Status"));
        request.setCreatedBy(rs.getLong("CreatedBy"));
        
        long approvedBy = rs.getLong("ApprovedBy");
        if (!rs.wasNull()) {
            request.setApprovedBy(approvedBy);
        }
        
        Timestamp approvedDate = rs.getTimestamp("ApprovedDate");
        if (approvedDate != null) {
            request.setApprovedDate(approvedDate.toLocalDateTime());
        }
        
        long rejectedBy = rs.getLong("RejectedBy");
        if (!rs.wasNull()) {
            request.setRejectedBy(rejectedBy);
        }
        
        Timestamp rejectedDate = rs.getTimestamp("RejectedDate");
        if (rejectedDate != null) {
            request.setRejectedDate(rejectedDate.toLocalDateTime());
        }
        
        request.setRejectionReason(rs.getString("RejectionReason"));
        
        long completedBy = rs.getLong("CompletedBy");
        if (!rs.wasNull()) {
            request.setCompletedBy(completedBy);
        }
        
        Timestamp completedDate = rs.getTimestamp("CompletedDate");
        if (completedDate != null) {
            request.setCompletedDate(completedDate.toLocalDateTime());
        }
        
        long salesOrderId = rs.getLong("SalesOrderId");
        if (!rs.wasNull()) {
            request.setSalesOrderId(salesOrderId);
        }
        
        long sourceWarehouseId = rs.getLong("SourceWarehouseId");
        if (!rs.wasNull()) {
            request.setSourceWarehouseId(sourceWarehouseId);
        }
        
        long destinationWarehouseId = rs.getLong("DestinationWarehouseId");
        if (!rs.wasNull()) {
            request.setDestinationWarehouseId(destinationWarehouseId);
        }
        
        Timestamp expectedDate = rs.getTimestamp("ExpectedDate");
        if (expectedDate != null) {
            request.setExpectedDate(expectedDate.toLocalDateTime());
        }
        
        request.setNotes(rs.getString("Notes"));
        request.setReason(rs.getString("Reason"));
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            request.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return request;
    }
}
