/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.swp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import vn.edu.fpt.swp.model.Location;
import vn.edu.fpt.swp.util.DBConnection;

/**
 *
 * @author dotri
 */
public class LocationDAO {
    public Location findById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLocation(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    public List<Location> findByWarehouse(Long warehouseId) {
        if (warehouseId == null || warehouseId <= 0) {
            return new ArrayList<>();
        }
        
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT Id, WarehouseId, Code, Type, IsActive FROM Locations " +
                     "WHERE WarehouseId = ? ORDER BY Code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, warehouseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    locations.add(mapResultSetToLocation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return locations;
    }
    
    private Location mapResultSetToLocation(ResultSet rs) throws SQLException {
        Location location = new Location();
        location.setId(rs.getLong("Id"));
        location.setWarehouseId(rs.getLong("WarehouseId"));
        location.setCode(rs.getString("Code"));
        location.setType(rs.getString("Type"));
        location.setActive(rs.getBoolean("IsActive"));
        return location;
    }
}
