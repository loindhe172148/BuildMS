package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.*;
import vn.edu.fpt.swp.service.SalesOrderService;
import vn.edu.fpt.swp.util.PageRequest;
import vn.edu.fpt.swp.util.PageResult;
import vn.edu.fpt.swp.util.PaginationUtil;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for Sales Order Management
 * 
 * UC-SO-001: Create Sales Order
 * UC-SO-002: Confirm Sales Order
 * UC-SO-003: Generate Outbound Request from Sales Order
 * UC-SO-004: Cancel Sales Order
 */
@WebServlet("/sales-order")
public class SalesOrderController extends HttpServlet {
    
    private SalesOrderService salesOrderService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        salesOrderService = new SalesOrderService();
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
                listOrders(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "view":
                viewOrder(request, response);
                break;
            case "generate-outbound":
                showGenerateOutboundForm(request, response);
                break;
            case "cancel":
                showCancelForm(request, response);
                break;
            default:
                listOrders(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sales-order");
            return;
        }
        
        switch (action) {
            case "create":
                createOrder(request, response);
                break;
            case "confirm":
                confirmOrder(request, response);
                break;
            case "generate-outbound":
                generateOutbound(request, response);
                break;
            case "cancel":
                cancelOrder(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/sales-order");
        }
    }
    
    /**
     * List all sales orders with optional status filter
     */
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");

        String selectedStatus = status != null ? status.trim() : null;
        if (selectedStatus != null && selectedStatus.isEmpty()) {
            selectedStatus = null;
        }

        PageRequest pageRequest = PaginationUtil.resolvePageRequest(request);
        PageResult<SalesOrder> orderPage = salesOrderService.getSalesOrdersPaginated(selectedStatus, pageRequest);
        List<SalesOrder> orders = orderPage.getItems();
        
        // Build lookup maps once — avoids N+1 DB calls per order
        java.util.Map<Long, Customer> customerMap = new java.util.HashMap<>();
        for (Customer c : salesOrderService.getAllCustomers()) {
            customerMap.put(c.getId(), c);
        }
        java.util.Map<Long, User> userMap = new java.util.HashMap<>();
        for (User u : salesOrderService.getAllUsers()) {
            userMap.put(u.getId(), u);
        }

        // Enrich with customer info
        List<Map<String, Object>> ordersWithDetails = new ArrayList<>();
        for (SalesOrder order : orders) {
            Map<String, Object> orderData = new HashMap<>();
            orderData.put("order", order);
            orderData.put("customer", customerMap.get(order.getCustomerId()));
            orderData.put("creator", userMap.get(order.getCreatedBy()));
            ordersWithDetails.add(orderData);
        }
        
        request.setAttribute("orders", ordersWithDetails);
        request.setAttribute("selectedStatus", selectedStatus);
        request.setAttribute("currentPage", orderPage.getCurrentPage());
        request.setAttribute("totalPages", orderPage.getTotalPages());
        request.setAttribute("pageSize", orderPage.getPageSize());
        request.setAttribute("totalItems", orderPage.getTotalItems());

        Map<String, String> paginationParams = new LinkedHashMap<>();
        paginationParams.put("status", selectedStatus);
        paginationParams.put("size", String.valueOf(pageRequest.getSize()));
        request.setAttribute("paginationBaseUrl", PaginationUtil.buildBaseUrl(request, "/sales-order", paginationParams));
        
        request.getRequestDispatcher("/WEB-INF/views/sales-order/list.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-SO-001: Show create order form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get active customers
        List<Customer> customers = salesOrderService.getActiveCustomers();
        if (customers.isEmpty()) {
            request.setAttribute("errorMessage", "No customers available. Please create a customer first.");
        }
        request.setAttribute("customers", customers);
        
        // Get active products
        List<Product> products = salesOrderService.getActiveProducts();
        request.setAttribute("products", products);
        
        request.getRequestDispatcher("/WEB-INF/views/sales-order/create.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-SO-001: Create sales order
     */
    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        try {
            // Parse customer ID
            Long customerId = Long.parseLong(request.getParameter("customerId"));
            
            // Parse order items
            String[] productIds = request.getParameterValues("productId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            
            if (productIds == null || productIds.length == 0) {
                request.setAttribute("errorMessage", "At least one item is required");
                showCreateForm(request, response);
                return;
            }
            
            // Build items list
            List<SalesOrderItem> items = new ArrayList<>();
            for (int i = 0; i < productIds.length; i++) {
                if (productIds[i] != null && !productIds[i].isEmpty()) {
                    SalesOrderItem item = new SalesOrderItem();
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
            
            // Create order
            SalesOrder order = new SalesOrder();
            order.setCustomerId(customerId);
            order.setCreatedBy(currentUser.getId());
            
            // Parse optional fields: orderDate, requiredDeliveryDate, notes
            String orderDateStr = request.getParameter("orderDate");
            if (orderDateStr != null && !orderDateStr.trim().isEmpty()) {
                try {
                    order.setOrderDate(LocalDateTime.parse(orderDateStr + "T00:00:00"));
                } catch (DateTimeParseException ex) {
                    // Ignore parse error, leave null (defaults to now in DB)
                }
            }
            
            String deliveryDateStr = request.getParameter("requiredDeliveryDate");
            if (deliveryDateStr != null && !deliveryDateStr.trim().isEmpty()) {
                try {
                    order.setRequiredDeliveryDate(LocalDateTime.parse(deliveryDateStr + "T00:00:00"));
                } catch (DateTimeParseException ex) {
                    // Ignore parse error, leave null
                }
            }
            
            String notes = request.getParameter("notes");
            if (notes != null && !notes.trim().isEmpty()) {
                order.setNotes(notes.trim());
            }
            
            SalesOrder createdOrder = salesOrderService.createSalesOrder(order, items);
            
            if (createdOrder != null) {
                request.getSession().setAttribute("successMessage", 
                    "Sales Order " + createdOrder.getOrderNo() + " created successfully");
                response.sendRedirect(request.getContextPath() + 
                    "/sales-order?action=view&id=" + createdOrder.getId());
            } else {
                request.setAttribute("errorMessage", "Failed to create sales order. Please check your inputs.");
                showCreateForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input format");
            showCreateForm(request, response);
        }
    }
    
    /**
     * View order details
     */
    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long orderId = Long.parseLong(request.getParameter("id"));
            
            SalesOrder order = salesOrderService.getSalesOrderById(orderId);
            if (order == null) {
                request.setAttribute("errorMessage", "Sales order not found");
                listOrders(request, response);
                return;
            }
            
            // Get related info
            Customer customer = salesOrderService.getCustomerById(order.getCustomerId());
            User creator = salesOrderService.getUserById(order.getCreatedBy());
            List<Map<String, Object>> items = salesOrderService.getOrderItemsWithDetails(orderId);
            List<Request> relatedRequests = salesOrderService.getRelatedRequests(orderId);
            
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);
            request.setAttribute("creator", creator);
            request.setAttribute("items", items);
            request.setAttribute("relatedRequests", relatedRequests);
            
            // Consume flash message from session
            HttpSession viewSession = request.getSession(false);
            if (viewSession != null) {
                String flashMsg = (String) viewSession.getAttribute("successMessage");
                if (flashMsg != null) {
                    request.setAttribute("successMessage", flashMsg);
                    viewSession.removeAttribute("successMessage");
                }
            }
            
            request.getRequestDispatcher("/WEB-INF/views/sales-order/view.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid order ID");
            listOrders(request, response);
        }
    }
    
    /**
     * UC-SO-002: Confirm sales order
     */
    private void confirmOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        try {
            Long orderId = Long.parseLong(request.getParameter("id"));
            
            boolean success = salesOrderService.confirmOrder(orderId, currentUser.getId());
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Sales order confirmed successfully");
                response.sendRedirect(request.getContextPath() + 
                    "/sales-order?action=view&id=" + orderId);
            } else {
                request.setAttribute("errorMessage", "Failed to confirm order. Order must be in Draft status.");
                viewOrder(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid order ID");
            listOrders(request, response);
        }
    }
    
    /**
     * UC-SO-003: Show generate outbound form
     */
    private void showGenerateOutboundForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        // Only Manager/Admin can generate outbound
        if (!"Manager".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole())) {
            request.setAttribute("errorMessage", "Only Managers can generate outbound requests");
            listOrders(request, response);
            return;
        }
        
        try {
            Long orderId = Long.parseLong(request.getParameter("id"));
            
            SalesOrder order = salesOrderService.getSalesOrderById(orderId);
            if (order == null || !"Confirmed".equals(order.getStatus())) {
                request.setAttribute("errorMessage", "Order must be in Confirmed status");
                listOrders(request, response);
                return;
            }
            
            Customer customer = salesOrderService.getCustomerById(order.getCustomerId());
            List<Map<String, Object>> items = salesOrderService.getOrderItemsWithDetails(orderId);
            List<Warehouse> warehouses = salesOrderService.getAllWarehouses();
            
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);
            request.setAttribute("items", items);
            request.setAttribute("warehouses", warehouses);
            
            // If warehouse selected, check availability
            String warehouseIdStr = request.getParameter("warehouseId");
            if (warehouseIdStr != null && !warehouseIdStr.isEmpty()) {
                Long warehouseId = Long.parseLong(warehouseIdStr);
                List<Map<String, Object>> availability = 
                    salesOrderService.checkInventoryAvailability(orderId, warehouseId);
                request.setAttribute("availability", availability);
                request.setAttribute("selectedWarehouseId", warehouseId);
            }
            
            request.getRequestDispatcher("/WEB-INF/views/sales-order/generate-outbound.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid order ID");
            listOrders(request, response);
        }
    }
    
