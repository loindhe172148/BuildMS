package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.*;
import vn.edu.fpt.swp.service.InventoryService;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PaginationUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
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
        
        if (isWarehouseScoped(request)) {
            // Staff and Manager can only view their assigned warehouse
            warehouseId = getAssignedWarehouseId(request);
            if (warehouseId == null) {
                request.setAttribute("errorMessage", "You are not assigned to any warehouse.");
                request.getRequestDispatcher("/WEB-INF/views/inventory/by-warehouse.jsp").forward(request, response);
                return;
            }
        } else {
            // Admin can select any warehouse
            if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
                try {
                    warehouseId = Long.parseLong(warehouseIdStr.trim());
                } catch (NumberFormatException e) {
                    // Ignore invalid input
                }
            }
        }
        
        // Get warehouses for dropdown (hidden for Staff and Manager)
        List<Warehouse> warehouses = inventoryService.getAllWarehouses();
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("isWarehouseScoped", isWarehouseScoped(request));

        // Handle search within warehouse
        String searchTerm = request.getParameter("search");
        String normalizedSearchTerm = searchTerm != null ? searchTerm.trim() : null;
        if (normalizedSearchTerm != null && normalizedSearchTerm.isEmpty()) {
            normalizedSearchTerm = null;
        }
        request.setAttribute("searchTerm", normalizedSearchTerm);

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        
        if (warehouseId != null) {
            // Get selected warehouse
            Warehouse selectedWarehouse = inventoryService.getWarehouseById(warehouseId);
            request.setAttribute("selectedWarehouse", selectedWarehouse);
            request.setAttribute("selectedWarehouseId", warehouseId);
            
            // Get inventory grouped by location
            Map<Location, List<Map<String, Object>>> inventoryByLocation = 
                    inventoryService.getInventoryByWarehouse(warehouseId);

            Map<Location, List<Map<String, Object>>> filteredInventoryByLocation = new LinkedHashMap<>();
            if (normalizedSearchTerm == null) {
                filteredInventoryByLocation.putAll(inventoryByLocation);
            } else {
                String term = normalizedSearchTerm.toLowerCase();
                for (Map.Entry<Location, List<Map<String, Object>>> entry : inventoryByLocation.entrySet()) {
                    List<Map<String, Object>> matchedItems = new ArrayList<>();
                    for (Map<String, Object> item : entry.getValue()) {
                        Product product = (Product) item.get("product");
                        if (product == null) {
                            continue;
                        }
                        String sku = product.getSku() != null ? product.getSku().toLowerCase() : "";
                        String name = product.getName() != null ? product.getName().toLowerCase() : "";
                        if (sku.contains(term) || name.contains(term)) {
                            matchedItems.add(item);
                        }
                    }
                    if (!matchedItems.isEmpty()) {
                        filteredInventoryByLocation.put(entry.getKey(), matchedItems);
                    }
                }
            }

            List<Map.Entry<Location, List<Map<String, Object>>>> locationEntries =
                new ArrayList<>(filteredInventoryByLocation.entrySet());
            int totalItems = locationEntries.size();
            int totalPages = (int) Math.max(1L, (long) Math.ceil((double) totalItems / pageRequest.getSize()));
            int currentPage = Math.min(pageRequest.getPage(), totalPages);
            int fromIndex = Math.min((currentPage - 1) * pageRequest.getSize(), totalItems);
            int toIndex = Math.min(fromIndex + pageRequest.getSize(), totalItems);

            Map<Location, List<Map<String, Object>>> pagedInventoryByLocation = new LinkedHashMap<>();
            for (Map.Entry<Location, List<Map<String, Object>>> entry : locationEntries.subList(fromIndex, toIndex)) {
                pagedInventoryByLocation.put(entry.getKey(), entry.getValue());
            }

            Map<String, String> paginationParams = new LinkedHashMap<>();
            paginationParams.put("warehouseId", String.valueOf(warehouseId));
            paginationParams.put("search", normalizedSearchTerm);
            paginationParams.put("size", String.valueOf(pageRequest.getSize()));

            request.setAttribute("inventoryByLocation", pagedInventoryByLocation);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageRequest.getSize());
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/inventory", "byWarehouse", paginationParams));
            
            // Get summary
            Map<String, Integer> summary = inventoryService.getWarehouseSummary(warehouseId);
            request.setAttribute("summary", summary);
        }
        
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
            PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
            int totalItems = searchResults.size();
            int totalPages = (int) Math.max(1L, (long) Math.ceil((double) totalItems / pageRequest.getSize()));
            int currentPage = Math.min(pageRequest.getPage(), totalPages);
            int fromIndex = Math.min((currentPage - 1) * pageRequest.getSize(), totalItems);
            int toIndex = Math.min(fromIndex + pageRequest.getSize(), totalItems);

            request.setAttribute("searchResults", searchResults.subList(fromIndex, toIndex));
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageRequest.getSize());
            request.setAttribute("totalItems", totalItems);

            Map<String, String> paginationParams = new LinkedHashMap<>();
            paginationParams.put("search", searchTerm.trim());
            paginationParams.put("size", String.valueOf(pageRequest.getSize()));
            request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/inventory", "byProduct", paginationParams));
        }
        
        // Get warehouse filter for Staff/Manager
        Long warehouseFilter = null;
        if (isWarehouseScoped(request)) {
            warehouseFilter = getAssignedWarehouseId(request);
            request.setAttribute("isWarehouseScoped", true);
        }
        
        if (productId != null) {
            // Get product details
            Product product = inventoryService.getProductById(productId);
            request.setAttribute("selectedProduct", product);
            
            if (product != null) {
                // Get inventory for product
                List<Map<String, Object>> inventoryList = 
                        inventoryService.getInventoryByProduct(productId, warehouseFilter);

                PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
                int totalItems = inventoryList.size();
                int totalPages = (int) Math.max(1L, (long) Math.ceil((double) totalItems / pageRequest.getSize()));
                int currentPage = Math.min(pageRequest.getPage(), totalPages);
                int fromIndex = Math.min((currentPage - 1) * pageRequest.getSize(), totalItems);
                int toIndex = Math.min(fromIndex + pageRequest.getSize(), totalItems);

                request.setAttribute("inventoryList", inventoryList.subList(fromIndex, toIndex));
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("pageSize", pageRequest.getSize());
                request.setAttribute("totalItems", totalItems);

                Map<String, String> paginationParams = new LinkedHashMap<>();
                paginationParams.put("productId", String.valueOf(productId));
                paginationParams.put("size", String.valueOf(pageRequest.getSize()));
                request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/inventory", "byProduct", paginationParams));
                
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
        
        // Parse warehouse ID (Staff and Manager can only search their assigned warehouse)
        if (isWarehouseScoped(request)) {
            warehouseId = getAssignedWarehouseId(request);
            request.setAttribute("isWarehouseScoped", true);
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

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        int totalItems = searchResults.size();
        int totalPages = (int) Math.max(1L, (long) Math.ceil((double) totalItems / pageRequest.getSize()));
        int currentPage = Math.min(pageRequest.getPage(), totalPages);
        int fromIndex = Math.min((currentPage - 1) * pageRequest.getSize(), totalItems);
        int toIndex = Math.min(fromIndex + pageRequest.getSize(), totalItems);

        List<Map<String, Object>> pagedResults = searchResults.subList(fromIndex, toIndex);

        Map<String, String> paginationParams = new LinkedHashMap<>();
        paginationParams.put("q", searchTerm);
        paginationParams.put("warehouseId", warehouseId != null ? String.valueOf(warehouseId) : null);
        paginationParams.put("categoryId", categoryId != null ? String.valueOf(categoryId) : null);
        paginationParams.put("minQty", minQuantity != null ? String.valueOf(minQuantity) : null);
        paginationParams.put("maxQty", maxQuantity != null ? String.valueOf(maxQuantity) : null);
        paginationParams.put("size", String.valueOf(pageRequest.getSize()));

        request.setAttribute("searchResults", pagedResults);
        request.setAttribute("resultCount", totalItems);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageRequest.getSize());
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/inventory", "search", paginationParams));
        
        request.getRequestDispatcher("/WEB-INF/views/inventory/search.jsp").forward(request, response);
    }
}
