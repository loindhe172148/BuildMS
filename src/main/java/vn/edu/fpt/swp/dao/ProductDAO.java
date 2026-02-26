package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Product;
import vn.edu.fpt.swp.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Product entity
 */
public class ProductDAO {
    
    /**
     * Find product by ID
     * @param id Product ID
     * @return Product object if found, null otherwise
     */
    public Product findById(Long id) {
        String sql = "SELECT id, sku, name, unit, categoryId, isActive, createdAt FROM Products WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Find product by SKU
     * @param sku Product SKU
     * @return Product object if found, null otherwise
     */
    public Product findBySku(String sku) {
        String sql = "SELECT id, sku, name, unit, categoryId, isActive, createdAt FROM Products WHERE sku = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sku);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all products
     * @return List of all products
     */
    public List<Product> getAll() {
        String sql = "SELECT id, sku, name, unit, categoryId, isActive, createdAt FROM Products ORDER BY name";
        List<Product> products = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * Get products by category
     * @param categoryId Category ID
     * @return List of products in the category
     */
    public List<Product> findByCategory(Long categoryId) {
        String sql = "SELECT id, sku, name, unit, categoryId, isActive, createdAt FROM Products " +
                     "WHERE categoryId = ? ORDER BY name";
        List<Product> products = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, categoryId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * Get active products only
     * @return List of active products
     */
    public List<Product> getActive() {
        String sql = "SELECT id, sku, name, unit, categoryId, isActive, createdAt FROM Products " +
                     "WHERE isActive = 1 ORDER BY name";
        List<Product> products = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * Create a new product
     * @param product Product object
     * @return Created product with generated ID, null if creation failed
     */
    public Product create(Product product) {
        if (product == null || product.getSku() == null || product.getSku().trim().isEmpty() ||
            product.getName() == null || product.getName().trim().isEmpty() ||
            product.getCategoryId() == null) {
            return null;
        }
        
        String sql = "INSERT INTO Products (sku, name, unit, categoryId, isActive, createdAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, product.getSku().trim());
            stmt.setString(2, product.getName().trim());
            stmt.setString(3, product.getUnit() != null ? product.getUnit().trim() : null);
            stmt.setLong(4, product.getCategoryId());
            stmt.setBoolean(5, product.isActive());
            stmt.setObject(6, LocalDateTime.now());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        product.setId(generatedKeys.getLong(1));
                        return product;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update an existing product
     * @param product Product object with updated values
     * @return true if update successful, false otherwise
     */
    public boolean update(Product product) {
        if (product == null || product.getId() == null || product.getSku() == null ||
            product.getSku().trim().isEmpty() || product.getName() == null ||
            product.getName().trim().isEmpty() || product.getCategoryId() == null) {
            return false;
        }
        
        String sql = "UPDATE Products SET sku = ?, name = ?, unit = ?, categoryId = ?, isActive = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getSku().trim());
            stmt.setString(2, product.getName().trim());
            stmt.setString(3, product.getUnit() != null ? product.getUnit().trim() : null);
            stmt.setLong(4, product.getCategoryId());
            stmt.setBoolean(5, product.isActive());
            stmt.setLong(6, product.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Toggle product active status
     * @param id Product ID
     * @param isActive New status
     * @return true if update successful, false otherwise
     */
    public boolean toggleStatus(Long id, boolean isActive) {
        if (id == null || id <= 0) {
            return false;
        }
        
        String sql = "UPDATE Products SET isActive = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, isActive);
            stmt.setLong(2, id);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a product
     * @param id Product ID
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        String sql = "DELETE FROM Products WHERE id = ?";
        
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
     * Get total inventory quantity for a product across all locations
     * @param productId Product ID
     * @return Total quantity
     */
    public int getTotalInventoryQuantity(Long productId) {
        if (productId == null || productId <= 0) {
            return 0;
        }
        
        String sql = "SELECT ISNULL(SUM(quantity), 0) as totalQty FROM Inventory WHERE productId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totalQty");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Check if product has pending sales orders
     * @param productId Product ID
     * @return Number of pending sales orders containing this product
     */
    public int countPendingOrders(Long productId) {
        if (productId == null || productId <= 0) {
            return 0;
        }
        
        String sql = "SELECT COUNT(DISTINCT so.id) as count FROM SalesOrders so " +
                     "JOIN SalesOrderItems soi ON so.id = soi.salesOrderId " +
                     "WHERE soi.productId = ? AND so.status != 'Completed' AND so.status != 'Cancelled'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, productId);
            
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
     * Search products
     * @param keyword Search keyword (searches SKU and name)
     * @return List of matching products
     */
    public List<Product> search(String keyword) {
        List<Product> products = new ArrayList<>();
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAll();
        }
        
        String sql = "SELECT id, sku, name, unit, categoryId, isActive, createdAt FROM Products " +
                     "WHERE sku LIKE ? OR name LIKE ? " +
                     "ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword.trim() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * Get products by status
     * @param isActive true for active, false for inactive
     * @return List of products with specified status
     */
    public List<Product> findByStatus(boolean isActive) {
        String sql = "SELECT id, sku, name, unit, categoryId, isActive, createdAt FROM Products " +
                     "WHERE isActive = ? ORDER BY name";
        List<Product> products = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, isActive);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * Map ResultSet row to Product object
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getLong("id"));
        product.setSku(rs.getString("sku"));
        product.setName(rs.getString("name"));
        product.setUnit(rs.getString("unit"));
        product.setCategoryId(rs.getLong("categoryId"));
        product.setActive(rs.getBoolean("isActive"));
        
        // Handle createdAt
        Timestamp ts = rs.getTimestamp("createdAt");
        if (ts != null) {
            product.setCreatedAt(ts.toLocalDateTime());
        }
        
        return product;
    }
}