    /**
     * UC-SO-003: Generate outbound request
     */
    private void generateOutbound(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        // Only Manager/Admin can generate outbound
        if (!"Manager".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole())) {
            request.setAttribute("errorMessage", "Only Managers can generate outbound requests");
            listOrders(request, response);
            return;
        }
        
        try {
            Long orderId = Long.parseLong(request.getParameter("id"));
            Long warehouseId = Long.parseLong(request.getParameter("warehouseId"));
            
            // Parse quantities (optional custom quantities)
            Map<Long, Integer> quantities = new HashMap<>();
            String[] productIds = request.getParameterValues("productId[]");
            String[] qtyValues = request.getParameterValues("fulfillQuantity[]");
            
            if (productIds != null && qtyValues != null) {
                for (int i = 0; i < productIds.length; i++) {
                    Long productId = Long.parseLong(productIds[i]);
                    Integer qty = Integer.parseInt(qtyValues[i]);
                    if (qty > 0) {
                        quantities.put(productId, qty);
                    }
                }
            }
            
            Request outboundRequest = salesOrderService.generateOutboundRequest(
                orderId, warehouseId, currentUser.getId(), 
                quantities.isEmpty() ? null : quantities);
            
            if (outboundRequest != null) {
                request.getSession().setAttribute("successMessage", 
                    "Outbound request " + outboundRequest.getId() + " generated successfully");
                response.sendRedirect(request.getContextPath() + 
                    "/sales-order?action=view&id=" + orderId);
            } else {
                request.setAttribute("errorMessage", "Failed to generate outbound request");
                showGenerateOutboundForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input");
            listOrders(request, response);
        }
    }
    
