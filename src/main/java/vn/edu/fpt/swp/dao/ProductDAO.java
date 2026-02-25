/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.swp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import vn.edu.fpt.swp.model.Product;
import vn.edu.fpt.swp.util.DBConnection;

/**
 *
 * @author dotri
 */
public class ProductDAO {
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
