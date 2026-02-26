package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.model.Warehouse;
import vn.edu.fpt.swp.service.UserService;
import vn.edu.fpt.swp.service.WarehouseService;

import java.io.IOException;
import java.util.List;

/**
 * Controller for User management
 * Handles UC-USER-001, UC-USER-002, UC-USER-003, UC-USER-004
 */
@WebServlet("/user")
public class UserController extends HttpServlet {
    
    private UserService userService;
    private WarehouseService warehouseService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
        warehouseService = new WarehouseService();
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
        
        List<User> users;
        
        if ((keyword != null && !keyword.trim().isEmpty()) || 
            (role != null && !role.trim().isEmpty()) ||
            (status != null && !status.trim().isEmpty()) ||
            warehouseId != null) {
            users = userService.searchUsers(keyword, role, status, warehouseId);
        } else {
            users = userService.getAllUsers();
        }
        
        // Get warehouses for filter dropdown and to display warehouse names
        List<Warehouse> warehouses = warehouseService.getAllWarehouses();
        
        // Set warehouse names for each user
        for (User user : users) {
            if (user.getWarehouseId() != null) {
                for (Warehouse wh : warehouses) {
                    if (wh.getId() == user.getWarehouseId().intValue()) {
                        request.setAttribute("warehouseName_" + user.getId(), wh.getName());
                        break;
                    }
                }
            }
        }
        
        // Get current user ID for highlighting
        User currentUser = getCurrentUser(request);
        
        request.setAttribute("users", users);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("keyword", keyword);
        request.setAttribute("role", role);
        request.setAttribute("status", status);
        request.setAttribute("warehouseId", warehouseId);
        request.setAttribute("currentUserId", currentUser != null ? currentUser.getId() : null);
        request.setAttribute("roles", userService.getValidRoles());
        
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
                request.getRequestDispatcher("/WEB-INF/views/user/edit.jsp")
                       .forward(request, response);
            }
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } catch (IllegalArgumentException e) {
            Long id = Long.parseLong(idParam);
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
}
