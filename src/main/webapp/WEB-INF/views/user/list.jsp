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
        <jsp:param name="pageTitle" value="User List" />
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
                                <li class="breadcrumb-item active" aria-current="page">Users</li>
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
                                <i class="bx bx-user-circle me-2"></i>User Management
                            </h4>
                            <a href="${contextPath}/user?action=add" class="btn btn-primary">
                                <i class="bx bx-plus me-1"></i>Add User
                            </a>
                        </div>
                        
                        <!-- Filters Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/user" method="get" class="row g-3">
                                    <input type="hidden" name="action" value="list" />
                                    
                                    <!-- Search -->
                                    <div class="col-md-3">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bx bx-search"></i></span>
                                            <input type="text" class="form-control" name="keyword" 
                                                   value="${keyword}" placeholder="Search username/email..." />
                                        </div>
                                    </div>
                                    
                                    <!-- Filter by Role -->
                                    <div class="col-md-2">
                                        <select class="form-select" name="role">
                                            <option value="">All Roles</option>
                                            <c:forEach var="r" items="${roles}">
                                                <option value="${r}" ${role == r ? 'selected' : ''}>${r}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <!-- Filter by Status -->
                                    <div class="col-md-2">
                                        <select class="form-select" name="status">
                                            <option value="">All Status</option>
                                            <option value="Active" ${status == 'Active' ? 'selected' : ''}>Active</option>
                                            <option value="Inactive" ${status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Filter by Warehouse -->
                                    <div class="col-md-2">
                                        <select class="form-select" name="warehouseId">
                                            <option value="">All Warehouses</option>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <option value="${wh.id}" ${warehouseId == wh.id ? 'selected' : ''}>
                                                    ${wh.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-1">
                                        <button type="submit" class="btn btn-outline-primary w-100">
                                            <i class="bx bx-filter-alt"></i>
                                        </button>
                                    </div>
                                    
                                    <div class="col-md-2">
                                        <a href="${contextPath}/user?action=list" class="btn btn-outline-secondary w-100">
                                            <i class="bx bx-reset me-1"></i>Reset
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Users Table -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Users</h5>
                                <span class="badge bg-primary">${users.size()} total</span>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;">#</th>
                                            <th>Username</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Role</th>
                                            <th>Warehouse</th>
                                            <th style="width: 100px;">Status</th>
                                            <th style="width: 130px;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="table-border-bottom-0">
                                        <c:choose>
                                            <c:when test="${empty users}">
                                                <tr>
                                                    <td colspan="8" class="text-center py-5">
                                                        <div class="text-muted">
                                                            <i class="bx bx-user-circle bx-lg mb-3 d-block"></i>
                                                            <p class="mb-0">No users found</p>
                                                            <a href="${contextPath}/user?action=add" class="btn btn-primary btn-sm mt-3">
                                                                <i class="bx bx-plus me-1"></i>Add First User
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="u" items="${users}" varStatus="loop">
                                                    <c:set var="warehouseName" value="${requestScope['warehouseName_'.concat(u.id)]}" />
                                                    <c:set var="isCurrentUser" value="${currentUserId == u.id}" />
                                                    <tr class="${u.status == 'Inactive' ? 'table-secondary' : ''} ${isCurrentUser ? 'table-info' : ''}">
                                                        <td><strong>${loop.index + 1}</strong></td>
                                                        <td>
                                                            <span class="fw-medium">${u.username}</span>
                                                            <c:if test="${isCurrentUser}">
                                                                <span class="badge bg-info ms-1">You</span>
                                                            </c:if>
                                                        </td>
                                                        <td>${u.name}</td>
                                                        <td>
                                                            <a href="mailto:${u.email}" class="text-primary">
                                                                ${u.email}
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${u.role == 'Admin'}">
                                                                    <span class="badge bg-danger">${u.role}</span>
                                                                </c:when>
                                                                <c:when test="${u.role == 'Manager'}">
                                                                    <span class="badge bg-warning">${u.role}</span>
                                                                </c:when>
                                                                <c:when test="${u.role == 'Staff'}">
                                                                    <span class="badge bg-primary">${u.role}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-info">${u.role}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty warehouseName}">
                                                                    ${warehouseName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${u.status == 'Active'}">
                                                                    <span class="badge bg-success">Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex gap-2">
                                                                <a href="${contextPath}/user?action=edit&id=${u.id}" 
                                                                   class="btn btn-sm btn-outline-primary" 
                                                                   data-bs-toggle="tooltip" title="Edit">
                                                                    <i class="bx bx-edit-alt"></i>
                                                                </a>
                                                                <c:choose>
                                                                    <c:when test="${isCurrentUser}">
                                                                        <button type="button" 
                                                                                class="btn btn-sm btn-outline-secondary" 
                                                                                disabled
                                                                                data-bs-toggle="tooltip" 
                                                                                title="Cannot change own status">
                                                                            <i class="bx bx-block"></i>
                                                                        </button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="button" 
                                                                                class="btn btn-sm ${u.status == 'Active' ? 'btn-outline-warning' : 'btn-outline-success'}" 
                                                                                data-bs-toggle="modal" 
                                                                                data-bs-target="#toggleModal"
                                                                                data-user-id="${u.id}"
                                                                                data-user-name="${u.username}"
                                                                                data-user-status="${u.status}"
                                                                                title="${u.status == 'Active' ? 'Deactivate' : 'Activate'}">
                                                                            <i class="bx ${u.status == 'Active' ? 'bx-block' : 'bx-check'}"></i>
                                                                        </button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
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
            var userId = button.getAttribute('data-user-id');
            var userName = button.getAttribute('data-user-name');
            var userStatus = button.getAttribute('data-user-status');
            
            var isActive = userStatus === 'Active';
            var action = isActive ? 'deactivate' : 'activate';
            var actionCapitalized = isActive ? 'Deactivate' : 'Activate';
            
            document.getElementById('toggleMessage').innerHTML = 
                'Are you sure you want to <strong>' + action + '</strong> user "<strong>' + userName + '</strong>"?';
            
            var confirmBtn = document.getElementById('toggleConfirmBtn');
            confirmBtn.href = '${contextPath}/user?action=toggle&id=' + userId;
            confirmBtn.className = isActive ? 'btn btn-warning' : 'btn btn-success';
            confirmBtn.innerHTML = '<i class="bx bx-check me-1"></i>' + actionCapitalized;
            
            var warningDiv = document.getElementById('toggleWarning');
            var warningText = document.getElementById('toggleWarningText');
            
            if (isActive) {
                warningDiv.style.display = 'block';
                warningText.textContent = 'Deactivated users will not be able to log in. Their active sessions will be invalidated.';
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
