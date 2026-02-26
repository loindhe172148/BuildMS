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
        <jsp:param name="pageTitle" value="Location List" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="locations" />
                <jsp:param name="activeSubMenu" value="location-list" />
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
                                <li class="breadcrumb-item active" aria-current="page">Locations</li>
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
                        
                        <c:if test="${not empty sessionScope.warningMessage}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="bx bx-info-circle me-2"></i>
                                ${sessionScope.warningMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="warningMessage" scope="session" />
                        </c:if>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-map me-2"></i>Location Management
                            </h4>
                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                <a href="${contextPath}/location?action=add${not empty warehouseId ? '&warehouseId='.concat(warehouseId) : ''}" 
                                   class="btn btn-primary">
                                    <i class="bx bx-plus me-1"></i>Add Location
                                </a>
                            </c:if>
                        </div>
                        
                        <!-- Filters Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/location" method="get" class="row g-3">
                                    <input type="hidden" name="action" value="list" />
                                    
                                    <!-- Search by Code -->
                                    <div class="col-md-3">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bx bx-search"></i></span>
                                            <input type="text" class="form-control" name="keyword" 
                                                   value="${keyword}" placeholder="Search by code..." />
                                        </div>
                                    </div>
                                    
                                    <!-- Filter by Warehouse -->
                                    <div class="col-md-3">
                                        <select class="form-select" name="warehouseId">
                                            <option value="">All Warehouses</option>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <option value="${wh.id}" ${warehouseId == wh.id ? 'selected' : ''}>
                                                    ${wh.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <!-- Filter by Type -->
                                    <div class="col-md-2">
                                        <select class="form-select" name="type">
                                            <option value="">All Types</option>
                                            <option value="Storage" ${type == 'Storage' ? 'selected' : ''}>Storage</option>
                                            <option value="Picking" ${type == 'Picking' ? 'selected' : ''}>Picking</option>
                                            <option value="Staging" ${type == 'Staging' ? 'selected' : ''}>Staging</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Filter by Status -->
                                    <div class="col-md-2">
                                        <select class="form-select" name="status">
                                            <option value="">All Status</option>
                                            <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                                            <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-outline-primary w-100">
                                            <i class="bx bx-filter-alt me-1"></i>Filter
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Locations Table -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Locations</h5>
                                <span class="badge bg-primary">${locations.size()} total</span>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 60px;">#</th>
                                            <th>Code</th>
                                            <th>Warehouse</th>
                                            <th>Type</th>
                                            <th style="width: 120px;">Inventory</th>
                                            <th style="width: 100px;">Status</th>
                                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                                <th style="width: 150px;">Actions</th>
                                            </c:if>
                                        </tr>
                                    </thead>
                                    <tbody class="table-border-bottom-0">
                                        <c:choose>
                                            <c:when test="${empty locations}">
                                                <tr>
                                                    <td colspan="${(currentUser.role == 'Admin' || currentUser.role == 'Manager') ? 7 : 6}" 
                                                        class="text-center py-5">
                                                        <div class="text-muted">
                                                            <i class="bx bx-map bx-lg mb-3 d-block"></i>
                                                            <p class="mb-0">No locations found</p>
                                                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                                                <a href="${contextPath}/location?action=add" class="btn btn-primary btn-sm mt-3">
                                                                    <i class="bx bx-plus me-1"></i>Add First Location
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="location" items="${locations}" varStatus="loop">
                                                    <c:set var="warehouseName" value="${requestScope['warehouseName_'.concat(location.warehouseId)]}" />
                                                    <c:set var="inventoryCount" value="${requestScope['inventoryCount_'.concat(location.id)]}" />
                                                    <tr class="${!location.active ? 'table-secondary' : ''}">
                                                        <td><strong>${loop.index + 1}</strong></td>
                                                        <td>
                                                            <span class="fw-medium">${location.code}</span>
                                                        </td>
                                                        <td>
                                                            <a href="${contextPath}/location?action=list&warehouseId=${location.warehouseId}" 
                                                               class="text-primary">
                                                                ${warehouseName}
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${location.type == 'Storage'}">
                                                                    <span class="badge bg-label-primary">
                                                                        <i class="bx bx-box me-1"></i>Storage
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${location.type == 'Picking'}">
                                                                    <span class="badge bg-label-info">
                                                                        <i class="bx bx-hand me-1"></i>Picking
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${location.type == 'Staging'}">
                                                                    <span class="badge bg-label-warning">
                                                                        <i class="bx bx-time me-1"></i>Staging
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-label-secondary">${location.type}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-label-${inventoryCount > 0 ? 'success' : 'secondary'}">
                                                                ${inventoryCount} item(s)
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${location.active}">
                                                                    <span class="badge bg-success">Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                                            <td>
                                                                <div class="d-flex gap-2">
                                                                    <a href="${contextPath}/location?action=edit&id=${location.id}" 
                                                                       class="btn btn-sm btn-outline-primary" 
                                                                       data-bs-toggle="tooltip" title="Edit">
                                                                        <i class="bx bx-edit-alt" aria-hidden="true"></i>
                                                                    </a>
                                                                    <c:choose>
                                                                        <c:when test="${location.active && inventoryCount > 0}">
                                                                            <button type="button" 
                                                                                    class="btn btn-sm btn-outline-secondary" 
                                                                                    disabled
                                                                                    data-bs-toggle="tooltip" 
                                                                                    title="Cannot deactivate - has inventory">
                                                                                <i class="bx bx-block" aria-hidden="true"></i>
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button type="button" 
                                                                                    class="btn btn-sm ${location.active ? 'btn-outline-warning' : 'btn-outline-success'}" 
                                                                                    data-bs-toggle="modal" 
                                                                                    data-bs-target="#toggleModal"
                                                                                    data-location-id="${location.id}"
                                                                                    data-location-code="${location.code}"
                                                                                    data-location-active="${location.active}"
                                                                                    title="${location.active ? 'Deactivate' : 'Activate'}">
                                                                                <i class="bx ${location.active ? 'bx-block' : 'bx-check'}"></i>
                                                                            </button>
                                                                        </c:otherwise>
                                                                    </c:choose>
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
    
    <!-- Toggle Status Confirmation Modal -->
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
                    <p id="toggleMessage"></p>
                    <div class="alert alert-warning mb-0" id="toggleWarning" style="display: none;">
                        <i class="bx bx-info-circle me-1"></i>
                        <span id="toggleWarningText"></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="toggleConfirmBtn" class="btn btn-warning">
                        <i class="bx bx-check me-1"></i>Confirm
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
    
    <script>
        // Toggle modal handler
        document.getElementById('toggleModal').addEventListener('show.bs.modal', function(event) {
            var button = event.relatedTarget;
            var locationId = button.getAttribute('data-location-id');
            var locationCode = button.getAttribute('data-location-code');
            var isActive = button.getAttribute('data-location-active') === 'true';
            
            var action = isActive ? 'deactivate' : 'activate';
            var actionCapitalized = isActive ? 'Deactivate' : 'Activate';
            
            document.getElementById('toggleMessage').innerHTML = 
                'Are you sure you want to <strong>' + action + '</strong> location "<strong>' + locationCode + '</strong>"?';
            
            var confirmBtn = document.getElementById('toggleConfirmBtn');
            confirmBtn.href = '${contextPath}/location?action=toggle&id=' + locationId;
            confirmBtn.className = isActive ? 'btn btn-warning' : 'btn btn-success';
            confirmBtn.innerHTML = '<i class="bx bx-check me-1"></i>' + actionCapitalized;
            
            var warningDiv = document.getElementById('toggleWarning');
            var warningText = document.getElementById('toggleWarningText');
            
            if (isActive) {
                warningDiv.style.display = 'block';
                warningText.textContent = 'Inactive locations cannot receive new inventory.';
            } else {
                warningDiv.style.display = 'none';
            }
        });
        
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
