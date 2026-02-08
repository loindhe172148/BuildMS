<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Dashboard" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard" />
            </jsp:include>
            
            <!-- Layout container -->
            <div class="layout-page">
                
                <!-- Navbar -->
                <jsp:include page="/WEB-INF/common/navbar.jsp" />
                
                <!-- Content wrapper -->
                <div class="content-wrapper">
                    <!-- Content -->
                    <main class="container-xxl flex-grow-1 container-p-y" role="main">
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <!-- Welcome Card -->
                        <div class="row">
                            <div class="col-xxl-8 mb-6 order-0">
                                <div class="card">
                                    <div class="d-flex align-items-start row">
                                        <div class="col-sm-7">
                                            <div class="card-body">
                                                <h5 class="card-title text-primary mb-3">
                                                    Welcome back, ${sessionScope.user.name != null ? sessionScope.user.name : sessionScope.user.username}! 👋
                                                </h5>
                                                <p class="mb-6">
                                                    You are logged in as <strong>${sessionScope.user.role}</strong>.<br />
                                                    Manage your warehouse operations from this dashboard.
                                                </p>
                                                <a href="${contextPath}/inventory?action=byWarehouse" class="btn btn-sm btn-outline-primary">
                                                    View Inventory
                                                </a>
                                            </div>
                                        </div>
                                        <div class="col-sm-5 text-center text-sm-left">
                                            <div class="card-body pb-0 px-0 px-md-6">
                                                <img src="${contextPath}/assets/img/illustrations/man-with-laptop.png" 
                                                     height="175" alt="View Badge User" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Quick Stats -->
                            <div class="col-xxl-4 col-lg-12 col-md-4 order-1">
                                <div class="row">
                                    <div class="col-lg-6 col-md-12 col-6 mb-6">
                                        <div class="card h-100">
                                            <div class="card-body">
                                                <div class="card-title d-flex align-items-start justify-content-between mb-4">
                                                    <div class="avatar flex-shrink-0">
                                                        <span class="avatar-initial rounded bg-label-primary">
                                                            <i class="bx bx-package"></i>
                                                        </span>
                                                    </div>
                                                </div>
                                                <p class="mb-1">Products</p>
                                                <h4 class="card-title mb-3">${totalProducts != null ? totalProducts : 0}</h4>
                                                <small class="text-success fw-medium">
                                                    <a href="${contextPath}/product?action=list">View all</a>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-12 col-6 mb-6">
                                        <div class="card h-100">
                                            <div class="card-body">
                                                <div class="card-title d-flex align-items-start justify-content-between mb-4">
                                                    <div class="avatar flex-shrink-0">
                                                        <span class="avatar-initial rounded bg-label-success">
                                                            <i class="bx bx-building-house"></i>
                                                        </span>
                                                    </div>
                                                </div>
                                                <p class="mb-1">Warehouses</p>
                                                <h4 class="card-title mb-3">${totalWarehouses != null ? totalWarehouses : 0}</h4>
                                                <small class="text-success fw-medium">
                                                    <a href="${contextPath}/warehouse?action=list">View all</a>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Second Row Stats -->
                        <div class="row">
                            <div class="col-lg-3 col-md-6 col-6 mb-6">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <div class="card-title d-flex align-items-start justify-content-between mb-4">
                                            <div class="avatar flex-shrink-0">
                                                <span class="avatar-initial rounded bg-label-info">
                                                    <i class="bx bx-log-in-circle"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <p class="mb-1">Pending Inbound</p>
                                        <h4 class="card-title mb-3">${pendingInbound != null ? pendingInbound : 0}</h4>
                                        <small><a href="${contextPath}/inbound?action=list&status=Created">View pending</a></small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-6 mb-6">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <div class="card-title d-flex align-items-start justify-content-between mb-4">
                                            <div class="avatar flex-shrink-0">
                                                <span class="avatar-initial rounded bg-label-warning">
                                                    <i class="bx bx-log-out-circle"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <p class="mb-1">Pending Outbound</p>
                                        <h4 class="card-title mb-3">${pendingOutbound != null ? pendingOutbound : 0}</h4>
                                        <small><a href="${contextPath}/outbound?action=list&status=Created">View pending</a></small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-6 mb-6">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <div class="card-title d-flex align-items-start justify-content-between mb-4">
                                            <div class="avatar flex-shrink-0">
                                                <span class="avatar-initial rounded bg-label-danger">
                                                    <i class="bx bx-error-circle"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <p class="mb-1">Low Stock Items</p>
                                        <h4 class="card-title mb-3">${lowStockItems != null ? lowStockItems : 0}</h4>
                                        <small><a href="${contextPath}/inventory?action=lowStock">View items</a></small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-6 mb-6">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <div class="card-title d-flex align-items-start justify-content-between mb-4">
                                            <div class="avatar flex-shrink-0">
                                                <span class="avatar-initial rounded bg-label-secondary">
                                                    <i class="bx bx-category"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <p class="mb-1">Categories</p>
                                        <h4 class="card-title mb-3">${totalCategories != null ? totalCategories : 0}</h4>
                                        <small><a href="${contextPath}/category?action=list">View all</a></small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Recent Activity -->
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center justify-content-between">
                                        <h5 class="card-title mb-0">Recent Requests</h5>
                                        <div>
                                            <a href="${contextPath}/inbound?action=list" class="btn btn-sm btn-outline-primary me-2">
                                                Inbound
                                            </a>
                                            <a href="${contextPath}/outbound?action=list" class="btn btn-sm btn-outline-primary">
                                                Outbound
                                            </a>
                                        </div>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Request ID</th>
                                                    <th>Type</th>
                                                    <th>Status</th>
                                                    <th>Created</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty recentRequests}">
                                                        <c:forEach var="request" items="${recentRequests}">
                                                            <tr>
                                                                <td><strong>${request.requestId}</strong></td>
                                                                <td>
                                                                    <span class="badge bg-label-${request.type == 'Inbound' ? 'info' : 'warning'}">
                                                                        ${request.type}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-label-${request.status == 'Completed' ? 'success' : 
                                                                                                  request.status == 'Rejected' ? 'danger' : 
                                                                                                  request.status == 'InProgress' ? 'primary' : 'secondary'}">
                                                                        ${request.status}
                                                                    </span>
                                                                </td>
                                                                <td>${request.createdDate}</td>
                                                                <td>
                                                                    <a href="${contextPath}/${request.type == 'Inbound' ? 'inbound' : 'outbound'}?action=view&id=${request.requestId}" 
                                                                       class="btn btn-sm btn-outline-primary">
                                                                        View
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="5" class="text-center text-muted py-4">
                                                                <i class="bx bx-folder-open" style="font-size: 2rem;"></i>
                                                                <p class="mb-0 mt-2">No recent requests</p>
                                                            </td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                    </main>
                    <!-- / Content -->
                    
                    <!-- Footer -->
                    <jsp:include page="/WEB-INF/common/footer.jsp" />
                    
                    <div class="content-backdrop fade"></div>
                </div>
                <!-- Content wrapper -->
            </div>
            <!-- / Layout page -->
        </div>

        <!-- Overlay -->
        <div class="layout-overlay layout-menu-toggle"></div>
    </div>
    <!-- / Layout wrapper -->

    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
