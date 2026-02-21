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
  
}
