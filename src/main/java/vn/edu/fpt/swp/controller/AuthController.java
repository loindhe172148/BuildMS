package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.service.AuthService;

import java.io.IOException;

/**
 * Controller for authentication operations
 * Handles: Login, Logout, Change Password
 * 
 * UC-AUTH-001: User Login
 * UC-AUTH-002: Change Password
 * UC-AUTH-004: User Logout
 */
@WebServlet("/auth")
public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private AuthService authService;
    
    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.trim().isEmpty()) {
            action = "login";
        }
        
        switch (action) {
            case "login":
                showLoginForm(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
            case "changePassword":
                showChangePasswordForm(request, response);
                break;
            default:
                showLoginForm(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.trim().isEmpty()) {
            action = "login";
        }
        
        switch (action) {
            case "login":
                processLogin(request, response);
                break;
            case "changePassword":
                processChangePassword(request, response);
                break;
            default:
                showLoginForm(request, response);
                break;
        }
    }
    
    /**
     * UC-AUTH-001: Display login form
     * Step 1: Display Login Form
     */
    private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }
    
    /**
     * UC-AUTH-001: Process login
     * Steps 2-8: Validate, Authenticate, Create Session, Redirect
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Step 3: Validate Input Fields
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            // A1: Input Validation Failed
            request.setAttribute("errorMessage", "Username or email and password are required");
            request.setAttribute("username", username); // Retain username/email
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }
        
        // Step 4-5: Authenticate User and Verify Password
        User user = authService.authenticate(username.trim(), password);
        
        if (user == null) {
            // Check if user exists but is inactive (for specific error message)
            User existingUser = authService.findByIdentifier(username.trim());
            if (existingUser != null && !"Active".equals(existingUser.getStatus())) {
                // A3: User Account Inactive
                request.setAttribute("errorMessage", "Your account has been deactivated. Please contact administrator");
            } else {
                // A2 or A4: User Not Found or Password Incorrect
                // BR-AUTH-003: Error messages must not reveal whether username or password was incorrect
                request.setAttribute("errorMessage", "Invalid username or password");
            }
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }
        
        // Step 6: Create User Session
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("role", user.getRole());
        session.setAttribute("lastActivityTime", System.currentTimeMillis());
        
        // Step 7: Update Last Login (already done in authService.authenticate)
        
        // Step 8: Redirect to Dashboard
        request.getSession().setAttribute("successMessage", "Login successful");
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
    
    /**
     * UC-AUTH-004: User Logout
     * Steps 1-5: Invalidate Session, Clear Data, Redirect
     */
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Step 3: Invalidate Session
        if (session != null) {
            // Step 4: Clear session data
            session.removeAttribute("user");
            session.removeAttribute("userId");
            session.removeAttribute("role");
            session.removeAttribute("lastActivityTime");
            session.invalidate();
        }
        
        // Step 5: Redirect to Login Page with success message
        // Note: Since session is invalidated, we pass message via URL parameter
        response.sendRedirect(request.getContextPath() + "/auth?action=login&logout=success");
    }
    
    /**
     * UC-AUTH-002: Display Change Password Form
     * Steps 1-2: Navigate and Display Form
     */
    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verify user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(request, response);
    }
    
    /**
     * UC-AUTH-002: Process Change Password
     * Steps 3-8: Validate, Verify Current, Hash New, Update, Confirm
     */
    private void processChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verify user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Step 4: Validate Input Fields
        // Check for empty current password
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Current password is required");
            request.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        // Check new password minimum length
        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("errorMessage", "New password must be at least 6 characters");
            request.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        // Check password confirmation matches
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New passwords do not match");
            request.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        // Check new password is different from current
        if (currentPassword.equals(newPassword)) {
            request.setAttribute("errorMessage", "New password must be different from current password");
            request.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        // Steps 5-7: Verify Current Password, Generate New Hash, Update
        boolean success = authService.changePassword(currentUser.getId(), currentPassword, newPassword);
        
        if (!success) {
            // A2: Current Password Incorrect
            request.setAttribute("errorMessage", "Current password is incorrect");
            request.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        // Step 8: Display Confirmation
        request.setAttribute("successMessage", "Password changed successfully");
        request.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(request, response);
    }
}
