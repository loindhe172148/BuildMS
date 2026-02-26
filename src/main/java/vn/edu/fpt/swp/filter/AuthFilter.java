package vn.edu.fpt.swp.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.swp.model.User;

import java.io.IOException;
import java.util.*;

/**
 * Authentication and Authorization Filter
 * 
 * UC-AUTH-005: Session Timeout
 * - Validates user session on every request
 * - Tracks last activity timestamp
 * - Enforces 30-minute inactivity timeout
 * - Implements role-based access control
 */
@WebFilter("/*")
public class AuthFilter implements Filter {
    
    // Session timeout in milliseconds (30 minutes)
    private static final long SESSION_TIMEOUT_MS = 30 * 60 * 1000;
    
    // Public paths that don't require authentication
    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
        "/auth",
        "/assets",
        "/css",
        "/js",
        "/images",
        "/libs",
        "/fonts"
    ));
    
    // Role-based access control map
    // Key: URL pattern, Value: Set of allowed roles
    private static final Map<String, Set<String>> ROLE_ACCESS_MAP = new HashMap<>();
    
    static {
        // Admin-only routes
        ROLE_ACCESS_MAP.put("/user", new HashSet<>(Arrays.asList("Admin")));
        ROLE_ACCESS_MAP.put("/users", new HashSet<>(Arrays.asList("Admin")));
        
        // Admin and Manager routes
        Set<String> adminManager = new HashSet<>(Arrays.asList("Admin", "Manager"));
        ROLE_ACCESS_MAP.put("/warehouse", adminManager);
        ROLE_ACCESS_MAP.put("/warehouses", adminManager);
        ROLE_ACCESS_MAP.put("/location", adminManager);
        ROLE_ACCESS_MAP.put("/locations", adminManager);
        ROLE_ACCESS_MAP.put("/category/add", adminManager);
        ROLE_ACCESS_MAP.put("/category/edit", adminManager);
        ROLE_ACCESS_MAP.put("/category/delete", adminManager);
        ROLE_ACCESS_MAP.put("/product/add", adminManager);
        ROLE_ACCESS_MAP.put("/product/edit", adminManager);
        ROLE_ACCESS_MAP.put("/product/toggle", adminManager);
        
        // Admin, Manager, Staff routes (warehouse operations)
        Set<String> warehouseStaff = new HashSet<>(Arrays.asList("Admin", "Manager", "Staff"));
        ROLE_ACCESS_MAP.put("/inbound", warehouseStaff);
        ROLE_ACCESS_MAP.put("/outbound", warehouseStaff);
        ROLE_ACCESS_MAP.put("/transfer", warehouseStaff);
        ROLE_ACCESS_MAP.put("/movement", warehouseStaff);
        ROLE_ACCESS_MAP.put("/inventory", warehouseStaff);
        
        // Sales routes
        Set<String> salesAccess = new HashSet<>(Arrays.asList("Admin", "Manager", "Sales"));
        ROLE_ACCESS_MAP.put("/sales-order", salesAccess);
        ROLE_ACCESS_MAP.put("/customer", salesAccess);
        ROLE_ACCESS_MAP.put("/customers", salesAccess);
        
        // All authenticated users
        Set<String> allRoles = new HashSet<>(Arrays.asList("Admin", "Manager", "Staff", "Sales"));
        ROLE_ACCESS_MAP.put("/dashboard", allRoles);
        ROLE_ACCESS_MAP.put("/profile", allRoles);
        ROLE_ACCESS_MAP.put("/product", allRoles);
        ROLE_ACCESS_MAP.put("/category", allRoles);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Check if path is public
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check for root path - let index.jsp handle it
        if (path.isEmpty() || path.equals("/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Get session (don't create new one)
        HttpSession session = httpRequest.getSession(false);
        
        // Step 1-2: Check if session exists
        if (session == null || session.getAttribute("user") == null) {
            // No session - redirect to login
            redirectToLogin(httpRequest, httpResponse, false);
            return;
        }
        
        // Step 3: Check session validity (timeout)
        Long lastActivityTime = (Long) session.getAttribute("lastActivityTime");
        long currentTime = System.currentTimeMillis();
        
        if (lastActivityTime != null) {
            long elapsedTime = currentTime - lastActivityTime;
            
            // Step 3: If elapsed time > 30 minutes → Session Expired (A1)
            if (elapsedTime > SESSION_TIMEOUT_MS) {
                // Invalidate expired session
                session.invalidate();
                // Redirect to login with expired message
                redirectToLogin(httpRequest, httpResponse, true);
                return;
            }
        }
        
        // Step 2: Update activity timestamp (Step 2 of UC-AUTH-005)
        session.setAttribute("lastActivityTime", currentTime);
        
        // Role-based access control
        User user = (User) session.getAttribute("user");
        if (!hasAccess(path, user.getRole())) {
            // User doesn't have access to this resource
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        // Step 4: Process Request - Session is valid, continue with request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
    
    /**
     * Check if the path is public (doesn't require authentication)
     */
    private boolean isPublicPath(String path) {
        // Check exact match or starts with public path
        for (String publicPath : PUBLIC_PATHS) {
            if (path.equals(publicPath) || path.startsWith(publicPath + "/") || path.startsWith(publicPath + "?")) {
                return true;
            }
        }
        
        // Check for static resources
        if (path.endsWith(".css") || path.endsWith(".js") || 
            path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".jpeg") ||
            path.endsWith(".gif") || path.endsWith(".ico") || path.endsWith(".svg") ||
            path.endsWith(".woff") || path.endsWith(".woff2") || path.endsWith(".ttf") ||
            path.endsWith(".eot")) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Check if user role has access to the requested path
     */
    private boolean hasAccess(String path, String role) {
        // Find matching path in access map
        for (Map.Entry<String, Set<String>> entry : ROLE_ACCESS_MAP.entrySet()) {
            String pattern = entry.getKey();
            if (path.equals(pattern) || path.startsWith(pattern + "/") || path.startsWith(pattern + "?")) {
                return entry.getValue().contains(role);
            }
        }
        
        // If no specific rule found, allow all authenticated users
        return true;
    }
    
    /**
     * Redirect to login page
     */
    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response, boolean expired)
            throws IOException {
        
        String contextPath = request.getContextPath();
        
        // Check if AJAX request
        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(xRequestedWith)) {
            // Return 401 for AJAX requests
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Session expired\", \"redirect\": \"" + 
                contextPath + "/auth?action=login&expired=true\"}");
            return;
        }
        
        // Regular redirect for page requests
        if (expired) {
            response.sendRedirect(contextPath + "/auth?action=login&expired=true");
        } else {
            response.sendRedirect(contextPath + "/auth?action=login");
        }
    }
}
