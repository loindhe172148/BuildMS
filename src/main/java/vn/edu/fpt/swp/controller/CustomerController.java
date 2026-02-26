package vn.edu.fpt.swp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.Customer;
import vn.edu.fpt.swp.model.User;
import vn.edu.fpt.swp.service.CustomerService;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Customer management
 * Handles UC-CUS-001, UC-CUS-002, UC-CUS-003, UC-CUS-004
 */
@WebServlet("/customer")
public class CustomerController extends HttpServlet {
    
    private CustomerService customerService;
    
    @Override
    public void init() throws ServletException {
        customerService = new CustomerService();
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
                if (!hasManageAccess(request)) {
                    response.sendRedirect(request.getContextPath() + "/customer?action=list");
                    return;
                }
                showAddForm(request, response);
                break;
            case "edit":
                if (!hasManageAccess(request)) {
                    response.sendRedirect(request.getContextPath() + "/customer?action=list");
                    return;
                }
                showEditForm(request, response);
                break;
            case "toggle":
                if (!hasToggleAccess(request)) {
                    response.sendRedirect(request.getContextPath() + "/customer?action=list");
                    return;
                }
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
        if (!hasManageAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/customer?action=list");
            return;
        }
        
        switch (action) {
            case "add":
                processAdd(request, response);
                break;
            case "edit":
                processEdit(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/customer?action=list");
        }
    }
    
    /**
     * UC-CUS-004: Display customer list with filters
     */
    private void showList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        
        List<Customer> customers;
        
        if ((keyword != null && !keyword.trim().isEmpty()) || 
            (status != null && !status.trim().isEmpty())) {
            customers = customerService.searchCustomers(keyword, status);
        } else {
            customers = customerService.getAllCustomers();
        }
        
        // Get order count for each customer
        for (Customer customer : customers) {
            int orderCount = customerService.getOrderCount(customer.getId());
            request.setAttribute("orderCount_" + customer.getId(), orderCount);
        }
        
        request.setAttribute("customers", customers);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        
        request.getRequestDispatcher("/WEB-INF/views/customer/list.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-CUS-001: Show add customer form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/customer/add.jsp")
               .forward(request, response);
    }
    
    /**
     * UC-CUS-001: Process add customer
     */
    private void processAdd(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String contactInfo = request.getParameter("contactInfo");
        
        try {
            Customer customer = new Customer();
            customer.setCode(code);
            customer.setName(name);
            customer.setContactInfo(contactInfo);
            
            Customer created = customerService.createCustomer(customer);
            
            if (created != null) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Customer created successfully!");
                response.sendRedirect(request.getContextPath() + "/customer?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to create customer. Please try again.");
                request.setAttribute("code", code);
                request.setAttribute("name", name);
                request.setAttribute("contactInfo", contactInfo);
                request.getRequestDispatcher("/WEB-INF/views/customer/add.jsp")
                       .forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("code", code);
            request.setAttribute("name", name);
            request.setAttribute("contactInfo", contactInfo);
            request.getRequestDispatcher("/WEB-INF/views/customer/add.jsp")
                   .forward(request, response);
        }
    }
    
    /**
     * UC-CUS-002: Show edit customer form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Customer ID is required");
            response.sendRedirect(request.getContextPath() + "/customer?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam);
            Customer customer = customerService.getCustomerById(id);
            
            if (customer == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Customer not found");
                response.sendRedirect(request.getContextPath() + "/customer?action=list");
                return;
            }
            
            int orderCount = customerService.getOrderCount(id);
            
            request.setAttribute("customer", customer);
            request.setAttribute("orderCount", orderCount);
            
            request.getRequestDispatcher("/WEB-INF/views/customer/edit.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid customer ID");
            response.sendRedirect(request.getContextPath() + "/customer?action=list");
        }
    }
    
    /**
     * UC-CUS-002: Process edit customer
     */
    private void processEdit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String contactInfo = request.getParameter("contactInfo");
        
        try {
            Long id = Long.parseLong(idParam);
            
            Customer customer = customerService.getCustomerById(id);
            if (customer == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Customer not found");
                response.sendRedirect(request.getContextPath() + "/customer?action=list");
                return;
            }
            
            customer.setCode(code);
            customer.setName(name);
            customer.setContactInfo(contactInfo);
            
            boolean updated = customerService.updateCustomer(customer);
            
            if (updated) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Customer updated successfully!");
                response.sendRedirect(request.getContextPath() + "/customer?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to update customer. Please try again.");
                request.setAttribute("customer", customer);
                request.setAttribute("orderCount", customerService.getOrderCount(id));
                request.getRequestDispatcher("/WEB-INF/views/customer/edit.jsp")
                       .forward(request, response);
            }
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid customer ID");
            response.sendRedirect(request.getContextPath() + "/customer?action=list");
        } catch (IllegalArgumentException e) {
            Long id = Long.parseLong(idParam);
            Customer customer = customerService.getCustomerById(id);
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("customer", customer);
            request.setAttribute("code", code);
            request.setAttribute("name", name);
            request.setAttribute("contactInfo", contactInfo);
            request.setAttribute("orderCount", customerService.getOrderCount(id));
            request.getRequestDispatcher("/WEB-INF/views/customer/edit.jsp")
                   .forward(request, response);
        }
    }
    
    /**
     * UC-CUS-003: Toggle customer status
     */
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Customer ID is required");
            response.sendRedirect(request.getContextPath() + "/customer?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam);
            Customer customer = customerService.getCustomerById(id);
            
            if (customer == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Customer not found");
                response.sendRedirect(request.getContextPath() + "/customer?action=list");
                return;
            }
            
            // Check for pending orders when deactivating
            boolean isDeactivating = "Active".equals(customer.getStatus());
            boolean hasPendingOrders = customerService.hasPendingOrders(id);
            
            boolean toggled = customerService.toggleCustomerStatus(id);
            
            HttpSession session = request.getSession();
            if (toggled) {
                String message = "Customer " + (isDeactivating ? "deactivated" : "activated") + " successfully!";
                if (isDeactivating && hasPendingOrders) {
                    message += " Note: Existing pending orders can still be processed.";
                    session.setAttribute("warningMessage", message);
                } else {
                    session.setAttribute("successMessage", message);
                }
            } else {
                session.setAttribute("errorMessage", "Failed to update customer status");
            }
            
            response.sendRedirect(request.getContextPath() + "/customer?action=list");
            
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid customer ID");
            response.sendRedirect(request.getContextPath() + "/customer?action=list");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/customer?action=list");
        }
    }
    
    /**
     * Check if user has access to view customers
     * Allowed: Admin, Manager, Sales
     */
    private boolean hasAccess(HttpServletRequest request) {
        User user = getCurrentUser(request);
        if (user == null) return false;
        
        String role = user.getRole();
        return "Admin".equals(role) || "Manager".equals(role) || "Sales".equals(role);
    }
    
    /**
     * Check if user has access to add/edit customers
     * Allowed: Admin, Manager, Sales
     */
    private boolean hasManageAccess(HttpServletRequest request) {
        return hasAccess(request); // Same as view access for customers
    }
    
    /**
     * Check if user has access to toggle customer status
     * Allowed: Admin only
     */
    private boolean hasToggleAccess(HttpServletRequest request) {
        User user = getCurrentUser(request);
        if (user == null) return false;
        
        return "Admin".equals(user.getRole());
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
