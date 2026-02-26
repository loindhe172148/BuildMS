package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.UserDAO;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.util.PasswordUtil;

/**
 * Service class for authentication operations
 */
public class AuthService {
    private final UserDAO userDAO;
    
    public AuthService() {
        this.userDAO = new UserDAO();
    }
    
    /**
     * Authenticate user with username or email and password
     * @param identifier Username or email
     * @param password Plain text password
     * @return User object if authentication successful, null otherwise
     */
    public User authenticate(String identifier, String password) {
        // Validate input
        if (identifier == null || identifier.trim().isEmpty()) {
            return null;
        }
        
        if (password == null || password.trim().isEmpty()) {
            return null;
        }
        
        // Try to find user by username first, then by email
        String id = identifier.trim();
        User user = userDAO.findByUsername(id);
        if (user == null) {
            user = userDAO.findByEmail(id);
        }
        
        // Check if user exists
        if (user == null) {
            return null;
        }
        
        // Check if user is active
        if (!"Active".equals(user.getStatus())) {
            return null;
        }
        
        // Verify password
        if (!PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
            return null;
        }
        
        // Update last login timestamp
        userDAO.updateLastLogin(user.getId());
        
        return user;
    }
    
    /**
     * Find user by username or email (helper)
     * @param identifier Username or email
     * @return User object if found, null otherwise
     */
    public User findByIdentifier(String identifier) {
        if (identifier == null || identifier.trim().isEmpty()) {
            return null;
        }
        String id = identifier.trim();
        User user = userDAO.findByUsername(id);
        if (user == null) {
            user = userDAO.findByEmail(id);
        }
        return user;
    }
    
    /**
     * Find user by username (for status check)
     * @param username Username to search
     * @return User object if found, null otherwise
     */
    public User findByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        return userDAO.findByUsername(username.trim());
    }
    
    /**
     * Find user by ID
     * @param userId User ID to search
     * @return User object if found, null otherwise
     */
    public User findById(Long userId) {
        if (userId == null) {
            return null;
        }
        return userDAO.findById(userId);
    }
    
    /**
     * Register new user (Admin only)
     * @param user User object with plain text password
     * @param plainPassword Plain text password
     * @return Created user if successful, null otherwise
     */
    public User registerUser(User user, String plainPassword) {
        // Validate input
        if (user == null || plainPassword == null || plainPassword.length() < 6) {
            return null;
        }
        
        // Validate username
        if (user.getUsername() == null || user.getUsername().trim().isEmpty() || 
            user.getUsername().length() < 3 || user.getUsername().length() > 50) {
            return null;
        }
        
        // Validate email
        if (user.getEmail() == null || user.getEmail().trim().isEmpty() || 
            !user.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return null;
        }
        
        // Check if username already exists
        if (userDAO.findByUsername(user.getUsername()) != null) {
            return null;
        }
        
        // Check if email already exists
        if (userDAO.findByEmail(user.getEmail()) != null) {
            return null;
        }
        
        // Hash password
        String hashedPassword = PasswordUtil.hashPassword(plainPassword);
        user.setPasswordHash(hashedPassword);
        
        // Set default status if not set
        if (user.getStatus() == null || user.getStatus().trim().isEmpty()) {
            user.setStatus("Active");
        }
        
        // Create user
        return userDAO.create(user);
    }
    
    /**
     * Change user password
     * @param userId User ID
     * @param currentPassword Current plain text password
     * @param newPassword New plain text password
     * @return true if password changed successfully
     */
    public boolean changePassword(Long userId, String currentPassword, String newPassword) {
        // Validate input
        if (userId == null || currentPassword == null || newPassword == null) {
            return false;
        }
        
        if (newPassword.length() < 6) {
            return false;
        }
        
        // Check if new password is different from current
        if (currentPassword.equals(newPassword)) {
            return false;
        }
        
        // Get user
        User user = userDAO.findById(userId);
        if (user == null) {
            return false;
        }
        
        // Verify current password
        if (!PasswordUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
            return false;
        }
        
        // Hash new password
        String newHashedPassword = PasswordUtil.hashPassword(newPassword);
        
        // Update password
        return userDAO.updatePassword(userId, newHashedPassword);
    }
    
    /**
     * Reset user password (Admin only)
     * @param userId User ID to reset
     * @param newPassword New plain text password
     * @return true if password reset successfully
     */
    public boolean resetPassword(Long userId, String newPassword) {
        // Validate input
        if (userId == null || newPassword == null || newPassword.length() < 6) {
            return false;
        }
        
        // Hash new password
        String newHashedPassword = PasswordUtil.hashPassword(newPassword);
        
        // Update password
        return userDAO.updatePassword(userId, newHashedPassword);
    }
}
