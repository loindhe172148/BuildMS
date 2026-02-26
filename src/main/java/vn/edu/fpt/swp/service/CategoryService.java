package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.CategoryDAO;
import vn.edu.fpt.swp.model.Category;

import java.util.List;

/**
 * Service class for category operations
 */
public class CategoryService {
    private final CategoryDAO categoryDAO;
    
    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }
    
    /**
     * Get category by ID
     * @param id Category ID
     * @return Category object if found, null otherwise
     */
    public Category getCategoryById(Long id) {
        return categoryDAO.findById(id);
    }
    
    /**
     * Get all categories
     * @return List of all categories
     */
    public List<Category> getAllCategories() {
        return categoryDAO.getAll();
    }
    
    /**
     * Create a new category
     * @param name Category name
     * @param description Category description
     * @return Created category with generated ID, null if failed
     */
    public Category createCategory(String name, String description) {
        // Validate input
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        
        // Check for duplicate name
        if (categoryDAO.findByName(name.trim()) != null) {
            return null; // Category name already exists
        }
        
        // Create category
        Category category = new Category(name.trim(), 
                                        description != null ? description.trim() : null);
        return categoryDAO.create(category);
    }
    
    /**
     * Update an existing category
     * @param id Category ID
     * @param name New category name
     * @param description New category description
     * @return true if update successful, false otherwise
     */
    public boolean updateCategory(Long id, String name, String description) {
        // Validate input
        if (id == null || id <= 0 || name == null || name.trim().isEmpty()) {
            return false;
        }
        
        // Check if category exists
        Category existing = categoryDAO.findById(id);
        if (existing == null) {
            return false;
        }
        
        // Check for duplicate name (only if name is different)
        if (!existing.getName().equalsIgnoreCase(name.trim())) {
            Category duplicate = categoryDAO.findByName(name.trim());
            if (duplicate != null) {
                return false; // Another category with this name exists
            }
        }
        
        // Update category
        Category category = new Category(name.trim(), 
                                        description != null ? description.trim() : null);
        category.setId(id);
        return categoryDAO.update(category);
    }
    
    /**
     * Delete a category
     * @param id Category ID
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteCategory(Long id) {
        // Validate input
        if (id == null || id <= 0) {
            return false;
        }
        
        // Check if category exists
        if (categoryDAO.findById(id) == null) {
            return false;
        }
        
        // Check for associated products
        if (categoryDAO.countProducts(id) > 0) {
            return false; // Cannot delete category with products
        }
        
        return categoryDAO.delete(id);
    }
    
    /**
     * Get product count for a category
     * @param categoryId Category ID
     * @return Number of products in category
     */
    public int getProductCount(Long categoryId) {
        return categoryDAO.countProducts(categoryId);
    }
    
    /**
     * Search categories
     * @param keyword Search keyword
     * @return List of matching categories
     */
    public List<Category> searchCategories(String keyword) {
        return categoryDAO.search(keyword);
    }
}
