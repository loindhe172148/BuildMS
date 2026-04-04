package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.Provider;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.service.ProviderService;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;
import vn.edu.fpt.swp.util.PaginationUtil;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Controller for Provider management
 * Handles UC-PRO-001, UC-PRO-002, UC-PRO-003, UC-PRO-004
 */
@WebServlet("/provider")
public class ProviderController extends HttpServlet {
    
    private ProviderService providerService;
    
    @Override
    public void init() throws ServletException {
        providerService = new ProviderService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        // Check access
        if (!hasAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        switch (action) {
            case "list":
                showList(request, response);
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
                showList(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        // Check access
        if (!hasAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
            return;
        }
        
        switch (action) {
            case "add":
                processAdd(request, response);
                break;
            case "edit":
                processEdit(request, response);
                break;
            case "toggle":
                toggleStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/provider?action=list");
        }
    }
    
    /**
     * UC-PRO-004: Display provider list with filters
     */
    private void showList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        String selectedKeyword = keyword != null ? keyword.trim() : null;
        String selectedStatus = status != null ? status.trim() : null;
        if (selectedKeyword != null && selectedKeyword.isEmpty()) {
            selectedKeyword = null;
        }
        if (selectedStatus != null && selectedStatus.isEmpty()) {
            selectedStatus = null;
        }

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        PageResult<Provider> providerPage = providerService.searchProvidersPaginated(selectedKeyword, selectedStatus, pageRequest);

        Map<String, String> paginationParams = new LinkedHashMap<>();
        paginationParams.put("keyword", selectedKeyword);
        paginationParams.put("status", selectedStatus);
        paginationParams.put("size", String.valueOf(pageRequest.getSize()));

        request.setAttribute("providers", providerPage.getItems());
        request.setAttribute("keyword", selectedKeyword);
        request.setAttribute("status", selectedStatus);
        request.setAttribute("currentPage", providerPage.getCurrentPage());
        request.setAttribute("totalPages", providerPage.getTotalPages());
        request.setAttribute("pageSize", providerPage.getPageSize());
        request.setAttribute("totalItems", providerPage.getTotalItems());
        request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/provider", paginationParams));
        
        request.getRequestDispatcher("/WEB-INF/views/provider/list.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-PRO-001: Show add provider form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/provider/add.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-PRO-001: Process add provider
     */
    private void processAdd(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String contactInfo = request.getParameter("contactInfo");
        
        try {
            Provider provider = new Provider();
            provider.setCode(code);
            provider.setName(name);
            provider.setContactInfo(contactInfo);
            
            Provider created = providerService.createProvider(provider);
            
            if (created != null) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Provider created successfully!");
                response.sendRedirect(request.getContextPath() + "/provider?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to create provider. Please try again.");
                request.setAttribute("code", code);
                request.setAttribute("name", name);
                request.setAttribute("contactInfo", contactInfo);
                request.getRequestDispatcher("/WEB-INF/views/provider/add.jsp")
                       .forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("code", code);
            request.setAttribute("name", name);
            request.setAttribute("contactInfo", contactInfo);
            request.getRequestDispatcher("/WEB-INF/views/provider/add.jsp")
                   .forward(request, response);
        }
    }
    
    /**
     * UC-PRO-002: Show edit provider form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Provider ID is required");
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam);
            Provider provider = providerService.getProviderById(id);
            
            if (provider == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Provider not found");
                response.sendRedirect(request.getContextPath() + "/provider?action=list");
                return;
            }
            
            boolean isUsed = providerService.isUsedInRequests(id);
            
            request.setAttribute("provider", provider);
            request.setAttribute("isUsed", isUsed);
            
            request.getRequestDispatcher("/WEB-INF/views/provider/edit.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid provider ID");
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
        }
    }
    
    /**
     * UC-PRO-002: Process edit provider
     */
    private void processEdit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String contactInfo = request.getParameter("contactInfo");
        
        if (idParam == null || idParam.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Provider ID is required");
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam);
            
            Provider provider = providerService.getProviderById(id);
            if (provider == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Provider not found");
                response.sendRedirect(request.getContextPath() + "/provider?action=list");
                return;
            }
            
            provider.setName(name);
            provider.setContactInfo(contactInfo);
            
            boolean updated = providerService.updateProvider(provider);
            
            if (updated) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Provider updated successfully!");
                response.sendRedirect(request.getContextPath() + "/provider?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to update provider. Please try again.");
                request.setAttribute("provider", provider);
                request.setAttribute("isUsed", providerService.isUsedInRequests(id));
                request.getRequestDispatcher("/WEB-INF/views/provider/edit.jsp")
                       .forward(request, response);
            }
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid provider ID");
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
        } catch (IllegalArgumentException e) {
            Long id = Long.parseLong(idParam);
            Provider provider = providerService.getProviderById(id);
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("provider", provider);
            
            // To restore draft changes upon validation error
            Provider draft = new Provider();
            draft.setId(provider.getId());
            draft.setCode(provider.getCode());
            draft.setName(name);
            draft.setContactInfo(contactInfo);
            draft.setStatus(provider.getStatus());
            
            request.setAttribute("provider", draft);
            
            request.setAttribute("isUsed", providerService.isUsedInRequests(id));
            request.getRequestDispatcher("/WEB-INF/views/provider/edit.jsp")
                   .forward(request, response);
        }
    }
    
    /**
     * UC-PRO-003: Toggle provider status
     */
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Provider ID is required");
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam);
            Provider provider = providerService.getProviderById(id);
            
            if (provider == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Provider not found");
                response.sendRedirect(request.getContextPath() + "/provider?action=list");
                return;
            }
            
            boolean isDeactivating = "Active".equals(provider.getStatus());
            boolean isUsed = providerService.isUsedInRequests(id);
            
            boolean toggled = providerService.toggleProviderStatus(id);
            
            HttpSession session = request.getSession();
            if (toggled) {
                String message = "Provider " + (isDeactivating ? "deactivated" : "activated") + " successfully!";
                if (isDeactivating && isUsed) {
                    message += " Note: Existing inbound requests using this provider remain unchanged.";
                    session.setAttribute("warningMessage", message);
                } else {
                    session.setAttribute("successMessage", message);
                }
            } else {
                session.setAttribute("errorMessage", "Failed to update provider status");
            }
            
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
            
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid provider ID");
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/provider?action=list");
        }
    }
    
    /**
     * Check if user has access to provider management (Admin, Manager)
     */
    private boolean hasAccess(HttpServletRequest request) {
        User user = getCurrentUser(request);
        if (user == null) return false;
        
        String role = user.getRole();
        return "Admin".equals(role) || "Manager".equals(role);
    }
    
    /**
     * Get current logged in user
     */
    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }
}
