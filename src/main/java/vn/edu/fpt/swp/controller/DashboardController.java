package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.Request;
import vn.edu.fpt.swp.service.ProductService;
import vn.edu.fpt.swp.service.WarehouseService;
import vn.edu.fpt.swp.service.CategoryService;
import vn.edu.fpt.swp.service.InboundService;
import vn.edu.fpt.swp.service.OutboundService;
import vn.edu.fpt.swp.service.InventoryService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Controller for the Dashboard page
 * This is the main landing page after successful login
 */
@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProductService productService;
    private WarehouseService warehouseService;
    private CategoryService categoryService;
    private InboundService inboundService;
    private OutboundService outboundService;
    private InventoryService inventoryService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        warehouseService = new WarehouseService();
        categoryService = new CategoryService();
        inboundService = new InboundService();
        outboundService = new OutboundService();
        inventoryService = new InventoryService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get session (AuthFilter ensures user is authenticated)
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        
        // Check for success message from login (stored in session)
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage"); // Clear after displaying
        }
        
        // Populate dashboard statistics
        try {
            List<?> products = productService.getAllProducts();
            request.setAttribute("totalProducts", products != null ? products.size() : 0);
        } catch (Exception e) {
            request.setAttribute("totalProducts", 0);
        }

        try {
            List<?> warehouses = warehouseService.getAllWarehouses();
            request.setAttribute("totalWarehouses", warehouses != null ? warehouses.size() : 0);
        } catch (Exception e) {
            request.setAttribute("totalWarehouses", 0);
        }

        try {
            List<?> categories = categoryService.getAllCategories();
            request.setAttribute("totalCategories", categories != null ? categories.size() : 0);
        } catch (Exception e) {
            request.setAttribute("totalCategories", 0);
        }

        try {
            List<Request> created = inboundService.getInboundRequestsByStatus("Created");
            List<Request> approved = inboundService.getInboundRequestsByStatus("Approved");
            int pendingInbound = (created != null ? created.size() : 0) + (approved != null ? approved.size() : 0);
            request.setAttribute("pendingInbound", pendingInbound);
        } catch (Exception e) {
            request.setAttribute("pendingInbound", 0);
        }

        try {
            List<Request> created = outboundService.getOutboundRequestsByStatus("Created");
            List<Request> approved = outboundService.getOutboundRequestsByStatus("Approved");
            int pendingOutbound = (created != null ? created.size() : 0) + (approved != null ? approved.size() : 0);
            request.setAttribute("pendingOutbound", pendingOutbound);
        } catch (Exception e) {
            request.setAttribute("pendingOutbound", 0);
        }

        try {
            List<Map<String, Object>> lowStock = inventoryService.searchInventory(null, null, null, null, 10);
            request.setAttribute("lowStockItems", lowStock != null ? lowStock.size() : 0);
        } catch (Exception e) {
            request.setAttribute("lowStockItems", 0);
        }

        try {
            List<Request> recentInbound = inboundService.getAllInboundRequests();
            List<Request> recentOutbound = outboundService.getAllOutboundRequests();
            List<Request> recentRequests = new ArrayList<>();
            if (recentInbound != null) recentRequests.addAll(recentInbound);
            if (recentOutbound != null) recentRequests.addAll(recentOutbound);
            recentRequests.sort((a, b) -> {
                if (b.getCreatedAt() == null) return -1;
                if (a.getCreatedAt() == null) return 1;
                return b.getCreatedAt().compareTo(a.getCreatedAt());
            });
            if (recentRequests.size() > 10) {
                recentRequests = recentRequests.subList(0, 10);
            }
            request.setAttribute("recentRequests", recentRequests);
        } catch (Exception e) {
            request.setAttribute("recentRequests", new ArrayList<>());
        }
        
        // Forward to dashboard view
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }
}
