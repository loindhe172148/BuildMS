package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Category;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Category entity
 */
public class CategoryDAO {
    
    /**
     * Find category by ID
     * @param id Category ID
     * @return Category object if found, null otherwise
     */
    public Category findById(Long id) {
        String sql = "SELECT id, name, description FROM Categories WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find category by name
     * @param name Category name
     * @return Category object if found, null otherwise
     */
    public Category findByName(String name) {
        String sql = "SELECT id, name, description FROM Categories WHERE name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, name);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all categories
     * @return List of all categories
     */
    public List<Category> getAll() {
        String sql = "SELECT id, name, description FROM Categories ORDER BY name";
        List<Category> categories = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
    
    /**
     * Create a new category
     * @param category Category object
     * @return Created category with generated ID, null if creation failed
     */
    public Category create(Category category) {
        if (category == null || category.getName() == null || category.getName().trim().isEmpty()) {
            return null;
        }
        
        String sql = "INSERT INTO Categories (name, description) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, category.getName().trim());
            stmt.setString(2, category.getDescription() != null ? category.getDescription().trim() : null);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        category.setId(generatedKeys.getLong(1));
                        return category;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update an existing category
     * @param category Category object with updated values
     * @return true if update successful, false otherwise
     */
    public boolean update(Category category) {
        if (category == null || category.getId() == null || category.getName() == null || 
            category.getName().trim().isEmpty()) {
            return false;
        }
        
        String sql = "UPDATE Categories SET name = ?, description = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category.getName().trim());
            stmt.setString(2, category.getDescription() != null ? category.getDescription().trim() : null);
            stmt.setLong(3, category.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a category
     * @param id Category ID
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        String sql = "DELETE FROM Categories WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Count products in a category
     * @param categoryId Category ID
     * @return Number of products in the category
     */
    public int countProducts(Long categoryId) {
        if (categoryId == null || categoryId <= 0) {
            return 0;
        }
        
        String sql = "SELECT COUNT(*) as count FROM Products WHERE CategoryId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, categoryId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Search categories by name or description
     * @param keyword Search keyword
     * @return List of matching categories
     */
    public List<Category> search(String keyword) {
        List<Category> categories = new ArrayList<>();
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAll();
        }
        
        String sql = "SELECT id, name, description FROM Categories " +
                     "WHERE name LIKE ? OR description LIKE ? " +
                     "ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword.trim() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    categories.add(mapResultSetToCategory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
    
    /**
     * Map ResultSet row to Category object
     */
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getLong("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        return category;
    }
}
