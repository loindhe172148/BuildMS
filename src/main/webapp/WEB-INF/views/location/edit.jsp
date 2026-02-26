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
        <jsp:param name="pageTitle" value="Edit Location" />
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
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/location?action=list">Locations</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Location</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-edit me-2"></i>Edit Location
                            </h4>
                            <a href="${contextPath}/location?action=list" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i>Back to List
                            </a>
                        </div>
                        
                        <div class="row">
                            <!-- Form Card -->
                            <div class="col-xl-8">
                                <div class="card mb-6">
                                    <div class="card-header d-flex align-items-center justify-content-between">
                                        <h5 class="mb-0">Location Information</h5>
                                        <small class="text-muted float-end">
                                            <span class="text-danger">*</span> Required fields
                                        </small>
                                    </div>
                                    <div class="card-body">
                                        <!-- Error Message -->
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                <i class="bx bx-error-circle me-2"></i>
                                                ${errorMessage}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        
                                        <form action="${contextPath}/location" method="post">
                                            <input type="hidden" name="action" value="edit" />
                                            <input type="hidden" name="id" value="${location.id}" />
                                            <input type="hidden" name="warehouseId" value="${location.warehouseId}" />
                                            
                                            <!-- Warehouse (Read-only) -->
                                            <div class="mb-4">
                                                <label for="warehouseName" class="form-label">Warehouse</label>
                                                <input type="text" class="form-control" id="warehouseName" 
                                                       value="${warehouseName}" readonly disabled />
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Warehouse cannot be changed after creation.
                                                </div>
                                            </div>
                                            
                                            <!-- Location Code -->
                                            <div class="mb-4">
                                                <label for="code" class="form-label">
                                                    Location Code <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="code" name="code" 
                                                       placeholder="Enter location code (e.g., A-01-01)" 
                                                       value="${not empty code ? code : location.code}" 
                                                       maxlength="50" 
                                                       required />
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Unique identifier within the warehouse.
                                                </div>
                                            </div>
                                            
                                            <!-- Location Type -->
                                            <div class="mb-4">
                                                <label class="form-label">
                                                    Location Type <span class="text-danger">*</span>
                                                </label>
                                                <c:set var="currentType" value="${not empty type ? type : location.type}" />
                                                <div class="row g-3">
                                                    <div class="col-md-4">
                                                        <input type="radio" class="btn-check" name="type" 
                                                               id="typeStorage" value="Storage" 
                                                               ${currentType == 'Storage' ? 'checked' : ''} required />
                                                        <label class="btn btn-outline-primary w-100 py-3" for="typeStorage">
                                                            <i class="bx bx-box fs-3 d-block mb-1"></i>
                                                            <span class="fw-medium">Storage</span>
                                                            <small class="d-block text-muted">Long-term inventory</small>
                                                        </label>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <input type="radio" class="btn-check" name="type" 
                                                               id="typePicking" value="Picking" 
                                                               ${currentType == 'Picking' ? 'checked' : ''} />
                                                        <label class="btn btn-outline-info w-100 py-3" for="typePicking">
                                                            <i class="bx bx-hand fs-3 d-block mb-1"></i>
                                                            <span class="fw-medium">Picking</span>
                                                            <small class="d-block text-muted">Order fulfillment</small>
                                                        </label>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <input type="radio" class="btn-check" name="type" 
                                                               id="typeStaging" value="Staging" 
                                                               ${currentType == 'Staging' ? 'checked' : ''} />
                                                        <label class="btn btn-outline-warning w-100 py-3" for="typeStaging">
                                                            <i class="bx bx-time fs-3 d-block mb-1"></i>
                                                            <span class="fw-medium">Staging</span>
                                                            <small class="d-block text-muted">Temporary holding</small>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Form Actions -->
                                            <div class="d-flex gap-3 pt-3">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Update Location
                                                </button>
                                                <a href="${contextPath}/location?action=list" class="btn btn-outline-secondary">
                                                    <i class="bx bx-x me-1"></i>Cancel
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Info Cards -->
                            <div class="col-xl-4">
                                <!-- Status Card -->
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-info-circle text-primary me-2"></i>
                                            Location Status
                                        </h6>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="me-3">Status:</span>
                                            <c:choose>
                                                <c:when test="${location.active}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="me-3">Inventory Items:</span>
                                            <span class="badge bg-label-${inventoryCount > 0 ? 'success' : 'secondary'}">
                                                ${inventoryCount}
                                            </span>
                                        </div>
                                        
                                        <hr />
                                        
                                        <c:choose>
                                            <c:when test="${location.active && inventoryCount > 0}">
                                                <div class="alert alert-warning mb-0">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Cannot deactivate - location has inventory.
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${location.active}">
                                                        <a href="${contextPath}/location?action=toggle&id=${location.id}" 
                                                           class="btn btn-warning w-100"
                                                           onclick="return confirm('Are you sure you want to deactivate this location?');">
                                                            <i class="bx bx-block me-1"></i>Deactivate Location
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${contextPath}/location?action=toggle&id=${location.id}" 
                                                           class="btn btn-success w-100"
                                                           onclick="return confirm('Are you sure you want to activate this location?');">
                                                            <i class="bx bx-check me-1"></i>Activate Location
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <!-- Quick Actions Card -->
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-zap text-warning me-2"></i>
                                            Quick Actions
                                        </h6>
                                        
                                        <div class="d-grid gap-2">
                                            <a href="${contextPath}/location?action=list&warehouseId=${location.warehouseId}" 
                                               class="btn btn-outline-primary">
                                                <i class="bx bx-list-ul me-1"></i>
                                                View Warehouse Locations
                                            </a>
                                            <c:if test="${inventoryCount > 0}">
                                                <a href="${contextPath}/inventory?action=byLocation&locationId=${location.id}" 
                                                   class="btn btn-outline-info">
                                                    <i class="bx bx-box me-1"></i>
                                                    View Inventory
                                                </a>
                                            </c:if>
                                            <a href="${contextPath}/location?action=add&warehouseId=${location.warehouseId}" 
                                               class="btn btn-outline-success">
                                                <i class="bx bx-plus me-1"></i>
                                                Add Another Location
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Help Card -->
                                <div class="card bg-light-primary">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-help-circle text-primary me-2"></i>
                                            Location Types
                                        </h6>
                                        
                                        <div class="d-flex mb-2">
                                            <span class="badge bg-label-primary me-2">
                                                <i class="bx bx-box"></i>
                                            </span>
                                            <small><strong>Storage:</strong> Long-term inventory</small>
                                        </div>
                                        
                                        <div class="d-flex mb-2">
                                            <span class="badge bg-label-info me-2">
                                                <i class="bx bx-hand"></i>
                                            </span>
                                            <small><strong>Picking:</strong> Order fulfillment</small>
                                        </div>
                                        
                                        <div class="d-flex">
                                            <span class="badge bg-label-warning me-2">
                                                <i class="bx bx-time"></i>
                                            </span>
                                            <small><strong>Staging:</strong> Temporary holding</small>
                                        </div>
                                    </div>
                                </div>
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
</body>
</html>
