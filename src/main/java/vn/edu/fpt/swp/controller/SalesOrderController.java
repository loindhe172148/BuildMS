package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.*;
import vn.edu.fpt.swp.service.SalesOrderService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        
        List<SalesOrder> orders;
        if (status != null && !status.isEmpty()) {
            orders = salesOrderService.getSalesOrdersByStatus(status);
        } else {
            orders = salesOrderService.getAllSalesOrders();
        }
        
        // Enrich with customer info
        List<Map<String, Object>> ordersWithDetails = new ArrayList<>();
        for (SalesOrder order : orders) {
            Map<String, Object> orderData = new HashMap<>();
            orderData.put("order", order);
            
            Customer customer = salesOrderService.getCustomerById(order.getCustomerId());
            orderData.put("customer", customer);
            
            User creator = salesOrderService.getUserById(order.getCreatedBy());
            orderData.put("creator", creator);
            
            ordersWithDetails.add(orderData);
        }
        
        request.setAttribute("orders", ordersWithDetails);
        request.setAttribute("selectedStatus", status);
        
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
}