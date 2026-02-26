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
        <jsp:param name="pageTitle" value="Inventory by Warehouse" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="inventory" />
                <jsp:param name="activeSubMenu" value="inventory-warehouse" />
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
                                <li class="breadcrumb-item active" aria-current="page">By Warehouse</li>
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
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-box me-2"></i>Inventory by Warehouse
                            </h4>
                            <a href="${contextPath}/inventory?action=search" class="btn btn-outline-primary">
                                <i class="bx bx-search me-1"></i>Advanced Search
                            </a>
                        </div>
                        
                        <!-- Warehouse Selection -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/inventory" method="get" class="row g-3 align-items-end">
                                    <input type="hidden" name="action" value="byWarehouse" />
                                    
                                    <c:choose>
                                        <c:when test="${isStaff}">
                                            <div class="col-md-6">
                                                <label class="form-label">Warehouse</label>
                                                <input type="text" class="form-control" 
                                                       value="${selectedWarehouse.name}" readonly disabled />
                                                <input type="hidden" name="warehouseId" value="${selectedWarehouseId}" />
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="col-md-4">
                                                <label class="form-label">Select Warehouse</label>
                                                <select class="form-select" name="warehouseId" onchange="this.form.submit()">
                                                    <option value="">-- Select Warehouse --</option>
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <option value="${wh.id}" ${selectedWarehouseId == wh.id ? 'selected' : ''}>
                                                            ${wh.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:if test="${not empty selectedWarehouseId}">
                                        <div class="col-md-4">
                                            <label class="form-label">Search SKU/Product Name</label>
                                            <input type="text" class="form-control" name="search" 
                                                   value="${searchTerm}" placeholder="Search...">
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="bx bx-search me-1"></i>Search
                                            </button>
                                        </div>
                                    </c:if>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Summary Cards -->
                        <c:if test="${not empty summary}">
                            <div class="row mb-6">
                                <div class="col-md-4">
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center">
                                                <div class="avatar avatar-lg me-4 rounded bg-label-primary">
                                                    <i class="bx bx-package bx-lg"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 text-muted">Total Products</h6>
                                                    <h3 class="mb-0">${summary.totalProducts}</h3>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
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
                                                    <h6 class="mb-0 text-muted">Active Locations</h6>
                                                    <h3 class="mb-0">${summary.locationCount}</h3>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Inventory by Location -->
                        <c:choose>
                            <c:when test="${empty selectedWarehouseId}">
                                <div class="card">
                                    <div class="card-body text-center py-5">
                                        <i class="bx bx-info-circle bx-lg text-muted mb-3"></i>
                                        <p class="text-muted mb-0">Please select a warehouse to view inventory.</p>
                                    </div>
                                </div>
                            </c:when>
                            <c:when test="${empty inventoryByLocation}">
                                <div class="card">
                                    <div class="card-body text-center py-5">
                                        <i class="bx bx-box bx-lg text-muted mb-3"></i>
                                        <p class="text-muted mb-0">No inventory in this warehouse.</p>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="accordion" id="inventoryAccordion">
                                    <c:forEach var="entry" items="${inventoryByLocation}" varStatus="status">
                                        <div class="card accordion-item mb-3">
                                            <h2 class="accordion-header">
                                                <button class="accordion-button ${status.first ? '' : 'collapsed'}" 
                                                        type="button" data-bs-toggle="collapse" 
                                                        data-bs-target="#location_${entry.key.id}">
                                                    <div class="d-flex align-items-center w-100 justify-content-between pe-3">
                                                        <span>
                                                            <i class="bx bx-map-pin me-2"></i>
                                                            <strong>${entry.key.code}</strong>
                                                            <span class="text-muted ms-2">(${entry.key.type})</span>
                                                        </span>
                                                        <span class="badge bg-primary">${entry.value.size()} products</span>
                                                    </div>
                                                </button>
                                            </h2>
                                            <div id="location_${entry.key.id}" 
                                                 class="accordion-collapse collapse ${status.first ? 'show' : ''}" 
                                                 data-bs-parent="#inventoryAccordion">
                                                <div class="accordion-body p-0">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover mb-0">
                                                            <thead class="table-light">
                                                                <tr>
                                                                    <th>SKU</th>
                                                                    <th>Product Name</th>
                                                                    <th>Quantity</th>
                                                                    <th>Unit</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="item" items="${entry.value}">
                                                                    <c:set var="inv" value="${item.inventory}" />
                                                                    <c:set var="prod" value="${item.product}" />
                                                                    <c:if test="${empty searchTerm or 
                                                                        (prod.sku.toLowerCase().contains(searchTerm.toLowerCase()) or 
                                                                         prod.name.toLowerCase().contains(searchTerm.toLowerCase()))}">
                                                                        <tr>
                                                                            <td>
                                                                                <a href="${contextPath}/product?action=details&id=${prod.id}">
                                                                                    ${prod.sku}
                                                                                </a>
                                                                            </td>
                                                                            <td>${prod.name}</td>
                                                                            <td>
                                                                                <span class="fw-bold ${inv.quantity < 10 ? 'text-warning' : ''}">
                                                                                    ${inv.quantity}
                                                                                </span>
                                                                            </td>
                                                                            <td>${prod.unit}</td>
                                                                        </tr>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
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
