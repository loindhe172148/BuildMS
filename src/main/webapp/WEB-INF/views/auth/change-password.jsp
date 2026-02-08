<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en" class="layout-menu-fixed layout-compact" 
      data-assets-path="${contextPath}/assets/" 
      data-template="vertical-menu-template-free">
<head>
    <jsp:include page="/WEB-INF/common/head.jsp">
        <jsp:param name="pageTitle" value="Change Password" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="change-password" />
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
                                <li class="breadcrumb-item active" aria-current="page">Change Password</li>
                            </ol>
                        </nav>
                        
                        <div class="row">
                            <div class="col-md-6 col-lg-5">
                                <div class="card mb-6">
                                    <h5 class="card-header">
                                        <i class="bx bx-lock-alt me-2"></i>Change Password
                                    </h5>
                                    <div class="card-body">
                                        
                                        <!-- Success Message -->
                                        <c:if test="${not empty successMessage}">
                                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                                <i class="bx bx-check-circle me-2"></i>
                                                ${successMessage}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Error Message -->
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                                <i class="bx bx-error-circle me-2"></i>
                                                ${errorMessage}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Change Password Form -->
                                        <form action="${contextPath}/auth" method="post">
                                            <input type="hidden" name="action" value="changePassword" />
                                            
                                            <div class="mb-4 form-password-toggle">
                                                <label class="form-label" for="currentPassword">Current Password <span class="text-danger">*</span></label>
                                                <div class="input-group input-group-merge">
                                                    <input type="password" 
                                                           id="currentPassword" 
                                                           name="currentPassword" 
                                                           class="form-control" 
                                                           placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;" 
                                                           required />
                                                    <span class="input-group-text cursor-pointer toggle-password">
                                                        <i class="icon-base bx bx-hide"></i>
                                                    </span>
                                                </div>
                                            </div>
                                            
                                            <div class="mb-4 form-password-toggle">
                                                <label class="form-label" for="newPassword">New Password <span class="text-danger">*</span></label>
                                                <div class="input-group input-group-merge">
                                                    <input type="password" 
                                                           id="newPassword" 
                                                           name="newPassword" 
                                                           class="form-control" 
                                                           placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;" 
                                                           minlength="6"
                                                           required />
                                                    <span class="input-group-text cursor-pointer toggle-password">
                                                        <i class="icon-base bx bx-hide"></i>
                                                    </span>
                                                </div>
                                                <div class="form-text">Minimum 6 characters</div>
                                            </div>
                                            
                                            <div class="mb-4 form-password-toggle">
                                                <label class="form-label" for="confirmPassword">Confirm New Password <span class="text-danger">*</span></label>
                                                <div class="input-group input-group-merge">
                                                    <input type="password" 
                                                           id="confirmPassword" 
                                                           name="confirmPassword" 
                                                           class="form-control" 
                                                           placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;" 
                                                           minlength="6"
                                                           required />
                                                    <span class="input-group-text cursor-pointer toggle-password">
                                                        <i class="icon-base bx bx-hide"></i>
                                                    </span>
                                                </div>
                                            </div>
                                            
                                            <div class="mt-6">
                                                <button type="submit" class="btn btn-primary me-3">
                                                    <i class="bx bx-check me-1"></i>Change Password
                                                </button>
                                                <a href="${contextPath}/dashboard" class="btn btn-outline-secondary">
                                                    Cancel
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                
                                <!-- Password Requirements Card -->
                                <div class="card">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <i class="bx bx-info-circle me-2 text-info"></i>Password Requirements
                                        </h6>
                                        <ul class="mb-0 ps-4">
                                            <li>Minimum 6 characters long</li>
                                            <li>Must be different from current password</li>
                                            <li>New password and confirmation must match</li>
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
    
    <!-- Password Toggle Script -->
    <script>
        document.querySelectorAll('.toggle-password').forEach(function(toggle) {
            toggle.addEventListener('click', function() {
                var input = this.previousElementSibling;
                var icon = this.querySelector('i');
                
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.remove('bx-hide');
                    icon.classList.add('bx-show');
                } else {
                    input.type = 'password';
                    icon.classList.remove('bx-show');
                    icon.classList.add('bx-hide');
                }
            });
        });
        
        // Client-side validation for password match
        document.querySelector('form').addEventListener('submit', function(e) {
            var newPassword = document.getElementById('newPassword').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('New passwords do not match');
                return false;
            }
        });
    </script>
</body>
</html>
