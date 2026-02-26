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
        <jsp:param name="pageTitle" value="Cancel Sales Order" />
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
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/sales-order?action=view&id=${order.id}">${order.orderNo}</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Cancel Order</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bx bx-error-circle me-2"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="mb-0">
                                <i class="bx bx-x-circle me-2 text-danger"></i>Cancel Sales Order
                            </h4>
                        </div>
                        
                        <c:choose>
                            <c:when test="${cancellationStatus.canCancel == false}">
                                <div class="alert alert-danger">
                                    <i class="bx bx-error-circle me-2"></i>
                                    ${cancellationStatus.reason}
                                </div>
                                <a href="${contextPath}/sales-order?action=view&id=${order.id}" class="btn btn-outline-secondary">
                                    <i class="bx bx-arrow-back me-1"></i> Back to Order
                                </a>
                            </c:when>
                            <c:otherwise>
                                <!-- Order Summary -->
                                <div class="card mb-4">
                                    <div class="card-header bg-danger text-white">
                                        <h5 class="mb-0">
                                            <i class="bx bx-error-circle me-2"></i>Confirm Cancellation
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <p><strong>Order No:</strong> ${order.orderNo}</p>
                                                <p><strong>Customer:</strong> ${customer.name}</p>
                                            </div>
                                            <div class="col-md-6">
                                                <p><strong>Current Status:</strong> 
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
                                                        <c:otherwise>
                                                            <span class="badge bg-label-secondary">${order.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                        
                                        <!-- Warnings -->
                                        <c:if test="${not empty cancellationStatus.warnings}">
                                            <div class="alert alert-warning mb-3">
                                                <h6 class="alert-heading">
                                                    <i class="bx bx-error me-1"></i> Warnings
                                                </h6>
                                                <ul class="mb-0">
                                                    <c:forEach var="warning" items="${cancellationStatus.warnings}">
                                                        <li>${warning}</li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>
                                        
                                        <form method="post" action="${contextPath}/sales-order" id="cancelForm">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="id" value="${order.id}">
                                            
                                            <div class="mb-3">
                                                <label for="reason" class="form-label">
                                                    Cancellation Reason <span class="text-danger">*</span>
                                                </label>
                                                <textarea id="reason" name="reason" class="form-control" 
                                                          rows="3" required 
                                                          placeholder="Please provide a reason for cancelling this order..."></textarea>
                                            </div>
                                            
                                            <c:if test="${cancellationStatus.requiresConfirmation}">
                                                <div class="mb-3 form-check">
                                                    <input type="checkbox" class="form-check-input" id="confirmCheck" required>
                                                    <label class="form-check-label" for="confirmCheck">
                                                        I understand there are active outbound requests that need manual handling
                                                    </label>
                                                </div>
                                            </c:if>
                                            
                                            <div class="d-flex justify-content-end gap-2">
                                                <a href="${contextPath}/sales-order?action=view&id=${order.id}" class="btn btn-outline-secondary">
                                                    <i class="bx bx-arrow-back me-1"></i> Back to Order
                                                </a>
                                                <button type="submit" class="btn btn-danger">
                                                    <i class="bx bx-x-circle me-1"></i> Cancel Order
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
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
