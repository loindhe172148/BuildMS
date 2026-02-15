package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.CustomerDAO;
import vn.edu.fpt.swp.model.Customer;

import java.util.List;

/**
 * Service layer for Customer operations
 */
public class CustomerService {
    
    private final CustomerDAO customerDAO;
    
    public CustomerService() {
        this.customerDAO = new CustomerDAO();
    }
    
    /**
     * Create new customer
     * @param customer Customer to create
     * @return Created customer, or null if failed
     * @throws IllegalArgumentException if validation fails
     */
    public Customer createCustomer(Customer customer) {
        // Validate required fields
        if (customer.getCode() == null || customer.getCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer code is required");
        }
        if (customer.getName() == null || customer.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer name is required");
        }
        
        // Trim values
        customer.setCode(customer.getCode().trim());
        customer.setName(customer.getName().trim());
        if (customer.getContactInfo() != null) {
            customer.setContactInfo(customer.getContactInfo().trim());
        }
        
        // Check for duplicate code
        Customer existing = customerDAO.findByCode(customer.getCode());
        if (existing != null) {
            throw new IllegalArgumentException("Customer code already exists");
        }
        
        // Set default status
        customer.setStatus("Active");
        
        return customerDAO.create(customer);
    }
    
    /**
     * Update existing customer
     * @param customer Customer to update
     * @return true if successful
     * @throws IllegalArgumentException if validation fails
     */
    public boolean updateCustomer(Customer customer) {
        // Validate required fields
        if (customer.getId() == null) {
            throw new IllegalArgumentException("Customer ID is required");
        }
        if (customer.getCode() == null || customer.getCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer code is required");
        }
        if (customer.getName() == null || customer.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer name is required");
        }
        
        // Trim values
        customer.setCode(customer.getCode().trim());
        customer.setName(customer.getName().trim());
        if (customer.getContactInfo() != null) {
            customer.setContactInfo(customer.getContactInfo().trim());
        }
        
        // Check if customer exists
        Customer existing = customerDAO.findById(customer.getId());
        if (existing == null) {
            throw new IllegalArgumentException("Customer not found");
        }
        
        // Check for duplicate code (excluding current customer)
        Customer duplicateCode = customerDAO.findByCode(customer.getCode());
        if (duplicateCode != null && !duplicateCode.getId().equals(customer.getId())) {
            throw new IllegalArgumentException("Customer code already exists");
        }
        
        return customerDAO.update(customer);
    }
    
    /**
     * Toggle customer status (Active <-> Inactive)
     * @param customerId Customer ID
     * @return true if successful
     * @throws IllegalArgumentException if customer not found
     */
    public boolean toggleCustomerStatus(Long customerId) {
        Customer customer = customerDAO.findById(customerId);
        if (customer == null) {
            throw new IllegalArgumentException("Customer not found");
        }
        
        String newStatus = "Active".equals(customer.getStatus()) ? "Inactive" : "Active";
        return customerDAO.toggleStatus(customerId, newStatus);
    }
    
    /**
     * Get customer by ID
     * @param id Customer ID
     * @return Customer if found
     */
    public Customer getCustomerById(Long id) {
        return customerDAO.findById(id);
    }
    
    /**
     * Get customer by code
     * @param code Customer code
     * @return Customer if found
     */
    public Customer getCustomerByCode(String code) {
        return customerDAO.findByCode(code);
    }
    
    /**
     * Get all customers
     * @return List of all customers
     */
    public List<Customer> getAllCustomers() {
        return customerDAO.getAll();
    }
    
    /**
     * Get customers by status
     * @param status Status to filter (Active/Inactive)
     * @return Filtered list
     */
    public List<Customer> getCustomersByStatus(String status) {
        return customerDAO.findByStatus(status);
    }
    
    /**
     * Get active customers only
     * @return List of active customers
     */
    public List<Customer> getActiveCustomers() {
        return customerDAO.getActiveCustomers();
    }
    
    /**
     * Search customers with filters
     * @param keyword Search keyword (code or name)
     * @param status Status filter (nullable)
     * @return Filtered list
     */
    public List<Customer> searchCustomers(String keyword, String status) {
        return customerDAO.search(keyword, status);
    }
    
    /**
     * Get order count for customer
     * @param customerId Customer ID
     * @return Number of orders
     */
    public int getOrderCount(Long customerId) {
        return customerDAO.getOrderCount(customerId);
    }
    
    /**
     * Check if customer has pending orders
     * @param customerId Customer ID
     * @return true if has pending orders
     */
    public boolean hasPendingOrders(Long customerId) {
        return customerDAO.hasPendingOrders(customerId);
    }
    
    /**
     * Check if customer is active
     * @param customerId Customer ID
     * @return true if active
     */
    public boolean isActive(Long customerId) {
        Customer customer = customerDAO.findById(customerId);
        return customer != null && "Active".equals(customer.getStatus());
    }
}
