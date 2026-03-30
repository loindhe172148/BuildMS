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
        <jsp:param name="pageTitle" value="Search Inventory" />
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
                                <li class="breadcrumb-item active" aria-current="page">Search</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <jsp:include page="/WEB-INF/common/alerts.jsp" />
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-search me-2"></i>Search Inventory
                            </h4>
                            <div>
                                <a href="${contextPath}/inventory?action=byWarehouse" class="btn btn-outline-secondary me-2">
                                    <i class="bx bx-building-house me-1"></i>By Warehouse
                                </a>
                                <a href="${contextPath}/inventory?action=byProduct" class="btn btn-outline-secondary">
                                    <i class="bx bx-package me-1"></i>By Product
                                </a>
                            </div>
                        </div>
                        
                        <!-- Search Form -->
                        <div class="card mb-6">
                            <div class="card-header">
                                <h5 class="mb-0">Search Filters</h5>
                            </div>
                            <div class="card-body">
                                <form action="${contextPath}/inventory" method="get">
                                    <input type="hidden" name="action" value="search" />
                                    
                                    <div class="row g-3">
                                        <!-- Search Term -->
                                        <div class="col-md-6">
                                            <label class="form-label">Search (SKU or Product Name)</label>
                                            <input type="text" class="form-control" name="q" 
                                                   value="<c:out value='${searchTerm}'/>" placeholder="Enter SKU or product name...">
                                        </div>
                                        
                                        <!-- Warehouse Filter -->
                                        <div class="col-md-6">
                                            <label class="form-label">Warehouse</label>
                                            <c:choose>
                                                <c:when test="${isWarehouseScoped}">
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <c:if test="${wh.id == selectedWarehouseId}">
                                                            <input type="text" class="form-control" 
                                                                   value="<c:out value='${wh.name}'/>" readonly disabled />
                                                            <input type="hidden" name="warehouseId" value="${selectedWarehouseId}" />
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <select class="form-select" name="warehouseId">
                                                        <option value="">All Warehouses</option>
                                                        <c:forEach var="wh" items="${warehouses}">
                                                            <option value="<c:out value='${wh.id}'/>" <c:out value="${selectedWarehouseId == wh.id ? 'selected' : ''}"/>>
                                                                <c:out value="${wh.name}"/>
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <!-- Category Filter -->
                                        <div class="col-md-4">
                                            <label class="form-label">Category</label>
                                            <select class="form-select" name="categoryId">
                                                <option value="">All Categories</option>
                                                <c:forEach var="cat" items="${categories}">
                                                    <option value="<c:out value='${cat.id}'/>" <c:out value="${selectedCategoryId == cat.id ? 'selected' : ''}"/>>
                                                        <c:out value="${cat.name}"/>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        
                                        <!-- Quantity Range -->
                                        <div class="col-md-4">
                                            <label class="form-label">Min Quantity</label>
                                            <input type="number" class="form-control" name="minQty" 
                                                   value="<c:out value='${minQty}'/>" min="0" placeholder="Min">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Max Quantity</label>
                                            <input type="number" class="form-control" name="maxQty" 
                                                   value="<c:out value='${maxQty}'/>" min="0" placeholder="Max">
                                        </div>
                                    </div>
                                    
                                    <div class="mt-4">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bx bx-search me-1"></i>Search
                                        </button>
                                        <a href="${contextPath}/inventory?action=search" class="btn btn-outline-secondary">
                                            <i class="bx bx-reset me-1"></i>Clear Filters
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Search Results -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Search Results</h5>
                                <c:if test="${not empty resultCount}">
                                    <span class="badge bg-primary"><c:out value="${resultCount}"/> results found</span>
                                </c:if>
                            </div>
                            <c:choose>
                                <c:when test="${empty searchResults}">
                                    <div class="card-body text-center py-5">
                                        <i class="bx bx-search bx-lg text-muted mb-3"></i>
                                        <p class="text-muted mb-0">
                                            <c:choose>
                                                <c:when test="${not empty searchTerm or not empty selectedWarehouseId or not empty selectedCategoryId}">
                                                    No inventory found matching your search criteria.
                                                </c:when>
                                                <c:otherwise>
                                                    Enter search criteria and click Search to find inventory.
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>SKU</th>
                                                    <th>Product Name</th>
                                                    <th>Category</th>
                                                    <th>Warehouse</th>
                                                    <th>Location</th>
                                                    <th>Quantity</th>
                                                    <th>Unit</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${searchResults}">
                                                    <c:set var="inv" value="${item.inventory}" />
                                                    <c:set var="prod" value="${item.product}" />
                                                    <c:set var="wh" value="${item.warehouse}" />
                                                    <c:set var="loc" value="${item.location}" />
                                                    <c:set var="cat" value="${item.category}" />
                                                    <tr>
                                                        <td>
                                                            <a href="${contextPath}/product?action=details&id=${prod.id}">
                                                                <c:out value="${prod.sku}"/>
                                                            </a>
                                                        </td>
                                                        <td><c:out value="${prod.name}"/></td>
                                                        <td><c:out value="${cat != null ? cat.name : '-'}"/></td>
                                                        <td>
                                                            <i class="bx bx-building-house me-1 text-muted"></i>
                                                            <c:out value="${wh.name}"/>
                                                        </td>
                                                        <td>
                                                            <i class="bx bx-map-pin me-1 text-muted"></i>
                                                            <c:out value="${loc.code}"/>
                                                        </td>
                                                        <td>
                                                            <span class="fw-bold ${inv.quantity < 10 ? 'text-warning' : ''}">
                                                                <c:out value="${inv.quantity}"/>
                                                            </span>
                                                        </td>
                                                        <td><c:out value="${prod.unit}"/></td>
                                                        <td>
                                                            <a href="${contextPath}/inventory?action=byProduct&productId=${prod.id}" 
                                                               class="btn btn-sm btn-outline-primary" title="View all locations">
                                                                <i class="bx bx-show"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="card-footer">
                                <jsp:include page="/WEB-INF/common/pagination.jsp">
                                    <jsp:param name="currentPage" value="${currentPage}" />
                                    <jsp:param name="totalPages" value="${totalPages}" />
                                    <jsp:param name="baseUrl" value="${paginationBaseUrl}" />
                                </jsp:include>
                            </div>
                        </div>
                        
                    </main>
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
