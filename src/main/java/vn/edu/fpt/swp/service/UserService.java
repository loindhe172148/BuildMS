package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.UserDAO;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.util.PasswordUtil;

import java.util.Arrays;
import java.util.List;

/**
 * Service layer for User management operations
 */
public class UserService {
    
    private final UserDAO userDAO;
    private static final List<String> VALID_ROLES = Arrays.asList("Admin", "Manager", "Staff", "Sales");
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    /**
     * Create new user
     * @param user User to create
     * @param password Plain text password
     * @return Created user, or null if failed
     * @throws IllegalArgumentException if validation fails
     */
    public User createUser(User user, String password) {
        // Validate required fields
        validateUser(user);
        
        // Validate password
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }
        
        // Check for duplicate username
        User existingUsername = userDAO.findByUsername(user.getUsername());
        if (existingUsername != null) {
            throw new IllegalArgumentException("Username already exists");
        }
        
        // Check for duplicate email
        User existingEmail = userDAO.findByEmail(user.getEmail());
        if (existingEmail != null) {
            throw new IllegalArgumentException("Email already registered");
        }
        
        // Hash password
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        
        // Set default status
        user.setStatus("Active");
        
        return userDAO.create(user);
    }
    
    /**
     * Update existing user (without password)
     * @param user User to update
     * @param currentUserId ID of the user performing the update
     * @return true if successful
     * @throws IllegalArgumentException if validation fails
     */
    public boolean updateUser(User user, Long currentUserId) {
        // Validate required fields
        validateUser(user);
        
        // Check if user exists
        User existing = userDAO.findById(user.getId());
        if (existing == null) {
            throw new IllegalArgumentException("User not found");
        }
        
        // Check for duplicate username (excluding current user)
        User duplicateUsername = userDAO.findByUsername(user.getUsername());
        if (duplicateUsername != null && !duplicateUsername.getId().equals(user.getId())) {
            throw new IllegalArgumentException("Username already exists");
        }
        
        // Check for duplicate email (excluding current user)
        User duplicateEmail = userDAO.findByEmail(user.getEmail());
        if (duplicateEmail != null && !duplicateEmail.getId().equals(user.getId())) {
            throw new IllegalArgumentException("Email already registered");
        }
        
        // Prevent admin from demoting themselves
        if (user.getId().equals(currentUserId) && "Admin".equals(existing.getRole()) && !"Admin".equals(user.getRole())) {
            throw new IllegalArgumentException("You cannot demote your own admin account");
        }
        
        return userDAO.update(user);
    }
    
    /**
     * Toggle user status (Active <-> Inactive)
     * @param userId User ID to toggle
     * @param currentUserId ID of the user performing the action
     * @return true if successful
     * @throws IllegalArgumentException if validation fails
     */
    public boolean toggleUserStatus(Long userId, Long currentUserId) {
        // Cannot deactivate own account
        if (userId.equals(currentUserId)) {
            throw new IllegalArgumentException("You cannot deactivate your own account");
        }
        
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found");
        }
        
        String newStatus = "Active".equals(user.getStatus()) ? "Inactive" : "Active";
        return userDAO.toggleStatus(userId, newStatus);
    }
    
    /**
     * Get user by ID
     * @param id User ID
     * @return User if found
     */
    public User getUserById(Long id) {
        return userDAO.findById(id);
    }
    
    /**
     * Get user by username
     * @param username Username
     * @return User if found
     */
    public User getUserByUsername(String username) {
        return userDAO.findByUsername(username);
    }
    
    /**
     * Get user by email
     * @param email Email
     * @return User if found
     */
    public User getUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }
    
    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        return userDAO.getAll();
    }
    
    /**
     * Get users by role
     * @param role Role to filter
     * @return Filtered list
     */
    public List<User> getUsersByRole(String role) {
        return userDAO.findByRole(role);
    }
    
    /**
     * Get users by status
     * @param status Status to filter
     * @return Filtered list
     */
    public List<User> getUsersByStatus(String status) {
        return userDAO.findByStatus(status);
    }
    
    /**
     * Search users with filters
     * @param keyword Search keyword (username, email, name)
     * @param role Role filter
     * @param status Status filter
     * @param warehouseId Warehouse filter
     * @return Filtered list
     */
    public List<User> searchUsers(String keyword, String role, String status, Long warehouseId) {
        return userDAO.search(keyword, role, status, warehouseId);
    }
    
    /**
     * Validate user fields
     * @param user User to validate
     * @throws IllegalArgumentException if validation fails
     */
    private void validateUser(User user) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (user.getName() == null || user.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required");
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (!isValidEmail(user.getEmail())) {
            throw new IllegalArgumentException("Invalid email format");
        }
        if (user.getRole() == null || user.getRole().trim().isEmpty()) {
            throw new IllegalArgumentException("Role is required");
        }
        if (!isValidRole(user.getRole())) {
            throw new IllegalArgumentException("Invalid role. Must be Admin, Manager, Staff, or Sales");
        }
        
        // Trim values
        user.setUsername(user.getUsername().trim());
        user.setName(user.getName().trim());
        user.setEmail(user.getEmail().trim().toLowerCase());
    }
    
    /**
     * Check if role is valid
     * @param role Role to check
     * @return true if valid
     */
    public boolean isValidRole(String role) {
        return VALID_ROLES.contains(role);
    }
    
    /**
     * Check if email format is valid
     * @param email Email to check
     * @return true if valid
     */
    private boolean isValidEmail(String email) {
        if (email == null) return false;
        // Simple email validation
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }
    
    /**
     * Get list of valid roles
     * @return List of valid role names
     */
    public List<String> getValidRoles() {
        return VALID_ROLES;
    }
}
