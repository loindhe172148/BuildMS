package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.model.Warehouse;
import vn.edu.fpt.swp.service.AuthService;
import vn.edu.fpt.swp.service.UserService;
import vn.edu.fpt.swp.service.WarehouseService;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;
import vn.edu.fpt.swp.util.PaginationUtil;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for User management
 * Handles UC-USER-001, UC-USER-002, UC-USER-003, UC-USER-004
 */
@WebServlet("/user")
public class UserController extends HttpServlet {
    
    private UserService userService;
    private WarehouseService warehouseService;
    private AuthService authService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
        warehouseService = new WarehouseService();
        authService = new AuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        // Check admin access
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        switch (action) {
            case "list":
                showList(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "toggle":
                toggleStatus(request, response);
                break;
            case "resetPassword":
                showResetPasswordForm(request, response);
                break;
            default:
                showList(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        // Check admin access
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        switch (action) {
            case "add":
                processAdd(request, response);
                break;
            case "edit":
                processEdit(request, response);
                break;
            case "resetPassword":
                processResetPassword(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/user?action=list");
        }
    }
    
    /**
     * UC-USER-004: Display user list with filters
     */
    private void showList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String warehouseIdParam = request.getParameter("warehouseId");
        
        Long warehouseId = null;
        if (warehouseIdParam != null && !warehouseIdParam.isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid warehouse ID
            }
        }

        String selectedKeyword = keyword != null ? keyword.trim() : null;
        String selectedRole = role != null ? role.trim() : null;
        String selectedStatus = status != null ? status.trim() : null;
        if (selectedKeyword != null && selectedKeyword.isEmpty()) {
            selectedKeyword = null;
        }
        if (selectedRole != null && selectedRole.isEmpty()) {
            selectedRole = null;
        }
        if (selectedStatus != null && selectedStatus.isEmpty()) {
            selectedStatus = null;
        }

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        PageResult<User> userPage = userService.searchUsersPaginated(
            selectedKeyword,
            selectedRole,
            selectedStatus,
            warehouseId,
            pageRequest
        );
        
        // Get warehouses for filter dropdown and to display warehouse names
        List<Warehouse> warehouses = warehouseService.getAllWarehouses();
        
        // Build warehouse name map — single pass, no extra DB queries
        java.util.Map<Long, String> warehouseMap = new java.util.HashMap<>();
        for (Warehouse wh : warehouses) {
            warehouseMap.put(wh.getId(), wh.getName());
        }
        request.setAttribute("warehouseMap", warehouseMap);

        // Get current user ID for highlighting
        User currentUser = getCurrentUser(request);

        Map<String, String> paginationParams = new LinkedHashMap<>();
        paginationParams.put("keyword", selectedKeyword);
        paginationParams.put("role", selectedRole);
        paginationParams.put("status", selectedStatus);
        paginationParams.put("warehouseId", warehouseId != null ? String.valueOf(warehouseId) : null);
        paginationParams.put("size", String.valueOf(pageRequest.getSize()));

        request.setAttribute("users", userPage.getItems());
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("keyword", selectedKeyword);
        request.setAttribute("role", selectedRole);
        request.setAttribute("status", selectedStatus);
        request.setAttribute("warehouseId", warehouseId);
        request.setAttribute("currentUserId", currentUser != null ? currentUser.getId() : null);
        request.setAttribute("roles", userService.getValidRoles());
        request.setAttribute("currentPage", userPage.getCurrentPage());
        request.setAttribute("totalPages", userPage.getTotalPages());
        request.setAttribute("pageSize", userPage.getPageSize());
        request.setAttribute("totalItems", userPage.getTotalItems());
        request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/user", paginationParams));
        
        request.getRequestDispatcher("/WEB-INF/views/user/list.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-USER-001: Show add user form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Warehouse> warehouses = warehouseService.getAllWarehouses();
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("roles", userService.getValidRoles());
        
        request.getRequestDispatcher("/WEB-INF/views/user/add.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-USER-001: Process add user
     */
    private void processAdd(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String warehouseIdParam = request.getParameter("warehouseId");
        
        Long warehouseId = null;
        if (warehouseIdParam != null && !warehouseIdParam.isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdParam);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        try {
            User user = new User();
            user.setUsername(username);
            user.setName(name);
            user.setEmail(email);
            user.setRole(role);
            user.setWarehouseId(warehouseId);
            
            User created = userService.createUser(user, password);
            
            if (created != null) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "User created successfully!");
                response.sendRedirect(request.getContextPath() + "/user?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to create user. Please try again.");
                setFormAttributes(request, username, name, email, role, warehouseId);
                request.getRequestDispatcher("/WEB-INF/views/user/add.jsp")
                       .forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            setFormAttributes(request, username, name, email, role, warehouseId);
            request.getRequestDispatcher("/WEB-INF/views/user/add.jsp")
                   .forward(request, response);
        }
    }
    
    /**
     * UC-USER-002: Show edit user form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "User ID is required");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam);
            User user = userService.getUserById(id);
            
            if (user == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/user?action=list");
                return;
            }
            
            List<Warehouse> warehouses = warehouseService.getAllWarehouses();
            User currentUser = getCurrentUser(request);
            
            // Get warehouse name if assigned
            if (user.getWarehouseId() != null) {
                for (Warehouse wh : warehouses) {
                    if (wh.getId() == user.getWarehouseId().intValue()) {
                        request.setAttribute("warehouseName", wh.getName());
                        break;
                    }
                }
            }
            
            request.setAttribute("user", user);
            request.setAttribute("warehouses", warehouses);
            request.setAttribute("roles", userService.getValidRoles());
            request.setAttribute("currentUserId", currentUser != null ? currentUser.getId() : null);
            request.setAttribute("isCurrentUser", currentUser != null && currentUser.getId().equals(id));
            
            request.getRequestDispatcher("/WEB-INF/views/user/edit.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        }
    }
    
    /**
     * UC-USER-002: Process edit user
     */
    private void processEdit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String warehouseIdParam = request.getParameter("warehouseId");
        
        Long warehouseId = null;
        if (warehouseIdParam != null && !warehouseIdParam.isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdParam);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        try {
            Long id = Long.parseLong(idParam);
            User currentUser = getCurrentUser(request);
            
            User user = userService.getUserById(id);
            if (user == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/user?action=list");
                return;
            }
            
            user.setUsername(username);
            user.setName(name);
            user.setEmail(email);
            user.setRole(role);
            user.setWarehouseId(warehouseId);
            
            boolean updated = userService.updateUser(user, currentUser.getId());
            
            if (updated) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "User updated successfully!");
                response.sendRedirect(request.getContextPath() + "/user?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to update user. Please try again.");
                request.setAttribute("user", user);
                request.setAttribute("warehouses", warehouseService.getAllWarehouses());
                request.setAttribute("roles", userService.getValidRoles());
                request.setAttribute("isCurrentUser", currentUser != null && currentUser.getId().equals(id));
                request.getRequestDispatcher("/WEB-INF/views/user/edit.jsp")
                       .forward(request, response);
            }
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } catch (IllegalArgumentException e) {
            Long id = Long.parseLong(idParam);
            User currentUser2 = getCurrentUser(request);
            User user = userService.getUserById(id);
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("user", user);
            request.setAttribute("username", username);
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("role", role);
            request.setAttribute("warehouseId", warehouseId);
            request.setAttribute("warehouses", warehouseService.getAllWarehouses());
            request.setAttribute("roles", userService.getValidRoles());
            request.setAttribute("isCurrentUser", currentUser2 != null && currentUser2.getId().equals(id));
            request.getRequestDispatcher("/WEB-INF/views/user/edit.jsp")
                   .forward(request, response);
        }
    }
    
