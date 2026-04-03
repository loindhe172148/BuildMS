package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.*;
import vn.edu.fpt.swp.service.MovementService;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;
import vn.edu.fpt.swp.util.PaginationUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

/**
 * Controller for Internal Movement Management
 * 
 * UC-MOV-001: Create Internal Movement Request
 * UC-MOV-002: Execute Internal Movement
 * UC-MOV-003: Approve Internal Movement Request
 */
@WebServlet("/movement")
public class MovementController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private MovementService movementService;
    
    @Override
    public void init() throws ServletException {
        movementService = new MovementService();
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
            case "complete":
                completeExecution(request, response);
                break;
            default:
                listRequests(request, response);
                break;
        }
    }
    
    /**
     * Check if user has access to internal movement (Admin, Manager, Staff)
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
     * Check if user can approve/reject movement requests (Admin or Manager only)
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
     * Get current user
     */
    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }
    
    /**
     * Get current user ID
     */
    private Long getCurrentUserId(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null ? user.getId() : null;
    }
    
    /**
     * Check if user is warehouse-scoped (Staff or Manager with an assigned warehouse)
     */
    private boolean isWarehouseScoped(HttpServletRequest request) {
        User user = getCurrentUser(request);
        if (user == null) return false;
        String role = user.getRole();
        return ("Staff".equals(role) || "Manager".equals(role)) && user.getWarehouseId() != null;
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
     * List all internal movement requests
     */
    private void listRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to view movements.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        String status = request.getParameter("status");
        String warehouseIdStr = request.getParameter("warehouseId");
        
        Long warehouseId = null;
        if (isWarehouseScoped(request)) {
            warehouseId = getAssignedWarehouseId(request);
        } else if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        String selectedStatus = status != null ? status.trim() : null;
        if (selectedStatus != null && selectedStatus.isEmpty()) {
            selectedStatus = null;
        }

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        PageResult<Request> requestPage = movementService.searchMovementRequestsPaginated(selectedStatus, warehouseId, pageRequest);
        
        // Get warehouses for filter
        List<Warehouse> warehouses = movementService.getAllWarehouses();

        // Build lookup maps for display using pre-loaded collections (no N+1 DB calls)
        java.util.Map<Long, String> warehouseMap = new java.util.HashMap<>();
        for (Warehouse wh : warehouses) {
            warehouseMap.put(wh.getId(), wh.getName());
        }
        java.util.Map<Long, String> userMap = new java.util.HashMap<>();
        for (User u : movementService.getAllUsers()) {
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
        request.setAttribute("isWarehouseScoped", isWarehouseScoped(request));
        request.setAttribute("currentPage", requestPage.getCurrentPage());
        request.setAttribute("totalPages", requestPage.getTotalPages());
        request.setAttribute("pageSize", requestPage.getPageSize());
        request.setAttribute("totalItems", requestPage.getTotalItems());
        request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/movement", paginationParams));
        
        request.getRequestDispatcher("/WEB-INF/views/movement/list.jsp").forward(request, response);
    }
    
    /**
     * UC-MOV-001: Show create movement form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to create movements.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // Get warehouse ID
        Long warehouseId = null;
        String warehouseIdStr = request.getParameter("warehouseId");
        
        if (isWarehouseScoped(request)) {
            warehouseId = getAssignedWarehouseId(request);
            if (warehouseId == null) {
                request.getSession().setAttribute("errorMessage", "You are not assigned to any warehouse.");
                response.sendRedirect(request.getContextPath() + "/movement");
                return;
            }
        } else if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        // Get warehouses for dropdown
        List<Warehouse> warehouses = movementService.getAllWarehouses();
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("isWarehouseScoped", isWarehouseScoped(request));
        
        if (warehouseId != null) {
            Warehouse selectedWarehouse = movementService.getWarehouseById(warehouseId);
            request.setAttribute("selectedWarehouse", selectedWarehouse);
            request.setAttribute("selectedWarehouseId", warehouseId);
            
            // Get locations in this warehouse
            List<Location> locations = movementService.getActiveLocationsByWarehouse(warehouseId);
            request.setAttribute("locations", locations);
            
            // Get products with inventory in this warehouse
            List<Map<String, Object>> productsWithInventory = 
                    movementService.getProductsWithInventoryAtWarehouse(warehouseId);
            request.setAttribute("productsWithInventory", productsWithInventory);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/movement/create.jsp").forward(request, response);
    }
    
    /**
     * UC-MOV-001: Create movement request
     */
    private void createRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to create movements.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        // Parse warehouse ID
        Long warehouseId = null;
        String warehouseIdStr = request.getParameter("warehouseId");
        if (isWarehouseScoped(request)) {
            warehouseId = getAssignedWarehouseId(request);
        } else if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdStr.trim());
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid warehouse selected.");
                response.sendRedirect(request.getContextPath() + "/movement?action=create");
                return;
            }
        }
        
        if (warehouseId == null) {
            request.getSession().setAttribute("errorMessage", "Please select a warehouse.");
            response.sendRedirect(request.getContextPath() + "/movement?action=create");
            return;
        }
        
        // Parse items
        String[] productIds = request.getParameterValues("productId");
        String[] sourceLocationIds = request.getParameterValues("sourceLocationId");
        String[] destinationLocationIds = request.getParameterValues("destinationLocationId");
        String[] quantities = request.getParameterValues("quantity");
        
        if (productIds == null || productIds.length == 0) {
            request.getSession().setAttribute("errorMessage", "At least one movement item is required.");
            response.sendRedirect(request.getContextPath() + "/movement?action=create&warehouseId=" + warehouseId);
            return;
        }
        
        List<RequestItem> items = new ArrayList<>();
        java.util.Set<Long> seenProductIds = new java.util.HashSet<>();
        
        for (int i = 0; i < productIds.length; i++) {
            try {
                Long productId = Long.parseLong(productIds[i]);
                Long sourceLocationId = Long.parseLong(sourceLocationIds[i]);
                Long destLocationId = Long.parseLong(destinationLocationIds[i]);
                Integer quantity = Integer.parseInt(quantities[i]);
                
                // Check for duplicate product (PK is RequestId + ProductId)
                if (!seenProductIds.add(productId)) {
                    request.getSession().setAttribute("errorMessage", 
                            "Duplicate product in item " + (i + 1) + ". Each product can only appear once per movement request.");
                    response.sendRedirect(request.getContextPath() + "/movement?action=create&warehouseId=" + warehouseId);
                    return;
                }
                
                // Validate item
                String validationError = movementService.validateMovementItem(
                        warehouseId, productId, sourceLocationId, destLocationId, quantity);
                
                if (validationError != null) {
                    request.getSession().setAttribute("errorMessage", "Item " + (i + 1) + ": " + validationError);
                    response.sendRedirect(request.getContextPath() + "/movement?action=create&warehouseId=" + warehouseId);
                    return;
                }
                
                RequestItem item = new RequestItem();
                item.setProductId(productId);
                item.setSourceLocationId(sourceLocationId);
                item.setDestinationLocationId(destLocationId);
                item.setQuantity(quantity);
                items.add(item);
                
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid data for item " + (i + 1));
                response.sendRedirect(request.getContextPath() + "/movement?action=create&warehouseId=" + warehouseId);
                return;
            }
        }
        
        // Create request object
        Request movementRequest = new Request();
        movementRequest.setCreatedBy(userId);
        movementRequest.setSourceWarehouseId(warehouseId);
        movementRequest.setNotes(request.getParameter("notes"));
        
        // Create the movement request
        Request createdRequest = movementService.createMovementRequest(movementRequest, items);
        
        if (createdRequest != null) {
            request.getSession().setAttribute("successMessage", 
                    "Internal Movement Request #" + createdRequest.getId() + " created successfully.");
            response.sendRedirect(request.getContextPath() + "/movement?action=details&id=" + createdRequest.getId());
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to create movement request. Please try again.");
            response.sendRedirect(request.getContextPath() + "/movement?action=create&warehouseId=" + warehouseId);
        }
    }
    
    /**
     * Show movement request details
     */
    private void showDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to view movements.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        Long requestId;
        try {
            requestId = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        Request movementRequest = movementService.getRequestById(requestId);
        if (movementRequest == null) {
            request.getSession().setAttribute("errorMessage", "Movement request not found.");
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        // Staff/Manager can only view movements for their assigned warehouse
        if (isWarehouseScoped(request)) {
            Long assignedWarehouseId = getAssignedWarehouseId(request);
            if (assignedWarehouseId == null || !assignedWarehouseId.equals(movementRequest.getSourceWarehouseId())) {
                request.getSession().setAttribute("errorMessage", "You don't have permission to view this movement.");
                response.sendRedirect(request.getContextPath() + "/movement");
                return;
            }
        }
        
        // Get request items with details
        List<Map<String, Object>> itemsWithDetails = movementService.getRequestItemsWithDetails(requestId);
        
        // Get warehouse info
        Warehouse warehouse = movementService.getWarehouseById(movementRequest.getSourceWarehouseId());
        
        // Get user info
        User createdBy = movementService.getUserById(movementRequest.getCreatedBy());
        User completedBy = movementRequest.getCompletedBy() != null ? 
                movementService.getUserById(movementRequest.getCompletedBy()) : null;
        User approvedByUser = movementRequest.getApprovedBy() != null ?
                movementService.getUserById(movementRequest.getApprovedBy()) : null;
        User rejectedByUser = movementRequest.getRejectedBy() != null ?
                movementService.getUserById(movementRequest.getRejectedBy()) : null;
        
        request.setAttribute("movementRequest", movementRequest);
        request.setAttribute("itemsWithDetails", itemsWithDetails);
        request.setAttribute("warehouse", warehouse);
        request.setAttribute("createdByUser", createdBy);
        request.setAttribute("completedByUser", completedBy);
        request.setAttribute("approvedByUser", approvedByUser);
        request.setAttribute("rejectedByUser", rejectedByUser);
        
        request.getRequestDispatcher("/WEB-INF/views/movement/details.jsp").forward(request, response);
    }
    
    /**
     * UC-MOV-003: Show approval form (same as details page with approve/reject buttons)
     */
    private void showApprovalForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to approve movement requests.");
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        showDetails(request, response);
    }
    
    /**
     * UC-MOV-003: Process approval
     */
    private void approveRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to approve movement requests.");
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        Long requestId;
        try {
            requestId = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        // Manager can only approve movements for their assigned warehouse
        if (isWarehouseScoped(request)) {
            Request movReq = movementService.getRequestById(requestId);
            Long assignedWarehouseId = getAssignedWarehouseId(request);
            if (movReq == null || assignedWarehouseId == null
                    || !assignedWarehouseId.equals(movReq.getSourceWarehouseId())) {
                request.getSession().setAttribute("errorMessage", "You don't have permission to approve this movement request.");
                response.sendRedirect(request.getContextPath() + "/movement");
                return;
            }
        }
        
        Long userId = getCurrentUserId(request);
        boolean approved = movementService.approveRequest(requestId, userId);
        
        if (approved) {
            request.getSession().setAttribute("successMessage", "Movement Request #" + requestId + " has been approved.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to approve request. It may have already been processed.");
        }
        
        response.sendRedirect(request.getContextPath() + "/movement?action=details&id=" + requestId);
    }
    
    /**
     * UC-MOV-003: Process rejection
     */
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to reject movement requests.");
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        String idStr = request.getParameter("id");
        String reason = request.getParameter("reason");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        if (reason == null || reason.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Rejection reason is required.");
            response.sendRedirect(request.getContextPath() + "/movement?action=details&id=" + idStr);
            return;
        }
        
        Long requestId;
        try {
            requestId = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        // Manager can only reject movements for their assigned warehouse
        if (isWarehouseScoped(request)) {
            Request movReq = movementService.getRequestById(requestId);
            Long assignedWarehouseId = getAssignedWarehouseId(request);
            if (movReq == null || assignedWarehouseId == null
                    || !assignedWarehouseId.equals(movReq.getSourceWarehouseId())) {
                request.getSession().setAttribute("errorMessage", "You don't have permission to reject this movement request.");
                response.sendRedirect(request.getContextPath() + "/movement");
                return;
            }
        }
        
        Long userId = getCurrentUserId(request);
        boolean rejected = movementService.rejectRequest(requestId, userId, reason.trim());
        
        if (rejected) {
            request.getSession().setAttribute("successMessage", "Movement Request #" + requestId + " has been rejected.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to reject request. It may have already been processed.");
        }
        
        response.sendRedirect(request.getContextPath() + "/movement?action=details&id=" + requestId);
    }
    
    /**
     * UC-MOV-002: Show execution form
     */
    private void showExecutionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute movements.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        Long requestId;
        try {
            requestId = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        Request movementRequest = movementService.getRequestById(requestId);
        if (movementRequest == null) {
            request.getSession().setAttribute("errorMessage", "Movement request not found.");
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        // Verify request is ready for execution (must be Approved first)
        String status = movementRequest.getStatus();
        if (!"Approved".equals(status) && !"InProgress".equals(status)) {
            request.getSession().setAttribute("errorMessage", 
                    "This request cannot be executed. Current status: " + status +
                    ". Only Approved requests can be executed.");
            response.sendRedirect(request.getContextPath() + "/movement?action=details&id=" + requestId);
            return;
        }
        
        // Staff/Manager can only execute movements for their assigned warehouse
        if (isWarehouseScoped(request)) {
            Long assignedWarehouseId = getAssignedWarehouseId(request);
            if (assignedWarehouseId == null || !assignedWarehouseId.equals(movementRequest.getSourceWarehouseId())) {
                request.getSession().setAttribute("errorMessage", "You don't have permission to execute this movement.");
                response.sendRedirect(request.getContextPath() + "/movement");
                return;
            }
        }
        
        // Get request items with details
        List<Map<String, Object>> itemsWithDetails = movementService.getRequestItemsWithDetails(requestId);
        
        // Get warehouse info
        Warehouse warehouse = movementService.getWarehouseById(movementRequest.getSourceWarehouseId());
        
        // Get user info
        User createdBy = movementService.getUserById(movementRequest.getCreatedBy());
        
        request.setAttribute("movementRequest", movementRequest);
        request.setAttribute("itemsWithDetails", itemsWithDetails);
        request.setAttribute("warehouse", warehouse);
        request.setAttribute("createdByUser", createdBy);
        
        request.getRequestDispatcher("/WEB-INF/views/movement/execute.jsp").forward(request, response);
    }
    
    /**
     * UC-MOV-002: Start execution
     */
    private void startExecution(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute movements.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        Long requestId;
        try {
            requestId = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        boolean success = movementService.startExecution(requestId);
        
        if (success) {
            request.getSession().setAttribute("successMessage", "Movement execution started.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to start movement execution.");
        }
        
        response.sendRedirect(request.getContextPath() + "/movement?action=execute&id=" + requestId);
    }
    
    /**
     * UC-MOV-002: Complete execution
     */
    private void completeExecution(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute movements.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        Long userId = getCurrentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        Long requestId;
        try {
            requestId = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movement");
            return;
        }
        
        boolean success = movementService.completeMovement(requestId, userId);
        
        if (success) {
            request.getSession().setAttribute("successMessage", 
                    "Internal Movement #" + requestId + " completed successfully.");
            response.sendRedirect(request.getContextPath() + "/movement?action=details&id=" + requestId);
        } else {
            request.getSession().setAttribute("errorMessage", 
                    "Failed to complete movement. Please verify inventory levels and try again.");
            response.sendRedirect(request.getContextPath() + "/movement?action=execute&id=" + requestId);
        }
    }
}
