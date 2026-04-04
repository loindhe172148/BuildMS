package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.Category;
import vn.edu.fpt.swp.model.Product;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.service.CategoryService;
import vn.edu.fpt.swp.service.ProductService;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;
import vn.edu.fpt.swp.util.PaginationUtil;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for Product Management
 * 
 * UC-PRD-001: Create Product
 * UC-PRD-002: Update Product
 * UC-PRD-003: Toggle Product Status
 * UC-PRD-004: View Product List
 * UC-PRD-005: View Product Details
 */
@WebServlet("/product")
public class ProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ProductService productService;
    private CategoryService categoryService;
    
    @Override
    public void init() throws ServletException {
        productService = new ProductService();
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
                listProducts(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "details":
                showDetails(request, response);
                break;
            case "toggle":
                toggleStatus(request, response);
                break;
            default:
                listProducts(request, response);
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
                createProduct(request, response);
                break;
            case "edit":
                updateProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }
    
    /**
     * Check if current user has admin/manager role
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
     * Get current user's role
     */
    private String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        
        User user = (User) session.getAttribute("user");
        return user != null ? user.getRole() : null;
    }
    
    /**
     * UC-PRD-004: View Product List
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        String status = request.getParameter("status");

        String selectedKeyword = keyword != null ? keyword.trim() : null;
        String selectedStatus = null;
        Long selectedCategoryId = null;
        Boolean statusFilter = null;

        if (selectedKeyword != null && !selectedKeyword.isEmpty()) {
            request.setAttribute("keyword", selectedKeyword);
            selectedCategoryId = null;
            statusFilter = null;
        } else if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                selectedCategoryId = Long.parseLong(categoryIdStr.trim());
                request.setAttribute("categoryId", selectedCategoryId);
                selectedKeyword = null;
            } catch (NumberFormatException e) {
                selectedCategoryId = null;
            }
        } else if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                selectedStatus = "active";
                statusFilter = true;
            } else if ("inactive".equalsIgnoreCase(status)) {
                selectedStatus = "inactive";
                statusFilter = false;
            }
            request.setAttribute("status", selectedStatus);
        }

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        PageResult<Product> productPage = productService.searchProductsPaginated(
            selectedKeyword,
            selectedCategoryId,
            statusFilter,
            pageRequest
        );
        
        // Get all categories for filter dropdown
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        
        // Build category map for display
        java.util.Map<Long, String> categoryMap = new java.util.HashMap<>();
        for (Category category : categories) {
            categoryMap.put(category.getId(), category.getName());
        }
        request.setAttribute("categoryMap", categoryMap);

        // Fetch all inventory totals in ONE query instead of N per-product queries
        java.util.Map<Long, Integer> inventoryTotals = productService.getAllProductTotalQuantities();
        request.setAttribute("inventoryTotals", inventoryTotals);

        Map<String, String> paginationParams = new LinkedHashMap<>();
        paginationParams.put("keyword", selectedKeyword);
        paginationParams.put("categoryId", selectedCategoryId != null ? String.valueOf(selectedCategoryId) : null);
        paginationParams.put("status", selectedStatus);
        paginationParams.put("size", String.valueOf(pageRequest.getSize()));

        request.setAttribute("products", productPage.getItems());
        request.setAttribute("currentPage", productPage.getCurrentPage());
        request.setAttribute("totalPages", productPage.getTotalPages());
        request.setAttribute("pageSize", productPage.getPageSize());
        request.setAttribute("totalItems", productPage.getTotalItems());
        request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/product", paginationParams));
        request.getRequestDispatcher("/WEB-INF/views/product/list.jsp").forward(request, response);
    }
    
    /**
     * UC-PRD-001: Show Add Product Form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        // Get categories for dropdown
        List<Category> categories = categoryService.getAllCategories();
        
        // AF-3: No Categories Available
        if (categories.isEmpty()) {
            request.getSession().setAttribute("warningMessage", 
                "Please create a category first before adding products.");
            response.sendRedirect(request.getContextPath() + "/category?action=add");
            return;
        }
        
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/product/add.jsp").forward(request, response);
    }
    
    /**
     * UC-PRD-001: Create Product
     */
    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String sku = request.getParameter("sku");
        String name = request.getParameter("name");
        String categoryIdStr = request.getParameter("categoryId");
        
        // Validate required fields - AF-2: Empty Required Fields
        boolean hasError = false;
        StringBuilder errorMsg = new StringBuilder();
        
        if (sku == null || sku.trim().isEmpty()) {
            errorMsg.append("SKU is required. ");
            hasError = true;
        }
        
        if (name == null || name.trim().isEmpty()) {
            errorMsg.append("Product name is required. ");
            hasError = true;
        }
        
        Long categoryId = null;
        if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            errorMsg.append("Category is required. ");
            hasError = true;
        } else {
            try {
                categoryId = Long.parseLong(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid category. ");
                hasError = true;
            }
        }
        
        if (hasError) {
            request.setAttribute("errorMessage", errorMsg.toString().trim());
            request.setAttribute("sku", sku);
            request.setAttribute("name", name);
            request.setAttribute("categoryId", categoryId);
            request.setAttribute("categories", categoryService.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/product/add.jsp").forward(request, response);
            return;
        }
        
        // Inherit exact unit from selected category
        Category category = categoryService.getCategoryById(categoryId);
        String unit = category != null ? category.getDefaultUnit() : null;
        
        // Create product
        Product created = productService.createProduct(sku.trim(), name.trim(), unit, categoryId);
        
        if (created == null) {
            // AF-1: Duplicate SKU
            request.setAttribute("errorMessage", "SKU already exists. Please use a unique SKU.");
            request.setAttribute("sku", sku);
            request.setAttribute("name", name);
            request.setAttribute("categoryId", categoryId);
            request.setAttribute("categories", categoryService.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/product/add.jsp").forward(request, response);
            return;
        }
        
        // Success - redirect to list
        request.getSession().setAttribute("successMessage", "Product created successfully");
        response.sendRedirect(request.getContextPath() + "/product?action=list");
    }
    
    /**
     * UC-PRD-002: Show Edit Product Form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Product ID is required");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            Product product = productService.getProductById(id);
            
            // AF-1: Product Not Found
            if (product == null) {
                request.getSession().setAttribute("errorMessage", "Product not found");
                response.sendRedirect(request.getContextPath() + "/product?action=list");
                return;
            }
            
            // Get categories for dropdown
            List<Category> categories = categoryService.getAllCategories();
            
            // Check if product has inventory (for SKU change warning)
            int inventoryQty = productService.getTotalInventoryQuantity(id);
            
            request.setAttribute("product", product);
            request.setAttribute("categories", categories);
            request.setAttribute("hasInventory", inventoryQty > 0);
            request.setAttribute("inventoryQty", inventoryQty);
            request.getRequestDispatcher("/WEB-INF/views/product/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid product ID");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
        }
    }
    
    /**
     * UC-PRD-002: Update Product
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Product ID is required");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            Product existing = productService.getProductById(id);
            if (existing == null) {
                request.getSession().setAttribute("errorMessage", "Product not found");
                response.sendRedirect(request.getContextPath() + "/product?action=list");
                return;
            }
            
            // Validate required fields
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Product name is required.");
                request.setAttribute("product", existing);
                request.setAttribute("categories", categoryService.getAllCategories());
                request.getRequestDispatcher("/WEB-INF/views/product/edit.jsp").forward(request, response);
                return;
            }
            
            // Update product (only Name is allowed to be updated)
            boolean updated = productService.updateProduct(id, existing.getSku(), name.trim(), existing.getUnit(), existing.getCategoryId());
            
            if (!updated) {
                request.getSession().setAttribute("errorMessage", "Failed to update product");
                response.sendRedirect(request.getContextPath() + "/product?action=list");
                return;
            }
            
            // Success
            request.getSession().setAttribute("successMessage", "Product updated successfully");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid product ID");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
        }
    }
    
    /**
     * UC-PRD-003: Toggle Product Status
     */
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Product ID is required");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            
            // Get product
            Product product = productService.getProductById(id);
            if (product == null) {
                request.getSession().setAttribute("errorMessage", "Product not found");
                response.sendRedirect(request.getContextPath() + "/product?action=list");
                return;
            }
            
            // Toggle status
            boolean success = productService.toggleProductStatus(id);
            
            if (success) {
                String action = product.isActive() ? "deactivated" : "activated";
                request.getSession().setAttribute("successMessage", "Product " + action + " successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update product status");
            }
            
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid product ID");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
        }
    }
    
    /**
     * UC-PRD-005: View Product Details
     */
    private void showDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Product ID is required");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            Product product = productService.getProductById(id);
            
            // AF-1: Product Not Found
            if (product == null) {
                request.getSession().setAttribute("errorMessage", "Product not found");
                response.sendRedirect(request.getContextPath() + "/product?action=list");
                return;
            }
            
            // Get category name
            Category category = categoryService.getCategoryById(product.getCategoryId());
            
            // Get total inventory
            int totalInventory = productService.getTotalInventoryQuantity(id);
            
            // Get pending orders count (for staff/admin/manager only, not for sales)
            String role = getUserRole(request);
            int pendingOrders = 0;
            if (!"Sales".equals(role)) {
                pendingOrders = productService.getPendingOrderCount(id);
            }
            
            // Get inventory breakdown (not visible to Sales)
            if (!"Sales".equals(role)) {
                HttpSession session = request.getSession(false);
                User currentUser = (User) session.getAttribute("user");
                Long warehouseFilter = "Staff".equals(role) ? currentUser.getWarehouseId() : null;
                java.util.List<java.util.Map<String, Object>> inventoryBreakdown = 
                    productService.getInventoryBreakdown(id, warehouseFilter);
                request.setAttribute("inventoryBreakdown", inventoryBreakdown);
            }
            
            request.setAttribute("product", product);
            request.setAttribute("category", category);
            request.setAttribute("totalInventory", totalInventory);
            request.setAttribute("pendingOrders", pendingOrders);
            request.getRequestDispatcher("/WEB-INF/views/product/details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid product ID");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
        }
    }
}
