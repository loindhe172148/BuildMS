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
        <jsp:param name="pageTitle" value="Generate Outbound Request" />
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
                                <li class="breadcrumb-item active" aria-current="page">Generate Outbound</li>
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
                                <i class="bx bx-export me-2"></i>Generate Outbound Request
                            </h4>
                        </div>
                        
                        <!-- Order Summary -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Order Summary</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>Order No:</strong> ${order.orderNo}</p>
                                        <p><strong>Customer:</strong> ${customer.name}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Status:</strong> 
                                            <span class="badge bg-label-info">Confirmed</span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Warehouse Selection -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Step 1: Select Source Warehouse</h5>
                            </div>
                            <div class="card-body">
                                <form method="get" action="${contextPath}/sales-order">
                                    <input type="hidden" name="action" value="generate-outbound">
                                    <input type="hidden" name="id" value="${order.id}">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label class="form-label">Source Warehouse <span class="text-danger">*</span></label>
                                            <select name="warehouseId" class="form-select" onchange="this.form.submit()">
                                                <option value="">Select Warehouse</option>
                                                <c:forEach var="warehouse" items="${warehouses}">
                                                    <option value="${warehouse.id}" ${selectedWarehouseId == warehouse.id ? 'selected' : ''}>
                                                        ${warehouse.name} (${warehouse.code})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Availability Check & Fulfillment -->
                        <c:if test="${not empty availability}">
                            <form method="post" action="${contextPath}/sales-order">
                                <input type="hidden" name="action" value="generate-outbound">
                                <input type="hidden" name="id" value="${order.id}">
                                <input type="hidden" name="warehouseId" value="${selectedWarehouseId}">
                                
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="mb-0">Step 2: Review Availability & Specify Quantities</h5>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>Product</th>
                                                    <th>SKU</th>
                                                    <th class="text-end">Ordered Qty</th>
                                                    <th class="text-end">Available</th>
                                                    <th class="text-end">Fulfill Qty</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="avail" items="${availability}">
                                                    <tr class="${avail.sufficient ? '' : 'table-warning'}">
                                                        <td>
                                                            <strong>${avail.product.name}</strong>
                                                            <input type="hidden" name="productId[]" value="${avail.product.id}">
                                                        </td>
                                                        <td>${avail.product.sku}</td>
                                                        <td class="text-end">${avail.requested}</td>
                                                        <td class="text-end">
                                                            <c:choose>
                                                                <c:when test="${avail.available < avail.requested}">
                                                                    <span class="text-danger">${avail.available}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-success">${avail.available}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end" style="width: 120px;">
                                                            <input type="number" 
                                                                   name="fulfillQuantity[]" 
                                                                   class="form-control form-control-sm text-end" 
                                                                   min="0" 
                                                                   max="${avail.requested}"
                                                                   value="${avail.available >= avail.requested ? avail.requested : avail.available}">
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${avail.sufficient}">
                                                                    <span class="badge bg-label-success">
                                                                        <i class="bx bx-check"></i> Sufficient
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-label-warning">
                                                                        <i class="bx bx-error"></i> Insufficient
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <!-- Actions -->
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="${contextPath}/sales-order?action=view&id=${order.id}" class="btn btn-outline-secondary">
                                        <i class="bx bx-x me-1"></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bx bx-export me-1"></i> Generate Outbound Request
                                    </button>
                                </div>
                            </form>
                        </c:if>
                        
                        <c:if test="${empty availability && empty selectedWarehouseId}">
                            <div class="alert alert-info">
                                <i class="bx bx-info-circle me-2"></i>
                                Please select a source warehouse to check inventory availability.
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
