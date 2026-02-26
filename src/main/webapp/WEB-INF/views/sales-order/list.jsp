<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Sales Orders" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="sales-orders" />
                <jsp:param name="activeSubMenu" value="sales-order-list" />
            </jsp:include>
            
            <!-- Layout container -->
            <div class="layout-page">
                
                <!-- Navbar -->
                <jsp:include page="/WEB-INF/common/navbar.jsp" />
                
                <!-- Content wrapper -->
                <div class="content-wrapper">
                    <!-- Content -->
                    <main class="container-xxl flex-grow-1 container-p-y" role="main">
                        
                        <!-- Breadcrumb -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/dashboard">Dashboard</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Sales Orders</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <c:if test="${not empty param.success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bx bx-check-circle me-2"></i>
                                ${param.success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="mb-0">
                                <i class="bx bx-cart me-2"></i>Sales Orders
                            </h4>
                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Sales'}">
                                <a href="${contextPath}/sales-order?action=create" class="btn btn-primary">
                                    <i class="bx bx-plus me-1"></i> Create Order
                                </a>
                            </c:if>
                        </div>
                        
                        <!-- Filter -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form method="get" action="${contextPath}/sales-order" class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Status</label>
                                        <select name="status" class="form-select">
                                            <option value="">All Status</option>
                                            <option value="Draft" ${selectedStatus == 'Draft' ? 'selected' : ''}>Draft</option>
                                            <option value="Confirmed" ${selectedStatus == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                            <option value="FulfillmentRequested" ${selectedStatus == 'FulfillmentRequested' ? 'selected' : ''}>Fulfillment Requested</option>
                                            <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                            <option value="Cancelled" ${selectedStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2 d-flex align-items-end">
                                        <button type="submit" class="btn btn-outline-primary">
                                            <i class="bx bx-filter-alt me-1"></i> Filter
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Orders Table -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Order List</h5>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Order No</th>
                                            <th>Customer</th>
                                            <th>Status</th>
                                            <th>Created By</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty orders}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-4">
                                                        <i class="bx bx-info-circle me-1"></i> No sales orders found
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="orderData" items="${orders}">
                                                    <tr>
                                                        <td>
                                                            <strong>${orderData.order.orderNo}</strong>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty orderData.customer}">
                                                                ${orderData.customer.name}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${orderData.order.status == 'Draft'}">
                                                                    <span class="badge bg-label-secondary">Draft</span>
                                                                </c:when>
                                                                <c:when test="${orderData.order.status == 'Confirmed'}">
                                                                    <span class="badge bg-label-info">Confirmed</span>
                                                                </c:when>
                                                                <c:when test="${orderData.order.status == 'FulfillmentRequested'}">
                                                                    <span class="badge bg-label-warning">Fulfillment Requested</span>
                                                                </c:when>
                                                                <c:when test="${orderData.order.status == 'Completed'}">
                                                                    <span class="badge bg-label-success">Completed</span>
                                                                </c:when>
                                                                <c:when test="${orderData.order.status == 'Cancelled'}">
                                                                    <span class="badge bg-label-danger">Cancelled</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-label-secondary">${orderData.order.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty orderData.creator}">
                                                                ${orderData.creator.fullName}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <fmt:parseDate value="${orderData.order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>
                                                            <div class="dropdown">
                                                                <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown" aria-label="More actions">
                                                                    <i class="bx bx-dots-vertical-rounded" aria-hidden="true"></i>
                                                                </button>
                                                                <div class="dropdown-menu">
                                                                    <a class="dropdown-item" href="${contextPath}/sales-order?action=view&id=${orderData.order.id}">
                                                                        <i class="bx bx-show me-1"></i> View Details
                                                                    </a>
                                                                    
                                                                    <c:if test="${orderData.order.status == 'Draft' && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Sales')}">
                                                                        <form action="${contextPath}/sales-order" method="post" style="display: inline;">
                                                                            <input type="hidden" name="action" value="confirm">
                                                                            <input type="hidden" name="id" value="${orderData.order.id}">
                                                                            <button type="submit" class="dropdown-item">
                                                                                <i class="bx bx-check-circle me-1"></i> Confirm Order
                                                                            </button>
                                                                        </form>
                                                                    </c:if>
                                                                    
                                                                    <c:if test="${orderData.order.status == 'Confirmed' && (currentUser.role == 'Admin' || currentUser.role == 'Manager')}">
                                                                        <a class="dropdown-item" href="${contextPath}/sales-order?action=generate-outbound&id=${orderData.order.id}">
                                                                            <i class="bx bx-export me-1"></i> Generate Outbound
                                                                        </a>
                                                                    </c:if>
                                                                    
                                                                    <c:if test="${orderData.order.status != 'Completed' && orderData.order.status != 'Cancelled' && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Sales')}">
                                                                        <a class="dropdown-item text-danger" href="${contextPath}/sales-order?action=cancel&id=${orderData.order.id}">
                                                                            <i class="bx bx-x-circle me-1"></i> Cancel Order
                                                                        </a>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                    </div>
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
    
    <!-- Core JS -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
