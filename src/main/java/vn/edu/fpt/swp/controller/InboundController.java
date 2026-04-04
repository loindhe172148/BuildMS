package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.*;
import vn.edu.fpt.swp.service.InboundService;
import vn.edu.fpt.swp.service.ProviderService;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;
import vn.edu.fpt.swp.util.PaginationUtil;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for Inbound Request Management
 * 
 * UC-INB-001: Create Inbound Request
 * UC-INB-002: Approve Inbound Request
 * UC-INB-003: Execute Inbound Request
 */
@WebServlet("/inbound")
public class InboundController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private InboundService inboundService;
    private ProviderService providerService;
    
    @Override
    public void init() throws ServletException {
        inboundService = new InboundService();
        providerService = new ProviderService();
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
                listRequests(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "details":
                showDetails(request, response);
                break;
            case "approve":
                showApprovalForm(request, response);
                break;
            case "execute":
                showExecutionForm(request, response);
                break;
            default:
                listRequests(request, response);
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
            case "create":
                createRequest(request, response);
                break;
            case "approve":
                approveRequest(request, response);
                break;
            case "reject":
                rejectRequest(request, response);
                break;
            case "start":
                startExecution(request, response);
                break;
            case "updateItem":
                updateItemReceived(request, response);
                break;
            case "complete":
                completeExecution(request, response);
                break;
            default:
                listRequests(request, response);
                break;
        }
    }
    
    /**
     * Check if user can create/approve inbound requests (Admin/Manager)
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
     * Check if user can execute requests (Admin/Manager/Staff)
     */
    private boolean hasExecuteAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;
        
        String role = user.getRole();
        return "Admin".equals(role) || "Manager".equals(role) || "Staff".equals(role);
    }
    
    /**
     * Get current user ID
     */
    private Long getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        
        User user = (User) session.getAttribute("user");
        return user != null ? user.getId() : null;
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
     * UC-INB-004: List all inbound requests
     */
    private void listRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String status = request.getParameter("status");
        String warehouseIdStr = request.getParameter("warehouseId");
        
        Long warehouseId = null;
        if (isWarehouseScoped(request)) {
            // Staff/Manager can only see requests for their assigned warehouse
            warehouseId = getAssignedWarehouseId(request);
        } else if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore invalid input
            }
        }
        
        String selectedStatus = status != null ? status.trim() : null;
        if (selectedStatus != null && selectedStatus.isEmpty()) {
            selectedStatus = null;
        }

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        PageResult<Request> requestPage = inboundService.searchInboundRequestsPaginated(selectedStatus, warehouseId, pageRequest);
        
        // Get warehouses for filter
        List<Warehouse> warehouses = inboundService.getAllWarehouses();

        // Build lookup maps for display using pre-loaded collections (no N+1 DB calls)
        java.util.Map<Long, String> warehouseMap = new java.util.HashMap<>();
        for (Warehouse wh : warehouses) {
            warehouseMap.put(wh.getId(), wh.getName());
        }
        java.util.Map<Long, String> userMap = new java.util.HashMap<>();
        for (User u : inboundService.getAllUsers()) {
            userMap.put(u.getId(), u.getName());
        }

        request.setAttribute("warehouseMap", warehouseMap);
        request.setAttribute("userMap", userMap);
        
        Map<String, String> paginationParams = new LinkedHashMap<>();
        paginationParams.put("status", selectedStatus);
        if (!isWarehouseScoped(request)) {
            paginationParams.put("warehouseId", warehouseId != null ? String.valueOf(warehouseId) : null);
        }
        paginationParams.put("size", String.valueOf(pageRequest.getSize()));

        request.setAttribute("requests", requestPage.getItems());
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("selectedStatus", selectedStatus);
        request.setAttribute("selectedWarehouseId", warehouseId);
        request.setAttribute("isManager", isWarehouseScoped(request));
        request.setAttribute("currentPage", requestPage.getCurrentPage());
        request.setAttribute("totalPages", requestPage.getTotalPages());
        request.setAttribute("pageSize", requestPage.getPageSize());
        request.setAttribute("totalItems", requestPage.getTotalItems());
        request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/inbound", paginationParams));
        
        request.getRequestDispatcher("/WEB-INF/views/inbound/list.jsp").forward(request, response);
    }
    
    /**
     * UC-INB-001: Show create inbound request form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to create inbound requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        List<Warehouse> warehouses = inboundService.getAllWarehouses();
        List<Product> products = inboundService.getActiveProducts();
        List<Provider> providers = providerService.getActiveProviders();
        
        if (warehouses.isEmpty()) {
            request.getSession().setAttribute("warningMessage", "Please create a warehouse first.");
            response.sendRedirect(request.getContextPath() + "/warehouse?action=add");
            return;
        }
        
        if (products.isEmpty()) {
            request.getSession().setAttribute("warningMessage", "Please create products first.");
            response.sendRedirect(request.getContextPath() + "/product?action=add");
            return;
        }
        
        // Staff/Manager: pre-select and lock to their assigned warehouse
        if (isWarehouseScoped(request)) {
            Long assignedWarehouseId = getAssignedWarehouseId(request);
            if (assignedWarehouseId == null) {
                request.getSession().setAttribute("errorMessage", "You are not assigned to any warehouse.");
                response.sendRedirect(request.getContextPath() + "/inbound");
                return;
            }
            request.setAttribute("lockedWarehouseId", assignedWarehouseId);
        }
        request.setAttribute("isManager", isWarehouseScoped(request));
        
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("products", products);
        request.setAttribute("providers", providers);
        
        request.getRequestDispatcher("/WEB-INF/views/inbound/create.jsp").forward(request, response);
    }
    
    /**
     * UC-INB-001: Process create inbound request
     */
    private void createRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to create inbound requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        try {
            // Get request data
            String warehouseIdStr = request.getParameter("warehouseId");
            String providerIdStr = request.getParameter("providerId");
            String expectedDateStr = request.getParameter("expectedDate");
            String notes = request.getParameter("notes");
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            String[] locationIds = request.getParameterValues("locationId");
            
            // Validate warehouse
            if (warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Please select a destination warehouse.");
                response.sendRedirect(request.getContextPath() + "/inbound?action=create");
                return;
            }
            
            Long warehouseId = Long.parseLong(warehouseIdStr.trim());
            
            // Staff/Manager can only create for their assigned warehouse
            if (isWarehouseScoped(request)) {
                Long assignedWarehouseId = getAssignedWarehouseId(request);
                if (assignedWarehouseId == null || !assignedWarehouseId.equals(warehouseId)) {
                    request.getSession().setAttribute("errorMessage", "You can only create inbound requests for your assigned warehouse.");
                    response.sendRedirect(request.getContextPath() + "/inbound?action=create");
                    return;
                }
            }
            
            // Validate items
            if (productIds == null || productIds.length == 0) {
                request.getSession().setAttribute("errorMessage", "At least one item is required.");
                response.sendRedirect(request.getContextPath() + "/inbound?action=create");
                return;
            }
            
            // Build request object
            Request inboundRequest = new Request("Inbound", userId);
            inboundRequest.setDestinationWarehouseId(warehouseId);
            inboundRequest.setNotes(notes);
            
            if (providerIdStr != null && !providerIdStr.trim().isEmpty()) {
                inboundRequest.setProviderId(Long.parseLong(providerIdStr.trim()));
            }
            
            if (expectedDateStr != null && !expectedDateStr.trim().isEmpty()) {
                inboundRequest.setExpectedDate(LocalDateTime.parse(expectedDateStr + "T00:00:00"));
            }
            
            // Build items list
            List<RequestItem> items = new ArrayList<>();
            for (int i = 0; i < productIds.length; i++) {
                if (productIds[i] == null || productIds[i].trim().isEmpty()) {
                    continue;
                }
                
                RequestItem item = new RequestItem();
                item.setProductId(Long.parseLong(productIds[i].trim()));
                
                int qty = 1;
                if (quantities != null && i < quantities.length && quantities[i] != null) {
                    qty = Integer.parseInt(quantities[i].trim());
                }
                if (qty <= 0) {
                    request.getSession().setAttribute("errorMessage", "Quantity must be greater than 0.");
                    response.sendRedirect(request.getContextPath() + "/inbound?action=create");
                    return;
                }
                item.setQuantity(qty);
                
                if (locationIds != null && i < locationIds.length && locationIds[i] != null && !locationIds[i].trim().isEmpty()) {
                    item.setLocationId(Long.parseLong(locationIds[i].trim()));
                }
                
                items.add(item);
            }
            
            if (items.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "At least one item is required.");
                response.sendRedirect(request.getContextPath() + "/inbound?action=create");
                return;
            }
            
            // Create the request
            Request created = inboundService.createInboundRequest(inboundRequest, items);
            
            if (created != null) {
                request.getSession().setAttribute("successMessage", "Inbound Request #" + created.getId() + " created successfully.");
                response.sendRedirect(request.getContextPath() + "/inbound?action=details&id=" + created.getId());
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to create inbound request. Please check your input.");
                response.sendRedirect(request.getContextPath() + "/inbound?action=create");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid input. Please check your entries.");
            response.sendRedirect(request.getContextPath() + "/inbound?action=create");
        }
    }
    
    /**
     * Show request details
     */
    private void showDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            Request inboundRequest = inboundService.getRequestById(requestId);
            
            if (inboundRequest == null) {
                request.getSession().setAttribute("errorMessage", "Request not found.");
                response.sendRedirect(request.getContextPath() + "/inbound");
                return;
            }
            
            // Staff/Manager can only view requests for their assigned warehouse
            if (isWarehouseScoped(request)) {
                Long assignedWarehouseId = getAssignedWarehouseId(request);
                if (assignedWarehouseId == null || !assignedWarehouseId.equals(inboundRequest.getDestinationWarehouseId())) {
                    request.getSession().setAttribute("errorMessage", "You don't have permission to view this request.");
                    response.sendRedirect(request.getContextPath() + "/inbound");
                    return;
                }
            }
            
            // Get items
            List<RequestItem> items = inboundService.getRequestItems(requestId);
            
            // Get lookup data
            if (inboundRequest.getDestinationWarehouseId() != null) {
                Warehouse wh = inboundService.getWarehouseById(inboundRequest.getDestinationWarehouseId());
                request.setAttribute("warehouse", wh);
            }
            
            if (inboundRequest.getProviderId() != null) {
                Provider provider = providerService.getProviderById(inboundRequest.getProviderId());
                request.setAttribute("provider", provider);
            }
            
            if (inboundRequest.getCreatedBy() != null) {
                User creator = inboundService.getUserById(inboundRequest.getCreatedBy());
                request.setAttribute("createdByUser", creator);
            }
            
            if (inboundRequest.getApprovedBy() != null) {
                User approver = inboundService.getUserById(inboundRequest.getApprovedBy());
                request.setAttribute("approvedByUser", approver);
            }
            
            if (inboundRequest.getRejectedBy() != null) {
                User rejector = inboundService.getUserById(inboundRequest.getRejectedBy());
                request.setAttribute("rejectedByUser", rejector);
            }
            
            if (inboundRequest.getCompletedBy() != null) {
                User completer = inboundService.getUserById(inboundRequest.getCompletedBy());
                request.setAttribute("completedByUser", completer);
            }
            
            // Get product names for items
            for (RequestItem item : items) {
                Product product = inboundService.getProductById(item.getProductId());
                if (product != null) {
                    request.setAttribute("productName_" + item.getProductId(), product.getName());
                    request.setAttribute("productSku_" + item.getProductId(), product.getSku());
                    request.setAttribute("productUnit_" + item.getProductId(), product.getUnit());
                }
                if (item.getLocationId() != null) {
                    Location location = inboundService.getLocationById(item.getLocationId());
                    if (location != null) {
                        request.setAttribute("locationCode_" + item.getLocationId(), location.getCode());
                    }
                }
            }
            
            request.setAttribute("inboundRequest", inboundRequest);
            request.setAttribute("items", items);
            
            request.getRequestDispatcher("/WEB-INF/views/inbound/details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/inbound");
        }
    }
    
    /**
     * UC-INB-002: Show approval form
     */
    private void showApprovalForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to approve requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        showDetails(request, response);
    }
    
    /**
     * UC-INB-002: Process approval
     */
    private void approveRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to approve requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            
            // Staff/Manager can only approve requests for their assigned warehouse
            if (isWarehouseScoped(request)) {
                Request inboundRequest = inboundService.getRequestById(requestId);
                Long assignedWarehouseId = getAssignedWarehouseId(request);
                if (inboundRequest == null || assignedWarehouseId == null
                        || !assignedWarehouseId.equals(inboundRequest.getDestinationWarehouseId())) {
                    request.getSession().setAttribute("errorMessage", "You don't have permission to approve this request.");
                    response.sendRedirect(request.getContextPath() + "/inbound");
                    return;
                }
            }
            
            Long userId = getCurrentUserId(request);
            
            boolean approved = inboundService.approveRequest(requestId, userId);
            
            if (approved) {
                request.getSession().setAttribute("successMessage", "Request #" + requestId + " has been approved.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to approve request. It may have already been processed.");
            }
            
            response.sendRedirect(request.getContextPath() + "/inbound?action=details&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/inbound");
        }
    }
    
    /**
     * UC-INB-002: Process rejection
     */
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to reject requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        String reason = request.getParameter("reason");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        if (reason == null || reason.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Rejection reason is required.");
            response.sendRedirect(request.getContextPath() + "/inbound?action=details&id=" + idStr);
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            
            // Staff/Manager can only reject requests for their assigned warehouse
            if (isWarehouseScoped(request)) {
                Request inboundRequest = inboundService.getRequestById(requestId);
                Long assignedWarehouseId = getAssignedWarehouseId(request);
                if (inboundRequest == null || assignedWarehouseId == null
                        || !assignedWarehouseId.equals(inboundRequest.getDestinationWarehouseId())) {
                    request.getSession().setAttribute("errorMessage", "You don't have permission to reject this request.");
                    response.sendRedirect(request.getContextPath() + "/inbound");
                    return;
                }
            }
            
            Long userId = getCurrentUserId(request);
            
            boolean rejected = inboundService.rejectRequest(requestId, userId, reason.trim());
            
            if (rejected) {
                request.getSession().setAttribute("successMessage", "Request #" + requestId + " has been rejected.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to reject request. It may have already been processed.");
            }
            
            response.sendRedirect(request.getContextPath() + "/inbound?action=details&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/inbound");
        }
    }
    
    /**
     * UC-INB-003: Show execution form
     */
    private void showExecutionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasExecuteAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            Request inboundRequest = inboundService.getRequestById(requestId);
            
            if (inboundRequest == null) {
                request.getSession().setAttribute("errorMessage", "Request not found.");
                response.sendRedirect(request.getContextPath() + "/inbound");
                return;
            }
            
            // Can only execute Approved or InProgress requests
            if (!"Approved".equals(inboundRequest.getStatus()) && !"InProgress".equals(inboundRequest.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Only approved requests can be executed.");
                response.sendRedirect(request.getContextPath() + "/inbound?action=details&id=" + requestId);
                return;
            }
            
            // Staff/Manager can only execute requests for their assigned warehouse
            if (isWarehouseScoped(request)) {
                Long assignedWarehouseId = getAssignedWarehouseId(request);
                if (assignedWarehouseId == null || !assignedWarehouseId.equals(inboundRequest.getDestinationWarehouseId())) {
                    request.getSession().setAttribute("errorMessage", "You don't have permission to execute this request.");
                    response.sendRedirect(request.getContextPath() + "/inbound");
                    return;
                }
            }
            
            // Get items
            List<RequestItem> items = inboundService.getRequestItems(requestId);
            
            // Get warehouse and locations
            if (inboundRequest.getDestinationWarehouseId() != null) {
                Warehouse wh = inboundService.getWarehouseById(inboundRequest.getDestinationWarehouseId());
                request.setAttribute("warehouse", wh);
                
                List<Location> locations = inboundService.getWarehouseLocations(inboundRequest.getDestinationWarehouseId());
                request.setAttribute("locations", locations);
            }
            
            // Get product info for items
            for (RequestItem item : items) {
                Product product = inboundService.getProductById(item.getProductId());
                if (product != null) {
                    request.setAttribute("productName_" + item.getProductId(), product.getName());
                    request.setAttribute("productSku_" + item.getProductId(), product.getSku());
                    request.setAttribute("productUnit_" + item.getProductId(), product.getUnit());
                    request.setAttribute("productCategory_" + item.getProductId(), product.getCategoryId());
                }
                if (item.getLocationId() != null) {
                    Location location = inboundService.getLocationById(item.getLocationId());
                    if (location != null) {
                        request.setAttribute("locationCode_" + item.getLocationId(), location.getCode());
                    }
                }
            }
            
            request.setAttribute("inboundRequest", inboundRequest);
            request.setAttribute("items", items);
            
            request.getRequestDispatcher("/WEB-INF/views/inbound/execute.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/inbound");
        }
    }
    
    /**
     * UC-INB-003: Start execution
     */
    private void startExecution(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasExecuteAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            
            boolean started = inboundService.startExecution(requestId);
            
            if (started) {
                request.getSession().setAttribute("successMessage", "Execution started for Request #" + requestId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to start execution. Request may not be in Approved status.");
            }
            
            response.sendRedirect(request.getContextPath() + "/inbound?action=execute&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/inbound");
        }
    }
    
    /**
     * UC-INB-003: Update received quantity for an item
     */
    private void updateItemReceived(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasExecuteAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        String requestIdStr = request.getParameter("id");
        String productIdStr = request.getParameter("productId");
        String receivedQtyStr = request.getParameter("receivedQuantity");
        String locationIdStr = request.getParameter("locationId");
        
        if (requestIdStr == null || productIdStr == null || receivedQtyStr == null) {
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(requestIdStr.trim());
            Long productId = Long.parseLong(productIdStr.trim());
            Integer receivedQty = Integer.parseInt(receivedQtyStr.trim());
            Long locationId = null;
            if (locationIdStr != null && !locationIdStr.trim().isEmpty()) {
                locationId = Long.parseLong(locationIdStr.trim());
            }
            
            boolean updated = inboundService.updateReceivedQuantity(requestId, productId, receivedQty, locationId);
            
            if (updated) {
                request.getSession().setAttribute("successMessage", "Item updated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update item.");
            }
            
            response.sendRedirect(request.getContextPath() + "/inbound?action=execute&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid input.");
            response.sendRedirect(request.getContextPath() + "/inbound");
        }
    }
    
    /**
     * UC-INB-003: Complete execution
     */
    private void completeExecution(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasExecuteAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute requests.");
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            Long userId = getCurrentUserId(request);

            boolean syncUpdated = syncReceivedItemsForCompletion(request, requestId);
            if (!syncUpdated) {
                request.getSession().setAttribute("errorMessage", "Failed to save received quantities. Please review item data and try again.");
                response.sendRedirect(request.getContextPath() + "/inbound?action=execute&id=" + requestId);
                return;
            }
            
            boolean completed = inboundService.completeExecution(requestId, userId);
            
            if (completed) {
                request.getSession().setAttribute("successMessage", "Inbound Request #" + requestId + " completed successfully. Inventory has been updated.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to complete execution. Please ensure all items have received quantities.");
            }
            
            response.sendRedirect(request.getContextPath() + "/inbound?action=details&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/inbound");
        }
    }

    /**
     * Save received quantities sent from complete form before finishing execution.
     */
    private boolean syncReceivedItemsForCompletion(HttpServletRequest request, Long requestId) {
        String[] productIds = request.getParameterValues("productId");
        String[] receivedQuantities = request.getParameterValues("receivedQuantity");
        String[] locationIds = request.getParameterValues("locationId");

        if (productIds == null || receivedQuantities == null || locationIds == null) {
            return false; // All three arrays are required for a consistent save
        }

        if (productIds.length != receivedQuantities.length || productIds.length != locationIds.length) {
            return false;
        }

        for (int i = 0; i < productIds.length; i++) {
            String productIdStr = productIds[i];
            String receivedQtyStr = receivedQuantities[i];
            String locationIdStr = locationIds[i];

            if (productIdStr == null || productIdStr.trim().isEmpty() ||
                receivedQtyStr == null || receivedQtyStr.trim().isEmpty() ||
                locationIdStr == null || locationIdStr.trim().isEmpty()) {
                return false;
            }

            try {
                Long productId = Long.parseLong(productIdStr.trim());
                Integer receivedQuantity = Integer.parseInt(receivedQtyStr.trim());
                Long locationId = Long.parseLong(locationIdStr.trim());

                boolean updated = inboundService.updateReceivedQuantity(requestId, productId, receivedQuantity, locationId);
                if (!updated) {
                    return false;
                }
            } catch (NumberFormatException e) {
                return false;
            }
        }

        return true;
    }
}
