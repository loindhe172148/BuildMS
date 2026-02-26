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
        <jsp:param name="pageTitle" value="Add Warehouse" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="warehouses" />
                <jsp:param name="activeSubMenu" value="warehouse-add" />
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
                                    <a href="${contextPath}/warehouse?action=list">Warehouses</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Add Warehouse</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-plus-circle me-2"></i>Add New Warehouse
                            </h4>
                        </div>
                        
                        <!-- Form Card -->
                        <div class="row">
                            <div class="col-xxl-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Warehouse Information</h5>
                                    </div>
                                    <div class="card-body">
                                        
                                        <!-- Error Alert -->
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                <i class="bx bx-error-circle me-2"></i>
                                                ${errorMessage}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        
                                        <form action="${contextPath}/warehouse" method="post">
                                            <input type="hidden" name="action" value="add" />
                                            
                                            <!-- Name -->
                                            <div class="mb-4">
                                                <label class="form-label" for="name">
                                                    Warehouse Name <span class="text-danger">*</span>
                                                </label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bx bx-buildings"></i></span>
                                                    <input type="text" class="form-control" id="name" name="name" 
                                                           value="${name}" placeholder="Enter warehouse name"
                                                           required maxlength="255" />
                                                </div>
                                            </div>
                                            
                                            <!-- Location -->
                                            <div class="mb-4">
                                                <label class="form-label" for="location">Location / Address</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bx bx-map-pin"></i></span>
                                                    <input type="text" class="form-control" id="location" name="location" 
                                                           value="${location}" placeholder="Enter warehouse location or address"
                                                           maxlength="255" />
                                                </div>
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Optional. Helps identify the physical location of the warehouse.
                                                </div>
                                            </div>
                                            
                                            <!-- Form Actions -->
                                            <div class="d-flex justify-content-end gap-3 mt-5">
                                                <a href="${contextPath}/warehouse?action=list" class="btn btn-outline-secondary">
                                                    <i class="bx bx-x me-1"></i>Cancel
                                                </a>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Save Warehouse
                                                </button>
                                            </div>
                                        </form>
                                        
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Help Card -->
                            <div class="col-xxl-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <i class="bx bx-help-circle me-2"></i>About Warehouses
                                        </h6>
                                        <ul class="list-unstyled mb-0">
                                            <li class="mb-2">
                                                <i class="bx bx-check text-success me-2"></i>
                                                Warehouses are physical facilities for storing inventory
                                            </li>
                                            <li class="mb-2">
                                                <i class="bx bx-check text-success me-2"></i>
                                                Each warehouse can have multiple storage locations (bins)
                                            </li>
                                            <li class="mb-2">
                                                <i class="bx bx-check text-success me-2"></i>
                                                Warehouse name must be unique in the system
                                            </li>
                                            <li class="mb-0">
                                                <i class="bx bx-check text-success me-2"></i>
                                                After creating, you can add locations to the warehouse
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
