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
        <jsp:param name="pageTitle" value="Add Location" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="locations" />
                <jsp:param name="activeSubMenu" value="location-add" />
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
                                <li class="breadcrumb-item active" aria-current="page">Add Location</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-plus-circle me-2"></i>Add New Location
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
                                            <input type="hidden" name="action" value="add" />
                                            
                                            <!-- Warehouse Selection -->
                                            <div class="mb-4">
                                                <label for="warehouseId" class="form-label">
                                                    Warehouse <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="warehouseId" name="warehouseId" required>
                                                    <option value="">Select Warehouse</option>
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <option value="${wh.id}" 
                                                                ${(selectedWarehouseId == wh.id || param.warehouseId == wh.id) ? 'selected' : ''}>
                                                            ${wh.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Select the warehouse where this location will be created.
                                                </div>
                                            </div>
                                            
                                            <!-- Location Code -->
                                            <div class="mb-4">
                                                <label for="code" class="form-label">
                                                    Location Code <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="code" name="code" 
                                                       placeholder="Enter location code (e.g., A-01-01)" 
                                                       value="${code}" 
                                                       maxlength="50" 
                                                       required />
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Unique identifier within the warehouse. Common format: Zone-Row-Shelf (e.g., A-01-01).
                                                </div>
                                            </div>
                                            
                                            <!-- Location Type -->
                                            <div class="mb-4">
                                                <label class="form-label">
                                                    Location Type <span class="text-danger">*</span>
                                                </label>
                                                <div class="row g-3">
                                                    <div class="col-md-4">
                                                        <input type="radio" class="btn-check" name="type" 
                                                               id="typeStorage" value="Storage" 
                                                               ${empty type || type == 'Storage' ? 'checked' : ''} required />
                                                        <label class="btn btn-outline-primary w-100 py-3" for="typeStorage">
                                                            <i class="bx bx-box fs-3 d-block mb-1"></i>
                                                            <span class="fw-medium">Storage</span>
                                                            <small class="d-block text-muted">Long-term inventory</small>
                                                        </label>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <input type="radio" class="btn-check" name="type" 
                                                               id="typePicking" value="Picking" 
                                                               ${type == 'Picking' ? 'checked' : ''} />
                                                        <label class="btn btn-outline-info w-100 py-3" for="typePicking">
                                                            <i class="bx bx-hand fs-3 d-block mb-1"></i>
                                                            <span class="fw-medium">Picking</span>
                                                            <small class="d-block text-muted">Order fulfillment</small>
                                                        </label>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <input type="radio" class="btn-check" name="type" 
                                                               id="typeStaging" value="Staging" 
                                                               ${type == 'Staging' ? 'checked' : ''} />
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
                                                    <i class="bx bx-save me-1"></i>Create Location
                                                </button>
                                                <a href="${contextPath}/location?action=list" class="btn btn-outline-secondary">
                                                    <i class="bx bx-x me-1"></i>Cancel
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Help Card -->
                            <div class="col-xl-4">
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-help-circle text-primary me-2"></i>
                                            Location Types Guide
                                        </h6>
                                        
                                        <div class="d-flex mb-3">
                                            <span class="badge bg-label-primary p-2 me-3">
                                                <i class="bx bx-box"></i>
                                            </span>
                                            <div>
                                                <h6 class="mb-1">Storage</h6>
                                                <small class="text-muted">
                                                    Primary locations for bulk inventory storage. 
                                                    Used for reserve stock and long-term holding.
                                                </small>
                                            </div>
                                        </div>
                                        
                                        <div class="d-flex mb-3">
                                            <span class="badge bg-label-info p-2 me-3">
                                                <i class="bx bx-hand"></i>
                                            </span>
                                            <div>
                                                <h6 class="mb-1">Picking</h6>
                                                <small class="text-muted">
                                                    Forward locations for order fulfillment. 
                                                    Products are picked here for customer orders.
                                                </small>
                                            </div>
                                        </div>
                                        
                                        <div class="d-flex">
                                            <span class="badge bg-label-warning p-2 me-3">
                                                <i class="bx bx-time"></i>
                                            </span>
                                            <div>
                                                <h6 class="mb-1">Staging</h6>
                                                <small class="text-muted">
                                                    Temporary locations for inbound/outbound processing. 
                                                    Used during receiving and shipping operations.
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="card bg-light-primary">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-bulb text-warning me-2"></i>
                                            Naming Convention Tips
                                        </h6>
                                        <ul class="mb-0 ps-3">
                                            <li class="mb-2">
                                                <strong>Zone-Row-Shelf:</strong> A-01-01, B-02-03
                                            </li>
                                            <li class="mb-2">
                                                <strong>Area-Aisle-Position:</strong> RECV-1-A, SHIP-2-B
                                            </li>
                                            <li class="mb-2">
                                                <strong>Floor-Section-Bin:</strong> 1F-A-001, 2F-B-015
                                            </li>
                                        </ul>
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
