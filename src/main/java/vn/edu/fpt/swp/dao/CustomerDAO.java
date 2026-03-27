package vn.edu.fpt.swp.dao;

import vn.edu.fpt.swp.model.Customer;
import vn.edu.fpt.swp.util.DBConnection;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Customer entity
 */
public class CustomerDAO {
    
    /**
     * Create new customer
     * @param customer Customer to create
     * @return Created customer with ID, or null if failed
     */
    public Customer create(Customer customer) {
        String sql = "INSERT INTO Customers (Code, Name, ContactInfo, Status) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, customer.getCode());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getContactInfo());
            stmt.setString(4, customer.getStatus() != null ? customer.getStatus() : "Active");
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        customer.setId(generatedKeys.getLong(1));
                        return customer;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find customer by ID
     * @param id Customer ID
     * @return Customer if found, null otherwise
     */
    public Customer findById(Long id) {
        String sql = "SELECT Id, Code, Name, ContactInfo, Status FROM Customers WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Find customer by code
     * @param code Customer code
     * @return Customer if found, null otherwise
     */
    public Customer findByCode(String code) {
        String sql = "SELECT Id, Code, Name, ContactInfo, Status FROM Customers WHERE Code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, code);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all customers
     * @return List of all customers
     */
    public List<Customer> getAll() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT Id, Code, Name, ContactInfo, Status FROM Customers ORDER BY Name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }
    
    /**
     * Get customers by status
     * @param status Status to filter by (Active/Inactive)
     * @return List of customers with given status
     */
    public List<Customer> findByStatus(String status) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT Id, Code, Name, ContactInfo, Status FROM Customers WHERE Status = ? ORDER BY Name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapResultSetToCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }
    
    /**
     * Search customers with filters
     * @param keyword Search by code or name (nullable)
     * @param status Status filter (nullable)
     * @return Filtered list of customers
     */
    public List<Customer> search(String keyword, String status) {
        List<Customer> customers = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT Id, Code, Name, ContactInfo, Status FROM Customers WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Code LIKE ? OR Name LIKE ?)");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add(status);
        }
        
        sql.append(" ORDER BY Name");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapResultSetToCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public PageResult<Customer> searchPaginated(String keyword, String status, PageRequest pageRequest) {
        List<Customer> customers = new ArrayList<>();
        StringBuilder fromClause = new StringBuilder(" FROM Customers WHERE 1=1");
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
                        customers.add(mapResultSetToCustomer(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return PageResult.of(customers, totalItems, pageRequest);
    }
    
    /**
     * Update customer
     * @param customer Customer to update
     * @return true if successful
     */
    public boolean update(Customer customer) {
        String sql = "UPDATE Customers SET Code = ?, Name = ?, ContactInfo = ? WHERE Id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getCode());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getContactInfo());
            stmt.setLong(4, customer.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Toggle customer status
     * @param id Customer ID
     * @param newStatus New status (Active/Inactive)
     * @return true if successful
     */
    public boolean toggleStatus(Long id, String newStatus) {
        String sql = "UPDATE Customers SET Status = ? WHERE Id = ?";
        
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
     * Get order count for customer
     * @param customerId Customer ID
     * @return Number of orders
     */
    public int getOrderCount(Long customerId) {
        String sql = "SELECT COUNT(*) FROM SalesOrders WHERE CustomerId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Check if customer has pending orders
     * @param customerId Customer ID
     * @return true if has pending orders
     */
    public boolean hasPendingOrders(Long customerId) {
        String sql = "SELECT COUNT(*) FROM SalesOrders WHERE CustomerId = ? AND Status NOT IN ('Completed', 'Cancelled')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, customerId);
            
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
     * Get active customers only
     * @return List of active customers
     */
    public List<Customer> getActiveCustomers() {
        return findByStatus("Active");
    }
    
    /**
     * Get order count for all customers in one query — avoids N+1 on the list page.
     *
     * @return Map of customerId -> order count
     */
    public Map<Long, Integer> getAllOrderCounts() {
        Map<Long, Integer> result = new HashMap<>();
        String sql = "SELECT CustomerId, COUNT(*) AS cnt FROM SalesOrders GROUP BY CustomerId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                result.put(rs.getLong("CustomerId"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Map ResultSet to Customer object
     * @param rs ResultSet
     * @return Customer object
     */
    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setId(rs.getLong("Id"));
        customer.setCode(rs.getString("Code"));
        customer.setName(rs.getString("Name"));
        customer.setContactInfo(rs.getString("ContactInfo"));
        customer.setStatus(rs.getString("Status"));
        return customer;
    }
}
