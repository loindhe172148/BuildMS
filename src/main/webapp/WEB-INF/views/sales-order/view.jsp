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
        <jsp:param name="pageTitle" value="Sales Order Details" />
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
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/sales-order">Sales Orders</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">${order.orderNo}</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bx bx-check-circle me-2"></i>
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
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
                                <i class="bx bx-cart me-2"></i>Sales Order: ${order.orderNo}
                            </h4>
                            <div class="d-flex gap-2">
                                <a href="${contextPath}/sales-order" class="btn btn-outline-secondary">
                                    <i class="bx bx-arrow-back me-1"></i> Back to List
                                </a>
                                
                                <c:if test="${order.status == 'Draft' && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Sales')}">
                                    <form action="${contextPath}/sales-order" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="confirm">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <button type="submit" class="btn btn-success">
                                            <i class="bx bx-check-circle me-1"></i> Confirm Order
                                        </button>
                                    </form>
                                </c:if>
                                
                                <c:if test="${order.status == 'Confirmed' && (currentUser.role == 'Admin' || currentUser.role == 'Manager')}">
                                    <a href="${contextPath}/sales-order?action=generate-outbound&id=${order.id}" class="btn btn-primary">
                                        <i class="bx bx-export me-1"></i> Generate Outbound
                                    </a>
                                </c:if>
                                
                                <c:if test="${order.status != 'Completed' && order.status != 'Cancelled' && (currentUser.role == 'Admin' || currentUser.role == 'Manager' || currentUser.role == 'Sales')}">
                                    <a href="${contextPath}/sales-order?action=cancel&id=${order.id}" class="btn btn-outline-danger">
                                        <i class="bx bx-x-circle me-1"></i> Cancel Order
                                    </a>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="row">
                            <!-- Order Info -->
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="mb-0">Order Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <table class="table table-borderless">
                                            <tr>
                                                <th width="40%">Order No:</th>
                                                <td><strong>${order.orderNo}</strong></td>
                                            </tr>
                                            <tr>
                                                <th>Status:</th>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.status == 'Draft'}">
                                                            <span class="badge bg-label-secondary">Draft</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Confirmed'}">
                                                            <span class="badge bg-label-info">Confirmed</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'FulfillmentRequested'}">
                                                            <span class="badge bg-label-warning">Fulfillment Requested</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Completed'}">
                                                            <span class="badge bg-label-success">Completed</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Cancelled'}">
                                                            <span class="badge bg-label-danger">Cancelled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-label-secondary">${order.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Created By:</th>
                                                <td>
                                                    <c:if test="${not empty creator}">
                                                        ${creator.fullName}
                                                    </c:if>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Created At:</th>
                                                <td>
                                                    <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                            </tr>
                                            <c:if test="${not empty order.confirmedDate}">
                                                <tr>
                                                    <th>Confirmed At:</th>
                                                    <td>
                                                        <fmt:parseDate value="${order.confirmedDate}" pattern="yyyy-MM-dd'T'HH:mm" var="confirmedDate" type="both" />
                                                        <fmt:formatDate value="${confirmedDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${order.status == 'Cancelled'}">
                                                <tr>
                                                    <th>Cancelled At:</th>
                                                    <td>
                                                        <fmt:parseDate value="${order.cancelledDate}" pattern="yyyy-MM-dd'T'HH:mm" var="cancelledDate" type="both" />
                                                        <fmt:formatDate value="${cancelledDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Cancellation Reason:</th>
                                                    <td class="text-danger">${order.cancellationReason}</td>
                                                </tr>
                                            </c:if>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Customer Info -->
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="mb-0">Customer Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <table class="table table-borderless">
                                            <tr>
                                                <th width="40%">Customer Code:</th>
                                                <td>${customer.code}</td>
                                            </tr>
                                            <tr>
                                                <th>Customer Name:</th>
                                                <td><strong>${customer.name}</strong></td>
                                            </tr>
                                            <tr>
                                                <th>Contact Info:</th>
                                                <td>${customer.contactInfo}</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Order Items -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Order Items</h5>
                            </div>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Product</th>
                                            <th>SKU</th>
                                            <th>Unit</th>
                                            <th class="text-end">Quantity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="itemData" items="${items}" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td><strong>${itemData.product.name}</strong></td>
                                                <td>${itemData.product.sku}</td>
                                                <td>${itemData.product.unit}</td>
                                                <td class="text-end">${itemData.item.quantity}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Related Requests -->
                        <c:if test="${not empty relatedRequests}">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Related Outbound Requests</h5>
                                </div>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Request ID</th>
                                                <th>Type</th>
                                                <th>Status</th>
                                                <th>Created At</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="req" items="${relatedRequests}">
                                                <tr>
                                                    <td>#${req.id}</td>
                                                    <td>${req.type}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${req.status == 'Created'}">
                                                                <span class="badge bg-label-secondary">Created</span>
                                                            </c:when>
                                                            <c:when test="${req.status == 'Approved'}">
                                                                <span class="badge bg-label-info">Approved</span>
                                                            </c:when>
                                                            <c:when test="${req.status == 'InProgress'}">
                                                                <span class="badge bg-label-warning">In Progress</span>
                                                            </c:when>
                                                            <c:when test="${req.status == 'Completed'}">
                                                                <span class="badge bg-label-success">Completed</span>
                                                            </c:when>
                                                            <c:when test="${req.status == 'Rejected'}">
                                                                <span class="badge bg-label-danger">Rejected</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-label-secondary">${req.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:parseDate value="${req.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="reqDate" type="both" />
                                                        <fmt:formatDate value="${reqDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td>
                                                        <a href="${contextPath}/outbound?action=view&id=${req.id}" class="btn btn-sm btn-outline-primary">
                                                            <i class="bx bx-show"></i> View
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:if>
                        
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
