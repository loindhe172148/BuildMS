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
        <jsp:param name="pageTitle" value="Edit Provider" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="providers" />
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
                                    <a href="${contextPath}/provider?action=list">Providers</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Provider</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-edit me-2"></i>Edit Provider
                            </h4>
                            <a href="${contextPath}/provider?action=list" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i>Back to List
                            </a>
                        </div>
                        
                        <div class="row">
                            <!-- Form Card -->
                            <div class="col-xl-8">
                                <div class="card mb-6">
                                    <div class="card-header d-flex align-items-center justify-content-between">
                                        <h5 class="mb-0">Provider Information</h5>
                                        <small class="text-muted float-end">
                                            <span class="text-danger">*</span> Required fields
                                        </small>
                                    </div>
                                    <div class="card-body">
                                        <!-- Error Message -->
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                <i class="bx bx-error-circle me-2"></i>
                                                <c:out value="${errorMessage}"/>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        
                                        <form action="${contextPath}/provider" method="post">
                                            <input type="hidden" name="action" value="edit" />
                                            <input type="hidden" name="id" value="${provider.id}" />
                                            
                                            <!-- Provider Code -->
                                            <div class="mb-4">
                                                <label for="code" class="form-label">
                                                    Provider Code <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="code" name="code" 
                                                       value="<c:out value='${provider.code}'/>" 
                                                       disabled />
                                                <div class="form-text">Provider code cannot be changed after creation.</div>
                                            </div>
                                            
                                            <!-- Provider Name -->
                                            <div class="mb-4">
                                                <label for="name" class="form-label">
                                                    Provider Name <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="name" name="name" 
                                                       placeholder="Enter provider name" 
                                                       value="<c:out value='${provider.name}'/>" 
                                                       maxlength="255" 
                                                       required />
                                            </div>
                                            
                                            <!-- Contact Info -->
                                            <div class="mb-4">
                                                <label for="contactInfo" class="form-label">Contact Information</label>
                                                <textarea class="form-control" id="contactInfo" name="contactInfo" 
                                                          rows="4" 
                                                          maxlength="500"
                                                          placeholder="Enter contact details (phone, email, address, etc.)"><c:out value="${provider.contactInfo}"/></textarea>
                                            </div>
                                            
                                            <!-- Form Actions -->
                                            <div class="d-flex gap-3 pt-3">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Update Provider
                                                </button>
                                                <a href="${contextPath}/provider?action=list" class="btn btn-outline-secondary">
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
                                            Provider Status
                                        </h6>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="me-3">Status:</span>
                                            <c:choose>
                                                <c:when test="${provider.status == 'Active'}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="me-3">Used in Inbound:</span>
                                            <span class="badge bg-label-${isUsed ? 'info' : 'secondary'}">
                                                <c:out value="${isUsed ? 'Yes' : 'No'}"/>
                                            </span>
                                        </div>
                                        
                                        <hr />
                                        
                                        <c:choose>
                                            <c:when test="${provider.status == 'Active'}">
                                                <form action="${contextPath}/provider" method="post" class="w-100">
                                                    <input type="hidden" name="action" value="toggle" />
                                                    <input type="hidden" name="id" value="${provider.id}" />
                                                    <button type="submit" class="btn btn-warning w-100"
                                                            onclick="return confirm('Are you sure you want to deactivate this provider? They will no longer be available for new inbound requests.');">
                                                        <i class="bx bx-block me-1"></i>Deactivate Provider
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${contextPath}/provider" method="post" class="w-100">
                                                    <input type="hidden" name="action" value="toggle" />
                                                    <input type="hidden" name="id" value="${provider.id}" />
                                                    <button type="submit" class="btn btn-success w-100"
                                                            onclick="return confirm('Are you sure you want to activate this provider?');">
                                                        <i class="bx bx-check me-1"></i>Activate Provider
                                                    </button>
                                                </form>
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
                                            <a href="${contextPath}/provider?action=list" 
                                               class="btn btn-outline-primary">
                                                <i class="bx bx-list-ul me-1"></i>
                                                View All Providers
                                            </a>
                                            <c:if test="${provider.status == 'Active'}">
                                                <a href="${contextPath}/inbound?action=create" 
                                                   class="btn btn-outline-success">
                                                    <i class="bx bx-plus me-1"></i>
                                                    Create Inbound Request
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Help Card -->
                                <div class="card bg-light-primary">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-help-circle text-primary me-2"></i>
                                            Status Information
                                        </h6>
                                        
                                        <div class="d-flex mb-2">
                                            <span class="badge bg-success me-2">Active</span>
                                            <small>Available for new inbound requests</small>
                                        </div>
                                        
                                        <div class="d-flex">
                                            <span class="badge bg-secondary me-2">Inactive</span>
                                            <small>Hidden from inbound request creation</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                    </main>
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
