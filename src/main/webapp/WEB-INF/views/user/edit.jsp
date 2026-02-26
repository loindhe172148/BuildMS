<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="currentUserSession" value="${sessionScope.user}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Edit User" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="users" />
                <jsp:param name="activeSubMenu" value="user-list" />
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
                                    <a href="${contextPath}/user?action=list">Users</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit User</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-edit me-2"></i>Edit User
                                <c:if test="${isCurrentUser}">
                                    <span class="badge bg-info ms-2">Your Account</span>
                                </c:if>
                            </h4>
                            <a href="${contextPath}/user?action=list" class="btn btn-outline-secondary">
                                <i class="bx bx-arrow-back me-1"></i>Back to List
                            </a>
                        </div>
                        
                        <div class="row">
                            <!-- Form Card -->
                            <div class="col-xl-8">
                                <div class="card mb-6">
                                    <div class="card-header d-flex align-items-center justify-content-between">
                                        <h5 class="mb-0">User Information</h5>
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
                                        
                                        <!-- Warning for editing self -->
                                        <c:if test="${isCurrentUser}">
                                            <div class="alert alert-info mb-4">
                                                <i class="bx bx-info-circle me-2"></i>
                                                You are editing your own account. Be careful with role changes.
                                            </div>
                                        </c:if>
                                        
                                        <form action="${contextPath}/user" method="post">
                                            <input type="hidden" name="action" value="edit" />
                                            <input type="hidden" name="id" value="${user.id}" />
                                            
                                            <!-- Account Information -->
                                            <h6 class="mb-3 text-muted">Account Information</h6>
                                            
                                            <div class="row mb-4">
                                                <div class="col-md-6">
                                                    <label for="username" class="form-label">
                                                        Username <span class="text-danger">*</span>
                                                    </label>
                                                    <input type="text" class="form-control" id="username" name="username" 
                                                           placeholder="Enter username" 
                                                           value="${not empty username ? username : user.username}" 
                                                           maxlength="100" 
                                                           required />
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="email" class="form-label">
                                                        Email <span class="text-danger">*</span>
                                                    </label>
                                                    <input type="email" class="form-control" id="email" name="email" 
                                                           placeholder="Enter email address" 
                                                           value="${not empty email ? email : user.email}" 
                                                           maxlength="255" 
                                                           required />
                                                </div>
                                            </div>
                                            
                                            <div class="alert alert-light mb-4">
                                                <i class="bx bx-lock me-1"></i>
                                                Password cannot be changed here. Use 
                                                <a href="${contextPath}/auth?action=resetPassword&id=${user.id}">Admin Reset Password</a> 
                                                to reset user password.
                                            </div>
                                            
                                            <hr class="my-4" />
                                            
                                            <!-- Personal Information -->
                                            <h6 class="mb-3 text-muted">Personal Information</h6>
                                            
                                            <div class="mb-4">
                                                <label for="name" class="form-label">
                                                    Full Name <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="name" name="name" 
                                                       placeholder="Enter full name" 
                                                       value="${not empty name ? name : user.name}" 
                                                       maxlength="255" 
                                                       required />
                                            </div>
                                            
                                            <hr class="my-4" />
                                            
                                            <!-- Role & Assignment -->
                                            <h6 class="mb-3 text-muted">Role & Assignment</h6>
                                            
                                            <div class="row mb-4">
                                                <div class="col-md-6">
                                                    <label for="role" class="form-label">
                                                        Role <span class="text-danger">*</span>
                                                    </label>
                                                    <c:set var="currentRole" value="${not empty role ? role : user.role}" />
                                                    <select class="form-select" id="role" name="role" required
                                                            ${isCurrentUser && user.role == 'Admin' ? '' : ''}>
                                                        <option value="">Select Role</option>
                                                        <c:forEach var="r" items="${roles}">
                                                            <option value="${r}" ${currentRole == r ? 'selected' : ''}>${r}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <c:if test="${isCurrentUser && user.role == 'Admin'}">
                                                        <div class="form-text text-warning">
                                                            <i class="bx bx-info-circle me-1"></i>
                                                            You cannot demote your own admin account.
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="warehouseId" class="form-label">Warehouse Assignment</label>
                                                    <c:set var="currentWarehouseId" value="${not empty warehouseId ? warehouseId : user.warehouseId}" />
                                                    <select class="form-select" id="warehouseId" name="warehouseId">
                                                        <option value="">No Assignment</option>
                                                        <c:forEach var="wh" items="${warehouses}">
                                                            <option value="${wh.id}" ${currentWarehouseId == wh.id ? 'selected' : ''}>
                                                                ${wh.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            
                                            <!-- Form Actions -->
                                            <div class="d-flex gap-3 pt-3">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Update User
                                                </button>
                                                <a href="${contextPath}/user?action=list" class="btn btn-outline-secondary">
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
                                            User Status
                                        </h6>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="me-3">Status:</span>
                                            <c:choose>
                                                <c:when test="${user.status == 'Active'}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="me-3">Created:</span>
                                            <small class="text-muted">
                                                <c:if test="${not empty user.createdAt}">
                                                    ${user.createdAt.toLocalDate()}
                                                </c:if>
                                            </small>
                                        </div>
                                        
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="me-3">Last Login:</span>
                                            <small class="text-muted">
                                                <c:choose>
                                                    <c:when test="${not empty user.lastLogin}">
                                                        ${user.lastLogin.toLocalDate()} ${user.lastLogin.toLocalTime().withNano(0)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Never
                                                    </c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                        
                                        <hr />
                                        
                                        <c:choose>
                                            <c:when test="${isCurrentUser}">
                                                <div class="alert alert-light mb-0">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    You cannot change your own status.
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${user.status == 'Active'}">
                                                        <a href="${contextPath}/user?action=toggle&id=${user.id}" 
                                                           class="btn btn-warning w-100"
                                                           onclick="return confirm('Are you sure you want to deactivate this user?');">
                                                            <i class="bx bx-block me-1"></i>Deactivate User
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${contextPath}/user?action=toggle&id=${user.id}" 
                                                           class="btn btn-success w-100"
                                                           onclick="return confirm('Are you sure you want to activate this user?');">
                                                            <i class="bx bx-check me-1"></i>Activate User
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
                                            <a href="${contextPath}/user?action=list" 
                                               class="btn btn-outline-primary">
                                                <i class="bx bx-list-ul me-1"></i>
                                                View All Users
                                            </a>
                                            <a href="${contextPath}/user?action=add" 
                                               class="btn btn-outline-success">
                                                <i class="bx bx-plus me-1"></i>
                                                Add New User
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Role Info Card -->
                                <div class="card bg-light-primary">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-help-circle text-primary me-2"></i>
                                            Role Information
                                        </h6>
                                        
                                        <div class="d-flex mb-2">
                                            <span class="badge bg-danger me-2" style="min-width: 60px;">Admin</span>
                                            <small>Full system access</small>
                                        </div>
                                        
                                        <div class="d-flex mb-2">
                                            <span class="badge bg-warning me-2" style="min-width: 60px;">Manager</span>
                                            <small>Warehouse management</small>
                                        </div>
                                        
                                        <div class="d-flex mb-2">
                                            <span class="badge bg-primary me-2" style="min-width: 60px;">Staff</span>
                                            <small>Warehouse operations</small>
                                        </div>
                                        
                                        <div class="d-flex">
                                            <span class="badge bg-info me-2" style="min-width: 60px;">Sales</span>
                                            <small>Sales operations</small>
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
