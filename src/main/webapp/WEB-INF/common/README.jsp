<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
    Base Layout Template for Smart WMS
    
    This layout provides a complete page structure with sidebar, navbar, and footer.
    
    USAGE IN CHILD PAGES:
    =====================
    
    Option 1: Using jsp:include with layout.jsp (recommended for complex pages)
    ---------------------------------------------------------------------------
    <jsp:include page="/WEB-INF/common/layout.jsp">
        <jsp:param name="pageTitle" value="Page Title" />
        <jsp:param name="activeMenu" value="products" />
        <jsp:param name="activeSubMenu" value="product-list" />
        <jsp:param name="contentPage" value="/WEB-INF/views/product/content.jsp" />
    </jsp:include>
    
    
    Option 2: Manual includes (for simple pages or when you need more control)
    --------------------------------------------------------------------------
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!DOCTYPE html>
    <html lang="en" class="layout-menu-fixed layout-compact">
    <head>
        <jsp:include page="/WEB-INF/common/head.jsp">
            <jsp:param name="pageTitle" value="Page Title" />
        </jsp:include>
    </head>
    <body>
        <div class="layout-wrapper layout-content-navbar">
            <div class="layout-container">
                <jsp:include page="/WEB-INF/common/sidebar.jsp">
                    <jsp:param name="activeMenu" value="products" />
                </jsp:include>
                <div class="layout-page">
                    <jsp:include page="/WEB-INF/common/navbar.jsp" />
                    <div class="content-wrapper">
                        <div class="container-xxl flex-grow-1 container-p-y">
                            <!-- Your page content here -->
                        </div>
                        <jsp:include page="/WEB-INF/common/footer.jsp" />
                        <div class="content-backdrop fade"></div>
                    </div>
                </div>
            </div>
            <div class="layout-overlay layout-menu-toggle"></div>
        </div>
        <jsp:include page="/WEB-INF/common/scripts.jsp" />
    </body>
    </html>
    
    
    AVAILABLE PARAMETERS:
    ====================
    
    head.jsp:
    - pageTitle: The page title (shown in browser tab)
    - pageCss: Additional CSS file path (e.g., "/assets/css/custom.css")
    
    sidebar.jsp:
    - activeMenu: Main menu item to highlight
      Values: dashboard, products, categories, inventory, warehouses, locations,
              inbound, outbound, movement, customers, sales-orders, users, suppliers,
              profile, change-password
    - activeSubMenu: Sub-menu item to highlight
      Values: product-list, product-add, category-list, category-add, etc.
    
    scripts.jsp:
    - pageScript: Additional JS file path (e.g., "/assets/js/custom.js")
    
    layout.jsp (includes all above):
    - All parameters from head.jsp, sidebar.jsp, scripts.jsp
    - contentPage: Path to the content JSP file (required)
    - breadcrumb: Set to "true" to show breadcrumb navigation
    
    
    ALERT MESSAGES:
    ===============
    Set these request attributes in your servlet to show alerts:
    - successMessage: Green success alert
    - errorMessage: Red error alert  
    - warningMessage: Yellow warning alert
    - infoMessage: Blue info alert
    
    Example in Servlet:
    request.setAttribute("successMessage", "Product created successfully!");
    
--%>
