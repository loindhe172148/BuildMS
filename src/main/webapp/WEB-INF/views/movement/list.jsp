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
        <jsp:param name="pageTitle" value="Internal Movements" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="movement" />
                <jsp:param name="activeSubMenu" value="movement-list" />
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
                                <li class="breadcrumb-item active" aria-current="page">Internal Movements</li>
                            </ol>
                        </nav>
                        
                        <!-- Alerts -->
                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bx bx-check-circle me-2"></i>
                                ${sessionScope.successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>
                        
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bx bx-error-circle me-2"></i>
                                ${sessionScope.errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-transfer me-2"></i>Internal Movements
                            </h4>
                            <a href="${contextPath}/movement?action=create" class="btn btn-primary">
                                <i class="bx bx-plus me-1"></i>Create Movement
                            </a>
                        </div>
                        
                        <!-- Filters Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/movement" method="get" class="row g-3">
                                    <input type="hidden" name="action" value="list" />
                                    
                                    <!-- Filter by Status -->
                                    <div class="col-md-4">
                                        <select class="form-select" name="status">
                                            <option value="">All Status</option>
                                            <option value="Created" ${selectedStatus == 'Created' ? 'selected' : ''}>Created</option>
                                            <option value="InProgress" ${selectedStatus == 'InProgress' ? 'selected' : ''}>In Progress</option>
                                            <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Filter by Warehouse -->
                                    <c:if test="${not isStaff}">
                                        <div class="col-md-4">
                                            <select class="form-select" name="warehouseId">
                                                <option value="">All Warehouses</option>
                                                <c:forEach var="wh" items="${warehouses}">
                                                    <option value="${wh.id}" ${selectedWarehouseId == wh.id ? 'selected' : ''}>
                                                        ${wh.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:if>
                                    
                                    <div class="col-md-4">
                                        <button type="submit" class="btn btn-outline-primary">
                                            <i class="bx bx-filter-alt me-1"></i>Filter
                                        </button>
                                        <a href="${contextPath}/movement" class="btn btn-outline-secondary">
                                            <i class="bx bx-reset me-1"></i>Reset
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Requests Table -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Movement Requests</h5>
                                <span class="badge bg-primary">${requests.size()} total</span>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 80px;">ID</th>
                                            <th>Warehouse</th>
                                            <th>Created By</th>
                                            <th>Created Date</th>
                                            <th style="width: 120px;">Status</th>
                                            <th style="width: 150px;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-border-bottom-0">
                                        <c:choose>
                                            <c:when test="${empty requests}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-4">
                                                        <i class="bx bx-info-circle bx-sm text-muted mb-2"></i>
                                                        <p class="text-muted mb-0">No movement requests found.</p>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="req" items="${requests}">
                                                    <tr>
                                                        <td><strong>#${req.id}</strong></td>
                                                        <td>
                                                            <i class="bx bx-building-house me-1 text-muted"></i>
                                                            ${requestScope["warehouseName_".concat(req.sourceWarehouseId)]}
                                                        </td>
                                                        <td>${requestScope["userName_".concat(req.createdBy)]}</td>
                                                        <td>
                                                            <fmt:parseDate value="${req.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${req.status == 'Created'}">
                                                                    <span class="badge bg-warning">Created</span>
                                                                </c:when>
                                                                <c:when test="${req.status == 'InProgress'}">
                                                                    <span class="badge bg-info">In Progress</span>
                                                                </c:when>
                                                                <c:when test="${req.status == 'Completed'}">
                                                                    <span class="badge bg-success">Completed</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${req.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <a href="${contextPath}/movement?action=details&id=${req.id}" 
                                                               class="btn btn-sm btn-outline-primary" title="View Details">
                                                                <i class="bx bx-show" aria-hidden="true"></i>
                                                            </a>
                                                            <c:if test="${req.status == 'Created' || req.status == 'InProgress'}">
                                                                <a href="${contextPath}/movement?action=execute&id=${req.id}" 
                                                                   class="btn btn-sm btn-outline-success" title="Execute">
                                                                    <i class="bx bx-play"></i>
                                                                </a>
                                                            </c:if>
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
