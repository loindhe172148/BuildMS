package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.*;
import vn.edu.fpt.swp.service.TransferService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Controller for Inter-Warehouse Transfer Management
 * 
 * UC-TRF-001: Create Inter-Warehouse Transfer Request
 * UC-TRF-002: Approve/Reject Transfer Request (destination warehouse)
 * UC-TRF-003: Execute Transfer Outbound (source warehouse)
 * UC-TRF-004: Execute Transfer Inbound & Complete (destination warehouse)
 *
 * Cross-warehouse collaborative workflow:
 * Source WH creates → Dest WH approves → Source WH outbound → Dest WH inbound & completes
 */
@WebServlet("/transfer")
public class TransferController extends HttpServlet {
    
    private TransferService transferService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        transferService = new TransferService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listTransfers(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "view":
                viewTransfer(request, response);
                break;
            case "execute-outbound":
                showOutboundExecutionForm(request, response);
                break;
            case "execute-inbound":
                showInboundExecutionForm(request, response);
                break;
            default:
                listTransfers(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/transfer");
            return;
        }
        
        switch (action) {
            case "create":
                createTransfer(request, response);
                break;
            case "approve":
                approveTransfer(request, response);
                break;
            case "reject":
                rejectTransfer(request, response);
                break;
            case "start-outbound":
                startOutbound(request, response);
                break;
            case "complete-outbound":
                completeOutbound(request, response);
                break;
            case "start-inbound":
                startInbound(request, response);
                break;
            case "complete-inbound":
                completeInbound(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/transfer");
        }
    }
    
    /**
     * List all transfer requests with optional status filter
     */
    private void listTransfers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        List<Request> transfers;
        if (status != null && !status.isEmpty()) {
            transfers = transferService.getTransferRequestsByStatus(status);
        } else {
            transfers = transferService.getAllTransferRequests();
        }
        
        // Manager/Staff: filter to only show transfers related to their warehouse
        if (("Manager".equals(currentUser.getRole()) || "Staff".equals(currentUser.getRole()))
                && currentUser.getWarehouseId() != null) {
            Long userWarehouseId = currentUser.getWarehouseId();
            transfers = transfers.stream()
                .filter(t -> userWarehouseId.equals(t.getSourceWarehouseId()) 
                          || userWarehouseId.equals(t.getDestinationWarehouseId()))
                .collect(Collectors.toList());
        }
        
        // Build lookup maps once — avoids N+1 DB calls per transfer
        java.util.Map<Long, Warehouse> warehouseMap = new java.util.HashMap<>();
        for (Warehouse w : transferService.getAllWarehouses()) {
            warehouseMap.put(w.getId(), w);
        }
        java.util.Map<Long, User> userMap = new java.util.HashMap<>();
        for (User u : transferService.getAllUsers()) {
            userMap.put(u.getId(), u);
        }

        // Enrich with warehouse info and per-row access flags
        Long userWarehouseId = currentUser.getWarehouseId();
        boolean isAdmin = "Admin".equals(currentUser.getRole());
        
        List<Map<String, Object>> transfersWithDetails = new ArrayList<>();
        for (Request transfer : transfers) {
            Map<String, Object> data = new HashMap<>();
            data.put("request", transfer);
            data.put("sourceWarehouse", warehouseMap.get(transfer.getSourceWarehouseId()));
            data.put("destinationWarehouse", warehouseMap.get(transfer.getDestinationWarehouseId()));
            data.put("creator", userMap.get(transfer.getCreatedBy()));
            // Per-row warehouse flags for action visibility
            data.put("isAtSourceWH", userWarehouseId != null 
                && userWarehouseId.equals(transfer.getSourceWarehouseId()));
            data.put("isAtDestWH", userWarehouseId != null 
                && userWarehouseId.equals(transfer.getDestinationWarehouseId()));
            data.put("isAdmin", isAdmin);
            transfersWithDetails.add(data);
        }
        
        request.setAttribute("transfers", transfersWithDetails);
        request.setAttribute("selectedStatus", status);
        
        request.getRequestDispatcher("/WEB-INF/views/transfer/list.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-TRF-001: Show create transfer form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        // Only Manager/Admin can create transfers
        if (!"Manager".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole())) {
            request.setAttribute("errorMessage", "Only Managers can create transfer requests");
            listTransfers(request, response);
            return;
        }
        
        List<Warehouse> warehouses = transferService.getAllWarehouses();
        request.setAttribute("warehouses", warehouses);
        
        // Manager: pre-select and lock source warehouse to their assigned warehouse
        boolean isManager = "Manager".equals(currentUser.getRole());
        if (isManager) {
            Long managerWarehouseId = currentUser.getWarehouseId();
            if (managerWarehouseId == null) {
                request.setAttribute("errorMessage", "You are not assigned to any warehouse.");
                listTransfers(request, response);
                return;
            }
            request.setAttribute("lockedSourceWarehouseId", managerWarehouseId);
        }
        request.setAttribute("isManager", isManager);
        
        // If source warehouse selected, load products
        String sourceWarehouseIdStr = request.getParameter("sourceWarehouseId");
        // For Manager, auto-select their assigned warehouse if not already in params
        if (isManager && (sourceWarehouseIdStr == null || sourceWarehouseIdStr.isEmpty())) {
            sourceWarehouseIdStr = String.valueOf(currentUser.getWarehouseId());
        }
        if (sourceWarehouseIdStr != null && !sourceWarehouseIdStr.isEmpty()) {
            Long sourceWarehouseId = Long.parseLong(sourceWarehouseIdStr);
            List<Map<String, Object>> products = 
                transferService.getProductsWithInventoryAtWarehouse(sourceWarehouseId);
            request.setAttribute("products", products);
            request.setAttribute("selectedSourceWarehouseId", sourceWarehouseId);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/transfer/create.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-TRF-001: Create transfer request
     */
    private void createTransfer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        // Only Manager/Admin can create transfers
        if (!"Manager".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole())) {
            request.setAttribute("errorMessage", "Only Managers can create transfer requests");
            listTransfers(request, response);
            return;
        }
        
        try {
            Long sourceWarehouseId = Long.parseLong(request.getParameter("sourceWarehouseId"));
            Long destinationWarehouseId = Long.parseLong(request.getParameter("destinationWarehouseId"));
            String notes = request.getParameter("notes");
            
            // Manager can only use their assigned warehouse as source
            if ("Manager".equals(currentUser.getRole())) {
                Long managerWarehouseId = currentUser.getWarehouseId();
                if (managerWarehouseId == null || !managerWarehouseId.equals(sourceWarehouseId)) {
                    request.setAttribute("errorMessage", "You can only create transfer requests from your assigned warehouse.");
                    showCreateForm(request, response);
                    return;
                }
            }
            
            // Validate different warehouses
            if (sourceWarehouseId.equals(destinationWarehouseId)) {
                request.setAttribute("errorMessage", "Source and destination warehouses must be different");
                showCreateForm(request, response);
                return;
            }
            
            // Parse items
            String[] productIds = request.getParameterValues("productId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            
            if (productIds == null || productIds.length == 0) {
                request.setAttribute("errorMessage", "At least one item is required");
                showCreateForm(request, response);
                return;
            }
            
            List<RequestItem> items = new ArrayList<>();
            for (int i = 0; i < productIds.length; i++) {
                if (productIds[i] != null && !productIds[i].isEmpty()) {
                    RequestItem item = new RequestItem();
                    item.setProductId(Long.parseLong(productIds[i]));
                    item.setQuantity(Integer.parseInt(quantities[i]));
                    items.add(item);
                }
            }
            
            if (items.isEmpty()) {
                request.setAttribute("errorMessage", "At least one item is required");
                showCreateForm(request, response);
                return;
            }
            
            // Parse optional expected date
            String expectedDateStr = request.getParameter("expectedDate");
            LocalDateTime expectedDate = null;
            if (expectedDateStr != null && !expectedDateStr.trim().isEmpty()) {
                expectedDate = LocalDateTime.parse(expectedDateStr + "T00:00:00");
            }
            
            Request transfer = transferService.createTransferRequest(
                sourceWarehouseId, destinationWarehouseId, currentUser.getId(), items, notes, expectedDate);
            
            if (transfer != null) {
                request.getSession().setAttribute("successMessage", "Transfer request created successfully");
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=view&id=" + transfer.getId());
            } else {
                request.setAttribute("errorMessage", "Failed to create transfer request");
                showCreateForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input format");
            showCreateForm(request, response);
        }
    }
    
    /**
     * View transfer details
     */
    private void viewTransfer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            Request transfer = transferService.getTransferRequestById(requestId);
            if (transfer == null) {
                request.setAttribute("errorMessage", "Transfer request not found");
                listTransfers(request, response);
                return;
            }
            
            // Manager/Staff can only view transfers related to their warehouse
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");
            if ("Manager".equals(currentUser.getRole()) || "Staff".equals(currentUser.getRole())) {
                Long userWarehouseId = currentUser.getWarehouseId();
                if (userWarehouseId == null
                        || (!userWarehouseId.equals(transfer.getSourceWarehouseId())
                            && !userWarehouseId.equals(transfer.getDestinationWarehouseId()))) {
                    request.setAttribute("errorMessage", "You don't have permission to view this transfer.");
                    listTransfers(request, response);
                    return;
                }
            }
            
            Warehouse source = transferService.getWarehouseById(transfer.getSourceWarehouseId());
            Warehouse dest = transferService.getWarehouseById(transfer.getDestinationWarehouseId());
            User creator = transferService.getUserById(transfer.getCreatedBy());
            List<Map<String, Object>> items = transferService.getTransferItemsWithDetails(requestId);
            
            request.setAttribute("transfer", transfer);
            request.setAttribute("sourceWarehouse", source);
            request.setAttribute("destinationWarehouse", dest);
            request.setAttribute("creator", creator);
            request.setAttribute("items", items);
            
            // Pass warehouse flags for the JSP to control button visibility
            Long userWarehouseId = currentUser.getWarehouseId();
            boolean isAdmin = "Admin".equals(currentUser.getRole());
            boolean isAtSourceWH = userWarehouseId != null 
                && userWarehouseId.equals(transfer.getSourceWarehouseId());
            boolean isAtDestWH = userWarehouseId != null 
                && userWarehouseId.equals(transfer.getDestinationWarehouseId());
            request.setAttribute("isAtSourceWH", isAtSourceWH);
            request.setAttribute("isAtDestWH", isAtDestWH);
            request.setAttribute("isAdmin", isAdmin);
            
            // Check success message from session flash
            HttpSession viewSession = request.getSession(false);
            if (viewSession != null && viewSession.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", viewSession.getAttribute("successMessage"));
                viewSession.removeAttribute("successMessage");
            }
            
            request.getRequestDispatcher("/WEB-INF/views/transfer/view.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * UC-TRF-002: Approve transfer request
     * Only destination warehouse Manager or Admin can approve.
     */
    private void approveTransfer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        if (!"Manager".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole())) {
            request.setAttribute("errorMessage", "Only Managers and Admins can approve transfers");
            listTransfers(request, response);
            return;
        }
        
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            // Manager can only approve transfers destined to their warehouse
            if ("Manager".equals(currentUser.getRole())) {
                Request transfer = transferService.getTransferRequestById(requestId);
                Long managerWarehouseId = currentUser.getWarehouseId();
                if (transfer == null || managerWarehouseId == null
                        || !managerWarehouseId.equals(transfer.getDestinationWarehouseId())) {
                    request.setAttribute("errorMessage", 
                        "Only the destination warehouse Manager can approve this transfer.");
                    listTransfers(request, response);
                    return;
                }
            }
            
            boolean success = transferService.approveTransfer(requestId, currentUser.getId());
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Transfer approved successfully");
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=view&id=" + requestId);
            } else {
                request.setAttribute("errorMessage", "Failed to approve transfer. Only transfers with status 'Created' can be approved.");
                viewTransfer(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * UC-TRF-002: Reject transfer request
     * Only destination warehouse Manager or Admin can reject.
     */
    private void rejectTransfer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        if (!"Manager".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole())) {
            request.setAttribute("errorMessage", "Only Managers and Admins can reject transfers");
            listTransfers(request, response);
            return;
        }
        
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            String reason = request.getParameter("reason");
            
            if (reason == null || reason.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Rejection reason is required");
                viewTransfer(request, response);
                return;
            }
            
            // Manager can only reject transfers destined to their warehouse
            if ("Manager".equals(currentUser.getRole())) {
                Request transfer = transferService.getTransferRequestById(requestId);
                Long managerWarehouseId = currentUser.getWarehouseId();
                if (transfer == null || managerWarehouseId == null
                        || !managerWarehouseId.equals(transfer.getDestinationWarehouseId())) {
                    request.setAttribute("errorMessage", 
                        "Only the destination warehouse Manager can reject this transfer.");
                    listTransfers(request, response);
                    return;
                }
            }
            
            boolean success = transferService.rejectTransfer(requestId, currentUser.getId(), reason);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Transfer rejected successfully");
                response.sendRedirect(request.getContextPath() + "/transfer");
            } else {
                request.setAttribute("errorMessage", "Failed to reject transfer");
                viewTransfer(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * UC-TRF-003: Show outbound execution form
     * Only source warehouse Staff/Manager or Admin can execute outbound.
     */
    private void showOutboundExecutionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            // Check success message from session flash
            HttpSession outSession = request.getSession(false);
            if (outSession != null && outSession.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", outSession.getAttribute("successMessage"));
                outSession.removeAttribute("successMessage");
            }
            
            Request transfer = transferService.getTransferRequestById(requestId);
            if (transfer == null) {
                request.setAttribute("errorMessage", "Transfer request not found");
                listTransfers(request, response);
                return;
            }
            
            // Verify user is at source warehouse (or Admin)
            User currentUser = (User) request.getSession(false).getAttribute("user");
            if (!"Admin".equals(currentUser.getRole())) {
                Long userWarehouseId = currentUser.getWarehouseId();
                if (userWarehouseId == null || !userWarehouseId.equals(transfer.getSourceWarehouseId())) {
                    request.setAttribute("errorMessage", 
                        "Only source warehouse staff can execute transfer outbound.");
                    viewTransfer(request, response);
                    return;
                }
            }
            
            // Must be Approved or InProgress
            if (!"Approved".equals(transfer.getStatus()) && !"InProgress".equals(transfer.getStatus())) {
                request.setAttribute("errorMessage", "Transfer must be approved before execution");
                viewTransfer(request, response);
                return;
            }
            
            Warehouse source = transferService.getWarehouseById(transfer.getSourceWarehouseId());
            Warehouse dest = transferService.getWarehouseById(transfer.getDestinationWarehouseId());
            List<Map<String, Object>> availability = transferService.checkTransferAvailability(requestId);
            
            request.setAttribute("transfer", transfer);
            request.setAttribute("sourceWarehouse", source);
            request.setAttribute("destinationWarehouse", dest);
            request.setAttribute("availability", availability);
            
            request.getRequestDispatcher("/WEB-INF/views/transfer/execute-outbound.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * UC-TRF-003: Start outbound execution
     */
    private void startOutbound(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            // Verify user is at source warehouse (or Admin)
            User currentUser = (User) request.getSession(false).getAttribute("user");
            Request transfer = transferService.getTransferRequestById(requestId);
            if (!"Admin".equals(currentUser.getRole())) {
                Long userWarehouseId = currentUser.getWarehouseId();
                if (transfer == null || userWarehouseId == null 
                        || !userWarehouseId.equals(transfer.getSourceWarehouseId())) {
                    request.setAttribute("errorMessage", 
                        "Only source warehouse staff can start transfer outbound.");
                    listTransfers(request, response);
                    return;
                }
            }
            
            boolean success = transferService.startOutboundExecution(requestId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Outbound picking started");
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=execute-outbound&id=" + requestId);
            } else {
                request.setAttribute("errorMessage", "Failed to start outbound execution");
                showOutboundExecutionForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * UC-TRF-003: Complete outbound execution
     */
    private void completeOutbound(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            // Verify user is at source warehouse (or Admin)
            Request transferCheck = transferService.getTransferRequestById(requestId);
            if (!"Admin".equals(currentUser.getRole())) {
                Long userWarehouseId = currentUser.getWarehouseId();
                if (transferCheck == null || userWarehouseId == null 
                        || !userWarehouseId.equals(transferCheck.getSourceWarehouseId())) {
                    request.setAttribute("errorMessage", 
                        "Only source warehouse staff can complete transfer outbound.");
                    listTransfers(request, response);
                    return;
                }
            }
            
            // Parse per-item picked quantities from form
            String[] productIds = request.getParameterValues("productId[]");
            String[] pickedQtys = request.getParameterValues("pickedQty[]");
            
            Map<Long, Integer> pickedQuantities = new HashMap<>();
            if (productIds != null && pickedQtys != null && productIds.length == pickedQtys.length) {
                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] != null && !productIds[i].isEmpty()
                            && pickedQtys[i] != null && !pickedQtys[i].isEmpty()) {
                        pickedQuantities.put(Long.parseLong(productIds[i]), Integer.parseInt(pickedQtys[i]));
                    }
                }
            }
            
            boolean success = transferService.completeOutboundExecution(requestId, currentUser.getId(), pickedQuantities);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Outbound completed. Goods are now in transit");
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=view&id=" + requestId);
            } else {
                request.setAttribute("errorMessage", "Failed to complete outbound");
                showOutboundExecutionForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * UC-TRF-004: Show inbound execution form
     * Only destination warehouse Staff/Manager or Admin can execute inbound.
     */
    private void showInboundExecutionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            // Check success message from session flash
            HttpSession execSession = request.getSession(false);
            if (execSession != null && execSession.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", execSession.getAttribute("successMessage"));
                execSession.removeAttribute("successMessage");
            }
            
            Request transfer = transferService.getTransferRequestById(requestId);
            if (transfer == null) {
                request.setAttribute("errorMessage", "Transfer request not found");
                listTransfers(request, response);
                return;
            }
            
            // Verify user is at destination warehouse (or Admin)
            User currentUser = (User) request.getSession(false).getAttribute("user");
            if (!"Admin".equals(currentUser.getRole())) {
                Long userWarehouseId = currentUser.getWarehouseId();
                if (userWarehouseId == null || !userWarehouseId.equals(transfer.getDestinationWarehouseId())) {
                    request.setAttribute("errorMessage", 
                        "Only destination warehouse staff can execute transfer inbound.");
                    viewTransfer(request, response);
                    return;
                }
            }
            
            // Must be InTransit or Receiving
            if (!"InTransit".equals(transfer.getStatus()) && !"Receiving".equals(transfer.getStatus())) {
                request.setAttribute("errorMessage", "Outbound must be completed before inbound execution");
                viewTransfer(request, response);
                return;
            }
            
            Warehouse source = transferService.getWarehouseById(transfer.getSourceWarehouseId());
            Warehouse dest = transferService.getWarehouseById(transfer.getDestinationWarehouseId());
            List<Map<String, Object>> items = transferService.getTransferItemsWithDetails(requestId);
            List<Location> locations = transferService.getLocationsByWarehouse(transfer.getDestinationWarehouseId());
            
            request.setAttribute("transfer", transfer);
            request.setAttribute("sourceWarehouse", source);
            request.setAttribute("destinationWarehouse", dest);
            request.setAttribute("items", items);
            request.setAttribute("locations", locations);
            
            request.getRequestDispatcher("/WEB-INF/views/transfer/execute-inbound.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * UC-TRF-004: Start inbound execution
     */
    
}
