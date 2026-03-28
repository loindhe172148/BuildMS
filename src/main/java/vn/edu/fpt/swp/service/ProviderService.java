package vn.edu.fpt.swp.service;

import vn.edu.fpt.swp.dao.ProviderDAO;
import vn.edu.fpt.swp.model.Provider;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;

import java.util.List;

/**
 * Service layer for Provider operations
 */
public class ProviderService {
    
    private final ProviderDAO providerDAO;
    
    public ProviderService() {
        this.providerDAO = new ProviderDAO();
    }
    
    /**
     * Create new provider
     * @param provider Provider to create
     * @return Created provider, or null if failed
     * @throws IllegalArgumentException if validation fails
     */
    public Provider createProvider(Provider provider) {
        // Validate required fields
        if (provider.getCode() == null || provider.getCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Provider code is required");
        }
        if (provider.getName() == null || provider.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Provider name is required");
        }
        
        // Trim values
        provider.setCode(provider.getCode().trim());
        provider.setName(provider.getName().trim());
        if (provider.getContactInfo() != null) {
            provider.setContactInfo(provider.getContactInfo().trim());
        }
        
        // Check for duplicate code
        Provider existing = providerDAO.findByCode(provider.getCode());
        if (existing != null) {
            throw new IllegalArgumentException("Provider code already exists");
        }
        
        // Set default status
        provider.setStatus("Active");
        
        return providerDAO.create(provider);
    }
    
    /**
     * Update existing provider
     * @param provider Provider to update
     * @return true if successful
     * @throws IllegalArgumentException if validation fails
     */
    public boolean updateProvider(Provider provider) {
        // Validate required fields
        if (provider.getId() == null) {
            throw new IllegalArgumentException("Provider ID is required");
        }
        if (provider.getName() == null || provider.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Provider name is required");
        }
        
        // Trim values
        provider.setName(provider.getName().trim());
        if (provider.getContactInfo() != null) {
            provider.setContactInfo(provider.getContactInfo().trim());
        }
        
        // Check if provider exists
        Provider existing = providerDAO.findById(provider.getId());
        if (existing == null) {
            throw new IllegalArgumentException("Provider not found");
        }
        
        return providerDAO.update(provider);
    }
    
    /**
     * Toggle provider status (Active <-> Inactive)
     * @param providerId Provider ID
     * @return true if successful
     * @throws IllegalArgumentException if provider not found
     */
    public boolean toggleProviderStatus(Long providerId) {
        Provider provider = providerDAO.findById(providerId);
        if (provider == null) {
            throw new IllegalArgumentException("Provider not found");
        }
        
        String newStatus = "Active".equals(provider.getStatus()) ? "Inactive" : "Active";
        return providerDAO.toggleStatus(providerId, newStatus);
    }
    
    /**
     * Get provider by ID
     * @param id Provider ID
     * @return Provider if found
     */
    public Provider getProviderById(Long id) {
        return providerDAO.findById(id);
    }
    
    /**
     * Get provider by code
     * @param code Provider code
     * @return Provider if found
     */
    public Provider getProviderByCode(String code) {
        return providerDAO.findByCode(code);
    }
    
    /**
     * Get all providers
     * @return List of all providers
     */
    public List<Provider> getAllProviders() {
        return providerDAO.getAll();
    }
    
    /**
     * Get providers by status
     * @param status Status to filter (Active/Inactive)
     * @return Filtered list
     */
    public List<Provider> getProvidersByStatus(String status) {
        return providerDAO.findByStatus(status);
    }
    
    /**
     * Get active providers only
     * @return List of active providers
     */
    public List<Provider> getActiveProviders() {
        return providerDAO.getActiveProviders();
    }
    
    public PageResult<Provider> searchProvidersPaginated(String keyword, String status, PageRequest pageRequest) {
        return providerDAO.searchPaginated(keyword, status, pageRequest);
    }
    
    /**
     * Check if provider is used in requests
     * @param providerId Provider ID
     * @return true if has used
     */
    public boolean isUsedInRequests(Long providerId) {
        return providerDAO.isUsedInRequests(providerId);
    }
    
    /**
     * Check if provider is active
     * @param providerId Provider ID
     * @return true if active
     */
    public boolean isActive(Long providerId) {
        Provider provider = providerDAO.findById(providerId);
        return provider != null && "Active".equals(provider.getStatus());
    }
}
