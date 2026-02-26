package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.model.Warehouse;
import vn.edu.fpt.swp.service.WarehouseService;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Warehouse Management
 * 
 * UC-WH-001: Create Warehouse
 * UC-WH-002: Update Warehouse
 * UC-WH-003: View Warehouse List
 */
@WebServlet("/warehouse")
public class WarehouseController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private WarehouseService warehouseService;
    
    @Override
    public void init() throws ServletException {
        warehouseService = new WarehouseService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listWarehouses(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listWarehouses(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "add":
                createWarehouse(request, response);
                break;
            case "edit":
                updateWarehouse(request, response);
                break;
            default:
                listWarehouses(request, response);
                break;
        }
    }
    
    /**
     * Check if current user has Admin role (only Admin can manage warehouses)
     */
    private boolean hasAdminAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;
        
        return "Admin".equals(user.getRole());
    }
    
    /**
     * Check if current user can view warehouses (Admin or Manager)
     */
    private boolean hasViewAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;
        
        String role = user.getRole();
        return "Admin".equals(role) || "Manager".equals(role);
    }
    
    /**
     * UC-WH-003: View Warehouse List
     */
    private void listWarehouses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check view access
        if (!hasViewAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String keyword = request.getParameter("keyword");
        List<Warehouse> warehouses;
        
        // Search or get all
        if (keyword != null && !keyword.trim().isEmpty()) {
            warehouses = warehouseService.searchWarehouses(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            warehouses = warehouseService.getAllWarehouses();
        }
        
        // Add location count for each warehouse
        for (Warehouse warehouse : warehouses) {
            int locationCount = warehouseService.getLocationCount(warehouse.getId());
            request.setAttribute("locationCount_" + warehouse.getId(), locationCount);
        }
        
        request.setAttribute("warehouses", warehouses);
        request.getRequestDispatcher("/WEB-INF/views/warehouse/list.jsp").forward(request, response);
    }
    
    /**
     * UC-WH-001: Show Add Warehouse Form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin access
        if (!hasAdminAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/warehouse/add.jsp").forward(request, response);
    }
    
    /**
     * UC-WH-001: Create Warehouse
     */
    private void createWarehouse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin access
        if (!hasAdminAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        
        // Validate input - AF-2: Empty Required Fields
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Warehouse name is required");
            request.setAttribute("name", name);
            request.setAttribute("location", location);
            request.getRequestDispatcher("/WEB-INF/views/warehouse/add.jsp").forward(request, response);
            return;
        }
        
        // Create warehouse
        Warehouse created = warehouseService.createWarehouse(name.trim(), location);
        
        if (created == null) {
            // AF-1: Duplicate Warehouse Name
            request.setAttribute("errorMessage", "Warehouse name already exists");
            request.setAttribute("name", name);
            request.setAttribute("location", location);
            request.getRequestDispatcher("/WEB-INF/views/warehouse/add.jsp").forward(request, response);
            return;
        }
        
        // Success - redirect to list
        request.getSession().setAttribute("successMessage", "Warehouse created successfully");
        response.sendRedirect(request.getContextPath() + "/warehouse?action=list");
    }
    
    /**
     * UC-WH-002: Show Edit Warehouse Form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin access
        if (!hasAdminAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Warehouse ID is required");
            response.sendRedirect(request.getContextPath() + "/warehouse?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            Warehouse warehouse = warehouseService.getWarehouseById(id);
            
            // AF-1: Warehouse Not Found
            if (warehouse == null) {
                request.getSession().setAttribute("errorMessage", "Warehouse not found");
                response.sendRedirect(request.getContextPath() + "/warehouse?action=list");
                return;
            }
            
            // Get location count
            int locationCount = warehouseService.getLocationCount(id);
            
            request.setAttribute("warehouse", warehouse);
            request.setAttribute("locationCount", locationCount);
            request.getRequestDispatcher("/WEB-INF/views/warehouse/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid warehouse ID");
            response.sendRedirect(request.getContextPath() + "/warehouse?action=list");
        }
    }
    
    /**
     * UC-WH-002: Update Warehouse
     */
    private void updateWarehouse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin access
        if (!hasAdminAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Warehouse ID is required");
            response.sendRedirect(request.getContextPath() + "/warehouse?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            
            // Validate name
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Warehouse name is required");
                Warehouse warehouse = warehouseService.getWarehouseById(id);
                if (warehouse != null) {
                    warehouse.setName(name);
                    warehouse.setLocation(location);
                    request.setAttribute("warehouse", warehouse);
                }
                request.getRequestDispatcher("/WEB-INF/views/warehouse/edit.jsp").forward(request, response);
                return;
            }
            
            // Update warehouse
            boolean updated = warehouseService.updateWarehouse(id, name.trim(), location);
            
            if (!updated) {
                // Could be duplicate name or warehouse not found
                Warehouse existing = warehouseService.getWarehouseById(id);
                if (existing == null) {
                    request.getSession().setAttribute("errorMessage", "Warehouse not found");
                } else {
                    request.setAttribute("errorMessage", "Warehouse name already exists");
                    existing.setName(name);
                    existing.setLocation(location);
                    request.setAttribute("warehouse", existing);
                    request.getRequestDispatcher("/WEB-INF/views/warehouse/edit.jsp").forward(request, response);
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/warehouse?action=list");
                return;
            }
            
            // Success
            request.getSession().setAttribute("successMessage", "Warehouse updated successfully");
            response.sendRedirect(request.getContextPath() + "/warehouse?action=list");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid warehouse ID");
            response.sendRedirect(request.getContextPath() + "/warehouse?action=list");
        }
    }
}
