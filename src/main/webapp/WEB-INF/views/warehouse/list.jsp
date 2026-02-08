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
        <jsp:param name="pageTitle" value="Warehouse List" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="warehouses" />
                <jsp:param name="activeSubMenu" value="warehouse-list" />
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
                                <li class="breadcrumb-item active" aria-current="page">Warehouses</li>
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
                                <i class="bx bx-buildings me-2"></i>Warehouse Management
                            </h4>
                            <c:if test="${currentUser.role == 'Admin'}">
                                <a href="${contextPath}/warehouse?action=add" class="btn btn-primary">
                                    <i class="bx bx-plus me-1"></i>Add Warehouse
                                </a>
                            </c:if>
                        </div>
                        
                        <!-- Search Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/warehouse" method="get" class="row g-3">
                                    <input type="hidden" name="action" value="list" />
                                    <div class="col-md-10">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bx bx-search"></i></span>
                                            <input type="text" class="form-control" name="keyword" 
                                                   value="${keyword}" placeholder="Search by name or location..." />
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-outline-primary w-100">Search</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Warehouses Table -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Warehouses</h5>
                                <span class="badge bg-primary">${warehouses.size()} total</span>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 60px;">#</th>
                                            <th>Name</th>
                                            <th>Location</th>
                                            <th style="width: 120px;">Locations</th>
                                            <th style="width: 150px;">Created</th>
                                            <c:if test="${currentUser.role == 'Admin'}">
                                                <th style="width: 150px;">Actions</th>
                                            </c:if>
                                        </tr>
                                    </thead>
                                    <tbody class="table-border-bottom-0">
                                        <c:choose>
                                            <c:when test="${empty warehouses}">
                                                <tr>
                                                    <td colspan="${currentUser.role == 'Admin' ? 6 : 5}" 
                                                        class="text-center py-5">
                                                        <div class="text-muted">
                                                            <i class="bx bx-buildings bx-lg mb-3 d-block"></i>
                                                            <p class="mb-0">No warehouses found</p>
                                                            <c:if test="${currentUser.role == 'Admin'}">
                                                                <a href="${contextPath}/warehouse?action=add" class="btn btn-primary btn-sm mt-3">
                                                                    <i class="bx bx-plus me-1"></i>Add First Warehouse
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="warehouse" items="${warehouses}" varStatus="status">
                                                    <c:set var="locationCount" value="${requestScope['locationCount_'.concat(warehouse.id)]}" />
                                                    <tr>
                                                        <td><strong>${status.index + 1}</strong></td>
                                                        <td>
                                                            <span class="fw-medium">${warehouse.name}</span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty warehouse.location}">
                                                                    <span class="text-truncate d-inline-block" style="max-width: 250px;" 
                                                                          title="${warehouse.location}">
                                                                        <i class="bx bx-map-pin me-1 text-muted"></i>${warehouse.location}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted fst-italic">Not specified</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <a href="${contextPath}/location?action=list&warehouseId=${warehouse.id}" 
                                                               class="badge bg-label-info">
                                                                <i class="bx bx-map me-1"></i>${locationCount} location(s)
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <small class="text-muted">
                                                                <c:choose>
                                                                    <c:when test="${not empty warehouse.createdAt}">
                                                                        ${warehouse.createdAt}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        -
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </small>
                                                        </td>
                                                        <c:if test="${currentUser.role == 'Admin'}">
                                                            <td>
                                                                <div class="d-flex gap-2">
                                                                    <a href="${contextPath}/warehouse?action=edit&id=${warehouse.id}" 
                                                                       class="btn btn-sm btn-outline-primary" 
                                                                       data-bs-toggle="tooltip" title="Edit">
                                                                        <i class="bx bx-edit-alt" aria-hidden="true"></i>
                                                                    </a>
                                                                    <a href="${contextPath}/location?action=list&warehouseId=${warehouse.id}" 
                                                                       class="btn btn-sm btn-outline-info" 
                                                                       data-bs-toggle="tooltip" title="View Locations">
                                                                        <i class="bx bx-map"></i>
                                                                    </a>
                                                                </div>
                                                            </td>
                                                        </c:if>
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
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
    
    <script>
        // Initialize tooltips
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function(tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>
