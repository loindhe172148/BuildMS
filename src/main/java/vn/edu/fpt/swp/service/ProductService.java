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
}