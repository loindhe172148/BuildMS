<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Product Details" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="products" />
                <jsp:param name="activeSubMenu" value="product-list" />
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
                                    <a href="${contextPath}/product?action=list">Products</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">${product.sku}</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <div>
                                <h4 class="mb-1">
                                    <i class="bx bx-package" aria-hidden="true me-2"></i>${product.name}
                                </h4>
                                <span class="text-muted">SKU: ${product.sku}</span>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="${contextPath}/product?action=list" class="btn btn-outline-secondary">
                                    <i class="bx bx-arrow-back me-1"></i>Back to List
                                </a>
                                <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                    <a href="${contextPath}/product?action=edit&id=${product.id}" class="btn btn-primary">
                                        <i class="bx bx-edit me-1"></i>Edit Product
                                    </a>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="row">
                            <!-- Product Information Card -->
                            <div class="col-md-6 col-lg-4 mb-6">
                                <div class="card h-100">
                                    <div class="card-header pb-0">
                                        <h5 class="mb-0">
                                            <i class="bx bx-info-circle me-2"></i>Product Information
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <ul class="list-unstyled mb-0">
                                            <li class="mb-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="flex-shrink-0 me-3">
                                                        <span class="avatar avatar-sm bg-label-primary rounded">
                                                            <i class="bx bx-barcode"></i>
                                                        </span>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <small class="text-muted d-block">SKU</small>
                                                        <span class="fw-medium">${product.sku}</span>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="mb-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="flex-shrink-0 me-3">
                                                        <span class="avatar avatar-sm bg-label-info rounded">
                                                            <i class="bx bx-category"></i>
                                                        </span>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <small class="text-muted d-block">Category</small>
                                                        <span class="fw-medium">
                                                            <c:choose>
                                                                <c:when test="${not empty category}">
                                                                    ${category.name}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Unknown</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="mb-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="flex-shrink-0 me-3">
                                                        <span class="avatar avatar-sm bg-label-secondary rounded">
                                                            <i class="bx bx-ruler"></i>
                                                        </span>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <small class="text-muted d-block">Unit of Measure</small>
                                                        <span class="fw-medium">
                                                            <c:choose>
                                                                <c:when test="${not empty product.unit}">
                                                                    ${product.unit}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Not specified</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="mb-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="flex-shrink-0 me-3">
                                                        <span class="avatar avatar-sm bg-label-${product.active ? 'success' : 'warning'} rounded">
                                                            <i class="bx ${product.active ? 'bx-check-circle' : 'bx-block'}"></i>
                                                        </span>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <small class="text-muted d-block">Status</small>
                                                        <span class="badge bg-${product.active ? 'success' : 'secondary'}">
                                                            ${product.active ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </div>
                                                </div>
                                            </li>
                                            <li>
                                                <div class="d-flex align-items-center">
                                                    <div class="flex-shrink-0 me-3">
                                                        <span class="avatar avatar-sm bg-label-dark rounded">
                                                            <i class="bx bx-calendar"></i>
                                                        </span>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <small class="text-muted d-block">Created Date</small>
                                                        <span class="fw-medium">
                                                            <c:choose>
                                                                <c:when test="${not empty product.createdAt}">
                                                                    ${product.createdAt}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Unknown</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Inventory Summary Card (Not visible for Sales role) -->
                            <c:if test="${currentUser.role != 'Sales'}">
                                <div class="col-md-6 col-lg-4 mb-6">
                                    <div class="card h-100">
                                        <div class="card-header pb-0">
                                            <h5 class="mb-0">
                                                <i class="bx bx-box me-2"></i>Inventory Summary
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="d-flex justify-content-center mb-4">
                                                <div class="text-center">
                                                    <div class="avatar avatar-xl bg-label-primary mb-3">
                                                        <span class="fs-3">${totalInventory}</span>
                                                    </div>
                                                    <h6 class="mb-0">Total Quantity</h6>
                                                    <small class="text-muted">across all locations</small>
                                                </div>
                                            </div>
                                            
                                            <c:if test="${totalInventory == 0}">
                                                <div class="alert alert-secondary mb-0 text-center">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    No inventory for this product yet.
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${pendingOrders > 0}">
                                                <div class="alert alert-info mb-0 mt-3">
                                                    <i class="bx bx-time-five me-1"></i>
                                                    <strong>${pendingOrders}</strong> pending order(s) contain this product.
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <!-- Quick Actions Card (Admin/Manager only) -->
                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                <div class="col-md-6 col-lg-4 mb-6">
                                    <div class="card h-100">
                                        <div class="card-header pb-0">
                                            <h5 class="mb-0">
                                                <i class="bx bx-bolt me-2"></i>Quick Actions
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="d-grid gap-3">
                                                <a href="${contextPath}/product?action=edit&id=${product.id}" 
                                                   class="btn btn-outline-primary">
                                                    <i class="bx bx-edit me-1"></i>Edit Product
                                                </a>
                                                <button type="button" 
                                                        class="btn ${product.active ? 'btn-outline-warning' : 'btn-outline-success'}"
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#toggleModal">
                                                    <i class="bx ${product.active ? 'bx-block' : 'bx-check'} me-1"></i>
                                                    ${product.active ? 'Deactivate' : 'Activate'} Product
                                                </button>
                                            </div>
                                            
                                            <hr class="my-4" />
                                            
                                            <div class="text-center">
                                                <small class="text-muted">
                                                    <c:choose>
                                                        <c:when test="${product.active}">
                                                            <i class="bx bx-check-circle text-success me-1"></i>
                                                            Product is available for orders
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bx bx-block text-warning me-1"></i>
                                                            Product cannot be added to new orders
                                                        </c:otherwise>
                                                    </c:choose>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Inventory Details Section (Not visible for Sales role) -->
                        <c:if test="${currentUser.role != 'Sales' && totalInventory > 0}">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bx bx-map-pin me-2"></i>Inventory by Location
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <p class="text-muted mb-0">
                                        <i class="bx bx-info-circle me-1"></i>
                                        Detailed inventory breakdown by warehouse and location will be shown here. 
                                        Navigate to the Inventory section to view and manage stock levels.
                                    </p>
                                    <div class="mt-3">
                                        <a href="${contextPath}/inventory?action=byProduct&productId=${product.id}" 
                                           class="btn btn-outline-primary btn-sm">
                                            <i class="bx bx-search me-1"></i>View Inventory Details
                                        </a>
                                    </div>
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
    
    <!-- Toggle Status Confirmation Modal -->
    <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
        <div class="modal fade" id="toggleModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bx bx-info-circle text-warning me-2"></i>Confirm Status Change
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>
                            Are you sure you want to 
                            <strong>${product.active ? 'deactivate' : 'activate'}</strong> 
                            product "<strong>${product.name}</strong>"?
                        </p>
                        <c:if test="${product.active}">
                            <div class="alert alert-warning mb-0">
                                <i class="bx bx-info-circle me-1"></i>
                                Inactive products cannot be added to new orders or requests. Existing orders will not be affected.
                            </div>
                        </c:if>
                        <c:if test="${product.active && pendingOrders > 0}">
                            <div class="alert alert-info mt-3 mb-0">
                                <i class="bx bx-time-five me-1"></i>
                                This product is in <strong>${pendingOrders}</strong> pending order(s). 
                                These orders can still be processed.
                            </div>
                        </c:if>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="${contextPath}/product?action=toggle&id=${product.id}" 
                           class="btn ${product.active ? 'btn-warning' : 'btn-success'}">
                            <i class="bx bx-check me-1"></i>${product.active ? 'Deactivate' : 'Activate'}
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
