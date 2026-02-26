package vn.edu.fpt.swp.controller;

import vn.edu.fpt.swp.model.Location;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.model.Warehouse;
import vn.edu.fpt.swp.model.RequestItem;
import vn.edu.fpt.swp.model.Request;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.service.TransferService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for Inter-Warehouse Transfer Management
 * 
 * UC-TRF-001: Create Inter-Warehouse Transfer Request
 * UC-TRF-002: Execute Transfer Outbound
 * UC-TRF-003: Execute Transfer Inbound
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
        
        List<Request> transfers;
        if (status != null && !status.isEmpty()) {
            transfers = transferService.getTransferRequestsByStatus(status);
        } else {
            transfers = transferService.getAllTransferRequests();
        }
        
        // Enrich with warehouse info
        List<Map<String, Object>> transfersWithDetails = new ArrayList<>();
        for (Request transfer : transfers) {
            Map<String, Object> data = new HashMap<>();
            data.put("request", transfer);
            
            Warehouse source = transferService.getWarehouseById(transfer.getSourceWarehouseId());
            Warehouse dest = transferService.getWarehouseById(transfer.getDestinationWarehouseId());
            User creator = transferService.getUserById(transfer.getCreatedBy());
            
            data.put("sourceWarehouse", source);
            data.put("destinationWarehouse", dest);
            data.put("creator", creator);
            
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
        
        // If source warehouse selected, load products
        String sourceWarehouseIdStr = request.getParameter("sourceWarehouseId");
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
            
            Request transfer = transferService.createTransferRequest(
                sourceWarehouseId, destinationWarehouseId, currentUser.getId(), items, notes);
            
            if (transfer != null) {
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=view&id=" + transfer.getId() + 
                    "&success=Transfer request created successfully");
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
            
            Warehouse source = transferService.getWarehouseById(transfer.getSourceWarehouseId());
            Warehouse dest = transferService.getWarehouseById(transfer.getDestinationWarehouseId());
            User creator = transferService.getUserById(transfer.getCreatedBy());
            List<Map<String, Object>> items = transferService.getTransferItemsWithDetails(requestId);
            
            request.setAttribute("transfer", transfer);
            request.setAttribute("sourceWarehouse", source);
            request.setAttribute("destinationWarehouse", dest);
            request.setAttribute("creator", creator);
            request.setAttribute("items", items);
            
            // Check success message
            String success = request.getParameter("success");
            if (success != null && !success.isEmpty()) {
                request.setAttribute("successMessage", success);
            }
            
            request.getRequestDispatcher("/WEB-INF/views/transfer/view.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * Approve transfer request
     */
    private void approveTransfer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        if (!"Manager".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole())) {
            request.setAttribute("errorMessage", "Only Managers can approve transfers");
            listTransfers(request, response);
            return;
        }
        
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            boolean success = transferService.approveTransfer(requestId, currentUser.getId());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=view&id=" + requestId + 
                    "&success=Transfer approved successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to approve transfer");
                viewTransfer(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * Reject transfer request
     */
    private void rejectTransfer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        if (!"Manager".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole())) {
            request.setAttribute("errorMessage", "Only Managers can reject transfers");
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
            
            boolean success = transferService.rejectTransfer(requestId, currentUser.getId(), reason);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?success=Transfer rejected");
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
     * UC-TRF-002: Show outbound execution form
     */
    private void showOutboundExecutionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            Request transfer = transferService.getTransferRequestById(requestId);
            if (transfer == null) {
                request.setAttribute("errorMessage", "Transfer request not found");
                listTransfers(request, response);
                return;
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
     * UC-TRF-002: Start outbound execution
     */
    private void startOutbound(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            boolean success = transferService.startOutboundExecution(requestId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=execute-outbound&id=" + requestId + 
                    "&success=Outbound picking started");
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
     * UC-TRF-002: Complete outbound execution
     */
    private void completeOutbound(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            boolean success = transferService.completeOutboundExecution(requestId, currentUser.getId());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=view&id=" + requestId + 
                    "&success=Outbound completed. Goods are now in transit");
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
     * UC-TRF-003: Show inbound execution form
     */
    private void showInboundExecutionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            Request transfer = transferService.getTransferRequestById(requestId);
            if (transfer == null) {
                request.setAttribute("errorMessage", "Transfer request not found");
                listTransfers(request, response);
                return;
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
     * UC-TRF-003: Start inbound execution
     */
    private void startInbound(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            
            boolean success = transferService.startInboundExecution(requestId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=execute-inbound&id=" + requestId + 
                    "&success=Inbound receiving started");
            } else {
                request.setAttribute("errorMessage", "Failed to start inbound execution");
                showInboundExecutionForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID");
            listTransfers(request, response);
        }
    }
    
    /**
     * UC-TRF-003: Complete inbound execution
     */
    private void completeInbound(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        try {
            Long requestId = Long.parseLong(request.getParameter("id"));
            Long destinationLocationId = Long.parseLong(request.getParameter("destinationLocationId"));
            
            boolean success = transferService.completeInboundExecution(
                requestId, currentUser.getId(), destinationLocationId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/transfer?action=view&id=" + requestId + 
                    "&success=Transfer completed successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to complete inbound");
                showInboundExecutionForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input");
            listTransfers(request, response);
        }
    }
}
