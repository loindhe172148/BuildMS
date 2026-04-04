package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.Category;
import vn.edu.fpt.swp.model.Location;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.model.Warehouse;
import vn.edu.fpt.swp.service.CategoryService;
import vn.edu.fpt.swp.service.LocationService;
import vn.edu.fpt.swp.service.WarehouseService;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;
import vn.edu.fpt.swp.util.PaginationUtil;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
    private CategoryService categoryService;
    
    @Override
    public void init() throws ServletException {
        locationService = new LocationService();
        warehouseService = new WarehouseService();
        categoryService = new CategoryService();
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
     * Get current user
     */
    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }
    
    /**
     * Check if user is warehouse-scoped (Staff or Manager — restricted to assigned warehouse)
     */
    private boolean isWarehouseScoped(HttpServletRequest request) {
        User user = getCurrentUser(request);
        if (user == null) return false;
        String role = user.getRole();
        return "Staff".equals(role) || "Manager".equals(role);
    }
    
    /**
     * Get the user's assigned warehouse ID (for Staff and Manager)
     */
    private Long getAssignedWarehouseId(HttpServletRequest request) {
        User user = getCurrentUser(request);
        if (user != null && ("Staff".equals(user.getRole()) || "Manager".equals(user.getRole()))) {
            return user.getWarehouseId();
        }
        return null;
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
        String categoryIdStr = request.getParameter("categoryId");

        Long selectedWarehouseId = null;
        String selectedType = null;
        String selectedStatus = null;
        String selectedKeyword = null;
        Boolean statusFilter = null;
        Long selectedCategoryId = null;

        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                selectedCategoryId = Long.parseLong(categoryIdStr.trim());
                request.setAttribute("categoryId", selectedCategoryId);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        // Staff/Manager can only view locations for their assigned warehouse
        if (isWarehouseScoped(request)) {
            selectedWarehouseId = getAssignedWarehouseId(request);
            if (selectedWarehouseId == null) {
                request.setAttribute("errorMessage", "You are not assigned to any warehouse.");
                request.getRequestDispatcher("/WEB-INF/views/location/list.jsp").forward(request, response);
                return;
            }
            request.setAttribute("warehouseId", selectedWarehouseId);
            request.setAttribute("isWarehouseScoped", true);
        } else if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                selectedWarehouseId = Long.parseLong(warehouseIdStr.trim());
                request.setAttribute("warehouseId", selectedWarehouseId);
            } catch (NumberFormatException e) {
                selectedWarehouseId = null;
            }
        }

        if (type != null && !type.trim().isEmpty()) {
            selectedType = type.trim();
            request.setAttribute("type", selectedType);
        } else if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                selectedStatus = "active";
                statusFilter = true;
            } else if ("inactive".equalsIgnoreCase(status)) {
                selectedStatus = "inactive";
                statusFilter = false;
            }
            request.setAttribute("status", selectedStatus);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            selectedKeyword = keyword.trim();
            request.setAttribute("keyword", selectedKeyword);
        }

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        PageResult<Location> locationPage = locationService.searchLocationsPaginated(
            selectedWarehouseId,
            selectedType,
            statusFilter,
            selectedKeyword,
            selectedCategoryId,
            pageRequest
        );
        
        // Get all warehouses for filter dropdown and display
        List<Warehouse> warehouses = warehouseService.getAllWarehouses();
        request.setAttribute("warehouses", warehouses);

        // Build warehouse name map for display
        java.util.Map<Long, String> warehouseMap = new java.util.HashMap<>();
        for (Warehouse warehouse : warehouses) {
            warehouseMap.put(warehouse.getId(), warehouse.getName());
        }
        request.setAttribute("warehouseMap", warehouseMap);

        // Fetch all inventory counts in ONE query instead of N per-location queries
        java.util.Map<Long, Integer> inventoryCountMap = locationService.getAllLocationInventoryCounts();
        request.setAttribute("inventoryCountMap", inventoryCountMap);

        // Category data for display and filtering
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);

        java.util.Map<Long, String> categoryMap = new java.util.HashMap<>();
        for (Category cat : categories) {
            categoryMap.put(cat.getId(), cat.getName());
        }
        request.setAttribute("categoryMap", categoryMap);

        Map<String, String> paginationParams = new LinkedHashMap<>();
        paginationParams.put("warehouseId", selectedWarehouseId != null ? String.valueOf(selectedWarehouseId) : null);
        paginationParams.put("type", selectedType);
        paginationParams.put("status", selectedStatus);
        paginationParams.put("keyword", selectedKeyword);
        paginationParams.put("categoryId", selectedCategoryId != null ? String.valueOf(selectedCategoryId) : null);
        paginationParams.put("size", String.valueOf(pageRequest.getSize()));

        request.setAttribute("locations", locationPage.getItems());
        request.setAttribute("currentPage", locationPage.getCurrentPage());
        request.setAttribute("totalPages", locationPage.getTotalPages());
        request.setAttribute("pageSize", locationPage.getPageSize());
        request.setAttribute("totalItems", locationPage.getTotalItems());
        request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/location", paginationParams));
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
        
        // Manager: pre-select and lock to their assigned warehouse
        if (isWarehouseScoped(request)) {
            Long assignedWarehouseId = getAssignedWarehouseId(request);
            if (assignedWarehouseId == null) {
                request.getSession().setAttribute("errorMessage", "You are not assigned to any warehouse.");
                response.sendRedirect(request.getContextPath() + "/location");
                return;
            }
            request.setAttribute("lockedWarehouseId", assignedWarehouseId);
            request.setAttribute("warehouseId", assignedWarehouseId);
        } else {
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
        }
        request.setAttribute("isWarehouseScoped", isWarehouseScoped(request));
        
        request.setAttribute("warehouses", warehouses);
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
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
        String categoryIdStr = request.getParameter("categoryId");
        Long categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore invalid - treat as no restriction
            }
        }
        
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
        
        // Manager can only create locations for their assigned warehouse
        if (!hasError && isWarehouseScoped(request)) {
            Long assignedWarehouseId = getAssignedWarehouseId(request);
            if (assignedWarehouseId == null || !assignedWarehouseId.equals(warehouseId)) {
                request.getSession().setAttribute("errorMessage", "You can only create locations for your assigned warehouse.");
                response.sendRedirect(request.getContextPath() + "/location?action=add");
                return;
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
            request.setAttribute("categoryId", categoryId);
            request.setAttribute("warehouses", warehouseService.getAllWarehouses());
            request.setAttribute("categories", categoryService.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/location/add.jsp").forward(request, response);
            return;
        }
        
        // Create location
        Location created = locationService.createLocation(warehouseId, code.trim(), type.trim(), categoryId);
        
        if (created == null) {
            // AF-1: Duplicate Location Code
            request.setAttribute("errorMessage", "Location code already exists in this warehouse");
            request.setAttribute("warehouseId", warehouseId);
            request.setAttribute("code", code);
            request.setAttribute("type", type);
            request.setAttribute("categoryId", categoryId);
            request.setAttribute("warehouses", warehouseService.getAllWarehouses());
            request.setAttribute("categories", categoryService.getAllCategories());
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
            
            // Manager can only edit locations in their assigned warehouse
            if (isWarehouseScoped(request)) {
                Long assignedWarehouseId = getAssignedWarehouseId(request);
                if (assignedWarehouseId == null || !assignedWarehouseId.equals(location.getWarehouseId())) {
                    request.getSession().setAttribute("errorMessage", "You don't have permission to edit this location.");
                    response.sendRedirect(request.getContextPath() + "/location?action=list");
                    return;
                }
            }
            
            // Get warehouse for display
            Warehouse warehouse = warehouseService.getWarehouseById(location.getWarehouseId());
            
            // Get inventory count
            int inventoryCount = locationService.getInventoryCount(id);
            
            request.setAttribute("location", location);
            request.setAttribute("warehouse", warehouse);
            request.setAttribute("inventoryCount", inventoryCount);
            List<Category> categories = categoryService.getAllCategories();
            request.setAttribute("categories", categories);
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
        String categoryIdStr = request.getParameter("categoryId");
        Long categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryIdStr.trim());
            } catch (NumberFormatException e) { /* no restriction */ }
        }
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Location ID is required");
            response.sendRedirect(request.getContextPath() + "/location?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            
            // Manager can only update locations in their assigned warehouse
            if (isWarehouseScoped(request)) {
                Location existing = locationService.getLocationById(id);
                Long assignedWarehouseId = getAssignedWarehouseId(request);
                if (existing == null || assignedWarehouseId == null || !assignedWarehouseId.equals(existing.getWarehouseId())) {
                    request.getSession().setAttribute("errorMessage", "You don't have permission to update this location.");
                    response.sendRedirect(request.getContextPath() + "/location?action=list");
                    return;
                }
            }
            
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
                    request.setAttribute("inventoryCount", locationService.getInventoryCount(id));
                }
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("categories", categoryService.getAllCategories());
                request.getRequestDispatcher("/WEB-INF/views/location/edit.jsp").forward(request, response);
                return;
            }
            
            // Get existing location for redirect
            Location existing = locationService.getLocationById(id);
            Long warehouseId = existing != null ? existing.getWarehouseId() : null;
            
            // Update location
            boolean updated = locationService.updateLocation(id, code.trim(), type.trim(), categoryId);
            
            if (!updated) {
                // Could be duplicate code, location not found, or category conflict
                Location loc = locationService.getLocationById(id);
                if (loc == null) {
                    request.getSession().setAttribute("errorMessage", "Location not found");
                } else {
                    request.setAttribute("errorMessage", "Could not update location. Ensure location code is unique and there is no category conflict with existing inventory");
                    loc.setCode(code);
                    loc.setType(type);
                    request.setAttribute("location", loc);
                    request.setAttribute("warehouse", warehouseService.getWarehouseById(loc.getWarehouseId()));
                    request.setAttribute("inventoryCount", locationService.getInventoryCount(id));
                    request.setAttribute("categoryId", categoryId);
                    request.setAttribute("categories", categoryService.getAllCategories());
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
            
            // Manager can only toggle locations in their assigned warehouse
            if (isWarehouseScoped(request)) {
                Long assignedWarehouseId = getAssignedWarehouseId(request);
                if (assignedWarehouseId == null || !assignedWarehouseId.equals(location.getWarehouseId())) {
                    request.getSession().setAttribute("errorMessage", "You don't have permission to modify this location.");
                    response.sendRedirect(request.getContextPath() + "/location?action=list");
                    return;
                }
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
