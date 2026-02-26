package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.ProductDAO;
import vn.edu.fpt.swp.model.Product;

import java.util.List;

/**
 * Service class for product operations
 */
public class ProductService {
    private final ProductDAO productDAO;
    
    public ProductService() {
        this.productDAO = new ProductDAO();
    }
    
    /**
     * Get product by ID
     * @param id Product ID
     * @return Product object if found, null otherwise
     */
    public Product getProductById(Long id) {
        return productDAO.findById(id);
    }
    
    /**
     * Get all products
     * @return List of all products
     */
    public List<Product> getAllProducts() {
        return productDAO.getAll();
    }
    
    /**
     * Get active products only
     * @return List of active products
     */
    public List<Product> getActiveProducts() {
        return productDAO.getActive();
    }
    
    /**
     * Get products by category
     * @param categoryId Category ID
     * @return List of products in the category
     */
    public List<Product> getProductsByCategory(Long categoryId) {
        if (categoryId == null || categoryId <= 0) {
            return List.of();
        }
        return productDAO.findByCategory(categoryId);
    }
    
    /**
     * Create a new product
     * @param sku Product SKU
     * @param name Product name
     * @param unit Unit of measure
     * @param categoryId Category ID
     * @return Created product with generated ID, null if failed
     */
    public Product createProduct(String sku, String name, String unit, Long categoryId) {
        // Validate input
        if (sku == null || sku.trim().isEmpty() || 
            name == null || name.trim().isEmpty() ||
            categoryId == null || categoryId <= 0) {
            return null;
        }
        
        // Check for duplicate SKU
        if (productDAO.findBySku(sku.trim()) != null) {
            return null; // SKU already exists
        }
        
        // Create product
        Product product = new Product(sku.trim(), name.trim(), 
                                     unit != null ? unit.trim() : null, categoryId);
        product.setActive(true); // New products are active by default
        return productDAO.create(product);
    }
    
    /**
     * Update an existing product
     * @param id Product ID
     * @param sku New SKU
     * @param name New name
     * @param unit New unit
     * @param categoryId New category ID
     * @return true if update successful, false otherwise
     */
    public boolean updateProduct(Long id, String sku, String name, String unit, Long categoryId) {
        // Validate input
        if (id == null || id <= 0 || sku == null || sku.trim().isEmpty() ||
            name == null || name.trim().isEmpty() || categoryId == null || categoryId <= 0) {
            return false;
        }
        
        // Check if product exists
        Product existing = productDAO.findById(id);
        if (existing == null) {
            return false;
        }
        
        // Check for duplicate SKU (only if SKU is different)
        if (!existing.getSku().equalsIgnoreCase(sku.trim())) {
            Product duplicate = productDAO.findBySku(sku.trim());
            if (duplicate != null) {
                return false; // Another product with this SKU exists
            }
        }
        
        // Update product
        Product product = new Product(sku.trim(), name.trim(), 
                                     unit != null ? unit.trim() : null, categoryId);
        product.setId(id);
        product.setActive(existing.isActive()); // Keep existing status
        product.setCreatedAt(existing.getCreatedAt()); // Keep original created time
        return productDAO.update(product);
    }
    
    /**
     * Toggle product status
     * @param id Product ID
     * @return true if update successful, false otherwise
     */
    public boolean toggleProductStatus(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        Product product = productDAO.findById(id);
        if (product == null) {
            return false;
        }
        
        return productDAO.toggleStatus(id, !product.isActive());
    }
    
    /**
     * Delete a product
     * @param id Product ID
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteProduct(Long id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        if (productDAO.findById(id) == null) {
            return false;
        }
        
        return productDAO.delete(id);
    }
    
    /**
     * Get total inventory quantity for a product
     * @param productId Product ID
     * @return Total quantity across all locations
     */
    public int getTotalInventoryQuantity(Long productId) {
        return productDAO.getTotalInventoryQuantity(productId);
    }
    
    /**
     * Check if product has pending sales orders
     * @param productId Product ID
     * @return Number of pending orders
     */
    public int getPendingOrderCount(Long productId) {
        return productDAO.countPendingOrders(productId);
    }
    
    /**
     * Search products
     * @param keyword Search keyword
     * @return List of matching products
     */
    public List<Product> searchProducts(String keyword) {
        return productDAO.search(keyword);
    }
    
    /**
     * Get products by status
     * @param isActive true for active, false for inactive
     * @return List of products with specified status
     */
    public List<Product> getProductsByStatus(boolean isActive) {
        return productDAO.findByStatus(isActive);
    }
}
