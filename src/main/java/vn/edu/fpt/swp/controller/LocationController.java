package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.Location;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.model.Warehouse;
import vn.edu.fpt.swp.service.LocationService;
import vn.edu.fpt.swp.service.WarehouseService;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Location Management
 * 
 * UC-LOC-001: Create Location
 * UC-LOC-002: Update Location
 * UC-LOC-003: Toggle Location Status
 * UC-LOC-004: View Location List
 */
@WebServlet("/location")
public class LocationController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private LocationService locationService;
    private WarehouseService warehouseService;
    
    @Override
    public void init() throws ServletException {
        locationService = new LocationService();
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
                listLocations(request, response);
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
                listLocations(request, response);
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
                createLocation(request, response);
                break;
            case "edit":
                updateLocation(request, response);
                break;
            default:
                listLocations(request, response);
                break;
        }
    }
    
    /**
     * Check if current user has Admin or Manager role
     */
    private boolean hasManageAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;
        
        String role = user.getRole();
        return "Admin".equals(role) || "Manager".equals(role);
    }
    
    /**
     * Check if current user can view locations (Admin, Manager, Staff)
     */
    private boolean hasViewAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;
        
        String role = user.getRole();
        return "Admin".equals(role) || "Manager".equals(role) || "Staff".equals(role);
    }
    
    /**
     * UC-LOC-004: View Location List
     */
    private void listLocations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check view access
        if (!hasViewAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String warehouseIdStr = request.getParameter("warehouseId");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        
        List<Location> locations;
        
        // Apply filters
        if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                Long warehouseId = Long.parseLong(warehouseIdStr.trim());
                locations = locationService.getLocationsByWarehouse(warehouseId);
                request.setAttribute("warehouseId", warehouseId);
            } catch (NumberFormatException e) {
                locations = locationService.getAllLocations();
            }
        } else if (type != null && !type.trim().isEmpty()) {
            locations = locationService.getLocationsByType(type.trim());
            request.setAttribute("type", type.trim());
        } else if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                locations = locationService.getLocationsByStatus(true);
                request.setAttribute("status", "active");
            } else if ("inactive".equalsIgnoreCase(status)) {
                locations = locationService.getLocationsByStatus(false);
                request.setAttribute("status", "inactive");
            } else {
                locations = locationService.getAllLocations();
            }
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            locations = locationService.searchLocations(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            locations = locationService.getAllLocations();
        }
        
        // Get all warehouses for filter dropdown and display
        List<Warehouse> warehouses = warehouseService.getAllWarehouses();
        request.setAttribute("warehouses", warehouses);
        
        // Build warehouse name map for display
        for (Warehouse warehouse : warehouses) {
            request.setAttribute("warehouseName_" + warehouse.getId(), warehouse.getName());
        }
        
        // Add inventory count for each location
        for (Location location : locations) {
            int inventoryCount = locationService.getInventoryCount(location.getId());
            request.setAttribute("inventoryCount_" + location.getId(), inventoryCount);
        }
        
        request.setAttribute("locations", locations);
        request.getRequestDispatcher("/WEB-INF/views/location/list.jsp").forward(request, response);
    }
    
    /**
     * UC-LOC-001: Show Add Location Form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check manage access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        // Get all warehouses for dropdown
        List<Warehouse> warehouses = warehouseService.getAllWarehouses();
        
        // AF-2: No Warehouses Available
        if (warehouses.isEmpty()) {
            request.getSession().setAttribute("warningMessage", 
                "Please create a warehouse first before adding locations.");
            response.sendRedirect(request.getContextPath() + "/warehouse?action=add");
            return;
        }
        
        // Pre-select warehouse if provided
        String warehouseIdStr = request.getParameter("warehouseId");
        if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                Long warehouseId = Long.parseLong(warehouseIdStr.trim());
                request.setAttribute("warehouseId", warehouseId);
            } catch (NumberFormatException e) {
                // Ignore invalid warehouse ID
            }
        }
        
        request.setAttribute("warehouses", warehouses);
        request.getRequestDispatcher("/WEB-INF/views/location/add.jsp").forward(request, response);
    }
    
    /**
     * UC-LOC-001: Create Location
     */
    private void createLocation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check manage access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String warehouseIdStr = request.getParameter("warehouseId");
        String code = request.getParameter("code");
        String type = request.getParameter("type");
        
        // Validate required fields
        boolean hasError = false;
        StringBuilder errorMsg = new StringBuilder();
        
        Long warehouseId = null;
        if (warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
            errorMsg.append("Warehouse is required. ");
            hasError = true;
        } else {
            try {
                warehouseId = Long.parseLong(warehouseIdStr.trim());
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid warehouse. ");
                hasError = true;
            }
        }
        
        if (code == null || code.trim().isEmpty()) {
            errorMsg.append("Location code is required. ");
            hasError = true;
        }
        
        if (type == null || type.trim().isEmpty()) {
            errorMsg.append("Location type is required. ");
            hasError = true;
        }
        
        if (hasError) {
            request.setAttribute("errorMessage", errorMsg.toString().trim());
            request.setAttribute("warehouseId", warehouseId);
            request.setAttribute("code", code);
            request.setAttribute("type", type);
            request.setAttribute("warehouses", warehouseService.getAllWarehouses());
            request.getRequestDispatcher("/WEB-INF/views/location/add.jsp").forward(request, response);
            return;
        }
        
        // Create location
        Location created = locationService.createLocation(warehouseId, code.trim(), type.trim());
        
        if (created == null) {
            // AF-1: Duplicate Location Code
            request.setAttribute("errorMessage", "Location code already exists in this warehouse");
            request.setAttribute("warehouseId", warehouseId);
            request.setAttribute("code", code);
            request.setAttribute("type", type);
            request.setAttribute("warehouses", warehouseService.getAllWarehouses());
            request.getRequestDispatcher("/WEB-INF/views/location/add.jsp").forward(request, response);
            return;
        }
        
        // Success - redirect to list filtered by warehouse
        request.getSession().setAttribute("successMessage", "Location created successfully");
        response.sendRedirect(request.getContextPath() + "/location?action=list&warehouseId=" + warehouseId);
    }
    
    /**
     * UC-LOC-002: Show Edit Location Form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check manage access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Location ID is required");
            response.sendRedirect(request.getContextPath() + "/location?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            Location location = locationService.getLocationById(id);
            
            // AF-1: Location Not Found
            if (location == null) {
                request.getSession().setAttribute("errorMessage", "Location not found");
                response.sendRedirect(request.getContextPath() + "/location?action=list");
                return;
            }
            
            // Get warehouse for display
            Warehouse warehouse = warehouseService.getWarehouseById(location.getWarehouseId());
            
            // Get inventory count
            int inventoryCount = locationService.getInventoryCount(id);
            
            request.setAttribute("location", location);
            request.setAttribute("warehouse", warehouse);
            request.setAttribute("inventoryCount", inventoryCount);
            request.getRequestDispatcher("/WEB-INF/views/location/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid location ID");
            response.sendRedirect(request.getContextPath() + "/location?action=list");
        }
    }
    
    /**
     * UC-LOC-002: Update Location
     */
    private void updateLocation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check manage access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        String code = request.getParameter("code");
        String type = request.getParameter("type");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Location ID is required");
            response.sendRedirect(request.getContextPath() + "/location?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            
            // Validate required fields
            boolean hasError = false;
            StringBuilder errorMsg = new StringBuilder();
            
            if (code == null || code.trim().isEmpty()) {
                errorMsg.append("Location code is required. ");
                hasError = true;
            }
            
            if (type == null || type.trim().isEmpty()) {
                errorMsg.append("Location type is required. ");
                hasError = true;
            }
            
            if (hasError) {
                request.setAttribute("errorMessage", errorMsg.toString().trim());
                Location location = locationService.getLocationById(id);
                if (location != null) {
                    location.setCode(code);
                    location.setType(type);
                    request.setAttribute("location", location);
                    request.setAttribute("warehouse", warehouseService.getWarehouseById(location.getWarehouseId()));
                }
                request.getRequestDispatcher("/WEB-INF/views/location/edit.jsp").forward(request, response);
                return;
            }
            
            // Get existing location for redirect
            Location existing = locationService.getLocationById(id);
            Long warehouseId = existing != null ? existing.getWarehouseId() : null;
            
            // Update location
            boolean updated = locationService.updateLocation(id, code.trim(), type.trim());
            
            if (!updated) {
                // Could be duplicate code or location not found
                Location loc = locationService.getLocationById(id);
                if (loc == null) {
                    request.getSession().setAttribute("errorMessage", "Location not found");
                } else {
                    // AF-2: Duplicate Location Code
                    request.setAttribute("errorMessage", "Location code already exists in this warehouse");
                    loc.setCode(code);
                    loc.setType(type);
                    request.setAttribute("location", loc);
                    request.setAttribute("warehouse", warehouseService.getWarehouseById(loc.getWarehouseId()));
                    request.getRequestDispatcher("/WEB-INF/views/location/edit.jsp").forward(request, response);
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/location?action=list");
                return;
            }
            
            // Success
            request.getSession().setAttribute("successMessage", "Location updated successfully");
            if (warehouseId != null) {
                response.sendRedirect(request.getContextPath() + "/location?action=list&warehouseId=" + warehouseId);
            } else {
                response.sendRedirect(request.getContextPath() + "/location?action=list");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid location ID");
            response.sendRedirect(request.getContextPath() + "/location?action=list");
        }
    }
    
    /**
     * UC-LOC-003: Toggle Location Status
     */
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check manage access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Location ID is required");
            response.sendRedirect(request.getContextPath() + "/location?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            
            // Get location
            Location location = locationService.getLocationById(id);
            if (location == null) {
                request.getSession().setAttribute("errorMessage", "Location not found");
                response.sendRedirect(request.getContextPath() + "/location?action=list");
                return;
            }
            
            Long warehouseId = location.getWarehouseId();
            
            // Check if trying to deactivate with inventory
            if (location.isActive() && locationService.hasInventory(id)) {
                // AF-1: Location Has Inventory
                request.getSession().setAttribute("errorMessage", 
                    "Cannot deactivate location with existing inventory. Please move inventory first.");
                response.sendRedirect(request.getContextPath() + "/location?action=list&warehouseId=" + warehouseId);
                return;
            }
            
            // Toggle status
            boolean success = locationService.toggleLocationStatus(id);
            
            if (success) {
                String action = location.isActive() ? "deactivated" : "activated";
                request.getSession().setAttribute("successMessage", "Location " + action + " successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update location status");
            }
            
            response.sendRedirect(request.getContextPath() + "/location?action=list&warehouseId=" + warehouseId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid location ID");
            response.sendRedirect(request.getContextPath() + "/location?action=list");
        }
    }
}
