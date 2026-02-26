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
        <jsp:param name="pageTitle" value="Inventory by Product" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="inventory" />
                <jsp:param name="activeSubMenu" value="inventory-product" />
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
                                <li class="breadcrumb-item">Inventory</li>
                                <li class="breadcrumb-item active" aria-current="page">By Product</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-package me-2"></i>Inventory by Product
                            </h4>
                            <a href="${contextPath}/inventory?action=search" class="btn btn-outline-primary">
                                <i class="bx bx-search me-1"></i>Advanced Search
                            </a>
                        </div>
                        
                        <!-- Product Search -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/inventory" method="get" class="row g-3 align-items-end">
                                    <input type="hidden" name="action" value="byProduct" />
                                    
                                    <div class="col-md-6">
                                        <label class="form-label">Search Product (SKU or Name)</label>
                                        <input type="text" class="form-control" name="search" 
                                               value="${searchTerm}" placeholder="Enter SKU or product name...">
                                    </div>
                                    <div class="col-md-3">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bx bx-search me-1"></i>Search
                                        </button>
                                        <c:if test="${not empty selectedProduct}">
                                            <a href="${contextPath}/inventory?action=byProduct" class="btn btn-outline-secondary">
                                                <i class="bx bx-reset me-1"></i>Clear
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Search Results (Product List) -->
                        <c:if test="${not empty searchResults and empty selectedProduct}">
                            <div class="card mb-6">
                                <div class="card-header">
                                    <h5 class="mb-0">Select a Product</h5>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>SKU</th>
                                                <th>Product Name</th>
                                                <th>Unit</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="product" items="${searchResults}">
                                                <tr>
                                                    <td>${product.sku}</td>
                                                    <td>${product.name}</td>
                                                    <td>${product.unit}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.active}">
                                                                <span class="badge bg-success">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Inactive</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${contextPath}/inventory?action=byProduct&productId=${product.id}" 
                                                           class="btn btn-sm btn-primary">
                                                            <i class="bx bx-show me-1"></i>View Inventory
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Selected Product Details -->
                        <c:if test="${not empty selectedProduct}">
                            <!-- Product Info Card -->
                            <div class="card mb-6">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Product Information</h5>
                                    <a href="${contextPath}/product?action=details&id=${selectedProduct.id}" 
                                       class="btn btn-sm btn-outline-primary">
                                        <i class="bx bx-link-external me-1"></i>View Details
                                    </a>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <p class="text-muted mb-1">SKU</p>
                                            <p class="fw-bold">${selectedProduct.sku}</p>
                                        </div>
                                        <div class="col-md-5">
                                            <p class="text-muted mb-1">Product Name</p>
                                            <p class="fw-bold">${selectedProduct.name}</p>
                                        </div>
                                        <div class="col-md-2">
                                            <p class="text-muted mb-1">Unit</p>
                                            <p class="fw-bold">${selectedProduct.unit}</p>
                                        </div>
                                        <div class="col-md-2">
                                            <p class="text-muted mb-1">Status</p>
                                            <c:choose>
                                                <c:when test="${selectedProduct.active}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Summary Cards -->
                            <c:if test="${not empty summary}">
                                <div class="row mb-6">
                                    <div class="col-md-4">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center">
                                                    <div class="avatar avatar-lg me-4 rounded bg-label-success">
                                                        <i class="bx bx-cube bx-lg"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-0 text-muted">Total Quantity</h6>
                                                        <h3 class="mb-0">${summary.totalQuantity}</h3>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center">
                                                    <div class="avatar avatar-lg me-4 rounded bg-label-info">
                                                        <i class="bx bx-map-pin bx-lg"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-0 text-muted">Locations</h6>
                                                        <h3 class="mb-0">${summary.locationCount}</h3>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center">
                                                    <div class="avatar avatar-lg me-4 rounded bg-label-primary">
                                                        <i class="bx bx-building-house bx-lg"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-0 text-muted">Warehouses</h6>
                                                        <h3 class="mb-0">${summary.warehouseCount}</h3>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <!-- Inventory Table -->
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Inventory Locations</h5>
                                    <c:if test="${isStaff}">
                                        <span class="badge bg-info">Showing your warehouse only</span>
                                    </c:if>
                                </div>
                                <c:choose>
                                    <c:when test="${empty inventoryList}">
                                        <div class="card-body text-center py-5">
                                            <i class="bx bx-box bx-lg text-muted mb-3"></i>
                                            <p class="text-muted mb-0">No inventory for this product.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Warehouse</th>
                                                        <th>Location</th>
                                                        <th>Quantity</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="item" items="${inventoryList}">
                                                        <c:set var="inv" value="${item.inventory}" />
                                                        <c:set var="wh" value="${item.warehouse}" />
                                                        <c:set var="loc" value="${item.location}" />
                                                        <tr>
                                                            <td>
                                                                <i class="bx bx-building-house me-1 text-muted"></i>
                                                                ${wh.name}
                                                            </td>
                                                            <td>
                                                                <i class="bx bx-map-pin me-1 text-muted"></i>
                                                                ${loc.code}
                                                                <span class="text-muted">(${loc.type})</span>
                                                            </td>
                                                            <td>
                                                                <span class="fw-bold ${inv.quantity < 10 ? 'text-warning' : ''}">
                                                                    ${inv.quantity}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                        
                        <!-- Initial State -->
                        <c:if test="${empty searchResults and empty selectedProduct}">
                            <div class="card">
                                <div class="card-body text-center py-5">
                                    <i class="bx bx-search bx-lg text-muted mb-3"></i>
                                    <p class="text-muted mb-0">Search for a product to view its inventory across all locations.</p>
                                </div>
                            </div>
                        </c:if>
                        
                    </div>
                    <!-- / Content -->
                    
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
    
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
