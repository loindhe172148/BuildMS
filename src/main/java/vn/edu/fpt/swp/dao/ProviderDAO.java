package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Provider;
import vn.edu.fpt.swp.util.DBConnection;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Provider entity
 */
public class ProviderDAO {
    
    /**
     * Create new provider
     * @param provider Provider to create
     * @return Created provider with ID, or null if failed
     */
    public Provider create(Provider provider) {
        String sql = "INSERT INTO Providers (Code, Name, ContactInfo, Status) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, provider.getCode());
            stmt.setString(2, provider.getName());
            stmt.setString(3, provider.getContactInfo());
            stmt.setString(4, provider.getStatus() != null ? provider.getStatus() : "Active");
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        provider.setId(generatedKeys.getLong(1));
                        return provider;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find provider by ID
     * @param id Provider ID
     * @return Provider if found, null otherwise
     */
    public Provider findById(Long id) {
        String sql = "SELECT Id, Code, Name, ContactInfo, Status FROM Providers WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProvider(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find provider by code
     * @param code Provider code
     * @return Provider if found, null otherwise
     */
    public Provider findByCode(String code) {
        String sql = "SELECT Id, Code, Name, ContactInfo, Status FROM Providers WHERE Code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, code);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProvider(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all providers
     * @return List of all providers
     */
    public List<Provider> getAll() {
        List<Provider> providers = new ArrayList<>();
        String sql = "SELECT Id, Code, Name, ContactInfo, Status FROM Providers ORDER BY Name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                providers.add(mapResultSetToProvider(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return providers;
    }
    
    /**
     * Get providers by status
     * @param status Status to filter by (Active/Inactive)
     * @return List of providers with given status
     */
    public List<Provider> findByStatus(String status) {
        List<Provider> providers = new ArrayList<>();
        String sql = "SELECT Id, Code, Name, ContactInfo, Status FROM Providers WHERE Status = ? ORDER BY Name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    providers.add(mapResultSetToProvider(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return providers;
    }
    
    public PageResult<Provider> searchPaginated(String keyword, String status, PageRequest pageRequest) {
        List<Provider> providers = new ArrayList<>();
        StringBuilder fromClause = new StringBuilder(" FROM Providers WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            fromClause.append(" AND (Code LIKE ? OR Name LIKE ?)");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            fromClause.append(" AND Status = ?");
            params.add(status.trim());
        }

        String countSql = "SELECT COUNT(*)" + fromClause;
        String dataSql = "SELECT Id, Code, Name, ContactInfo, Status" + fromClause
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
                        providers.add(mapResultSetToProvider(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return PageResult.of(providers, totalItems, pageRequest);
    }
    
    /**
     * Update provider
     * @param provider Provider to update
     * @return true if successful
     */
    public boolean update(Provider provider) {
        String sql = "UPDATE Providers SET Name = ?, ContactInfo = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, provider.getName());
            stmt.setString(2, provider.getContactInfo());
            stmt.setLong(3, provider.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Toggle provider status
     * @param id Provider ID
     * @param newStatus New status (Active/Inactive)
     * @return true if successful
     */
    public boolean toggleStatus(Long id, String newStatus) {
        String sql = "UPDATE Providers SET Status = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newStatus);
            stmt.setLong(2, id);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if provider is used in any Request
     * @param providerId Provider ID
     * @return true if used
     */
    public boolean isUsedInRequests(Long providerId) {
        String sql = "SELECT COUNT(*) FROM Requests WHERE ProviderId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, providerId);
            
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
     * Get active providers only
     * @return List of active providers
     */
    public List<Provider> getActiveProviders() {
        return findByStatus("Active");
    }
    
    /**
     * Map ResultSet to Provider object
     * @param rs ResultSet
     * @return Provider object
     */
    private Provider mapResultSetToProvider(ResultSet rs) throws SQLException {
        Provider provider = new Provider();
        provider.setId(rs.getLong("Id"));
        provider.setCode(rs.getString("Code"));
        provider.setName(rs.getString("Name"));
        provider.setContactInfo(rs.getString("ContactInfo"));
        provider.setStatus(rs.getString("Status"));
        return provider;
    }
}