    /**
     * UC-SO-004: Show cancel order form
     */
    private void showCancelForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long orderId = Long.parseLong(request.getParameter("id"));
            
            SalesOrder order = salesOrderService.getSalesOrderById(orderId);
            if (order == null) {
                request.setAttribute("errorMessage", "Sales order not found");
                listOrders(request, response);
                return;
            }
            
            Map<String, Object> cancellationStatus = salesOrderService.checkCancellationStatus(orderId);
            
            Customer customer = salesOrderService.getCustomerById(order.getCustomerId());
            
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);
            request.setAttribute("cancellationStatus", cancellationStatus);
            
            request.getRequestDispatcher("/WEB-INF/views/sales-order/cancel.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid order ID");
            listOrders(request, response);
        }
    }
    
    /**
     * UC-SO-004: Cancel sales order
     */
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        try {
            Long orderId = Long.parseLong(request.getParameter("id"));
            String reason = request.getParameter("reason");
            
            if (reason == null || reason.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Cancellation reason is required");
                showCancelForm(request, response);
                return;
            }
            
            boolean success = salesOrderService.cancelOrder(orderId, currentUser.getId(), reason);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/sales-order?success=Sales order cancelled successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to cancel order");
                showCancelForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid order ID");
            listOrders(request, response);
        }
    }
}
