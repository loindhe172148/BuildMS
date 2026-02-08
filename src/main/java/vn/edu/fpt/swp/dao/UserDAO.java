package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User entity
 */
public class UserDAO {
    
    /**
     * Find user by ID
     * @param id User ID
     * @return User object if found, null otherwise
     */
    public User findById(Long id) {
        String sql = "SELECT id, username, name, email, passwordHash, role, status, warehouseId, createdAt, lastLogin " +
                     "FROM Users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find user by username
     * @param username Username to search for
     * @return User object if found, null otherwise
     */
    public User findByUsername(String username) {
        String sql = "SELECT id, username, name, email, passwordHash, role, status, warehouseId, createdAt, lastLogin " +
                     "FROM Users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find user by email
     * @param email Email to search for
     * @return User object if found, null otherwise
     */
    public User findByEmail(String email) {
        String sql = "SELECT id, username, name, email, passwordHash, role, status, warehouseId, createdAt, lastLogin " +
                     "FROM Users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update user's last login timestamp
     * @param userId User ID
     * @return true if update successful
     */
    public boolean updateLastLogin(Long userId) {
        String sql = "UPDATE Users SET lastLogin = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update user's password
     * @param userId User ID
     * @param newPasswordHash New password hash (includes salt)
     * @return true if update successful
     */
    public boolean updatePassword(Long userId, String newPasswordHash) {
        String sql = "UPDATE Users SET passwordHash = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPasswordHash);
            stmt.setLong(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Create new user
     * @param user User object to create
     * @return Created user with ID, or null if failed
     */
    public User create(User user) {
        String sql = "INSERT INTO Users (username, name, email, passwordHash, role, status, warehouseId, createdAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPasswordHash());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getStatus());
            
            if (user.getWarehouseId() != null) {
                stmt.setLong(7, user.getWarehouseId());
            } else {
                stmt.setNull(7, Types.BIGINT);
            }
            
            stmt.setTimestamp(8, Timestamp.valueOf(user.getCreatedAt()));
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getLong(1));
                        return user;
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, name, email, passwordHash, role, status, warehouseId, createdAt, lastLogin " +
                     "FROM Users ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Search users with filters
     * @param keyword Search by username or email
     * @param role Role filter
     * @param status Status filter
     * @param warehouseId Warehouse filter
     * @return Filtered list of users
     */
    public List<User> search(String keyword, String role, String status, Long warehouseId) {
        List<User> users = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT id, username, name, email, passwordHash, role, status, warehouseId, createdAt, lastLogin " +
            "FROM Users WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR email LIKE ? OR name LIKE ?)");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }
        
        if (role != null && !role.trim().isEmpty()) {
            sql.append(" AND role = ?");
            params.add(role);
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        
        if (warehouseId != null) {
            sql.append(" AND warehouseId = ?");
            params.add(warehouseId);
        }
        
        sql.append(" ORDER BY name");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Get users by role
     * @param role Role to filter
     * @return List of users with given role
     */
    public List<User> findByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, name, email, passwordHash, role, status, warehouseId, createdAt, lastLogin " +
                     "FROM Users WHERE role = ? ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Get users by status
     * @param status Status to filter
     * @return List of users with given status
     */
    public List<User> findByStatus(String status) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, name, email, passwordHash, role, status, warehouseId, createdAt, lastLogin " +
                     "FROM Users WHERE status = ? ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Update user (without password)
     * @param user User to update
     * @return true if successful
     */
    public boolean update(User user) {
        String sql = "UPDATE Users SET username = ?, name = ?, email = ?, role = ?, warehouseId = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getRole());
            
            if (user.getWarehouseId() != null) {
                stmt.setLong(5, user.getWarehouseId());
            } else {
                stmt.setNull(5, Types.BIGINT);
            }
            
            stmt.setLong(6, user.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Toggle user status
     * @param id User ID
     * @param newStatus New status (Active/Inactive)
     * @return true if successful
     */
    public boolean toggleStatus(Long id, String newStatus) {
        String sql = "UPDATE Users SET status = ? WHERE id = ?";
        
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
     * Map ResultSet to User object
     * @param rs ResultSet
     * @return User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("passwordHash"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        
        Long warehouseId = rs.getLong("warehouseId");
        if (!rs.wasNull()) {
            user.setWarehouseId(warehouseId);
        }
        
        Timestamp createdAt = rs.getTimestamp("createdAt");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp lastLogin = rs.getTimestamp("lastLogin");
        if (lastLogin != null) {
            user.setLastLogin(lastLogin.toLocalDateTime());
        }
        
        return user;
    }
}
