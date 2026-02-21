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
    
}
