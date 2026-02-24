package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.RequestItem;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for RequestItem entity
 */
public class RequestItemDAO {
    
    /**
     * Create a new request item
     * @param item RequestItem to create
     * @return true if successful
     */
    public boolean create(RequestItem item) {
        if (item == null || item.getRequestId() == null || item.getProductId() == null) {
            return false;
        }
        
        String sql = "INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, " +
                     "SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, item.getRequestId());
            stmt.setLong(2, item.getProductId());
            stmt.setInt(3, item.getQuantity() != null ? item.getQuantity() : 0);
            
            if (item.getLocationId() != null) {
                stmt.setLong(4, item.getLocationId());
            } else {
                stmt.setNull(4, Types.BIGINT);
            }
            
            if (item.getSourceLocationId() != null) {
                stmt.setLong(5, item.getSourceLocationId());
            } else {
                stmt.setNull(5, Types.BIGINT);
            }
            
            if (item.getDestinationLocationId() != null) {
                stmt.setLong(6, item.getDestinationLocationId());
            } else {
                stmt.setNull(6, Types.BIGINT);
            }
            
            if (item.getReceivedQuantity() != null) {
                stmt.setInt(7, item.getReceivedQuantity());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }
            
            if (item.getPickedQuantity() != null) {
                stmt.setInt(8, item.getPickedQuantity());
            } else {
                stmt.setNull(8, Types.INTEGER);
            }
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Create multiple request items in batch
     * @param items List of items to create
     * @return true if all successful
     */
    public boolean createBatch(List<RequestItem> items) {
        if (items == null || items.isEmpty()) {
            return false;
        }
        
        String sql = "INSERT INTO RequestItems (RequestId, ProductId, Quantity, LocationId, " +
                     "SourceLocationId, DestinationLocationId, ReceivedQuantity, PickedQuantity) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            stmt = conn.prepareStatement(sql);
            
            for (RequestItem item : items) {
                stmt.setLong(1, item.getRequestId());
                stmt.setLong(2, item.getProductId());
                stmt.setInt(3, item.getQuantity() != null ? item.getQuantity() : 0);
                
                if (item.getLocationId() != null) {
                    stmt.setLong(4, item.getLocationId());
                } else {
                    stmt.setNull(4, Types.BIGINT);
                }
                
                if (item.getSourceLocationId() != null) {
                    stmt.setLong(5, item.getSourceLocationId());
                } else {
                    stmt.setNull(5, Types.BIGINT);
                }
                
                if (item.getDestinationLocationId() != null) {
                    stmt.setLong(6, item.getDestinationLocationId());
                } else {
                    stmt.setNull(6, Types.BIGINT);
                }
                
                if (item.getReceivedQuantity() != null) {
                    stmt.setInt(7, item.getReceivedQuantity());
                } else {
                    stmt.setNull(7, Types.INTEGER);
                }
                
                if (item.getPickedQuantity() != null) {
                    stmt.setInt(8, item.getPickedQuantity());
                } else {
                    stmt.setNull(8, Types.INTEGER);
                }
                
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            conn.commit();
            
            for (int result : results) {
                if (result <= 0 && result != Statement.SUCCESS_NO_INFO) {
                    return false;
                }
            }
            
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Find all items for a request
     * @param requestId Request ID
     * @return List of request items
     */
    public List<RequestItem> findByRequestId(Long requestId) {
        List<RequestItem> items = new ArrayList<>();
        
        if (requestId == null) {
            return items;
        }
        
        String sql = "SELECT RequestId, ProductId, Quantity, LocationId, SourceLocationId, " +
                     "DestinationLocationId, ReceivedQuantity, PickedQuantity " +
                     "FROM RequestItems WHERE RequestId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, requestId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToRequestItem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Find a specific item in a request
     * @param requestId Request ID
     * @param productId Product ID
     * @return RequestItem if found
     */
    public RequestItem findByRequestAndProduct(Long requestId, Long productId) {
        if (requestId == null || productId == null) {
            return null;
        }
        
        String sql = "SELECT RequestId, ProductId, Quantity, LocationId, SourceLocationId, " +
                     "DestinationLocationId, ReceivedQuantity, PickedQuantity " +
                     "FROM RequestItems WHERE RequestId = ? AND ProductId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, requestId);
            stmt.setLong(2, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRequestItem(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update received quantity for inbound execution
     * @param requestId Request ID
     * @param productId Product ID
     * @param receivedQuantity Actual received quantity
     * @return true if successful
     */
    public boolean updateReceivedQuantity(Long requestId, Long productId, Integer receivedQuantity) {
        if (requestId == null || productId == null || receivedQuantity == null) {
            return false;
        }
        
        String sql = "UPDATE RequestItems SET ReceivedQuantity = ? WHERE RequestId = ? AND ProductId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, receivedQuantity);
            stmt.setLong(2, requestId);
            stmt.setLong(3, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update picked quantity for outbound execution
     * @param requestId Request ID
     * @param productId Product ID
     * @param pickedQuantity Actual picked quantity
     * @return true if successful
     */
    public boolean updatePickedQuantity(Long requestId, Long productId, Integer pickedQuantity) {
        if (requestId == null || productId == null || pickedQuantity == null) {
            return false;
        }
        
        String sql = "UPDATE RequestItems SET PickedQuantity = ? WHERE RequestId = ? AND ProductId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pickedQuantity);
            stmt.setLong(2, requestId);
            stmt.setLong(3, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update location for a request item
     * @param requestId Request ID
     * @param productId Product ID
     * @param locationId New location ID
     * @return true if successful
     */
    public boolean updateLocation(Long requestId, Long productId, Long locationId) {
        if (requestId == null || productId == null) {
            return false;
        }
        
        String sql = "UPDATE RequestItems SET LocationId = ? WHERE RequestId = ? AND ProductId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (locationId != null) {
                stmt.setLong(1, locationId);
            } else {
                stmt.setNull(1, Types.BIGINT);
            }
            stmt.setLong(2, requestId);
            stmt.setLong(3, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete all items for a request
     * @param requestId Request ID
     * @return true if successful
     */
    public boolean deleteByRequestId(Long requestId) {
        if (requestId == null) {
            return false;
        }
        
        String sql = "DELETE FROM RequestItems WHERE RequestId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, requestId);
            
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Map ResultSet to RequestItem object
     */
    private RequestItem mapResultSetToRequestItem(ResultSet rs) throws SQLException {
        RequestItem item = new RequestItem();
        item.setRequestId(rs.getLong("RequestId"));
        item.setProductId(rs.getLong("ProductId"));
        item.setQuantity(rs.getInt("Quantity"));
        
        long locationId = rs.getLong("LocationId");
        if (!rs.wasNull()) {
            item.setLocationId(locationId);
        }
        
        long sourceLocationId = rs.getLong("SourceLocationId");
        if (!rs.wasNull()) {
            item.setSourceLocationId(sourceLocationId);
        }
        
        long destLocationId = rs.getLong("DestinationLocationId");
        if (!rs.wasNull()) {
            item.setDestinationLocationId(destLocationId);
        }
        
        int receivedQty = rs.getInt("ReceivedQuantity");
        if (!rs.wasNull()) {
            item.setReceivedQuantity(receivedQty);
        }
        
        int pickedQty = rs.getInt("PickedQuantity");
        if (!rs.wasNull()) {
            item.setPickedQuantity(pickedQty);
        }
        
        return item;
    }
}
