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
        <jsp:param name="pageTitle" value="Product List" />
    </jsp:include>
</head>
<body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/common/sidebar.jsp">
                <jsp:param name="activeMenu" value="products" />
                <jsp:param name="activeSubMenu" value="product-list" />
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
                                <li class="breadcrumb-item active" aria-current="page">Products</li>
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
                                <i class="bx bx-package" aria-hidden="true me-2"></i>Product Management
                            </h4>
                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                <a href="${contextPath}/product?action=add" class="btn btn-primary">
                                    <i class="bx bx-plus me-1"></i>Add Product
                                </a>
                            </c:if>
                        </div>
                        
                        <!-- Filters Card -->
                        <div class="card mb-6">
                            <div class="card-body">
                                <form action="${contextPath}/product" method="get" class="row g-3">
                                    <input type="hidden" name="action" value="list" />
                                    
                                    <!-- Search by SKU/Name -->
                                    <div class="col-md-4">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bx bx-search"></i></span>
                                            <input type="text" class="form-control" name="keyword" 
                                                   value="${keyword}" placeholder="Search by SKU or name..." />
                                        </div>
                                    </div>
                                    
                                    <!-- Filter by Category -->
                                    <div class="col-md-3">
                                        <select class="form-select" name="categoryId">
                                            <option value="">All Categories</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.id}" ${categoryId == cat.id ? 'selected' : ''}>
                                                    ${cat.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <!-- Filter by Status -->
                                    <div class="col-md-3">
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
                        
                        <!-- Products Table -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Products</h5>
                                <span class="badge bg-primary">${products.size()} total</span>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 60px;">#</th>
                                            <th>SKU</th>
                                            <th>Name</th>
                                            <th>Category</th>
                                            <th>Unit</th>
                                            <th style="width: 100px;">Total Stock</th>
                                            <th style="width: 100px;">Status</th>
                                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                                <th style="width: 180px;">Actions</th>
                                            </c:if>
                                        </tr>
                                    </thead>
                                    <tbody class="table-border-bottom-0">
                                        <c:choose>
                                            <c:when test="${empty products}">
                                                <tr>
                                                    <td colspan="${(currentUser.role == 'Admin' || currentUser.role == 'Manager') ? 8 : 7}" 
                                                        class="text-center py-5">
                                                        <div class="text-muted">
                                                            <i class="bx bx-package" aria-hidden="true bx-lg mb-3 d-block"></i>
                                                            <p class="mb-0">No products found</p>
                                                            <c:if test="${currentUser.role == 'Admin' || currentUser.role == 'Manager'}">
                                                                <a href="${contextPath}/product?action=add" class="btn btn-primary btn-sm mt-3">
                                                                    <i class="bx bx-plus me-1"></i>Add First Product
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="product" items="${products}" varStatus="loop">
                                                    <c:set var="categoryName" value="${requestScope['categoryName_'.concat(product.categoryId)]}" />
                                                    <c:set var="totalQty" value="${requestScope['totalQty_'.concat(product.id)]}" />
                                                    <tr class="${!product.active ? 'table-secondary' : ''}">
                                                        <td><strong>${loop.index + 1}</strong></td>
                                                        <td>
                                                            <a href="${contextPath}/product?action=details&id=${product.id}" 
                                                               class="fw-medium text-primary">
                                                                ${product.sku}
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <span class="text-truncate d-inline-block" style="max-width: 200px;"
                                                                  title="${product.name}">
                                                                ${product.name}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-label-info">
                                                                ${categoryName}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty product.unit}">
                                                                    ${product.unit}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-label-${totalQty > 0 ? 'success' : 'secondary'}">
                                                                ${totalQty}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${product.active}">
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
                                                                    <a href="${contextPath}/product?action=details&id=${product.id}" 
                                                                       class="btn btn-sm btn-outline-info" 
                                                                       data-bs-toggle="tooltip" title="View Details"
                                                                       aria-label="View product details">
                                                                        <i class="bx bx-show" aria-hidden="true"></i>
                                                                    </a>
                                                                    <a href="${contextPath}/product?action=edit&id=${product.id}" 
                                                                       class="btn btn-sm btn-outline-primary" 
                                                                       data-bs-toggle="tooltip" title="Edit"
                                                                       aria-label="Edit product">
                                                                        <i class="bx bx-edit-alt" aria-hidden="true"></i>
                                                                    </a>
                                                                    <button type="button" 
                                                                            class="btn btn-sm ${product.active ? 'btn-outline-warning' : 'btn-outline-success'}" 
                                                                            data-bs-toggle="modal" 
                                                                            data-bs-target="#toggleModal"
                                                                            data-product-id="${product.id}"
                                                                            data-product-name="${product.name}"
                                                                            data-product-active="${product.active}"
                                                                            title="${product.active ? 'Deactivate' : 'Activate'}"
                                                                            aria-label="${product.active ? 'Deactivate product' : 'Activate product'}">
                                                                        <i class="bx ${product.active ? 'bx-block' : 'bx-check'}" aria-hidden="true"></i>
                                                                    </button>
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
            var productId = button.getAttribute('data-product-id');
            var productName = button.getAttribute('data-product-name');
            var isActive = button.getAttribute('data-product-active') === 'true';
            
            var action = isActive ? 'deactivate' : 'activate';
            var actionCapitalized = isActive ? 'Deactivate' : 'Activate';
            
            document.getElementById('toggleMessage').innerHTML = 
                'Are you sure you want to <strong>' + action + '</strong> product "<strong>' + productName + '</strong>"?';
            
            var confirmBtn = document.getElementById('toggleConfirmBtn');
            confirmBtn.href = '${contextPath}/product?action=toggle&id=' + productId;
            confirmBtn.className = isActive ? 'btn btn-warning' : 'btn btn-success';
            confirmBtn.innerHTML = '<i class="bx bx-check me-1"></i>' + actionCapitalized;
            
            var warningDiv = document.getElementById('toggleWarning');
            var warningText = document.getElementById('toggleWarningText');
            
            if (isActive) {
                warningDiv.style.display = 'block';
                warningText.textContent = 'Inactive products cannot be added to new orders or requests. Existing orders will not be affected.';
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