    /**
     * UC-USER-003: Toggle user status
     */
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "User ID is required");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam);
            User currentUser = getCurrentUser(request);
            User targetUser = userService.getUserById(id);
            
            if (targetUser == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/user?action=list");
                return;
            }
            
            boolean isDeactivating = "Active".equals(targetUser.getStatus());
            
            boolean toggled = userService.toggleUserStatus(id, currentUser.getId());
            
            HttpSession session = request.getSession();
            if (toggled) {
                String message = "User " + (isDeactivating ? "deactivated" : "activated") + " successfully!";
                session.setAttribute("successMessage", message);
            } else {
                session.setAttribute("errorMessage", "Failed to update user status");
            }
            
            response.sendRedirect(request.getContextPath() + "/user?action=list");
            
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        }
    }
    
    /**
     * Set form attributes for re-displaying form with values
     */
    private void setFormAttributes(HttpServletRequest request, String username, String name, 
                                   String email, String role, Long warehouseId) {
        request.setAttribute("username", username);
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
        request.setAttribute("warehouseId", warehouseId);
        request.setAttribute("warehouses", warehouseService.getAllWarehouses());
        request.setAttribute("roles", userService.getValidRoles());
    }
    
    /**
     * Check if current user is Admin
     */
    private boolean isAdmin(HttpServletRequest request) {
        User user = getCurrentUser(request);
        if (user == null) return false;
        return "Admin".equals(user.getRole());
    }
    
    /**
     * Get current logged in user
     */
    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }
    
    /**
     * UC-AUTH-003: Show admin reset password form
     */
    private void showResetPasswordForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "User ID is required");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
            return;
        }
        try {
            Long id = Long.parseLong(idParam.trim());
            User user = userService.getUserById(id);
            if (user == null) {
                request.getSession().setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/user?action=list");
                return;
            }
            request.setAttribute("targetUser", user);
            request.getRequestDispatcher("/WEB-INF/views/user/reset-password.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        }
    }
    
    /**
     * UC-AUTH-003: Process admin reset password
     */
    private void processResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "User ID is required");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            User user = userService.getUserById(id);
            if (user == null) {
                request.getSession().setAttribute("errorMessage", "User not found");
                response.sendRedirect(request.getContextPath() + "/user?action=list");
                return;
            }
            
            // Validate passwords
            if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("errorMessage", "Password must be at least 6 characters");
                request.setAttribute("targetUser", user);
                request.getRequestDispatcher("/WEB-INF/views/user/reset-password.jsp").forward(request, response);
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match");
                request.setAttribute("targetUser", user);
                request.getRequestDispatcher("/WEB-INF/views/user/reset-password.jsp").forward(request, response);
                return;
            }
            
            boolean success = authService.resetPassword(id, newPassword);
            if (success) {
                request.getSession().setAttribute("successMessage", "Password reset successfully for " + user.getUsername());
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to reset password");
            }
            response.sendRedirect(request.getContextPath() + "/user?action=edit&id=" + id);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        }
    }
}
