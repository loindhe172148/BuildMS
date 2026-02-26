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
        <jsp:param name="pageTitle" value="Category List" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="categories" />
                <jsp:param name="activeSubMenu" value="category-list" />
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
                                <li class="breadcrumb-item active" aria-current="page">Categories</li>
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
                                <i class="bx bx-category me-2"></i>Category Management
                            </h4>
                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                <a href="${contextPath}/category?action=add" class="btn btn-primary">
                                    <i class="bx bx-plus me-1"></i>Add Category
                                </a>
                            </c:if>
                        </div>
                        
                        <!-- Search Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/category" method="get" class="row g-3">
                                    <input type="hidden" name="action" value="list" />
                                    <div class="col-md-10">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bx bx-search"></i></span>
                                            <input type="text" class="form-control" name="keyword" 
                                                   value="${keyword}" placeholder="Search by name or description..." />
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-outline-primary w-100">Search</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Categories Table -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Categories</h5>
                                <span class="badge bg-primary">${categories.size()} total</span>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 60px;">#</th>
                                            <th>Name</th>
                                            <th>Description</th>
                                            <th style="width: 120px;">Products</th>
                                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                                <th style="width: 150px;">Actions</th>
                                            </c:if>
                                        </tr>
                                    </thead>
                                    <tbody class="table-border-bottom-0">
                                        <c:choose>
                                            <c:when test="${empty categories}">
                                                <tr>
                                                    <td colspan="${(currentUser.role == 'Admin' || currentUser.role == 'Manager') ? 5 : 4}" 
                                                        class="text-center py-5">
                                                        <div class="text-muted">
                                                            <i class="bx bx-folder-open bx-lg mb-3 d-block"></i>
                                                            <p class="mb-0">No categories found</p>
                                                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                                                <a href="${contextPath}/category?action=add" class="btn btn-primary btn-sm mt-3">
                                                                    <i class="bx bx-plus me-1"></i>Add First Category
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="category" items="${categories}" varStatus="status">
                                                    <c:set var="productCount" value="${requestScope['productCount_'.concat(category.id)]}" />
                                                    <tr>
                                                        <td><strong>${status.index + 1}</strong></td>
                                                        <td>
                                                            <span class="fw-medium">${category.name}</span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty category.description}">
                                                                    <span class="text-truncate d-inline-block" style="max-width: 300px;" 
                                                                          title="${category.description}">
                                                                        ${category.description}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted fst-italic">No description</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-label-info">
                                                                <i class="bx bx-package" aria-hidden="true me-1"></i>${productCount} product(s)
                                                            </span>
                                                        </td>
                                                        <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                                            <td>
                                                                <div class="d-flex gap-2">
                                                                    <a href="${contextPath}/category?action=edit&id=${category.id}" 
                                                                       class="btn btn-sm btn-outline-primary" 
                                                                       data-bs-toggle="tooltip" title="Edit"
                                                                       aria-label="Edit category">
                                                                        <i class="bx bx-edit-alt" aria-hidden="true"></i>
                                                                    </a>
                                                                    <c:choose>
                                                                        <c:when test="${productCount > 0}">
                                                                            <button type="button" 
                                                                                    class="btn btn-sm btn-outline-secondary" 
                                                                                    disabled
                                                                                    data-bs-toggle="tooltip" 
                                                                                    title="Cannot delete - has ${productCount} product(s)"
                                                                                    aria-label="Cannot delete category - has products">
                                                                                <i class="bx bx-trash" aria-hidden="true"></i>
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button type="button" 
                                                                                    class="btn btn-sm btn-outline-danger" 
                                                                                    data-bs-toggle="modal" 
                                                                                    data-bs-target="#deleteModal"
                                                                                    data-category-id="${category.id}"
                                                                                    data-category-name="${category.name}"
                                                                                    title="Delete"
                                                                                    aria-label="Delete category">
                                                                                <i class="bx bx-trash" aria-hidden="true"></i>
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
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bx bx-error-circle text-danger me-2"></i>Confirm Delete
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete category "<strong id="deleteCategoryName"></strong>"?</p>
                    <div class="alert alert-warning mb-0">
                        <i class="bx bx-info-circle me-1"></i>
                        This action cannot be undone.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="deleteConfirmBtn" class="btn btn-danger">
                        <i class="bx bx-trash me-1"></i>Delete
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
    
    <script>
        // Delete modal handler
        document.getElementById('deleteModal').addEventListener('show.bs.modal', function(event) {
            var button = event.relatedTarget;
            var categoryId = button.getAttribute('data-category-id');
            var categoryName = button.getAttribute('data-category-name');
            
            document.getElementById('deleteCategoryName').textContent = categoryName;
            document.getElementById('deleteConfirmBtn').href = 
                '${contextPath}/category?action=delete&id=' + categoryId;
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
