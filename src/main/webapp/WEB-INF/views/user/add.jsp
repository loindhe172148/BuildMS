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
        <jsp:param name="pageTitle" value="Add User" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="users" />
                <jsp:param name="activeSubMenu" value="user-add" />
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
                                <li class="breadcrumb-item active" aria-current="page">Add User</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-plus-circle me-2"></i>Add New User
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
                                        
                                        <form action="${contextPath}/user" method="post">
                                            <input type="hidden" name="action" value="add" />
                                            
                                            <!-- Account Information -->
                                            <h6 class="mb-3 text-muted">Account Information</h6>
                                            
                                            <div class="row mb-4">
                                                <div class="col-md-6">
                                                    <label for="username" class="form-label">
                                                        Username <span class="text-danger">*</span>
                                                    </label>
                                                    <input type="text" class="form-control" id="username" name="username" 
                                                           placeholder="Enter username" 
                                                           value="${username}" 
                                                           maxlength="100" 
                                                           required />
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="email" class="form-label">
                                                        Email <span class="text-danger">*</span>
                                                    </label>
                                                    <input type="email" class="form-control" id="email" name="email" 
                                                           placeholder="Enter email address" 
                                                           value="${email}" 
                                                           maxlength="255" 
                                                           required />
                                                </div>
                                            </div>
                                            
                                            <div class="mb-4">
                                                <label for="password" class="form-label">
                                                    Password <span class="text-danger">*</span>
                                                </label>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="password" name="password" 
                                                           placeholder="Enter password (min 6 characters)" 
                                                           minlength="6" 
                                                           required />
                                                    <button type="button" class="btn btn-outline-secondary" 
                                                            onclick="togglePassword()" id="togglePasswordBtn">
                                                        <i class="bx bx-show" id="togglePasswordIcon"></i>
                                                    </button>
                                                </div>
                                                <div class="form-text">
                                                    <i class="bx bx-info-circle me-1"></i>
                                                    Minimum 6 characters required.
                                                </div>
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
                                                       value="${name}" 
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
                                                    <select class="form-select" id="role" name="role" required>
                                                        <option value="">Select Role</option>
                                                        <c:forEach var="r" items="${roles}">
                                                            <option value="${r}" ${role == r ? 'selected' : ''}>${r}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="warehouseId" class="form-label">Warehouse Assignment</label>
                                                    <select class="form-select" id="warehouseId" name="warehouseId">
                                                        <option value="">No Assignment</option>
                                                        <c:forEach var="wh" items="${warehouses}">
                                                            <option value="${wh.id}" ${warehouseId == wh.id ? 'selected' : ''}>
                                                                ${wh.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                    <div class="form-text">
                                                        <i class="bx bx-info-circle me-1"></i>
                                                        Recommended for Staff and Manager roles.
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Form Actions -->
                                            <div class="d-flex gap-3 pt-3">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Create User
                                                </button>
                                                <a href="${contextPath}/user?action=list" class="btn btn-outline-secondary">
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
                                            Role Descriptions
                                        </h6>
                                        
                                        <div class="d-flex mb-3">
                                            <span class="badge bg-danger me-3" style="min-width: 70px;">Admin</span>
                                            <small class="text-muted">
                                                Full system access. Manage users, settings, and all operations.
                                            </small>
                                        </div>
                                        
                                        <div class="d-flex mb-3">
                                            <span class="badge bg-warning me-3" style="min-width: 70px;">Manager</span>
                                            <small class="text-muted">
                                                Warehouse management. Approve requests and manage inventory.
                                            </small>
                                        </div>
                                        
                                        <div class="d-flex mb-3">
                                            <span class="badge bg-primary me-3" style="min-width: 70px;">Staff</span>
                                            <small class="text-muted">
                                                Warehouse operations. Execute requests and handle inventory.
                                            </small>
                                        </div>
                                        
                                        <div class="d-flex">
                                            <span class="badge bg-info me-3" style="min-width: 70px;">Sales</span>
                                            <small class="text-muted">
                                                Sales operations. Manage customers and sales orders.
                                            </small>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="card bg-light-primary">
                                    <div class="card-body">
                                        <h6 class="mb-3">
                                            <i class="bx bx-bulb text-warning me-2"></i>
                                            Password Requirements
                                        </h6>
                                        <ul class="mb-0 ps-3">
                                            <li class="mb-2">
                                                Minimum <strong>6 characters</strong>
                                            </li>
                                            <li class="mb-2">
                                                Password is hashed with <strong>SHA-256</strong> + salt
                                            </li>
                                            <li class="mb-2">
                                                Users can change their password later
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
    
    <script>
        function togglePassword() {
            var passwordInput = document.getElementById('password');
            var toggleIcon = document.getElementById('togglePasswordIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('bx-show');
                toggleIcon.classList.add('bx-hide');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('bx-hide');
                toggleIcon.classList.add('bx-show');
            }
        }
    </script>
</body>
</html>
