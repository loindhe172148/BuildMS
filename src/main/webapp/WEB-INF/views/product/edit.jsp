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
        <jsp:param name="pageTitle" value="Edit Product" />
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
                                <li class="breadcrumb-item">
                                    <a href="${contextPath}/product?action=list">Products</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Product</li>
                            </ol>
                        </nav>
                        
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-6">
                            <h4 class="mb-0">
                                <i class="bx bx-edit me-2"></i>Edit Product
                            </h4>
                            <span class="badge bg-label-${product.active ? 'success' : 'secondary'} fs-6">
                                ${product.active ? 'Active' : 'Inactive'}
                            </span>
                        </div>
                        
                        <!-- Form Card -->
                        <div class="row">
                            <div class="col-xxl-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Product Information</h5>
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
                                        
                                        <!-- SKU Change Warning -->
                                        <c:if test="${hasInventory}">
                                            <div class="alert alert-warning" role="alert">
                                                <i class="bx bx-info-circle me-2"></i>
                                                <strong>Warning:</strong> This product has ${inventoryQty} units in inventory. 
                                                Changing the SKU is not recommended as it may cause tracking issues.
                                            </div>
                                        </c:if>
                                        
                                        <form action="${contextPath}/product" method="post">
                                            <input type="hidden" name="action" value="edit" />
                                            <input type="hidden" name="id" value="${product.id}" />
                                            
                                            <!-- SKU -->
                                            <div class="mb-4">
                                                <label class="form-label" for="sku">
                                                    SKU <span class="text-danger">*</span>
                                                </label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bx bx-barcode"></i></span>
                                                    <input type="text" class="form-control ${hasInventory ? 'border-warning' : ''}" 
                                                           id="sku" name="sku" 
                                                           value="${product.sku}" placeholder="e.g., PRD-001, SKU-ABC123"
                                                           required maxlength="100" />
                                                </div>
                                                <c:if test="${hasInventory}">
                                                    <div class="form-text text-warning">
                                                        <i class="bx bx-error me-1"></i>
                                                        Changing SKU may affect inventory tracking.
                                                    </div>
                                                </c:if>
                                            </div>
                                            
                                            <!-- Name -->
                                            <div class="mb-4">
                                                <label class="form-label" for="name">
                                                    Product Name <span class="text-danger">*</span>
                                                </label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bx bx-package" aria-hidden="true"></i></span>
                                                    <input type="text" class="form-control" id="name" name="name" 
                                                           value="${product.name}" placeholder="Enter product name"
                                                           required maxlength="255" />
                                                </div>
                                            </div>
                                            
                                            <!-- Category -->
                                            <div class="mb-4">
                                                <label class="form-label" for="categoryId">
                                                    Category <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="categoryId" name="categoryId" required>
                                                    <option value="">Select a category</option>
                                                    <c:forEach var="cat" items="${categories}">
                                                        <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>
                                                            ${cat.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            
                                            <!-- Unit -->
                                            <div class="mb-4">
                                                <label class="form-label" for="unit">Unit of Measure</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bx bx-ruler"></i></span>
                                                    <input type="text" class="form-control" id="unit" name="unit" 
                                                           value="${product.unit}" placeholder="e.g., pcs, kg, box, carton"
                                                           maxlength="50" list="unitSuggestions" />
                                                </div>
                                                <datalist id="unitSuggestions">
                                                    <option value="pcs">
                                                    <option value="kg">
                                                    <option value="g">
                                                    <option value="box">
                                                    <option value="carton">
                                                    <option value="pack">
                                                    <option value="set">
                                                    <option value="unit">
                                                    <option value="pair">
                                                    <option value="dozen">
                                                    <option value="liter">
                                                    <option value="meter">
                                                </datalist>
                                            </div>
                                            
                                            <!-- Form Actions -->
                                            <div class="d-flex justify-content-end gap-3 mt-5">
                                                <a href="${contextPath}/product?action=list" class="btn btn-outline-secondary">
                                                    <i class="bx bx-x me-1"></i>Cancel
                                                </a>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bx bx-save me-1"></i>Save Changes
                                                </button>
                                            </div>
                                        </form>
                                        
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Info Card -->
                            <div class="col-xxl-6">
                                <div class="card">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <i class="bx bx-info-circle me-2"></i>Product Status
                                        </h6>
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="badge bg-${product.active ? 'success' : 'secondary'} me-2">
                                                ${product.active ? 'Active' : 'Inactive'}
                                            </span>
                                            <span class="text-muted">
                                                ${product.active ? 'Product is available for orders' : 'Product cannot be added to new orders'}
                                            </span>
                                        </div>
                                        
                                        <c:if test="${hasInventory}">
                                            <div class="alert alert-info mb-0">
                                                <i class="bx bx-box me-1"></i>
                                                <strong>Current Inventory:</strong> ${inventoryQty} units across all locations
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not hasInventory}">
                                            <div class="alert alert-secondary mb-0">
                                                <i class="bx bx-box me-1"></i>
                                                No inventory for this product yet.
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <!-- Quick Actions Card -->
                                <div class="card mt-4">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <i class="bx bx-bolt me-2"></i>Quick Actions
                                        </h6>
                                        <div class="d-grid gap-2">
                                            <a href="${contextPath}/product?action=details&id=${product.id}" 
                                               class="btn btn-outline-info">
                                                <i class="bx bx-show me-1"></i>View Details
                                            </a>
                                            <button type="button" 
                                                    class="btn ${product.active ? 'btn-outline-warning' : 'btn-outline-success'}"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#toggleModal">
                                                <i class="bx ${product.active ? 'bx-block' : 'bx-check'} me-1"></i>
                                                ${product.active ? 'Deactivate' : 'Activate'} Product
                                            </button>
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
                    <p>
                        Are you sure you want to 
                        <strong>${product.active ? 'deactivate' : 'activate'}</strong> 
                        product "<strong>${product.name}</strong>"?
                    </p>
                    <c:if test="${product.active}">
                        <div class="alert alert-warning mb-0">
                            <i class="bx bx-info-circle me-1"></i>
                            Inactive products cannot be added to new orders or requests. Existing orders will not be affected.
                        </div>
                    </c:if>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="${contextPath}/product?action=toggle&id=${product.id}" 
                       class="btn ${product.active ? 'btn-warning' : 'btn-success'}">
                        <i class="bx bx-check me-1"></i>${product.active ? 'Deactivate' : 'Activate'}
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <jsp:include page="/WEB-INF/common/scripts.jsp" />
</body>
</html>
