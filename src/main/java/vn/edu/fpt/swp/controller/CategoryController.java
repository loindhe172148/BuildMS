package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.Category;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.service.CategoryService;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Category Management
 * 
 * UC-CAT-001: Create Category
 * UC-CAT-002: Update Category
 * UC-CAT-003: Delete Category
 * UC-CAT-004: View Category List
 */
@WebServlet("/category")
public class CategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CategoryService categoryService;
    
    @Override
    public void init() throws ServletException {
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
                listCategories(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
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
                createCategory(request, response);
                break;
            case "edit":
                updateCategory(request, response);
                break;
            default:
                listCategories(request, response);
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
     * UC-CAT-004: View Category List
     */
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        List<Category> categories;
        
        // Search or get all
        if (keyword != null && !keyword.trim().isEmpty()) {
            categories = categoryService.searchCategories(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            categories = categoryService.getAllCategories();
        }
        
        // Add product count for each category
        for (Category category : categories) {
            int productCount = categoryService.getProductCount(category.getId());
            request.setAttribute("productCount_" + category.getId(), productCount);
        }
        
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/category/list.jsp").forward(request, response);
    }
    
    /**
     * UC-CAT-001: Show Add Category Form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/category/add.jsp").forward(request, response);
    }
    
    /**
     * UC-CAT-001: Create Category
     */
    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        // Validate input - AF-2: Empty Required Fields
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Category name is required");
            request.setAttribute("name", name);
            request.setAttribute("description", description);
            request.getRequestDispatcher("/WEB-INF/views/category/add.jsp").forward(request, response);
            return;
        }
        
        // Create category
        Category created = categoryService.createCategory(name.trim(), description);
        
        if (created == null) {
            // AF-1: Duplicate Category Name
            request.setAttribute("errorMessage", "Category name already exists");
            request.setAttribute("name", name);
            request.setAttribute("description", description);
            request.getRequestDispatcher("/WEB-INF/views/category/add.jsp").forward(request, response);
            return;
        }
        
        // Success - redirect to list
        request.getSession().setAttribute("successMessage", "Category created successfully");
        response.sendRedirect(request.getContextPath() + "/category?action=list");
    }
    
    /**
     * UC-CAT-002: Show Edit Category Form
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
            request.getSession().setAttribute("errorMessage", "Category ID is required");
            response.sendRedirect(request.getContextPath() + "/category?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            Category category = categoryService.getCategoryById(id);
            
            // AF-1: Category Not Found
            if (category == null) {
                request.getSession().setAttribute("errorMessage", "Category not found");
                response.sendRedirect(request.getContextPath() + "/category?action=list");
                return;
            }
            
            request.setAttribute("category", category);
            request.getRequestDispatcher("/WEB-INF/views/category/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid category ID");
            response.sendRedirect(request.getContextPath() + "/category?action=list");
        }
    }
    
    /**
     * UC-CAT-002: Update Category
     */
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Category ID is required");
            response.sendRedirect(request.getContextPath() + "/category?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            
            // Validate name
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Category name is required");
                Category category = categoryService.getCategoryById(id);
                if (category != null) {
                    category.setName(name);
                    category.setDescription(description);
                    request.setAttribute("category", category);
                }
                request.getRequestDispatcher("/WEB-INF/views/category/edit.jsp").forward(request, response);
                return;
            }
            
            // Update category
            boolean updated = categoryService.updateCategory(id, name.trim(), description);
            
            if (!updated) {
                // Could be duplicate name or category not found
                Category existing = categoryService.getCategoryById(id);
                if (existing == null) {
                    request.getSession().setAttribute("errorMessage", "Category not found");
                } else {
                    request.setAttribute("errorMessage", "Category name already exists");
                    existing.setName(name);
                    existing.setDescription(description);
                    request.setAttribute("category", existing);
                    request.getRequestDispatcher("/WEB-INF/views/category/edit.jsp").forward(request, response);
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/category?action=list");
                return;
            }
            
            // Success
            request.getSession().setAttribute("successMessage", "Category updated successfully");
            response.sendRedirect(request.getContextPath() + "/category?action=list");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid category ID");
            response.sendRedirect(request.getContextPath() + "/category?action=list");
        }
    }
    
    /**
     * UC-CAT-003: Delete Category
     */
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check access
        if (!hasManageAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        // Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Category ID is required");
            response.sendRedirect(request.getContextPath() + "/category?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam.trim());
            
            // Check if category exists
            Category category = categoryService.getCategoryById(id);
            if (category == null) {
                // AF-3: Category Not Found
                request.getSession().setAttribute("errorMessage", "Category not found");
                response.sendRedirect(request.getContextPath() + "/category?action=list");
                return;
            }
            
            // Check for associated products
            int productCount = categoryService.getProductCount(id);
            if (productCount > 0) {
                // AF-1: Category Has Products
                request.getSession().setAttribute("errorMessage", 
                    "Cannot delete category with associated products. Please reassign or remove " + 
                    productCount + " product(s) first.");
                response.sendRedirect(request.getContextPath() + "/category?action=list");
                return;
            }
            
            // Delete category
            boolean deleted = categoryService.deleteCategory(id);
            
            if (deleted) {
                request.getSession().setAttribute("successMessage", "Category deleted successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete category");
            }
            
            response.sendRedirect(request.getContextPath() + "/category?action=list");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid category ID");
            response.sendRedirect(request.getContextPath() + "/category?action=list");
        }
    }
}
