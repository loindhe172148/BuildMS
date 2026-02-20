package controller;

import model.Category;
import model.Location;
import model.User;
import model.Product;
import model.Warehouse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Service.InventoryService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Controller for Inventory Management
 * 
 * UC-INV-001: View Inventory by Warehouse
 * UC-INV-002: View Inventory by Product
 * UC-INV-003: Search Inventory
 */
@WebServlet("/inventory")
public class InventoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private InventoryService inventoryService;
    
    @Override
    public void init() throws ServletException {
        inventoryService = new InventoryService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.trim().isEmpty()) {
            action = "byWarehouse";
        }
        
        switch (action) {
            case "byWarehouse":
                viewByWarehouse(request, response);
                break;
            case "byProduct":
                viewByProduct(request, response);
                break;
            case "search":
                searchInventory(request, response);
                break;
            default:
                viewByWarehouse(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Check if user has access to inventory (Admin, Manager, Staff)
     */
    private boolean hasAccess(HttpServletRequest request) {
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
     * Check if user is Staff (restricted to assigned warehouse)
     */
    private boolean isStaff(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null && "Staff".equals(user.getRole());
    }
    
    /**
     * Get Staff's assigned warehouse ID
     */
    private Long getStaffWarehouseId(HttpServletRequest request) {
        User user = getCurrentUser(request);
        if (user != null && "Staff".equals(user.getRole())) {
            return user.getWarehouseId();
        }
        return null;
    }
    
    /**
     * UC-INV-001: View Inventory by Warehouse
     */
    private void viewByWarehouse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to view inventory.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // Get warehouse ID from request or Staff's assigned warehouse
        Long warehouseId = null;
        String warehouseIdStr = request.getParameter("warehouseId");
        
        if (isStaff(request)) {
            // Staff can only view their assigned warehouse
            warehouseId = getStaffWarehouseId(request);
            if (warehouseId == null) {
                request.setAttribute("errorMessage", "You are not assigned to any warehouse.");
                request.getRequestDispatcher("/WEB-INF/views/inventory/by-warehouse.jsp").forward(request, response);
                return;
            }
        } else {
            // Admin/Manager can select any warehouse
            if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
                try {
                    warehouseId = Long.parseLong(warehouseIdStr.trim());
                } catch (NumberFormatException e) {
                    // Ignore invalid input
                }
            }
        }
        
        // Get warehouses for dropdown (hidden for Staff)
        List<Warehouse> warehouses = inventoryService.getAllWarehouses();
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("isStaff", isStaff(request));
        
        if (warehouseId != null) {
            // Get selected warehouse
            Warehouse selectedWarehouse = inventoryService.getWarehouseById(warehouseId);
            request.setAttribute("selectedWarehouse", selectedWarehouse);
            request.setAttribute("selectedWarehouseId", warehouseId);
            
            // Get inventory grouped by location
            Map<Location, List<Map<String, Object>>> inventoryByLocation = 
                    inventoryService.getInventoryByWarehouse(warehouseId);
            request.setAttribute("inventoryByLocation", inventoryByLocation);
            
            // Get summary
            Map<String, Integer> summary = inventoryService.getWarehouseSummary(warehouseId);
            request.setAttribute("summary", summary);
        }
        
        // Handle search within warehouse
        String searchTerm = request.getParameter("search");
        request.setAttribute("searchTerm", searchTerm);
        
        request.getRequestDispatcher("/WEB-INF/views/inventory/by-warehouse.jsp").forward(request, response);
    }
    
    /**
     * UC-INV-002: View Inventory by Product
     */
    private void viewByProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to view inventory.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // Get product ID from request
        Long productId = null;
        String productIdStr = request.getParameter("productId");
        if (productIdStr != null && !productIdStr.trim().isEmpty()) {
            try {
                productId = Long.parseLong(productIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore invalid input
            }
        }
        
        // Get search term for product search
        String searchTerm = request.getParameter("search");
        request.setAttribute("searchTerm", searchTerm);
        
        // Search products if search term provided
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            List<Product> searchResults = inventoryService.searchProducts(searchTerm);
            request.setAttribute("searchResults", searchResults);
        }
        
        // Get Staff warehouse filter if applicable
        Long warehouseFilter = null;
        if (isStaff(request)) {
            warehouseFilter = getStaffWarehouseId(request);
            request.setAttribute("isStaff", true);
        }
        
        if (productId != null) {
            // Get product details
            Product product = inventoryService.getProductById(productId);
            request.setAttribute("selectedProduct", product);
            
            if (product != null) {
                // Get inventory for product
                List<Map<String, Object>> inventoryList = 
                        inventoryService.getInventoryByProduct(productId, warehouseFilter);
                request.setAttribute("inventoryList", inventoryList);
                
                // Get summary
                Map<String, Integer> summary = 
                        inventoryService.getProductInventorySummary(productId, warehouseFilter);
                request.setAttribute("summary", summary);
            }
        }
        
        request.getRequestDispatcher("/WEB-INF/views/inventory/by-product.jsp").forward(request, response);
    }
    
    /**
     * UC-INV-003: Search Inventory
     */
    private void searchInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to view inventory.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // Get search parameters
        String searchTerm = request.getParameter("q");
        String warehouseIdStr = request.getParameter("warehouseId");
        String categoryIdStr = request.getParameter("categoryId");
        String minQtyStr = request.getParameter("minQty");
        String maxQtyStr = request.getParameter("maxQty");
        
        Long warehouseId = null;
        Long categoryId = null;
        Integer minQuantity = null;
        Integer maxQuantity = null;
        
        // Parse warehouse ID (Staff can only search their assigned warehouse)
        if (isStaff(request)) {
            warehouseId = getStaffWarehouseId(request);
            request.setAttribute("isStaff", true);
        } else if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        // Parse category ID
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        // Parse quantity range
        if (minQtyStr != null && !minQtyStr.trim().isEmpty()) {
            try {
                minQuantity = Integer.parseInt(minQtyStr.trim());
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        if (maxQtyStr != null && !maxQtyStr.trim().isEmpty()) {
            try {
                maxQuantity = Integer.parseInt(maxQtyStr.trim());
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        // Store filter values for display
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("selectedWarehouseId", warehouseId);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("minQty", minQuantity);
        request.setAttribute("maxQty", maxQuantity);
        
        // Get filter options
        List<Warehouse> warehouses = inventoryService.getAllWarehouses();
        List<Category> categories = inventoryService.getAllCategories();
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("categories", categories);
        
        // Perform search
        List<Map<String, Object>> searchResults = inventoryService.searchInventory(
                searchTerm, warehouseId, categoryId, minQuantity, maxQuantity);
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("resultCount", searchResults.size());
        
        request.getRequestDispatcher("/WEB-INF/views/inventory/search.jsp").forward(request, response);
    }
}
