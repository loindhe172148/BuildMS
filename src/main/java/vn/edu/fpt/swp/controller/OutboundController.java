package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.*;
import vn.edu.fpt.swp.service.OutboundService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller for Outbound Request Management
 * 
 * UC-OUT-001: Approve Outbound Request
 * UC-OUT-002: Execute Outbound Request
 * UC-OUT-003: Create Internal Outbound Request
 */
@WebServlet("/outbound")
public class OutboundController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private OutboundService outboundService;
    
    @Override
    public void init() throws ServletException {
        outboundService = new OutboundService();
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
                updateItemPicked(request, response);
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
     * Check if user can create/approve outbound requests (Admin/Manager)
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
     * List all outbound requests
     */
    private void listRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String status = request.getParameter("status");
        String warehouseIdStr = request.getParameter("warehouseId");
        
        Long warehouseId = null;
        if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                warehouseId = Long.parseLong(warehouseIdStr.trim());
            } catch (NumberFormatException e) {
                // Ignore invalid input
            }
        }
        
        List<Request> requests;
        if ((status != null && !status.trim().isEmpty()) || warehouseId != null) {
            requests = outboundService.searchOutboundRequests(status, warehouseId);
        } else {
            requests = outboundService.getAllOutboundRequests();
        }
        
        // Get warehouses for filter
        List<Warehouse> warehouses = outboundService.getAllWarehouses();
        
        // Build lookup maps for display
        for (Request req : requests) {
            if (req.getCreatedBy() != null) {
                User creator = outboundService.getUserById(req.getCreatedBy());
                if (creator != null) {
                    request.setAttribute("userName_" + req.getCreatedBy(), creator.getName());
                }
            }
            if (req.getSourceWarehouseId() != null) {
                Warehouse wh = outboundService.getWarehouseById(req.getSourceWarehouseId());
                if (wh != null) {
                    request.setAttribute("warehouseName_" + req.getSourceWarehouseId(), wh.getName());
                }
            }
        }
        
        request.setAttribute("requests", requests);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedWarehouseId", warehouseId);
        
        request.getRequestDispatcher("/WEB-INF/views/outbound/list.jsp").forward(request, response);
    }
    
    /**
     * UC-OUT-003: Show create internal outbound request form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to create outbound requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        List<Warehouse> warehouses = outboundService.getAllWarehouses();
        List<Product> products = outboundService.getActiveProducts();
        List<String> reasons = outboundService.getValidReasons();
        
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
        
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("products", products);
        request.setAttribute("reasons", reasons);
        
        request.getRequestDispatcher("/WEB-INF/views/outbound/create.jsp").forward(request, response);
    }
    
    /**
     * UC-OUT-003: Process create internal outbound request
     */
    private void createRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to create outbound requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
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
            String reason = request.getParameter("reason");
            String notes = request.getParameter("notes");
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            
            // Validate warehouse
            if (warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Please select a source warehouse.");
                response.sendRedirect(request.getContextPath() + "/outbound?action=create");
                return;
            }
            
            Long warehouseId = Long.parseLong(warehouseIdStr.trim());
            
            // Validate reason
            if (reason == null || reason.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Please select an outbound reason.");
                response.sendRedirect(request.getContextPath() + "/outbound?action=create");
                return;
            }
            
            // Validate items
            if (productIds == null || productIds.length == 0) {
                request.getSession().setAttribute("errorMessage", "At least one item is required.");
                response.sendRedirect(request.getContextPath() + "/outbound?action=create");
                return;
            }
            
            // Build request object
            Request outboundRequest = new Request("Outbound", userId);
            outboundRequest.setSourceWarehouseId(warehouseId);
            outboundRequest.setReason(reason);
            outboundRequest.setNotes(notes);
            
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
                    response.sendRedirect(request.getContextPath() + "/outbound?action=create");
                    return;
                }
                item.setQuantity(qty);
                
                items.add(item);
            }
            
            if (items.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "At least one item is required.");
                response.sendRedirect(request.getContextPath() + "/outbound?action=create");
                return;
            }
            
            // Create the request
            Request created = outboundService.createInternalOutboundRequest(outboundRequest, items);
            
            if (created != null) {
                request.getSession().setAttribute("successMessage", "Internal Outbound Request #" + created.getId() + " created successfully.");
                response.sendRedirect(request.getContextPath() + "/outbound?action=details&id=" + created.getId());
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to create outbound request. Please check your input.");
                response.sendRedirect(request.getContextPath() + "/outbound?action=create");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid input. Please check your entries.");
            response.sendRedirect(request.getContextPath() + "/outbound?action=create");
        }
    }
    
    /**
     * Show request details
     */
    private void showDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            Request outboundRequest = outboundService.getRequestById(requestId);
            
            if (outboundRequest == null) {
                request.getSession().setAttribute("errorMessage", "Request not found.");
                response.sendRedirect(request.getContextPath() + "/outbound");
                return;
            }
            
            // Get items
            List<RequestItem> items = outboundService.getRequestItems(requestId);
            
            // Get lookup data
            if (outboundRequest.getSourceWarehouseId() != null) {
                Warehouse wh = outboundService.getWarehouseById(outboundRequest.getSourceWarehouseId());
                request.setAttribute("warehouse", wh);
            }
            
            if (outboundRequest.getCreatedBy() != null) {
                User creator = outboundService.getUserById(outboundRequest.getCreatedBy());
                request.setAttribute("createdByUser", creator);
            }
            
            if (outboundRequest.getApprovedBy() != null) {
                User approver = outboundService.getUserById(outboundRequest.getApprovedBy());
                request.setAttribute("approvedByUser", approver);
            }
            
            if (outboundRequest.getRejectedBy() != null) {
                User rejector = outboundService.getUserById(outboundRequest.getRejectedBy());
                request.setAttribute("rejectedByUser", rejector);
            }
            
            if (outboundRequest.getCompletedBy() != null) {
                User completer = outboundService.getUserById(outboundRequest.getCompletedBy());
                request.setAttribute("completedByUser", completer);
            }
            
            // Get product names and inventory for items
            Long warehouseId = outboundRequest.getSourceWarehouseId();
            for (RequestItem item : items) {
                Product product = outboundService.getProductById(item.getProductId());
                if (product != null) {
                    request.setAttribute("productName_" + item.getProductId(), product.getName());
                    request.setAttribute("productSku_" + item.getProductId(), product.getSku());
                }
                if (warehouseId != null) {
                    int available = outboundService.getInventoryQuantity(item.getProductId(), warehouseId);
                    request.setAttribute("available_" + item.getProductId(), available);
                }
            }
            
            request.setAttribute("outboundRequest", outboundRequest);
            request.setAttribute("items", items);
            
            request.getRequestDispatcher("/WEB-INF/views/outbound/details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/outbound");
        }
    }
    
    /**
     * UC-OUT-001: Show approval form
     */
    private void showApprovalForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to approve requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        showDetails(request, response);
    }
    
    /**
     * UC-OUT-001: Process approval
     */
    private void approveRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to approve requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            Long userId = getCurrentUserId(request);
            
            boolean approved = outboundService.approveRequest(requestId, userId);
            
            if (approved) {
                request.getSession().setAttribute("successMessage", "Request #" + requestId + " has been approved.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to approve request. It may have already been processed.");
            }
            
            response.sendRedirect(request.getContextPath() + "/outbound?action=details&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/outbound");
        }
    }
    
    /**
     * UC-OUT-001: Process rejection
     */
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasManageAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to reject requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        String reason = request.getParameter("reason");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        if (reason == null || reason.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Rejection reason is required.");
            response.sendRedirect(request.getContextPath() + "/outbound?action=details&id=" + idStr);
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            Long userId = getCurrentUserId(request);
            
            boolean rejected = outboundService.rejectRequest(requestId, userId, reason.trim());
            
            if (rejected) {
                request.getSession().setAttribute("successMessage", "Request #" + requestId + " has been rejected.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to reject request. It may have already been processed.");
            }
            
            response.sendRedirect(request.getContextPath() + "/outbound?action=details&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/outbound");
        }
    }
    
    /**
     * UC-OUT-002: Show execution form
     */
    private void showExecutionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasExecuteAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            Request outboundRequest = outboundService.getRequestById(requestId);
            
            if (outboundRequest == null) {
                request.getSession().setAttribute("errorMessage", "Request not found.");
                response.sendRedirect(request.getContextPath() + "/outbound");
                return;
            }
            
            // Can only execute Approved or InProgress requests
            if (!"Approved".equals(outboundRequest.getStatus()) && !"InProgress".equals(outboundRequest.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Only approved requests can be executed.");
                response.sendRedirect(request.getContextPath() + "/outbound?action=details&id=" + requestId);
                return;
            }
            
            // Get items
            List<RequestItem> items = outboundService.getRequestItems(requestId);
            
            // Get warehouse info
            Long warehouseId = outboundRequest.getSourceWarehouseId();
            if (warehouseId != null) {
                Warehouse wh = outboundService.getWarehouseById(warehouseId);
                request.setAttribute("warehouse", wh);
            }
            
            // Get product info and inventory for items
            for (RequestItem item : items) {
                Product product = outboundService.getProductById(item.getProductId());
                if (product != null) {
                    request.setAttribute("productName_" + item.getProductId(), product.getName());
                    request.setAttribute("productSku_" + item.getProductId(), product.getSku());
                }
                if (warehouseId != null) {
                    int available = outboundService.getInventoryQuantity(item.getProductId(), warehouseId);
                    request.setAttribute("available_" + item.getProductId(), available);
                }
            }
            
            request.setAttribute("outboundRequest", outboundRequest);
            request.setAttribute("items", items);
            
            request.getRequestDispatcher("/WEB-INF/views/outbound/execute.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/outbound");
        }
    }
    
    /**
     * UC-OUT-002: Start execution
     */
    private void startExecution(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasExecuteAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            
            boolean started = outboundService.startExecution(requestId);
            
            if (started) {
                request.getSession().setAttribute("successMessage", "Picking started for Request #" + requestId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to start execution. Request may not be in Approved status.");
            }
            
            response.sendRedirect(request.getContextPath() + "/outbound?action=execute&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/outbound");
        }
    }
    
    /**
     * UC-OUT-002: Update picked quantity for an item
     */
    private void updateItemPicked(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasExecuteAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        String requestIdStr = request.getParameter("id");
        String productIdStr = request.getParameter("productId");
        String pickedQtyStr = request.getParameter("pickedQuantity");
        
        if (requestIdStr == null || productIdStr == null || pickedQtyStr == null) {
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(requestIdStr.trim());
            Long productId = Long.parseLong(productIdStr.trim());
            Integer pickedQty = Integer.parseInt(pickedQtyStr.trim());
            
            boolean updated = outboundService.updatePickedQuantity(requestId, productId, pickedQty);
            
            if (updated) {
                request.getSession().setAttribute("successMessage", "Item updated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update item. Check if picked quantity exceeds available inventory.");
            }
            
            response.sendRedirect(request.getContextPath() + "/outbound?action=execute&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid input.");
            response.sendRedirect(request.getContextPath() + "/outbound");
        }
    }
    
    /**
     * UC-OUT-002: Complete execution
     */
    private void completeExecution(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!hasExecuteAccess(request)) {
            request.getSession().setAttribute("errorMessage", "You don't have permission to execute requests.");
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/outbound");
            return;
        }
        
        try {
            Long requestId = Long.parseLong(idStr.trim());
            Long userId = getCurrentUserId(request);
            
            boolean completed = outboundService.completeExecution(requestId, userId);
            
            if (completed) {
                request.getSession().setAttribute("successMessage", "Outbound Request #" + requestId + " completed successfully. Inventory has been updated.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to complete execution. Please ensure all items have picked quantities.");
            }
            
            response.sendRedirect(request.getContextPath() + "/outbound?action=details&id=" + requestId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/outbound");
        }
    }
}
